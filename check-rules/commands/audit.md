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

If any failures, MUST use AskUserQuestion tool with:
```json
{
  "questions": [{
    "question": "Save error log?",
    "header": "Log",
    "options": [
      {"label": "Yes", "description": "Save to .mr-plugins/check-rules/log.md"},
      {"label": "No", "description": "Skip saving"}
    ],
    "multiSelect": false
  }]
}
```

If user selects Yes:
1. Create directory .mr-plugins/check-rules/ if needed
2. Write log.md with date and failure details

DO NOT offer to fix files.
