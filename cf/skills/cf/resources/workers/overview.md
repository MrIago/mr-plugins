---
name: cf-workers
description: Cloudflare Workers development. Use when building serverless apps, APIs, fetch handlers, cron triggers, bindings (KV, R2, D1, DO, Queues), service bindings, RPC, wrangler config, or deploying to Cloudflare.
---

# Cloudflare Workers

Serverless platform for building and deploying apps across Cloudflare's global network.

## Setup

```bash
npm create cloudflare@latest my-worker
cd my-worker
npx wrangler dev      # Local development
npx wrangler deploy   # Deploy to Cloudflare
```

## Basic Worker

```typescript
export default {
  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    return new Response('Hello World!');
  },
};
```

## Wrangler Config (wrangler.jsonc)

```jsonc
{
  "$schema": "./node_modules/wrangler/config-schema.json",
  "name": "my-worker",
  "main": "src/index.ts",
  "compatibility_date": "2024-12-01",

  // Environment variables
  "vars": { "API_HOST": "example.com" },

  // KV namespace
  "kv_namespaces": [{ "binding": "MY_KV", "id": "<KV_ID>" }],

  // D1 database
  "d1_databases": [{ "binding": "DB", "database_name": "my-db", "database_id": "<DB_ID>" }],

  // R2 bucket
  "r2_buckets": [{ "binding": "BUCKET", "bucket_name": "my-bucket" }],

  // Durable Objects
  "durable_objects": {
    "bindings": [{ "name": "MY_DO", "class_name": "MyDurableObject" }]
  },
  "migrations": [{ "tag": "v1", "new_sqlite_classes": ["MyDurableObject"] }],

  // Service bindings (call other Workers)
  "services": [{ "binding": "OTHER_WORKER", "service": "other-worker-name" }],

  // Queues
  "queues": {
    "producers": [{ "binding": "MY_QUEUE", "queue": "my-queue" }],
    "consumers": [{ "queue": "my-queue", "max_batch_size": 10 }]
  },

  // Cron triggers
  "triggers": { "crons": ["0 * * * *"] },

  // Workers AI
  "ai": { "binding": "AI" },

  // Static assets
  "assets": { "directory": "./public", "binding": "ASSETS" }
}
```

## Handlers

### Fetch Handler (HTTP)

```typescript
export default {
  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    const url = new URL(request.url);
    if (url.pathname === '/api/data') {
      return Response.json({ data: await env.MY_KV.get('key') });
    }
    return new Response('Not Found', { status: 404 });
  },
};
```

### Scheduled Handler (Cron)

```typescript
export default {
  async scheduled(controller: ScheduledController, env: Env, ctx: ExecutionContext) {
    ctx.waitUntil(doBackgroundTask());
  },
  async fetch(request: Request, env: Env, ctx: ExecutionContext) {
    return new Response('OK');
  },
};
```

Test: `npx wrangler dev --test-scheduled` then `curl "http://localhost:8787/__scheduled"`

### Queue Handler

```typescript
export default {
  async queue(batch: MessageBatch<MyMessage>, env: Env) {
    for (const message of batch.messages) {
      console.log(message.body);
      message.ack();
    }
  },
  async fetch(request: Request, env: Env) {
    await env.MY_QUEUE.send({ data: 'hello' });
    return new Response('Queued');
  },
};
```

## Service Bindings (RPC)

### Worker B (provides RPC methods)

```typescript
import { WorkerEntrypoint } from 'cloudflare:workers';

export default class extends WorkerEntrypoint {
  async fetch() { return new Response('Hello from Worker B'); }
  add(a: number, b: number) { return a + b; }
  async getData(id: string) {
    return this.env.DB.prepare('SELECT * FROM data WHERE id = ?').bind(id).first();
  }
}
```

### Worker A (calls Worker B)

```jsonc
{ "services": [{ "binding": "WORKER_B", "service": "worker-b" }] }
```

```typescript
export default {
  async fetch(request: Request, env: Env) {
    const result = await env.WORKER_B.add(1, 2);  // Direct RPC call
    return new Response(String(result));
  },
};
```

### Named Entrypoints

