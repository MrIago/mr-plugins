---
name: cc
description: Claude Code CLI and SDK for programmatic use. Use when building sandbox agents, DO orchestrators, Sandbox SDK integrations, or any programmatic Claude Code execution (headless, streaming, CI/CD).
---


## How to Use This Skill

1. Identify the Claude Code topics you need from the Reference Navigation table below.
2. Ship background agents to explore each resource to look for what you need to know specifically about each one:
    - Ask it to read the corresponding `{topic_name}.md` and answer what you need to know about it.
3. Gather the information from the agents and combine it to answer or do what was asked.

Attention: Always ship background agents in parallel, do not wait for one to finish before starting another. You can have up to 10 agents running at the same time.


## Reference Navigation

Read the relevant reference file based on what you need:

### Getting Started

| Topic | Use when | Path |
|-------|----------|------|
| **Overview** | Introduction to Claude Code | [overview.md](reference/overview.md) |
| **Quickstart** | First-time setup guide | [quickstart.md](reference/quickstart.md) |
| **Common Workflows** | Typical usage patterns | [common-workflows.md](reference/common-workflows.md) |
| **Claude Code on the Web** | Cloud-based execution | [claude-code-on-the-web.md](reference/claude-code-on-the-web.md) |

### Core Features

| Topic | Use when | Path |
|-------|----------|------|
| **CLI Reference** | All CLI flags and commands | [cli-reference.md](reference/cli-reference.md) |
| **Headless Mode** | Programmatic execution (-p) | [headless.md](reference/headless.md) |
| **Output Formats** | JSON, stream-json parsing | [output-formats.md](reference/output-formats.md) |
| **Interactive Mode** | REPL, keyboard shortcuts | [interactive-mode.md](reference/interactive-mode.md) |
| **Memory** | CLAUDE.md, rules, context | [memory.md](reference/memory.md) |
| **Checkpointing** | Session state management | [checkpointing.md](reference/checkpointing.md) |

### Extensibility

| Topic | Use when | Path |
|-------|----------|------|
| **Skills** | Agent skills, custom capabilities | [skills.md](reference/skills.md) |
| **Sub-agents** | Custom subagents, delegation | [sub-agents.md](reference/sub-agents.md) |
| **Hooks** | Event hooks (pre/post tool) | [hooks.md](reference/hooks.md) |
| **Hooks Guide** | Practical hooks tutorial | [hooks-guide.md](reference/hooks-guide.md) |
| **MCP** | Model Context Protocol servers | [mcp.md](reference/mcp.md) |
| **Plugins** | Plugin system | [plugins.md](reference/plugins.md) |
| **Plugins Reference** | Plugin manifest schema | [plugins-reference.md](reference/plugins-reference.md) |
| **Plugin Marketplaces** | Plugin discovery/distribution | [plugin-marketplaces.md](reference/plugin-marketplaces.md) |
| **Slash Commands** | Custom commands | [slash-commands.md](reference/slash-commands.md) |
| **Output Styles** | Custom output formatting | [output-styles.md](reference/output-styles.md) |

### Integrations

| Topic | Use when | Path |
|-------|----------|------|
| **GitHub Actions** | GitHub CI/CD integration | [github-actions.md](reference/github-actions.md) |
| **GitLab CI/CD** | GitLab CI/CD integration | [gitlab-ci-cd.md](reference/gitlab-ci-cd.md) |
| **VS Code** | VS Code extension | [vs-code.md](reference/vs-code.md) |
| **JetBrains** | IntelliJ, PyCharm, etc. | [jetbrains.md](reference/jetbrains.md) |
| **DevContainer** | Dev container setup | [devcontainer.md](reference/devcontainer.md) |
| **LSP** | Language Server Protocol | [lsp.md](reference/lsp.md) |

### Deployment

| Topic | Use when | Path |
|-------|----------|------|
| **Cloudflare Integration** | Sandbox SDK, Workers, DO, headless boilerplates | [cloudflare.md](reference/cloudflare.md) |
| **Third-party Integrations** | Enterprise deployment overview | [third-party-integrations.md](reference/third-party-integrations.md) |
| **Amazon Bedrock** | AWS Bedrock setup | [amazon-bedrock.md](reference/amazon-bedrock.md) |
| **Google Vertex AI** | GCP Vertex setup | [google-vertex-ai.md](reference/google-vertex-ai.md) |
| **Network Config** | Proxy, CA certs, mTLS | [network-config.md](reference/network-config.md) |
| **LLM Gateway** | LiteLLM, gateway config | [llm-gateway.md](reference/llm-gateway.md) |
| **Sandboxing** | Sandbox security model | [sandboxing.md](reference/sandboxing.md) |

### Configuration

| Topic | Use when | Path |
|-------|----------|------|
| **Setup** | Installation, updates | [setup.md](reference/setup.md) |
| **Settings** | All configuration options | [settings.md](reference/settings.md) |
| **Model Config** | Model selection and config | [model-config.md](reference/model-config.md) |
| **Terminal Config** | Terminal customization | [terminal-config.md](reference/terminal-config.md) |
| **Statusline** | Custom status line | [statusline.md](reference/statusline.md) |
| **OpenRouter** | OpenRouter provider | [openrouter.md](reference/openrouter.md) |

### Administration

| Topic | Use when | Path |
|-------|----------|------|
| **IAM** | Identity, auth, permissions | [iam.md](reference/iam.md) |
| **Security** | Security best practices | [security.md](reference/security.md) |
| **Data Usage** | Privacy, data policies | [data-usage.md](reference/data-usage.md) |
| **Monitoring Usage** | OpenTelemetry metrics | [monitoring-usage.md](reference/monitoring-usage.md) |
| **Costs** | Token usage, cost tracking | [costs.md](reference/costs.md) |
| **Analytics** | Usage analytics dashboard | [analytics.md](reference/analytics.md) |

### Resources

| Topic | Use when | Path |
|-------|----------|------|
| **Troubleshooting** | Common issues, fixes | [troubleshooting.md](reference/troubleshooting.md) |
| **Legal and Compliance** | Terms, BAA, compliance | [legal-and-compliance.md](reference/legal-and-compliance.md) |
