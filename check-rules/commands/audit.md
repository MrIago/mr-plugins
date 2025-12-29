---
description: Audit changed files against project rules (auto-loop)
allowed-tools: Task, TaskOutput, AskUserQuestion, Read
---

# Check Rules Audit

Follow hook instructions above.

## After All Rounds

Agents return "OK" or "FAIL" with file list.

- All "OK" → say "All files pass"
- Any "FAIL" → list failures, ask: "Fix all" or "Fix one by one", launch rules-fixer
