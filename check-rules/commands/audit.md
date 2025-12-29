---
description: Audit changed files against project rules (auto-loop)
allowed-tools: Task, TaskOutput, AskUserQuestion, Read
---

# Check Rules Audit

**STOP. DO NOT RUN ANY COMMANDS.**

A UserPromptSubmit hook has already collected files and prepared Task agent instructions.

Look for the `<user-prompt-submit-hook>` section in your context - it contains:
- The exact list of files to audit
- Pre-configured Task agent commands to launch
- Batch and round information

**YOU MUST:**
1. Find the hook output with "CHECK-RULES AUDIT" header
2. Launch ALL Task agents listed there in a SINGLE message
3. Use `run_in_background: true` for each
4. Wait for ALL TaskOutput before stopping

**DO NOT:**
- Run git diff or any file discovery commands
- Decide which files to audit yourself
- Modify the Task agent parameters

## After All Rounds

Agents return "OK" or "FAIL" with file list.

- All "OK" → say "All files pass"
- Any "FAIL" → list failures, ask: "Fix all" or "Fix one by one", launch rules-fixer
