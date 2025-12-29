
# Claude Code (Programmatic)

Run Claude Code headless via CLI or SDK. Essential for Sandbox agent integration.

## Sandbox Integration

```typescript
// Run Claude Code in a Sandbox container
const sandbox = await SandboxSDK.create(env.SANDBOX_WORKER);

// Clone repo and run Claude Code
await sandbox.exec('git', ['clone', repoUrl, '/workspace']);
const result = await sandbox.exec('claude', [
  '-p', task,
  '--output-format', 'json',
  '--allowedTools', 'Read,Edit,Bash',
  '--max-turns', '10'
], { cwd: '/workspace' });

const output = JSON.parse(result.stdout);
return { logs: output.result, diff: await sandbox.exec('git', ['diff']) };
```

## CLI Programmatic Mode (-p)

```bash
# Basic query
claude -p "Fix the bug in auth.py"

# With auto-approved tools
claude -p "Run tests and fix failures" --allowedTools "Bash,Read,Edit"

# JSON output for parsing
claude -p "Analyze code" --output-format json

# Limit iterations
claude -p "Fix all issues" --max-turns 10
```

## Output Formats

### JSON (for automation)

```bash
claude -p "Query" --output-format json
```

```json
{
  "session_id": "550e8400-...",
  "result": "Final answer text",
  "is_error": false,
  "total_cost_usd": 0.0234,
  "usage": { "input_tokens": 1500, "output_tokens": 500 }
}
```

### Stream-JSON (real-time)

```bash
claude -p "Query" --output-format stream-json
```

```json
{"type":"system","subtype":"init","session_id":"..."}
{"type":"assistant","message":{"content":[{"type":"text","text":"..."}]}}
{"type":"tool_use","id":"...","name":"Read","input":{...}}
{"type":"result","subtype":"success","total_cost_usd":0.02}
```

## Session Management

```bash
# Capture session ID
SESSION=$(claude -p "Start task" --output-format json | jq -r '.session_id')

# Continue conversation
claude -p "Next step" --resume "$SESSION" --output-format json

# Or use --continue for most recent
claude -p "Continue" --continue
```

## Tool Restrictions

```bash
# Auto-approve specific tools
--allowedTools "Bash(git:*),Read,Edit"

# Restrict available tools
--tools "Read,Grep,Glob"

# Block specific tools
--disallowedTools "Edit,Write"
```

## Structured Output (JSON Schema)

```bash
claude -p "Extract function names from auth.py" \
  --output-format json \
  --json-schema '{"type":"object","properties":{"functions":{"type":"array","items":{"type":"string"}}},"required":["functions"]}'
```

Result in `structured_output` field.

## Custom System Prompts

```bash
# Append to default prompt
claude -p "Review code" --append-system-prompt "Focus on security"

# Replace entire prompt
claude -p "Task" --system-prompt "You are a Python expert"

# Load from file
claude -p "Task" --system-prompt-file ./prompt.txt
```

## Inline Agents

```bash
claude -p "Review code" --agents '{
  "security-reviewer": {
    "description": "Security expert",
    "prompt": "Audit for vulnerabilities",
    "tools": ["Read", "Grep"],
    "model": "opus"
  }
}'
```

## Parsing Results

### Bash + jq

```bash
# Extract result
result=$(claude -p "Query" --output-format json | jq -r '.result')

# Extract session for multi-step
SESSION=$(claude -p "Step 1" --output-format json | jq -r '.session_id')

# Check for errors
is_error=$(claude -p "Query" --output-format json | jq '.is_error')
```

### Node.js

```typescript
import { execSync, spawn } from 'child_process';

// Sync execution
function runClaude(prompt: string): { result: string; session_id: string } {
  const output = execSync(
    `claude -p "${prompt}" --output-format json`,
    { encoding: 'utf-8' }
  );
  return JSON.parse(output);
}

// Streaming
const claude = spawn('claude', ['-p', prompt, '--output-format', 'stream-json']);
for await (const line of claude.stdout) {
  const event = JSON.parse(line);
  if (event.type === 'assistant') console.log(event.message.content);
}
```

### Python

```python
import subprocess
import json

def run_claude(prompt: str, tools: list = None) -> dict:
    cmd = ["claude", "-p", prompt, "--output-format", "json"]
    if tools:
        cmd.extend(["--allowedTools", ",".join(tools)])

    result = subprocess.run(cmd, capture_output=True, text=True)
    data = json.loads(result.stdout)

    if data.get('is_error'):
        raise RuntimeError(data['error']['message'])

    return data
```

## Exit Codes

| Code | Meaning |
|------|---------|
| `0` | Success |
| `1` | Error |
| `2` | Invalid args |
| `130` | Interrupted |

## Memory (CLAUDE.md)

```
CLAUDE.md                   # Project (team)
CLAUDE.local.md             # Project (personal, gitignored)
.claude/rules/*.md          # Modular rules
~/.claude/CLAUDE.md         # User global
```

Path-based rules:
```yaml
---
paths: src/api/**/*.ts
---

# API Rules
- Validate all inputs
- Use standard error format
```

## Multi-step Workflow Pattern

```bash
#!/bin/bash
set -e

# Step 1: Plan
SESSION=$(claude -p "Plan implementation for $TASK" \
  --output-format json | jq -r '.session_id')

# Step 2: Execute
claude -p "Execute the plan" \
  --resume "$SESSION" \
  --allowedTools "Bash,Read,Edit" \
  --output-format json

# Step 3: Test
claude -p "Run tests and fix failures" \
  --resume "$SESSION" \
  --allowedTools "Bash(npm test:*),Read,Edit" \
  --max-turns 5 \
  --output-format json

# Step 4: Get final result
RESULT=$(claude -p "Summarize what was done" \
  --resume "$SESSION" \
  --output-format json | jq -r '.result')
```

## Sandbox Worker Pattern

```typescript
// Durable Object for Claude Code execution
export class SandboxDO extends DurableObject {
  async runClaudeCode(repo: string, task: string): Promise<ClaudeResult> {
    const sandbox = await SandboxSDK.create(this.env.SANDBOX_WORKER);

    // Setup workspace
    await sandbox.exec('git', ['clone', repo, '/workspace']);

    // Run Claude Code with streaming
    const events: StreamEvent[] = [];
    const process = sandbox.spawn('claude', [
      '-p', task,
      '--output-format', 'stream-json',
      '--allowedTools', 'Read,Edit,Bash',
      '--max-turns', '20'
    ], { cwd: '/workspace' });

    for await (const line of process.stdout) {
      const event = JSON.parse(line);
      events.push(event);

      // Stream to WebSocket client
      this.ctx.getWebSockets().forEach(ws => ws.send(JSON.stringify(event)));
    }

    // Get changes
    const diff = await sandbox.exec('git', ['diff']);

    return {
      events,
      diff: diff.stdout,
      success: events.some(e => e.type === 'result' && e.subtype === 'success')
    };
  }
}
```