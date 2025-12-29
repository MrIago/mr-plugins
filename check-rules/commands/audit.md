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

If user selects Yes, use Write tool directly to .mr-plugins/check-rules/log.md (it creates dirs automatically).

DO NOT offer to fix files.
DO NOT use Bash mkdir - Write tool handles it.
