# Claude Code Output Formats

> Complete reference for parsing CLI output in automation

---

## Available Formats

| Format | Flag | Use Case |
|--------|------|----------|
| **text** | (default) | Human readable |
| **json** | `--output-format json` | Scripts, automation |
| **stream-json** | `--output-format stream-json` | Real-time processing |

---

## Text Format

Default output, formatted for terminal.

```bash
claude -p "Explain this file"
# Returns plain text
```

**Use for:** Development, manual testing, human reading

---

## JSON Format

Structured object with full metadata.

```bash
claude -p "Query" --output-format json
```

### Structure

```json
{
  "session_id": "550e8400-e29b-41d4-a716-446655440000",
  "result": "Final answer text",
  "is_error": false,
  "stop_reason": "end_turn",
  "num_turns": 3,
  "duration_ms": 2543,
  "duration_api_ms": 1823,
  "total_cost_usd": 0.0234,
  "usage": {
    "input_tokens": 1500,
    "output_tokens": 500,
    "cache_creation_input_tokens": 100,
    "cache_read_input_tokens": 200
  },
  "messages": [
    {
      "type": "user",
      "content": "Query text"
    },
    {
      "type": "assistant",
      "content": [
        { "type": "text", "text": "Response..." }
      ],
      "model": "claude-sonnet-4-5"
    }
  ]
}
```

### Key Fields

| Field | Description |
|-------|-------------|
| `session_id` | UUID for resuming session |
| `result` | Final answer (if available) |
| `is_error` | Boolean error flag |
| `stop_reason` | Why stopped (end_turn, tool_use, max_tokens) |
| `total_cost_usd` | Cost in USD |
| `usage` | Token counts |
| `messages` | Full conversation history |

### Message Types

| Type | Description |
|------|-------------|
| `user` | User input |
| `assistant` | Claude response |
| `system` | System messages |
| `result` | Final result |

### Content Block Types

```json
// Text
{ "type": "text", "text": "Response text" }

// Tool use
{ "type": "tool_use", "id": "call_123", "name": "Read", "input": {...} }

// Tool result
{ "type": "tool_result", "tool_use_id": "call_123", "content": "..." }

// Thinking (extended)
{ "type": "thinking", "thinking": "Let me consider..." }
```

---

## Stream-JSON Format

Newline-delimited JSON events in real-time.

```bash
claude -p "Query" --output-format stream-json
```

### Event Sequence

```json
{"type":"system","subtype":"init","session_id":"...","model":"..."}
{"type":"assistant","message":{"content":[{"type":"text","text":"..."}]}}
{"type":"tool_use","id":"...","name":"Read","input":{...}}
{"type":"tool_result","tool_use_id":"...","content":"..."}
{"type":"assistant","message":{"content":[{"type":"text","text":"..."}]}}
{"type":"result","subtype":"success","duration_ms":2543,"total_cost_usd":0.02}
```

### Event Types

| Event | When | Key Fields |
|-------|------|------------|
| `system` | Start, errors | `subtype`, `session_id` |
| `assistant` | Claude responds | `message.content[]` |
| `tool_use` | Tool called | `id`, `name`, `input` |
| `tool_result` | Tool finished | `tool_use_id`, `content` |
| `result` | End | `subtype`, `usage`, `cost` |

### With Partial Messages

```bash
claude -p "Query" --output-format stream-json --include-partial-messages
```

Shows incremental text as Claude types.

---

## Exit Codes

| Code | Meaning | Action |
|------|---------|--------|
| `0` | Success | Process result |
| `1` | Error | Check stderr/JSON |
| `2` | Input error | Fix arguments |
| `130` | Interrupted | User cancelled |

---

## Parsing Examples

### Bash + jq

#### Extract session_id

```bash
session=$(claude -p "Query" --output-format json | jq -r '.session_id')
```

#### Extract result

```bash
result=$(claude -p "Query" --output-format json | jq -r '.result')
```

#### Extract cost

```bash
cost=$(claude -p "Query" --output-format json | jq '.total_cost_usd')
```

#### Check for error

```bash
is_error=$(claude -p "Query" --output-format json | jq '.is_error')
if [ "$is_error" == "true" ]; then
  echo "Error occurred"
fi
```

#### Extract assistant messages

```bash
claude -p "Query" --output-format json | \
  jq -r '.messages[] | select(.type=="assistant") | .content[0].text'
```

#### Extract tool calls

```bash
claude -p "Query" --output-format json | \
  jq '.messages[] | select(.type=="assistant") | .content[] | select(.type=="tool_use")'
```

### Bash Stream Processing

```bash
claude -p "Query" --output-format stream-json | while IFS= read -r line; do
  type=$(echo "$line" | jq -r '.type')

  case "$type" in
    system)
      echo "Session: $(echo "$line" | jq -r '.session_id')"
      ;;
    assistant)
      text=$(echo "$line" | jq -r '.message.content[0].text? // empty')
      [ -n "$text" ] && echo "Claude: $text"
      ;;
    tool_use)
      echo "Tool: $(echo "$line" | jq -r '.name')"
      ;;
    result)
      echo "Done! Cost: \$$(echo "$line" | jq -r '.total_cost_usd')"
      ;;
  esac
done
```

### Python

#### JSON Parsing

```python
import subprocess
import json

result = subprocess.run(
    ["claude", "-p", "Query", "--output-format", "json"],
    capture_output=True,
    text=True
)

data = json.loads(result.stdout)

print(f"Session: {data['session_id']}")
print(f"Result: {data['result']}")
print(f"Cost: ${data['total_cost_usd']}")
print(f"Tokens: {data['usage']['input_tokens']} in, {data['usage']['output_tokens']} out")
```

#### Stream Processing

