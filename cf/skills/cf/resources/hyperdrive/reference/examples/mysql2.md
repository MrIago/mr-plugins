# mysql2


The [mysql2](https://github.com/sidorares/node-mysql2) package is a modern MySQL driver for Node.js with better performance and built-in Promise support. This example demonstrates how to use it with Cloudflare Workers and Hyperdrive.

Install the [mysql2](https://github.com/sidorares/node-mysql2) driver:

* npm

  ```sh
  npm i mysql2@>3.13.0
  ```

* yarn

  ```sh
  yarn add mysql2@>3.13.0
  ```

* pnpm

  ```sh
  pnpm add mysql2@>3.13.0
  ```

Note

`mysql2` v3.13.0 or later is required

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

Create a new `connection` instance and pass the Hyperdrive parameters:

```ts
// mysql2 v3.13.0 or later is required
import { createConnection } from "mysql2/promise";


export default {
  async fetch(request, env, ctx): Promise<Response> {
    // Create a connection using the mysql2 driver with the Hyperdrive credentials (only accessible from your Worker).
    const connection = await createConnection({
      host: env.HYPERDRIVE.host,
      user: env.HYPERDRIVE.user,
      password: env.HYPERDRIVE.password,
      database: env.HYPERDRIVE.database,
      port: env.HYPERDRIVE.port,


      // Required to enable mysql2 compatibility for Workers
      disableEval: true,
    });


    try {
      // Sample query
      const [results, fields] = await connection.query("SHOW tables;");


      // Clean up the client after the response is returned, before the Worker is killed
      ctx.waitUntil(connection.end());


      // Return result rows as JSON
      return Response.json({ results, fields });
    } catch (e) {
      console.error(e);
    }
  },
} satisfies ExportedHandler<Env>;
```

Note

The minimum version of `mysql2` required for Hyperdrive is `3.13.0`.


