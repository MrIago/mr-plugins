---
name: cf-durable-objects
description: Cloudflare Durable Objects development. Use when creating DO classes, SQLite storage, WebSockets, alarms, RPC between workers, streaming patterns, session management.
---

# Durable Objects

Stateful compute + storage on Cloudflare edge. Single-threaded per instance, globally unique ID.

## Basic Structure

```typescript
import { DurableObject } from "cloudflare:workers"

export class SessionDO extends DurableObject<Env> {
  constructor(ctx: DurableObjectState, env: Env) {
    super(ctx, env)
    ctx.blockConcurrencyWhile(async () => {
      this.ctx.storage.sql.exec(`
        CREATE TABLE IF NOT EXISTS events (
          id INTEGER PRIMARY KEY,
          data TEXT,
          created_at INTEGER DEFAULT (unixepoch())
        )
      `)
    })
  }

  async processEvent(data: string): Promise<{ success: boolean }> {
    this.ctx.storage.sql.exec("INSERT INTO events (data) VALUES (?)", data)
    return { success: true }
  }
}
```

## Wrangler Config

```jsonc
{
  "durable_objects": {
    "bindings": [{ "name": "SESSION", "class_name": "SessionDO" }]
  },
  "migrations": [{ "tag": "v1", "new_sqlite_classes": ["SessionDO"] }]
}
```

## Calling DO from Worker

```typescript
// By name (deterministic - same name = same instance)
const id = env.SESSION.idFromName(userId)
const stub = env.SESSION.get(id)
const result = await stub.processEvent(data)

// Or directly
const stub = env.SESSION.getByName(userId)
```

## WebSockets (Hibernatable)

```typescript
export class SessionDO extends DurableObject<Env> {
  async fetch(request: Request): Promise<Response> {
    if (request.headers.get("Upgrade") === "websocket") {
      const pair = new WebSocketPair()
      this.ctx.acceptWebSocket(pair[1])
      return new Response(null, { status: 101, webSocket: pair[0] })
    }
    return new Response("Expected WebSocket", { status: 400 })
  }

  webSocketMessage(ws: WebSocket, message: string | ArrayBuffer) {
    const data = typeof message === "string" ? message : new TextDecoder().decode(message)
    for (const client of this.ctx.getWebSockets()) {
      if (client !== ws) client.send(data)
    }
  }

  webSocketClose(ws: WebSocket, code: number, reason: string, wasClean: boolean) {
    ws.close(code, reason)
  }
}
```

## Alarms

```typescript
export class SessionDO extends DurableObject<Env> {
  async scheduleRetry(delayMs: number) {
    await this.ctx.storage.setAlarm(Date.now() + delayMs)
  }

  async alarm() {
    // Guaranteed at-least-once, make idempotent
    const pending = this.ctx.storage.sql.exec(
      "SELECT * FROM jobs WHERE status = 'pending'"
    ).toArray()
    for (const job of pending) {
      await this.processJob(job)
    }
  }
}
```

## Concurrency Model

```typescript
// Multiple writes without await = atomic batch
this.ctx.storage.sql.exec("INSERT INTO a VALUES (?)", 1)
this.ctx.storage.sql.exec("INSERT INTO b VALUES (?)", 2)

// await breaks atomicity - use transactions
this.ctx.storage.transactionSync(() => {
  const count = this.ctx.storage.sql.exec("SELECT count FROM counters WHERE id = 1").one()
  this.ctx.storage.sql.exec("UPDATE counters SET count = ? WHERE id = 1", count + 1)
})
```

## Long-Running Streams

```typescript
async streamGeneration(prompt: string) {
  const genId = crypto.randomUUID()
  this.ctx.storage.sql.exec(
    "INSERT INTO generations (id, status) VALUES (?, 'running')", genId
  )

  const sandbox = this.env.SANDBOX.get(this.env.SANDBOX.idFromName(genId))

  try {
    for await (const chunk of sandbox.runStream(prompt)) {
      this.ctx.storage.sql.exec(
        "INSERT INTO chunks (gen_id, data) VALUES (?, ?)",
        genId, JSON.stringify(chunk)
      )
      for (const ws of this.ctx.getWebSockets()) {
        ws.send(JSON.stringify(chunk))
      }
    }
    this.ctx.storage.sql.exec("UPDATE generations SET status = 'completed' WHERE id = ?", genId)
  } catch {
    this.ctx.storage.sql.exec("UPDATE generations SET status = 'failed' WHERE id = ?", genId)
    await this.ctx.storage.setAlarm(Date.now() + 5000)
  }
}
```


## Reference

```
reference/
├── api
│   ├── alarms.md
│   ├── durable-object-base-class.md
│   ├── durable-object-container.md
│   ├── durable-object-id.md
│   ├── durable-object-namespace.md
│   ├── durable-object-state.md
│   ├── durable-object-stub.md
│   ├── kv-backed-durable-object-storage-legacy.md
│   ├── rust-api.md
│   ├── sqlite-backed-durable-object-storage.md
│   ├── webgpu.md
│   └── workers-binding-api.md
├── best-practices
│   ├── access-durable-objects-storage.md
│   ├── best-practices.md
│   ├── error-handling.md
│   ├── invoke-methods.md
│   └── use-websockets.md
├── concepts
│   ├── concepts.md
│   ├── lifecycle-of-a-durable-object.md
│   └── what-are-durable-objects.md
├── examples
│   ├── agents.md
│   ├── build-a-counter.md
│   ├── build-a-rate-limiter.md
│   ├── build-a-websocket-server.md
│   ├── build-a-websocket-server-with-websocket-hibernation.md
│   ├── durable-object-in-memory-state.md
│   ├── durable-objects-use-kv-within-durable-objects.md
│   ├── durable-object-time-to-live.md
│   ├── examples.md
│   ├── testing-with-durable-objects.md
│   ├── use-readablestream-with-durable-object-and-workers.md
│   ├── use-rpctarget-class-to-handle-durable-object-metadata.md
│   └── use-the-alarms-api.md
├── misc
│   ├── demos-and-architectures.md
│   ├── getting-started.md
│   ├── overview.md
│   ├── release-notes.md
│   ├── rest-api.md
│   └── videos.md
├── observability
│   ├── data-studio.md
│   ├── metrics-and-analytics.md
│   ├── observability.md
│   └── troubleshooting.md
├── platform
│   ├── choose-a-data-or-storage-product.md
│   ├── known-issues.md
│   ├── limits.md
│   ├── platform.md
│   └── pricing.md
├── reference
│   ├── data-location.md
│   ├── data-security.md
│   ├── durable-objects-migrations.md
│   ├── environments.md
│   ├── faqs.md
│   ├── glossary.md
│   ├── gradual-deployments.md
│   ├── in-memory-state-in-a-durable-object.md
│   └── reference.md
└── tutorials
    ├── build-a-seat-booking-app-with-sqlite-in-durable-objects.md
    └── tutorials.md
```
