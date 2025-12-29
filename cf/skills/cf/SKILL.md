---
name: cf
description: Cloudflare platform development. Use PROACTIVELY when building Workers, Durable Objects, Queues, Workflows, AI, Hyperdrive, Containers, Sandbox, Browser Rendering, or using any Cloudflare service.
---

# Cloudflare Platform

Comprehensive knowledge base for building on Cloudflare's developer platform.

## How to Use This Skill

1. Identify the Cloudflare services you need, you can explore multiple services at the same time.
2. Ship background agents to explore each resource to look for what you need to know specificaly about each one:
    - Ask it to read the corresponding `overview.md` for core concepts and patterns
    - Instruct each agent that overviews are only the beginning. Alway dive into `reference/` subdirectories for detailed documentation
    - Each resource has its own reference structure with examples, tutorials, and API docs
4. While the agents are exploring, always read the full ./resources/intro.md file (~1400 lines), that is the official cloudflare resources overview.
3. Gather the information from the agents and the intro.md file and combine it to answer or do what was asked.

Attention: Always ship background agents in parallel, do not wait for one to finish before starting another. You can have up to 10 agents running at the same time.

## Resources Navigation

### Core Compute

| Resource | Use when | Path |
|----------|----------|------|
| **Workers** | Serverless functions, fetch handlers, cron, bindings | [workers/overview.md](resources/workers/overview.md) |
| **Durable Objects** | Stateful actors, WebSockets, SQLite, alarms | [durable-objects/overview.md](resources/durable-objects/overview.md) |
| **Containers** | Long-running processes, full Linux containers | [containers/overview.md](resources/containers/overview.md) |

### Orchestration & Messaging

| Resource | Use when | Path |
|----------|----------|------|
| **Workflows** | Durable execution, steps, retries, long-running tasks | [workflows/overview.md](resources/workflows/overview.md) |
| **Queues** | Message queues, background jobs, batching | [queues/overview.md](resources/queues/overview.md) |

### Data & Storage

| Resource | Use when | Path |
|----------|----------|------|
| **Hyperdrive** | PostgreSQL/MySQL connection pooling, query caching | [hyperdrive/overview.md](resources/hyperdrive/overview.md) |

### AI & Automation

| Resource | Use when | Path |
|----------|----------|------|
| **Workers AI** | LLM inference, embeddings, image generation | [workers-ai/overview.md](resources/workers-ai/overview.md) |
| **Agents** | AI agents, tool use, MCP servers | [agents/overview.md](resources/agents/overview.md) |
| **Sandbox** | Code execution, Claude Code, isolated containers | [sandbox/overview.md](resources/sandbox/overview.md) |
| **Browser Rendering** | Puppeteer, screenshots, PDF generation | [browser-rendering/overview.md](resources/browser-rendering/overview.md) |

### Platform Features

| Resource | Use when | Path |
|----------|----------|------|
| **Workers for Platforms** | Multi-tenant, dispatch namespaces, user scripts | [workers-for-platforms/overview.md](resources/workers-for-platforms/overview.md) |
| **OpenNext** | Next.js on Workers, opennextjs-cloudflare | [open-next/overview.md](resources/open-next/overview.md) |

### Tooling

| Resource | Use when | Path |
|----------|----------|------|
| **Wrangler** | CLI commands, deploy, dev, d1, r2, kv | [wrangler/overview.md](resources/wrangler/overview.md) |