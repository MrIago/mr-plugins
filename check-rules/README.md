# Check Rules Plugin

Audit changed files against project rules with parallel batch processing using deterministic hooks to orchestrate AI agents.

## Features

- **Deterministic orchestration** - Bash hooks control the flow, not LLM interpretation
- **Parallel batch processing** - Up to 10 agents running simultaneously
- **Token optimized** - Only reports failures, ~98% less output
- **Scalable** - Handles 100+ files with multi-round execution
- **Auto-fix workflow** - Option to fix violations after audit

## Installation

```bash
/plugin marketplace add MrIago/mr-plugins
/plugin install check-rules@mr-plugins
```

## Usage

```bash
/check-rules:audit
```

## Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│  User: /check-rules:audit                                           │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│  UserPromptSubmit Hook (init.sh)                                    │
│  ─────────────────────────────────────────────────────────────────  │
│  1. Detects "/check-rules:audit"                                    │
│  2. git diff + git ls-files → collects modified files               │
│  3. Groups into batches of 10                                       │
│  4. Calculates rounds (max 10 batches per round)                    │
│  5. Creates state file JSON                                         │
│  6. Injects instructions: "Launch these 10 Task agents"             │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│  Claude Main Agent                                                  │
│  ─────────────────────────────────────────────────────────────────  │
│  Launches up to 10 rules-auditor in parallel (run_in_background)    │
│  Waits for TaskOutput from all                                      │
└─────────────────────────────────────────────────────────────────────┘
                                    │
            ┌───────────────────────┼───────────────────────┐
            ▼                       ▼                       ▼
┌───────────────────┐   ┌───────────────────┐   ┌───────────────────┐
│  rules-auditor    │   │  rules-auditor    │   │  rules-auditor    │
│  (haiku)          │   │  (haiku)          │   │  (haiku)          │
│  ───────────────  │   │  ───────────────  │   │  ───────────────  │
│  10 files each    │   │  10 files each    │   │  10 files each    │
│  Reads file       │   │  Reads file       │   │  Reads file       │
│  (rules injected) │   │  (rules injected) │   │  (rules injected) │
│  Returns: OK      │   │  Returns: OK      │   │  Returns: FAIL    │
│  or FAIL + list   │   │  or FAIL + list   │   │  file.ts: error   │
└───────────────────┘   └───────────────────┘   └───────────────────┘
            │                       │                       │
            └───────────────────────┼───────────────────────┘
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│  Stop Hook (loop.sh)                                                │
│  ─────────────────────────────────────────────────────────────────  │
│  if current_round < total_rounds:                                   │
│      → "block" + instructions for next round                        │
│  else:                                                              │
│      → delete state + "approve" (finish)                            │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                    ┌───────────────┴───────────────┐
                    ▼                               ▼
            [More rounds]                   [Last round]
                    │                               │
                    ▼                               ▼
            Loop back to                    Claude shows summary
            Main Agent                      If FAIL → AskUserQuestion
                                            → rules-fixer agents
```

## Components

| File | Type | Function |
|------|------|----------|
| `hooks/hooks.json` | Hook Config | Registers init.sh and loop.sh |
| `scripts/init.sh` | UserPromptSubmit Hook | Detects command, collects files, creates state, launches round 1 |
| `scripts/loop.sh` | Stop Hook | Continues rounds or finalizes |
| `commands/audit.md` | Slash Command | Defines allowed tools and final instructions |
| `agents/rules-auditor.md` | Subagent (haiku) | Audits batch of files, returns "OK" or "FAIL" |
| `agents/rules-fixer.md` | Subagent (sonnet) | Fixes identified violations |

## Why Hooks?

**Problem**: LLMs are not deterministic. Asking "read all files from git diff" sometimes gets 5, sometimes 10.

**Solution**: Hooks are bash scripts → 100% deterministic. The hook collects files and **injects** the exact list for Claude to execute.

```
Hook (deterministic)       →  "Launch Task for: file1, file2, file3..."
Claude (non-deterministic) →  Executes exactly what was asked
```

## Context Optimizations

| Problem | Solution |
|---------|----------|
| 10 agents fill context | Each agent returns only "OK" or errors |
| Listing passed files | Never lists - only reports failures |
| Subagents can't spawn subagents | Batching: 1 agent processes 10 files sequentially |
| 100+ files | Multi-round: 10 batches per round, loop via Stop hook |

## State File Schema

```json
{
  "files": ["/path/file1.ts", "/path/file2.ts", ...],
  "total_files": 150,
  "batch_size": 10,
  "max_parallel": 10,
  "total_batches": 15,
  "total_rounds": 2,
  "current_round": 1
}
```

## Example: 150 Files

```
Round 1: Launches batches 1-10 (100 files) in parallel
         Stop hook: current=1, total=2 → block + round 2

Round 2: Launches batches 11-15 (50 files) in parallel
         Stop hook: current=2, total=2 → approve + delete state

End: Claude shows "All pass" or lists failures
```

## Auto-Injection of Rules

When the agent reads a file, Claude Code automatically injects applicable rules based on the `paths:` frontmatter:

```markdown
---
paths: packages/types/**
---
# Types Package Rules
## [ ] Use pure types, not Zod
```

Agent reads `packages/types/result.ts` → receives file + rules above in context.

## Token Cost

| Scenario | Approximate Tokens |
|----------|-------------------|
| 100 files, all OK | ~50 tokens (10x "OK") |
| 100 files, 3 errors | ~100 tokens (7x "OK" + 3 errors) |
| Before optimization | ~5000 tokens (listed everything) |

**Reduction: ~98% tokens** in agent output.

## Requirements

- Project must have rules in `.claude/rules/` with `## [ ]` checkboxes
- Rules use frontmatter `paths:` to match files (or `global` for all files)

## Example Rule

```markdown
---
paths: src/**/*.ts
---

# TypeScript Rules

## [ ] Use explicit return types
## [ ] Handle errors with Result pattern
## [ ] No console.log in production code

# Examples

## 1

\`\`\`typescript
// Correct: explicit return type + Result pattern
function getUser(id: string): Result<User> {
  return ok(user)
}
\`\`\`
```

## Author

**mriago**
- GitHub: [MrIago](https://github.com/MrIago)
- LinkedIn: [mriago](https://www.linkedin.com/in/mriago/)
- YouTube: [@mriago](https://www.youtube.com/@mriago)

## License

MIT
