# Claude Code with OpenRouter

> Use Claude Code with any model via OpenRouter

Source: https://openrouter.ai/docs/guides/claude-code-integration

---

## Quick Start

### Step 1: Install Claude Code

```bash
# macOS, Linux, WSL
curl -fsSL https://claude.ai/install.sh | bash

# Windows PowerShell
irm https://claude.ai/install.ps1 | iex

# npm (requires Node.js 18+)
npm install -g @anthropic-ai/claude-code
```

### Step 2: Connect to OpenRouter

**Shell Profile (~/.bashrc, ~/.zshrc):**

```bash
export ANTHROPIC_BASE_URL="https://openrouter.ai/api"
export ANTHROPIC_AUTH_TOKEN="$OPENROUTER_API_KEY"
export ANTHROPIC_API_KEY="" # Important: Must be explicitly empty
```

**Or Project Settings (.claude/settings.local.json):**

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://openrouter.ai/api",
    "ANTHROPIC_AUTH_TOKEN": "<your-openrouter-api-key>",
    "ANTHROPIC_API_KEY": ""
  }
}
```

**Warning:** Do not use `.env` files - Claude Code native installer doesn't read them.

### Step 3: Verify

```bash
cd /path/to/your/project
claude
```

Inside Claude Code:
```
> /status
Auth token: ANTHROPIC_AUTH_TOKEN
Anthropic base URL: https://openrouter.ai/api
```

---

## Changing Models

By default, OpenRouter maps Claude Code aliases (Sonnet, Opus, Haiku) to Anthropic models.

### Override with Any Model

**Important:** Selected model must support tool use. See [models with tool use](https://openrouter.ai/models?supported_parameters=tools).

```bash
# Use GPT instead of Sonnet
export ANTHROPIC_DEFAULT_SONNET_MODEL="openai/gpt-5.1-codex-max"

# Override other tiers
export ANTHROPIC_DEFAULT_OPUS_MODEL="openai/gpt-5.2-pro"
export ANTHROPIC_DEFAULT_HAIKU_MODEL="minimax/minimax-m2:exacto"
```

### Using Presets

For fallbacks, custom prompts, or provider routing:

1. Create preset at [openrouter.ai/settings/presets](https://openrouter.ai/settings/presets)
2. Use as model:

```bash
export ANTHROPIC_DEFAULT_SONNET_MODEL="@preset/my-coding-setup"
```

---

## How It Works

1. **Direct Connection** - Claude Code speaks native Anthropic protocol to OpenRouter (no proxy needed)
2. **Anthropic Skin** - OpenRouter behaves exactly like Anthropic API
3. **Billing** - Uses OpenRouter credits, usage in dashboard

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Tool Use Errors | Model doesn't support tool use. Use [compatible model](https://openrouter.ai/models?supported_parameters=tools) |
| Auth Errors | Ensure `ANTHROPIC_API_KEY=""` (empty string, not unset) |
| Context Length Errors | Use models with 128k+ context |
| Privacy | OpenRouter doesn't log prompts unless opted-in |

---

## Environment Variables Summary

| Variable | Value |
|----------|-------|
| `ANTHROPIC_BASE_URL` | `https://openrouter.ai/api` |
| `ANTHROPIC_AUTH_TOKEN` | Your OpenRouter API key |
| `ANTHROPIC_API_KEY` | `""` (empty string) |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | Any OpenRouter model (optional) |
| `ANTHROPIC_DEFAULT_OPUS_MODEL` | Any OpenRouter model (optional) |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | Any OpenRouter model (optional) |
