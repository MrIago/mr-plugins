# Run Claude Code programmatically

> Use the Agent SDK to run Claude Code programmatically from the CLI, Python, or TypeScript.

The [Agent SDK](https://platform.claude.com/docs/en/agent-sdk/overview) gives you the same tools, agent loop, and context management that power Claude Code. It's available as a CLI for scripts and CI/CD, or as [Python](https://platform.claude.com/docs/en/agent-sdk/python) and [TypeScript](https://platform.claude.com/docs/en/agent-sdk/typescript) packages for full programmatic control.

<Note>
  The CLI was previously called "headless mode." The `-p` flag and all CLI options work the same way.
</Note>

To run Claude Code programmatically from the CLI, pass `-p` with your prompt and any [CLI options](/en/cli-reference):

```bash  theme={null}
claude -p "Find and fix the bug in auth.py" --allowedTools "Read,Edit,Bash"
```

This page covers using the Agent SDK via the CLI (`claude -p`). For the Python and TypeScript SDK packages with structured outputs, tool approval callbacks, and native message objects, see the [full Agent SDK documentation](https://platform.claude.com/docs/en/agent-sdk/overview).

## Basic usage

Add the `-p` (or `--print`) flag to any `claude` command to run it non-interactively. All [CLI options](/en/cli-reference) work with `-p`, including:

* `--continue` for [continuing conversations](#continue-conversations)
* `--allowedTools` for [auto-approving tools](#auto-approve-tools)
* `--output-format` for [structured output](#get-structured-output)

This example asks Claude a question about your codebase and prints the response:

```bash  theme={null}
claude -p "What does the auth module do?"
```

## Examples

These examples highlight common CLI patterns.

### Get structured output

Use `--output-format` to control how responses are returned:

* `text` (default): plain text output
* `json`: structured JSON with result, session ID, and metadata
* `stream-json`: newline-delimited JSON for real-time streaming

This example returns a project summary as JSON with session metadata, with the text result in the `result` field:

```bash  theme={null}
claude -p "Summarize this project" --output-format json
```

To get output conforming to a specific schema, use `--output-format json` with `--json-schema` and a [JSON Schema](https://json-schema.org/) definition. The response includes metadata about the request (session ID, usage, etc.) with the structured output in the `structured_output` field.

This example extracts function names and returns them as an array of strings:

```bash  theme={null}
claude -p "Extract the main function names from auth.py" \
  --output-format json \
  --json-schema '{"type":"object","properties":{"functions":{"type":"array","items":{"type":"string"}}},"required":["functions"]}'
```

<Tip>
  Use a tool like [jq](https://jqlang.github.io/jq/) to parse the response and extract specific fields:

  ```bash  theme={null}
  # Extract the text result
  claude -p "Summarize this project" --output-format json | jq -r '.result'

  # Extract structured output
  claude -p "Extract function names from auth.py" \
    --output-format json \
    --json-schema '{"type":"object","properties":{"functions":{"type":"array","items":{"type":"string"}}},"required":["functions"]}' \
    | jq '.structured_output'
  ```
</Tip>

### Auto-approve tools

Use `--allowedTools` to let Claude use certain tools without prompting. This example runs a test suite and fixes failures, allowing Claude to execute Bash commands and read/edit files without asking for permission:

```bash  theme={null}
claude -p "Run the test suite and fix any failures" \
  --allowedTools "Bash,Read,Edit"
```

### Create a commit

This example reviews staged changes and creates a commit with an appropriate message:

```bash  theme={null}
claude -p "Look at my staged changes and create an appropriate commit" \
  --allowedTools "Bash(git diff:*),Bash(git log:*),Bash(git status:*),Bash(git commit:*)"
```

<Note>
  [Slash commands](/en/slash-commands) like `/commit` are only available in interactive mode. In `-p` mode, describe the task you want to accomplish instead.
</Note>

### Customize the system prompt

Use `--append-system-prompt` to add instructions while keeping Claude Code's default behavior. This example pipes a PR diff to Claude and instructs it to review for security vulnerabilities:

```bash  theme={null}
gh pr diff "$1" | claude -p \
  --append-system-prompt "You are a security engineer. Review for vulnerabilities." \
  --output-format json
```

See [system prompt flags](/en/cli-reference#system-prompt-flags) for more options including `--system-prompt` to fully replace the default prompt.

### Continue conversations

Use `--continue` to continue the most recent conversation, or `--resume` with a session ID to continue a specific conversation. This example runs a review, then sends follow-up prompts:

```bash  theme={null}
# First request
claude -p "Review this codebase for performance issues"

# Continue the most recent conversation
claude -p "Now focus on the database queries" --continue
claude -p "Generate a summary of all issues found" --continue
```

If you're running multiple conversations, capture the session ID to resume a specific one:

```bash  theme={null}
session_id=$(claude -p "Start a review" --output-format json | jq -r '.session_id')
claude -p "Continue that review" --resume "$session_id"
```

## Exit Codes

| Code | Meaning |
|------|---------|
| `0` | Success |
| `1` | General error (API, permissions) |
| `2` | Invalid CLI arguments |
| `130` | Interrupted (Ctrl+C) |

```bash
#!/bin/bash
if claude -p "Task" --output-format json > result.json 2> error.log; then
  echo "Success"
  jq -r '.result' result.json
else
  echo "Failed" >&2
  cat error.log
  exit 1
fi
```

## CI/CD Integration

### GitHub Actions

```yaml
name: Claude Code Review
on: [pull_request]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run Claude Review
        run: |
          git diff HEAD~1 | \
            claude -p "Review for bugs and security" \
              --allowedTools "Read,Grep" \
              --max-turns 3 \
              --output-format json \
            > review.json

      - name: Show Results
        run: jq -r '.result' review.json
```

### GitLab CI

```yaml
claude-review:
  script:
    - git diff HEAD~1 | claude -p "Review changes" --output-format json > review.json
    - jq -r '.result' review.json
  artifacts:
    paths:
      - review.json
```

## Language Integration

### Python

```python
import subprocess
import json

def run_claude(prompt, allowed_tools=None):
    cmd = ["claude", "-p", prompt, "--output-format", "json"]
    if allowed_tools:
        cmd.extend(["--allowedTools", allowed_tools])

    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode == 0:
        return json.loads(result.stdout)
    raise Exception(f"Claude error: {result.stderr}")

response = run_claude("Analyze this code", "Read,Grep")
print(response['result'])
```

### Node.js

```javascript
const { execSync } = require('child_process');

function runClaude(prompt, outputFormat = 'json') {
  const cmd = `claude -p "${prompt}" --output-format ${outputFormat}`;
  const output = execSync(cmd, { encoding: 'utf-8' });
  return JSON.parse(output);
}

const result = runClaude('What is the project structure?');
console.log(result.result);
```

## Practical Examples

### Batch Processing

```bash
#!/bin/bash
for file in src/**/*.ts; do
  echo "Analyzing $file..."
  claude -p "Analyze and suggest 3 improvements" \
    --allowedTools "Read" \
    --output-format json \
    < "$file" | \
    jq -r '.result' >> report.txt
  echo "---" >> report.txt
done
```

### Safe Read-only Analysis

```bash
cat production-logs.txt | \
  claude -p "Analyze problems" \
  --permission-mode plan \
  --disallowedTools "Edit,Write,Bash"
```

### Fix Tests in Loop

```bash
claude -p "Run tests and fix failures" \
  --allowedTools "Bash(npm test:*),Bash(npm run:*),Read,Edit" \
  --max-turns 5
```

## Best Practices

1. **Always use JSON for automation**
   ```bash
   claude -p "Task" --output-format json > result.json
   ```

2. **Use session IDs for multi-step workflows**
   ```bash
   SESSION=$(claude -p "Step 1" --output-format json | jq -r '.session_id')
   claude -p "Step 2" --resume "$SESSION"
   ```

3. **Set `--max-turns` in CI/CD** to control cost and prevent loops

4. **Use plan mode for safe analysis**
   ```bash
   claude -p "Analyze risks" --permission-mode plan
   ```

5. **Handle errors properly** - check exit codes in scripts

6. **Capture stderr** for debugging
   ```bash
   claude -p "Task" --output-format json 2> error.log
   ```

## Troubleshooting

| Problem | Solution |
|---------|----------|
| "Command not found: claude" | Run `curl https://install.claude.sh \| bash` |
| "Permission denied" with Bash | Add `--allowedTools "Bash,Edit,Read"` |
| Timeout / No response | Use `timeout 60 claude -p "Task"` |
| Invalid JSON output | Redirect stderr: `2> error.log` |

## CLI vs Interactive Comparison

| Aspect | CLI (`-p`) | Interactive |
|--------|------------|-------------|
| Mode | Non-interactive | REPL |
| Input | Arguments + stdin | Keyboard + `/` commands |
| Output | Structured formats | Terminal formatted |
| Continue | `--resume` | `/resume` command |
| Best for | Scripts, CI/CD, APIs | Manual development |

## Next steps

<CardGroup cols={2}>
  <Card title="Agent SDK quickstart" icon="play" href="https://platform.claude.com/docs/en/agent-sdk/quickstart">
    Build your first agent with Python or TypeScript
  </Card>

  <Card title="CLI reference" icon="terminal" href="/en/cli-reference">
    Explore all CLI flags and options
  </Card>

  <Card title="GitHub Actions" icon="github" href="/en/github-actions">
    Use the Agent SDK in GitHub workflows
  </Card>

  <Card title="GitLab CI/CD" icon="gitlab" href="/en/gitlab-ci-cd">
    Use the Agent SDK in GitLab pipelines
  </Card>
</CardGroup>


---

> To find navigation and other pages in this documentation, fetch the llms.txt file at: https://code.claude.com/docs/llms.txt