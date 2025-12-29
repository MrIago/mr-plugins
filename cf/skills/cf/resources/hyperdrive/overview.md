---
name: cf-hyperdrive
description: Cloudflare Hyperdrive development. Use when connecting to PostgreSQL, MySQL, Neon, PlanetScale, Supabase, or any external database from Workers with connection pooling and query caching.
---

# Hyperdrive

Accelerate database access from Workers. Connection pooling + query caching for PostgreSQL/MySQL.

## Setup

### 1. Create Hyperdrive Config

```bash
# PostgreSQL
npx wrangler hyperdrive create my-db --connection-string="postgres://user:pass@host:5432/dbname"

# MySQL
npx wrangler hyperdrive create my-db --connection-string="mysql://user:pass@host:3306/dbname"
```

### 2. Wrangler Config

```jsonc
{
  "compatibility_flags": ["nodejs_compat"],
  "hyperdrive": [{
    "binding": "DB",
    "id": "<HYPERDRIVE_ID>",
    "localConnectionString": "postgres://user:pass@localhost:5432/dbname"
  }]
}
```

## PostgreSQL with postgres.js

```typescript
import postgres from 'postgres';

export default {
  async fetch(request: Request, env: Env) {
    const sql = postgres(env.DB.connectionString);

    const users = await sql`SELECT * FROM users WHERE active = true`;

    return Response.json(users);
  }
};
```

## PostgreSQL with node-postgres (pg)

```typescript
import { Client } from 'pg';

export default {
  async fetch(request: Request, env: Env) {
    const client = new Client({ connectionString: env.DB.connectionString });
    await client.connect();

    const { rows } = await client.query('SELECT * FROM users');

    return Response.json(rows);
  }
};
```

## MySQL with mysql2

```typescript
import { createConnection } from 'mysql2/promise';

export default {
  async fetch(request: Request, env: Env) {
    const connection = await createConnection({
      host: env.DB.host,
      user: env.DB.user,
      password: env.DB.password,
      database: env.DB.database,
      port: env.DB.port
    });

    const [rows] = await connection.execute('SELECT * FROM users');

    return Response.json(rows);
  }
};
```

## With Drizzle ORM

```typescript
import { drizzle } from 'drizzle-orm/postgres-js';
import postgres from 'postgres';
import * as schema from './schema';

export default {
  async fetch(request: Request, env: Env) {
    const client = postgres(env.DB.connectionString);
    const db = drizzle(client, { schema });

    const users = await db.select().from(schema.users);

    return Response.json(users);
  }
};
```

## With Prisma

```typescript
import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import { Client } from 'pg';

export default {
  async fetch(request: Request, env: Env) {
    const client = new Client({ connectionString: env.DB.connectionString });
    await client.connect();

    const adapter = new PrismaPg(client);
    const prisma = new PrismaClient({ adapter });

    const users = await prisma.user.findMany();

    return Response.json(users);
  }
};
```

## Hyperdrive Binding Properties

```typescript
interface Hyperdrive {
  connectionString: string;  // Full connection string
  host: string;              // Hyperdrive host
  port: number;              // Hyperdrive port
  user: string;              // Database username
  password: string;          // Database password
  database: string;          // Database name
}
```

## Query Caching

Hyperdrive caches read queries by default. Control caching:

```bash
# Disable caching
npx wrangler hyperdrive update my-db --caching-disabled=true

# Max age (seconds)
npx wrangler hyperdrive update my-db --max-age=60

# Stale-while-revalidate
npx wrangler hyperdrive update my-db --swr=30
```

## Private Database (via Tunnel)

```bash
# Create tunnel
cloudflared tunnel create my-tunnel

# Route tunnel to database
cloudflared tunnel route ip add 10.0.0.0/8 my-tunnel

# Create Hyperdrive with Access
npx wrangler hyperdrive create my-db \
  --connection-string="postgres://user:pass@internal-db:5432/dbname" \
  --access-client-id="<CLIENT_ID>" \
  --access-client-secret="<CLIENT_SECRET>"
```

## Local Development

Use `localConnectionString` to connect directly during dev:

```jsonc
{
  "hyperdrive": [{
    "binding": "DB",
    "id": "<HYPERDRIVE_ID>",
    "localConnectionString": "postgres://user:pass@localhost:5432/dbname"
  }]
}
```

## Rotate Credentials

```bash
# Update connection string
npx wrangler hyperdrive update my-db \
  --connection-string="postgres://newuser:newpass@host:5432/dbname"
```

## Supported Databases

| Database | Protocol |
|----------|----------|
| PostgreSQL | postgres:// |
| MySQL | mysql:// |
| Neon | postgres:// |
| Supabase | postgres:// |
| PlanetScale | mysql:// |
| CockroachDB | postgres:// |
| Timescale | postgres:// |
| AWS RDS/Aurora | postgres:// or mysql:// |

## Reference

```
reference/
├── concepts
│   ├── concepts.md
│   ├── connection-lifecycle.md
│   ├── connection-pooling.md
│   ├── how-hyperdrive-works.md
│   └── query-caching.md
├── examples
│   ├── aws-rds-and-aurora.md
│   ├── azure-database.md
│   ├── cockroachdb.md
│   ├── connect-to-mysql.md
│   ├── connect-to-postgresql.md
│   ├── database-providers.md
│   ├── digital-ocean.md
│   ├── drizzle-orm.md
│   ├── examples.md
│   ├── fly.md
│   ├── google-cloud-sql.md
│   ├── libraries-and-drivers.md
│   ├── materialize.md
│   ├── mysql2.md
│   ├── mysql.md
│   ├── neon.md
│   ├── nile.md
│   ├── node-postgres-pg.md
│   ├── pgedge-cloud.md
│   ├── planetscale.md
│   ├── postgres-js.md
│   ├── prisma-orm.md
│   ├── prisma-postgres.md
│   ├── supabase.md
│   ├── timescale.md
│   └── xata.md
├── misc
│   ├── configuration.md
│   ├── connect-to-a-private-database-using-tunnel.md
│   ├── demos-and-architectures.md
│   ├── firewall-and-networking-configuration.md
│   ├── getting-started.md
│   ├── hyperdrive-rest-api.md
│   ├── local-development.md
│   ├── overview.md
│   ├── rotating-database-credentials.md
│   ├── ssl-tls-certificates.md
│   └── tune-connection-pooling.md
├── observability
│   ├── metrics-and-analytics.md
│   ├── observability.md
│   └── troubleshoot-and-debug.md
├── platform
│   ├── choose-a-data-or-storage-product.md
│   ├── limits.md
│   ├── platform.md
│   ├── pricing.md
│   └── release-notes.md
├── reference
│   ├── faq.md
│   ├── reference.md
│   ├── supported-databases-and-features.md
│   └── wrangler-commands.md
└── tutorials
    ├── create-a-serverless-globally-distributed-time-series-api-with-timescale.md
    └── tutorials.md
```
