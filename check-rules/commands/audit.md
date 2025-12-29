---
description: Audit changed files against project rules
allowed-tools: Task, TaskOutput, AskUserQuestion
---

Hook injected file list and Task commands above.

Execute ALL Task agents in SINGLE message with run_in_background: true.

Wait ALL TaskOutput.

Show summary:
- Files audited
- Pass/fail count
- List failures

If failures, ask: "Fix all at once" or "Fix one by one"
