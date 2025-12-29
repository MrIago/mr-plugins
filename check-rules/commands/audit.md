---
description: Audit changed files against project rules
allowed-tools: Task, TaskOutput, Read
---

# Check Rules Audit

Read `.claude/state/check-rules.json` to get file list and batch info.

## Execution

1. Read state file
2. Calculate which files belong to current round's batches:
   - batch_size = 10 files per agent
   - max_parallel = 10 agents per round
   - Round N processes batches: ((N-1)*10) to (N*10-1)
3. Launch agents in SINGLE message with `run_in_background: true`
4. Each agent: `subagent_type=rules-auditor, model=haiku, prompt="Audit: file1, file2..."`
5. Wait ALL TaskOutput
6. Stop (hook handles next round)

## Agent Response

Each agent returns ONLY:
- "OK" if all files pass
- "FAIL: path1, path2" listing only failed files

## Final Summary

After all rounds, show:
- Total files audited
- Pass/fail count
- List of failures with reasons
