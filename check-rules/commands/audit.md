---
description: Audit changed files against project rules
allowed-tools: Task, TaskOutput, AskUserQuestion
---

Hook injected Task commands above.

**CRITICAL: Launch ALL agents in ONE response with MULTIPLE Task tool calls in PARALLEL.**

Do NOT launch one agent, wait, then launch another.
Send SINGLE message with ALL Task invocations at once.

Each Task: subagent_type=rules-auditor, model=haiku, run_in_background=true

After ALL launched, wait ALL TaskOutput.

Show summary table. If failures, ask to fix.
