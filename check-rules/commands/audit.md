---
description: Audit changed files against project rules
allowed-tools: Task, TaskOutput, Write
---

Hook injected agents and files above.

Launch ALL agents in ONE message (run_in_background=true each).

Wait ALL TaskOutput.

Show summary:
- Total files audited
- Pass count
- Fail count with file paths and reasons

If failures exist, ask: "Save error log to .claude/check-rules-log.md?"

If yes, write markdown file with:
- Date/time
- List of failed files with reasons
- User can review and fix manually later
