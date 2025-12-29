# Claude Code LSP (Language Server Protocol)

> Semantic code intelligence for precise navigation

---

## What Is LSP

LSP provides semantic code understanding instead of text-based searching. Claude Code communicates with language-specific analyzers to get deterministic results.

**Without LSP:**
- Grep finds all text occurrences (including comments, strings)
- Results are heuristic-based

**With LSP:**
- Find exact definitions without ambiguity
- Understand types, imports, interfaces
- Reduced token cost (single operation vs multiple reads)
- Higher precision for refactoring

---

## LSP Operations

| Operation | Description |
|-----------|-------------|
| `goToDefinition` | Find where symbol is defined |
| `findReferences` | Find all usages of symbol |
| `hover` | Get type info and documentation |
| `documentSymbol` | List all symbols in file |
| `workspaceSymbol` | Search symbols across project |
| `goToImplementation` | Find interface implementations |
| `prepareCallHierarchy` | Get function info for hierarchy |
| `incomingCalls` | Find functions that call this |
| `outgoingCalls` | Find functions this calls |

---

## Enabling LSP

### Environment Variable

```bash
# Export before running
export ENABLE_LSP_TOOLS=1
claude

# Single command
ENABLE_LSP_TOOLS=1 claude -p "Find references"
```

### Settings File

```json
{
  "env": {
    "ENABLE_LSP_TOOLS": "1"
  }
}
```

---

## Installing Language Servers

LSP servers must be installed separately:

```bash
# TypeScript (vtsls)
npm install -g vtsls

# Python (pyright)
npm install -g pyright

# Go (gopls)
go install golang.org/x/tools/gopls@latest

# Rust (rust-analyzer)
rustup component add rust-analyzer
```

---

## Configuration (.lsp.json)

Create `.lsp.json` at project root:

### TypeScript

```json
{
  "typescript": {
    "command": ["vtsls", "--stdio"],
    "initializationOptions": {
      "preferences": {
        "importModuleSpecifierPreference": "relative"
      }
    },
    "extensionToLanguage": {
      ".tsx": "typescript",
      ".ts": "typescript"
    },
    "startupTimeout": 15000
  }
}
```

### Python

```json
{
  "python": {
    "command": ["pyright-langserver", "--stdio"],
    "initializationOptions": {
      "pythonPath": "/usr/bin/python3",
      "typecheckingMode": "standard"
    },
    "startupTimeout": 10000
  }
}
```

### Go

```json
{
  "go": {
    "command": "gopls",
    "args": ["serve"]
  }
}
```

### Configuration Fields

| Field | Description |
|-------|-------------|
| `command` | Server startup command (must use `--stdio`) |
| `extensionToLanguage` | Map file extensions to language |
| `initializationOptions` | Config passed at startup |
| `settings` | Config after startup |
| `startupTimeout` | Startup wait time (ms) |

---

## Plugin-Based LSP

Easiest way to add LSP servers:

### Enable in settings.json

```json
{
  "enabledPlugins": {
    "typescript-lsp@claude-plugins-official": true,
    "pyright-lsp@claude-plugins-official": true
  }
}
```

---

## Debug Flag

```bash
claude --enable-lsp-logging
```

Logs stored in `~/.claude/debug/lsp-*.log`

Use for:
- Server startup failures
- Performance issues
- Protocol debugging

---

## Headless Usage

### Basic

```bash
ENABLE_LSP_TOOLS=1 claude -p "Find definition of getUserData" \
  --output-format json
```

### With Allowed Tools

```bash
ENABLE_LSP_TOOLS=1 claude -p "Find all references to this function" \
  --allowedTools "Read,LSP" \
  --output-format json
```

### Multi-Turn

```bash
# Start analysis
SESSION=$(ENABLE_LSP_TOOLS=1 claude -p "Analyze auth module" \
  --output-format json | jq -r '.session_id')

# Continue
ENABLE_LSP_TOOLS=1 claude -r "$SESSION" -p "Find all callers of validateToken" \
  --output-format json
```

### CI/CD Integration

```bash
#!/bin/bash

export ENABLE_LSP_TOOLS=1

# Type-aware code analysis
claude -p "Review type safety in the API layer" \
  --output-format json \
  --enable-lsp-logging > analysis.json
```

---

## LSP vs Text Search

| Aspect | Without LSP | With LSP |
|--------|-------------|----------|
| Accuracy | Heuristic | Deterministic |
| Token cost | High | Low |
| Speed | Fast initial | Slow startup, fast queries |
| Best for | Exploration | Refactoring, impact analysis |

---

## When to Use LSP

**Use LSP:**
- Refactoring code
- Finding implementations
- Understanding complex types
- Impact analysis
- Type-based generation

**Skip LSP:**
- Quick text searches
- Simple exploration
- Small codebases

---

## Resource Considerations

| Aspect | Impact |
|--------|--------|
| Startup | Seconds to parse project |
| Memory | Varies by language/project size |
| After warmup | Fast queries |

---

## Example: Next.js/TypeScript Config

```json
{
  "typescript": {
    "command": ["vtsls", "--stdio"],
    "initializationOptions": {
      "preferences": {
        "importModuleSpecifierPreference": "relative",
        "useAliasesForRenames": true,
        "quotePreference": "double"
      }
    },
    "settings": {
      "typescript": {
        "preferences": {
          "autoImportFileExcludePatterns": ["**/*node_modules*"],
          "includeAutoImports": true
        }
      }
    },
    "extensionToLanguage": {
      ".tsx": "typescript",
      ".ts": "typescript",
      ".jsx": "typescript",
      ".js": "typescript"
    },
    "startupTimeout": 15000
  }
}
```

---

## Container/Sandbox Setup

Install LSP servers in container image:

```dockerfile
# Install language servers
RUN npm install -g vtsls pyright
```

Include `.lsp.json` in project for auto-discovery.

---

## Quick Reference

### Enable LSP

```bash
export ENABLE_LSP_TOOLS=1
```

### Headless with LSP

```bash
ENABLE_LSP_TOOLS=1 claude -p "Query" --output-format json
```

### Debug Logging

```bash
claude --enable-lsp-logging
```

### Install Servers

```bash
npm install -g vtsls pyright
```

### Configure (.lsp.json)

```json
{
  "typescript": {
    "command": ["vtsls", "--stdio"],
    "extensionToLanguage": {
      ".ts": "typescript",
      ".tsx": "typescript"
    }
  }
}
```
