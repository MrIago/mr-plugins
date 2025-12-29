## Drizzle ORM

[Drizzle](https://developers.cloudflare.com/d1/reference/community-projects/#drizzle-orm) is a TypeScript ORM for SQL databases. It is designed to be lightweight and easy to use, making it a great choice for Cloudflare Workers.
There is not much specific to configure in Drizzle, but there is one important thing to note is that you don't want to have a global client.

### `lib/db.ts`

Instead of creating a global client, you should create a new client for each request. This is because some adapters (like Postgres) will use a connection pool, and reuse the same connection for multiple requests. This is not allowed in Cloudflare Workers, and will cause subsequent requests to fail.

#### PostgreSQL

Instead of that :

```ts
//lib/db.ts
import { drizzle } from "drizzle-orm/node-postgres";
import * as schema from "./schema/pg";
import { Pool } from "pg";

const pool = new Pool({
  connectionString: process.env.PG_URL,
});

export const db = drizzle({ client: pool, schema });
```

You should do this instead:

```ts
//lib/db.ts
import { drizzle } from "drizzle-orm/node-postgres";
// You can use cache from react to cache the client during the same request
// this is not mandatory and only has an effect for server components
import { cache } from "react";
import * as schema from "./schema/pg";
import { Pool } from "pg";

export const getDb = cache(() => {
  const pool = new Pool({
    connectionString: process.env.PG_URL,
    // You don't want to reuse the same connection for multiple requests
    maxUses: 1,
  });
  return drizzle({ client: pool, schema });
});
```

#### D1 example

```ts
import { getCloudflareContext } from "@opennextjs/cloudflare";
import { drizzle } from "drizzle-orm/d1";
import { cache } from "react";
import * as schema from "./schema/d1";

export const getDb = cache(() => {
  const { env } = getCloudflareContext();
  return drizzle(env.MY_D1, { schema });
});

// This is the one to use for static routes (i.e. ISR/SSG)
export const getDbAsync = cache(async () => {
  const { env } = await getCloudflareContext({ async: true });
  return drizzle(env.MY_D1, { schema });
});
```

#### Hyperdrive example

```ts
import { getCloudflareContext } from "@opennextjs/cloudflare";
import { drizzle } from "drizzle-orm/node-postgres";
import { cache } from "react";
import * as schema from "./schema/pg";
import { Pool } from "pg";

export const getDb = cache(() => {
  const { env } = getCloudflareContext();
  const connectionString = env.HYPERDRIVE.connectionString;
  const pool = new Pool({
    connectionString,
    // You don't want to reuse the same connection for multiple requests
    maxUses: 1,
  });
  return drizzle({ client: pool, schema });
});

// This is the one to use for static routes (i.e. ISR/SSG)
export const getDbAsync = cache(async () => {
  const { env } = await getCloudflareContext({ async: true });
  const connectionString = env.HYPERDRIVE.connectionString;
  const pool = new Pool({
    connectionString,
    // You don't want to reuse the same connection for multiple requests
    maxUses: 1,
  });
  return drizzle({ client: pool, schema });
});
```

You can then use the `getDb` function to get a new client for each request. This will ensure that you don't run into any issues with connection pooling.

