---
description: Audit changed files against project rules
allowed-tools: Task, TaskOutput, Write, AskUserQuestion
---

Hook injected agents and files above.

Launch ALL agents in ONE message (run_in_background=true each).

Wait ALL TaskOutput.

Show summary table:
- Total files
- Passed
- Failed (with paths and reasons)

If any failures, use AskUserQuestion tool:
- question: "Save error log?"
- options: ["Yes, save to .claude/check-rules-log.md", "No"]

If user says yes, Write the log file with date and failure details.

DO NOT offer to fix files. User will fix manually.