```python
import subprocess
import json

process = subprocess.Popen(
    ["claude", "-p", "Query", "--output-format", "stream-json"],
    stdout=subprocess.PIPE,
    text=True
)

for line in process.stdout:
    if line.strip():
        event = json.loads(line)

        if event['type'] == 'assistant':
            for block in event['message']['content']:
                if block.get('type') == 'text':
                    print(f"Claude: {block['text']}")

        elif event['type'] == 'result':
            print(f"Cost: ${event.get('total_cost_usd', 0)}")
```

#### Reusable Function

```python
def run_claude(prompt: str, tools: list = None) -> dict:
    import subprocess, json

    cmd = ["claude", "-p", prompt, "--output-format", "json"]
    if tools:
        cmd.extend(["--allowedTools", ",".join(tools)])

    result = subprocess.run(cmd, capture_output=True, text=True)
    data = json.loads(result.stdout)

    if data.get('is_error'):
        raise RuntimeError(data.get('error', {}).get('message'))

    return data

# Usage
data = run_claude("Analyze code", tools=["Read", "Grep"])
print(data['result'])
```

### Node.js

#### JSON Parsing

```javascript
const { execSync } = require('child_process');

const output = execSync(
  'claude -p "Query" --output-format json',
  { encoding: 'utf-8' }
);

const data = JSON.parse(output);

console.log(`Session: ${data.session_id}`);
console.log(`Result: ${data.result}`);
console.log(`Cost: $${data.total_cost_usd}`);
```

#### Stream Processing

```javascript
const { spawn } = require('child_process');
const readline = require('readline');

const claude = spawn('claude', ['-p', 'Query', '--output-format', 'stream-json']);

const rl = readline.createInterface({ input: claude.stdout });

rl.on('line', (line) => {
  if (line.trim()) {
    const event = JSON.parse(line);

    if (event.type === 'assistant') {
      event.message.content.forEach(block => {
        if (block.type === 'text') console.log(`Claude: ${block.text}`);
      });
    } else if (event.type === 'result') {
      console.log(`Cost: $${event.total_cost_usd}`);
    }
  }
});
```

---

## Error Handling

### JSON Error Structure

```json
{
  "is_error": true,
  "error": {
    "message": "File not found: /path/to/file.py",
    "type": "FileNotFoundError"
  },
  "session_id": "..."
}
```

### Result Subtypes

| Subtype | Meaning |
|---------|---------|
| `success` | Completed successfully |
| `error` | General error |
| `error_max_turns` | Too many iterations |
| `error_max_structured_output_retries` | JSON schema failed |

### Bash Error Handling

```bash
output=$(claude -p "Query" --output-format json)
exit_code=$?

if [ $exit_code -ne 0 ]; then
  echo "Exit code: $exit_code"
  exit $exit_code
fi

is_error=$(echo "$output" | jq '.is_error')
if [ "$is_error" == "true" ]; then
  error_msg=$(echo "$output" | jq -r '.error.message')
  echo "Error: $error_msg"
  exit 1
fi

echo "Success: $(echo "$output" | jq -r '.result')"
```

### Python Error Handling

```python
def run_claude_safe(prompt: str) -> str:
    import subprocess, json

    result = subprocess.run(
        ["claude", "-p", prompt, "--output-format", "json"],
        capture_output=True,
        text=True
    )

    if result.returncode != 0:
        raise RuntimeError(f"Exit code: {result.returncode}")

    data = json.loads(result.stdout)

    if data.get('is_error'):
        raise RuntimeError(data['error']['message'])

    return data.get('result', '')
```

---

## Stop Reasons

| Value | Meaning | Action |
|-------|---------|--------|
| `end_turn` | Natural completion | Process result |
| `tool_use` | Wants to use tool | SDK handles |
| `max_tokens` | Token limit hit | Response incomplete |

---

## Format Comparison

| Aspect | text | json | stream-json |
|--------|------|------|-------------|
| Real-time | No | No | Yes |
| Metadata | Minimal | Full | Incremental |
| Parsing | Manual | jq/JSON | Line by line |
| Session ID | No | Yes | Yes (init event) |
| Cost tracking | No | Yes | Yes (result event) |
| Error details | stderr | JSON field | Event |

---

## When to Use Each

### text
- Development
- Manual testing
- Human reading

### json
- Scripts & automation
- CI/CD pipelines
- Cost tracking
- Session management
- Archiving results

### stream-json
- Real-time monitoring
- Long-running tasks
- Progress tracking
- Large responses

---

## Quick Reference

### Essential Parsing

```bash
# Session ID
jq -r '.session_id'

# Result
jq -r '.result'

# Cost
jq '.total_cost_usd'

# Error check
jq '.is_error'

# Token usage
jq '.usage.input_tokens, .usage.output_tokens'
```

### Multi-step Workflow

```bash
# Step 1: Capture session
SESSION=$(claude -p "Start task" --output-format json | jq -r '.session_id')

# Step 2: Continue
claude -p "Next step" --resume "$SESSION" --output-format json

# Step 3: Get final result
RESULT=$(claude -p "Finish" --resume "$SESSION" --output-format json | jq -r '.result')
```

### Complete Script Template

```bash
#!/bin/bash
set -e

run_claude() {
  local prompt="$1"
  local output

  output=$(claude -p "$prompt" \
    --output-format json \
    --allowedTools "Read,Edit,Bash(npm:*)" \
    --max-turns 10)

  if [ "$(echo "$output" | jq '.is_error')" == "true" ]; then
    echo "Error: $(echo "$output" | jq -r '.error.message')" >&2
    return 1
  fi

  echo "$output" | jq -r '.result'
}

# Usage
result=$(run_claude "Analyze and fix bugs")
echo "Result: $result"
```