```typescript
import { WorkerEntrypoint } from 'cloudflare:workers';

export class AdminEntrypoint extends WorkerEntrypoint {
  async deleteUser(id: string) { /* admin only */ }
}

export class UserEntrypoint extends WorkerEntrypoint {
  async getProfile(id: string) { /* user methods */ }
}

export default class extends WorkerEntrypoint {
  async fetch() { return new Response('Hello'); }
}
```

Bind: `{ "services": [{ "binding": "ADMIN", "service": "my-worker", "entrypoint": "AdminEntrypoint" }] }`

## Bindings Quick Reference

```typescript
// KV
await env.MY_KV.get('key');
await env.MY_KV.put('key', 'value', { expirationTtl: 3600 });

// D1
const { results } = await env.DB.prepare('SELECT * FROM users WHERE id = ?').bind(userId).all();
await env.DB.prepare('INSERT INTO users (name) VALUES (?)').bind(name).run();

// R2
const object = await env.BUCKET.get('file.txt');
await env.BUCKET.put('file.txt', content, { httpMetadata: { contentType: 'text/plain' } });

// Durable Objects
const id = env.MY_DO.idFromName('room-123');
const stub = env.MY_DO.get(id);
const response = await stub.fetch(request);

// Queues
await env.MY_QUEUE.send({ type: 'email', to: 'user@example.com' });
```

## Context (ctx)

```typescript
ctx.waitUntil(logToAnalytics(request));  // Continue after response
ctx.passThroughOnException();             // Pass to origin on error
```

## Static Assets

```jsonc
{
  "assets": {
    "directory": "./public",
    "binding": "ASSETS",
    "html_handling": "auto-trailing-slash",
    "not_found_handling": "single-page-application",
    "run_worker_first": ["/api/*"]
  }
}
```

## Environments

```jsonc
{
  "name": "my-worker",
  "vars": { "ENV": "production" },
  "env": {
    "staging": {
      "name": "my-worker-staging",
      "vars": { "ENV": "staging" }
    }
  }
}
```

Deploy: `npx wrangler deploy --env staging`

## Local Development

```bash
npx wrangler dev                      # Start local server
npx wrangler dev --remote             # Use remote resources
npx wrangler dev --persist-to ./data  # Persist local state
```

`.dev.vars` for secrets: `SECRET_KEY="local-secret"`

## Deploy & Types

```bash
npx wrangler deploy                 # Deploy
npx wrangler tail                   # Stream logs
npx wrangler types                  # Generate Env types
```

## Code Standards

- TypeScript by default, ES modules only (never Service Worker format)
- Import all methods/classes/types used
- Single file unless otherwise specified
- Use official SDKs when available, minimize dependencies
- No FFI/native/C bindings libraries
- Never hardcode secrets, use env vars
- Include error handling and logging

## Required Config

```jsonc
{
  "compatibility_date": "2025-01-01",
  "compatibility_flags": ["nodejs_compat"],
  "observability": { "enabled": true }
}
```

## Storage Selection

| Need | Use |
|------|-----|
| Key-value, config, profiles | KV |
| Consistent state, coordination, agents | Durable Objects |
| Relational data, SQL | D1 |
| Files, images, uploads | R2 |
| Existing Postgres | Hyperdrive |
| Async processing, background | Queues |
| Embeddings, vector search | Vectorize |
| Metrics, analytics, billing | Analytics Engine |
| AI inference | Workers AI |
| Headless browser | Browser Rendering |
| Frontend/static files | Static Assets |

## Security

- Validate all request inputs
- Use appropriate security headers
- Handle CORS correctly
- Implement rate limiting where needed
- Sanitize user inputs
- Follow least privilege for bindings

## Reference

375 reference files organized by category:

```
reference/
├── api/                  # API reference
├── examples/             # 48 code examples (CORS, caching, auth, etc)
├── misc/                 # 258 files (bindings, handlers, frameworks, etc)
│   ├── configuration-wrangler.md
│   ├── fetch-handler.md
│   ├── scheduled-handler.md
│   ├── service-bindings-rpc-workerentrypoint.md
│   ├── kv.md, d1.md, r2.md, queues.md
│   ├── durable-objects.md
│   ├── next-js.md, astro.md, hono.md, nuxt.md
│   └── ... (see reference/misc/)
├── observability/        # 24 files (logs, traces, profiling)
├── platform/             # 13 files (limits, pricing, changelog)
├── reference/            # 13 files (architecture, security)
└── tutorials/            # 18 tutorials
```
