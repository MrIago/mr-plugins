# Connect to PostgreSQL


Hyperdrive supports PostgreSQL and PostgreSQL-compatible databases, [popular drivers](#supported-drivers) and Object Relational Mapper (ORM) libraries that use those drivers.

## Create a Hyperdrive

Note

New to Hyperdrive? Refer to the [Get started guide](https://developers.cloudflare.com/hyperdrive/get-started/) to learn how to set up your first Hyperdrive.

To create a Hyperdrive that connects to an existing PostgreSQL database, use the [wrangler](https://developers.cloudflare.com/workers/wrangler/install-and-update/) CLI or the [Cloudflare dashboard](https://dash.cloudflare.com/?to=/:account/workers/hyperdrive).

When using wrangler, replace the placeholder value provided to `--connection-string` with the connection string for your database:

```sh
# wrangler v3.11 and above required
npx wrangler hyperdrive create my-first-hyperdrive --connection-string="postgres://user:password@database.host.example.com:5432/databasenamehere"
```

The command above will output the ID of your Hyperdrive, which you will need to set in the [Wrangler configuration file](https://developers.cloudflare.com/workers/wrangler/configuration/) for your Workers project:

* wrangler.jsonc

  ```jsonc
  {
    "$schema": "./node_modules/wrangler/config-schema.json",
    "compatibility_flags": [
      "nodejs_compat"
    ],
    "compatibility_date": "2024-09-23",
    "hyperdrive": [
      {
        "binding": "HYPERDRIVE",
        "id": "<your-hyperdrive-id-here>"
      }
    ]
  }
  ```

* wrangler.toml

  ```toml
  # required for database drivers to function
  compatibility_flags = ["nodejs_compat"]
  compatibility_date = "2024-09-23"


  [[hyperdrive]]
  binding = "HYPERDRIVE"
  id = "<your-hyperdrive-id-here>"
  ```

This will allow Hyperdrive to generate a dynamic connection string within your Worker that you can pass to your existing database driver. Refer to [Driver examples](#driver-examples) to learn how to set up a database driver with Hyperdrive.

Refer to the [Examples documentation](https://developers.cloudflare.com/hyperdrive/examples/) for step-by-step guides on how to set up Hyperdrive with several popular database providers.

## Supported drivers

Hyperdrive uses Workers [TCP socket support](https://developers.cloudflare.com/workers/runtime-apis/tcp-sockets/#connect) to support TCP connections to databases. The following table lists the supported database drivers and the minimum version that works with Hyperdrive:

| Driver | Documentation | Minimum Version Required | Notes |
| - | - | - | - |
| node-postgres - `pg` (recommended) | [node-postgres - `pg` documentation](https://node-postgres.com/) | `pg@8.13.0` | `8.11.4` introduced a bug with URL parsing and will not work. `8.11.5` fixes this. Requires `compatibility_flags = ["nodejs_compat"]` and `compatibility_date = "2024-09-23"` - refer to [Node.js compatibility](https://developers.cloudflare.com/workers/runtime-apis/nodejs). Requires wrangler `3.78.7` or later. |
| Postgres.js | [Postgres.js documentation](https://github.com/porsager/postgres) | `postgres@3.4.4` | Supported in both Workers & Pages. |
| Drizzle | [Drizzle documentation](https://orm.drizzle.team/) | `0.26.2`^ | |
| Kysely | [Kysely documentation](https://kysely.dev/) | `0.26.3`^ | |
| [rust-postgres](https://github.com/sfackler/rust-postgres) | [rust-postgres documentation](https://docs.rs/postgres/latest/postgres/) | `v0.19.8` | Use the [`query_typed`](https://docs.rs/postgres/latest/postgres/struct.Client.html#method.query_typed) method for best performance. |

^ *The marked libraries use `node-postgres` as a dependency.*

Other drivers and ORMs not listed may also be supported: this list is not exhaustive.

Recommended driver

[Node-postgres](https://node-postgres.com/) (`pg`) is the recommended driver for connecting to your Postgres database from JavaScript or TypeScript Workers. It has the best compatibility with Hyperdrive's caching and is commonly available with popular ORM libraries. [Postgres.js](https://github.com/porsager/postgres) is also supported.

### Database drivers and Node.js compatibility

[Node.js compatibility](https://developers.cloudflare.com/workers/runtime-apis/nodejs/) is required for database drivers, including Postgres.js, and needs to be configured for your Workers project.

To enable both built-in runtime APIs and polyfills for your Worker or Pages project, add the [`nodejs_compat`](https://developers.cloudflare.com/workers/configuration/compatibility-flags/#nodejs-compatibility-flag) [compatibility flag](https://developers.cloudflare.com/workers/configuration/compatibility-flags/#nodejs-compatibility-flag) to your [Wrangler configuration file](https://developers.cloudflare.com/workers/wrangler/configuration/), and set your compatibility date to September 23rd, 2024 or later. This will enable [Node.js compatibility](https://developers.cloudflare.com/workers/runtime-apis/nodejs/) for your Workers project.

* wrangler.jsonc

  ```jsonc
  {
    "$schema": "./node_modules/wrangler/config-schema.json",
    "compatibility_flags": [
      "nodejs_compat"
    ],
    "compatibility_date": "2024-09-23"
  }
  ```

* wrangler.toml

  ```toml
  compatibility_flags = [ "nodejs_compat" ]
  compatibility_date = "2024-09-23"
  ```

## Driver examples

The following examples show you how to:

1. Create a database client with a database driver.
2. Pass the Hyperdrive connection string and connect to the database.
3. Query your database via Hyperdrive.

### node-postgres / pg

Install the `node-postgres` driver:

* npm

  ```sh
  npm i pg@>8.16.3
  ```

* yarn

  ```sh
  yarn add pg@>8.16.3
  ```

* pnpm

  ```sh
  pnpm add pg@>8.16.3
  ```

Note

The minimum version of `node-postgres` required for Hyperdrive is `8.16.3`.

If using TypeScript, install the types package:

* npm

  ```sh
  npm i -D @types/pg
  ```

* yarn

  ```sh
  yarn add -D @types/pg
  ```

* pnpm

  ```sh
  pnpm add -D @types/pg
  ```

Add the required Node.js compatibility flags and Hyperdrive binding to your `wrangler.jsonc` file:

* wrangler.jsonc

  ```jsonc
  {
    "$schema": "./node_modules/wrangler/config-schema.json",
    "compatibility_flags": [
      "nodejs_compat"
    ],
    "compatibility_date": "2024-09-23",
    "hyperdrive": [
      {
        "binding": "HYPERDRIVE",
        "id": "<your-hyperdrive-id-here>"
      }
    ]
  }
  ```

* wrangler.toml

  ```toml
  # required for database drivers to function
  compatibility_flags = ["nodejs_compat"]
  compatibility_date = "2024-09-23"


  [[hyperdrive]]
  binding = "HYPERDRIVE"
  id = "<your-hyperdrive-id-here>"
  ```

Create a new `Client` instance and pass the Hyperdrive `connectionString`:

```ts
// filepath: src/index.ts
import { Client } from "pg";


export default {
  async fetch(
    request: Request,
    env: Env,
    ctx: ExecutionContext,
  ): Promise<Response> {
    // Create a new client instance for each request.
    const client = new Client({
      connectionString: env.HYPERDRIVE.connectionString,
    });


    try {
      // Connect to the database
      await client.connect();
      console.log("Connected to PostgreSQL database");


      // Perform a simple query
      const result = await client.query("SELECT * FROM pg_tables");


      return Response.json({
        success: true,
        result: result.rows,
      });
    } catch (error: any) {
      console.error("Database error:", error.message);


      new Response("Internal error occurred", { status: 500 });
    }
  },
};
```

### Postgres.js

The following Workers code shows you how to use [Postgres.js](https://github.com/porsager/postgres) with Hyperdrive.

Install [Postgres.js](https://github.com/porsager/postgres):

* npm

  ```sh
  npm i postgres@>3.4.5
  ```

* yarn

  ```sh
  yarn add postgres@>3.4.5
  ```

* pnpm

  ```sh
  pnpm add postgres@>3.4.5
  ```

Note

The minimum version of `postgres-js` required for Hyperdrive is `3.4.5`.

Add the required Node.js compatibility flags and Hyperdrive binding to your `wrangler.jsonc` file:

* wrangler.jsonc

  ```jsonc
  {
    "$schema": "./node_modules/wrangler/config-schema.json",
    "compatibility_flags": [
      "nodejs_compat"
    ],
    "compatibility_date": "2024-09-23",
    "hyperdrive": [
      {
        "binding": "HYPERDRIVE",
        "id": "<your-hyperdrive-id-here>"
      }
    ]
  }
  ```

* wrangler.toml

  ```toml
  # required for database drivers to function
  compatibility_flags = ["nodejs_compat"]
  compatibility_date = "2024-09-23"


  [[hyperdrive]]
  binding = "HYPERDRIVE"
  id = "<your-hyperdrive-id-here>"
  ```

Create a Worker that connects to your PostgreSQL database via Hyperdrive:

```ts
// filepath: src/index.ts
import postgres from "postgres";


export default {
  async fetch(
    request: Request,
    env: Env,
    ctx: ExecutionContext,
  ): Promise<Response> {
    // Create a database client that connects to your database via Hyperdrive
    // using the Hyperdrive credentials
    const sql = postgres(env.HYPERDRIVE.connectionString, {
      // Limit the connections for the Worker request to 5 due to Workers' limits on concurrent external connections
      max: 5,
      // If you are not using array types in your Postgres schema, disable `fetch_types` to avoid an additional round-trip (unnecessary latency)
      fetch_types: false,


      // This is set to true by default, but certain query generators such as Kysely or queries using sql.unsafe() will set this to false. Hyperdrive will not cache prepared statements when this option is set to false and will require additional round-trips.
      prepare: true,
    });


    try {
      // A very simple test query
      const result = await sql`select * from pg_tables`;


      // Return result rows as JSON
      return Response.json({ success: true, result: result });
    } catch (e: any) {
      console.error("Database error:", e.message);


      return Response.error();
    }
  },
} satisfies ExportedHandler<Env>;
```

## Identify connections from Hyperdrive

To identify active connections to your Postgres database server from Hyperdrive:

* Hyperdrive's connections to your database will show up with `Cloudflare Hyperdrive` as the `application_name` in the `pg_stat_activity` table.
* Run `SELECT DISTINCT usename, application_name FROM pg_stat_activity WHERE application_name = 'Cloudflare Hyperdrive'` to show whether Hyperdrive is currently holding a connection (or connections) open to your database.

## Next steps

* Refer to the list of [supported database integrations](https://developers.cloudflare.com/workers/databases/connecting-to-databases/) to understand other ways to connect to existing databases.
* Learn more about how to use the [Socket API](https://developers.cloudflare.com/workers/runtime-apis/tcp-sockets) in a Worker.
* Understand the [protocols supported by Workers](https://developers.cloudflare.com/workers/reference/protocols/).


