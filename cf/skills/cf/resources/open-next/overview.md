---
name: cf-open-next
description: OpenNext/Cloudflare adapter for Next.js. Use when deploying Next.js to Workers, configuring caching (ISR/SSG/R2), bindings, DO Queue, Tag Cache, Drizzle/Prisma setup.
---

# OpenNext Cloudflare

Deploy Next.js to Cloudflare Workers via `@opennextjs/cloudflare`.

## Quick Start

```bash
# New project
npm create cloudflare@latest -- my-app --framework=next --platform=workers

# Existing project
npm install @opennextjs/cloudflare@latest wrangler@latest
```

## Essential Config

### wrangler.jsonc

```jsonc
{
  "main": ".open-next/worker.js",
  "name": "my-app",
  "compatibility_date": "2024-12-30",
  "compatibility_flags": ["nodejs_compat"],
  "assets": { "directory": ".open-next/assets", "binding": "ASSETS" },
  "services": [{ "binding": "WORKER_SELF_REFERENCE", "service": "my-app" }]
}
```

### open-next.config.ts

```typescript
import { defineCloudflareConfig } from "@opennextjs/cloudflare";
import r2IncrementalCache from "@opennextjs/cloudflare/overrides/incremental-cache/r2-incremental-cache";
import doQueue from "@opennextjs/cloudflare/overrides/queue/do-queue";

export default defineCloudflareConfig({
  incrementalCache: r2IncrementalCache,
  queue: doQueue,
  enableCacheInterception: true,
});
```

### next.config.ts

```typescript
import { initOpenNextCloudflareForDev } from "@opennextjs/cloudflare";
initOpenNextCloudflareForDev();

export default {
  serverExternalPackages: ["@prisma/client", ".prisma/client", "postgres"],
};
```

## Bindings

```typescript
import { getCloudflareContext } from "@opennextjs/cloudflare";

// SSR
const { env } = getCloudflareContext();

// SSG/ISR
const { env } = await getCloudflareContext({ async: true });
```

## ORM (per-request client)

```typescript
import { getCloudflareContext } from "@opennextjs/cloudflare";
import { drizzle } from "drizzle-orm/node-postgres";
import { cache } from "react";
import { Pool } from "pg";

export const getDb = cache(() => {
  const { env } = getCloudflareContext();
  return drizzle(new Pool({
    connectionString: env.HYPERDRIVE.connectionString,
    maxUses: 1,
  }));
});
```

## Reference

```
reference/
├── caching.md                 # ISR, R2, Queue, Tag Cache
├── cloudflare.md              # Adapter overview
├── deploy-*.md                # New/existing project setup
├── drizzle-orm.md             # Drizzle setup
├── prisma-orm.md              # Prisma setup
├── troubleshooting.md         # Common errors
└── ...
```
