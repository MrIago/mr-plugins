# Check Rules Plugin

Audit changed files against project rules with parallel batch processing using deterministic hooks.

## Features

- **Deterministic orchestration** - Bash hooks control the flow, not LLM interpretation
- **Parallel batch processing** - Up to 10 agents × 10 files = 100 files per part
- **Token optimized** - Agents return only "OK" or error list (~98% less output)
- **Scalable** - Manual parts for 100+ files
- **Error logging** - Save failures to `.mr-plugins/check-rules/log.md`

## Installation

```bash
/plugin marketplace add MrIago/mr-plugins
/plugin install check-rules@mr-plugins
```

## Usage

```bash
# Audit up to 100 files
/check-rules:audit

# For 100+ files, run additional parts
/check-rules:audit 2
/check-rules:audit 3
```

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│  User: /check-rules:audit                                   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  UserPromptSubmit Hook (init.sh)                            │
│  ─────────────────────────────────────────────────────────  │
│  1. Detects "/check-rules:audit [N]"                        │
│  2. git diff + git ls-files → collects modified files       │
│  3. Groups into batches of 10 files                         │
│  4. Injects: "Launch 10 agents with these files"            │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  Claude Main Agent                                          │
│  ─────────────────────────────────────────────────────────  │
│  Launches up to 10 rules-auditor in parallel                │
│  Each agent receives 10 files in prompt                     │
│  Waits for all TaskOutput                                   │
└─────────────────────────────────────────────────────────────┘
                              │
          ┌───────────────────┼───────────────────┐
          ▼                   ▼                   ▼
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
│  rules-auditor  │ │  rules-auditor  │ │  rules-auditor  │
│  (haiku)        │ │  (haiku)        │ │  (haiku)        │
│  ─────────────  │ │  ─────────────  │ │  ─────────────  │
│  10 files each  │ │  10 files each  │ │  10 files each  │
│  Returns: OK    │ │  Returns: OK    │ │  Returns: FAIL  │
│  or FAIL + list │ │  or FAIL + list │ │  file.ts: error │
└─────────────────┘ └─────────────────┘ └─────────────────┘
          │                   │                   │
          └───────────────────┼───────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  Summary + Log                                              │
│  ─────────────────────────────────────────────────────────  │
│  - Shows pass/fail count                                    │
│  - Lists failed files with reasons                          │
│  - Asks: Save log to .mr-plugins/check-rules/log.md?        │
│  - If >100 files: "Run /check-rules:audit 2"                │
└─────────────────────────────────────────────────────────────┘
```

## Components

| File | Type | Function |
|------|------|----------|
| `hooks/hooks.json` | Hook Config | Registers init.sh |
| `scripts/init.sh` | UserPromptSubmit Hook | Collects files, builds agent list |
| `commands/audit.md` | Slash Command | Instructions for main agent |
| `agents/rules-auditor.md` | Subagent (haiku) | Audits files, returns OK or FAIL |

## Why Hooks?

**Problem**: LLMs are not deterministic. Asking "read all files from git diff" sometimes gets 5, sometimes 10.

**Solution**: Hooks are bash scripts → 100% deterministic.

```
Hook (deterministic)       →  "Launch 10 agents with these exact files"
Claude (non-deterministic) →  Executes exactly what was asked
```

## Token Optimizations

| Problem | Solution |
|---------|----------|
| Agents fill context | Each returns only "OK" or errors |
| Listing passed files | Never lists - only reports failures |
| 100+ files | Manual parts: /check-rules:audit 2, 3... |

## Example: 250 Files

```
/check-rules:audit      → Part 1: files 1-100 (10 agents × 10 files)
/check-rules:audit 2    → Part 2: files 101-200
/check-rules:audit 3    → Part 3: files 201-250

Each part shows summary and offers to save log.
```

## Auto-Injection of Rules

When agent reads a file, Claude Code injects matching rules based on `paths:` frontmatter:

```markdown
---
paths: packages/types/**
---
# Types Package Rules
## [ ] Use pure types, not Zod
```

Agent reads `packages/types/result.ts` → receives file + rules in context.

## Requirements

- Project must have rules in `.claude/rules/` with `## [ ]` checkboxes
- Rules use frontmatter `paths:` to match files

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
