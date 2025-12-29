# mysql


The [mysql](https://github.com/mysqljs/mysql) package is a MySQL driver for Node.js. This example demonstrates how to use it with Cloudflare Workers and Hyperdrive.

Install the [mysql](https://github.com/mysqljs/mysql) driver:

* npm

  ```sh
  npm i mysql
  ```

* yarn

  ```sh
  yarn add mysql
  ```

* pnpm

  ```sh
  pnpm add mysql
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

Create a new connection and pass the Hyperdrive parameters:

```ts
import { createConnection } from "mysql";


export default {
  async fetch(request, env, ctx): Promise<Response> {
    const result = await new Promise<any>((resolve) => {
      // Create a connection using the mysql driver with the Hyperdrive credentials (only accessible from your Worker).
      const connection = createConnection({
        host: env.HYPERDRIVE.host,
        user: env.HYPERDRIVE.user,
        password: env.HYPERDRIVE.password,
        database: env.HYPERDRIVE.database,
        port: env.HYPERDRIVE.port,
      });


      connection.connect((error: { message: string }) => {
        if (error) {
          throw new Error(error.message);
        }


        // Sample query
        connection.query("SHOW tables;", [], (error, rows, fields) => {
          connection.end();


          resolve({ fields, rows });
        });
      });
    });


    // Return result  as JSON
    return new Response(JSON.stringify(result), {
      headers: {
        "Content-Type": "application/json",
      },
    });
  },
} satisfies ExportedHandler<Env>;
```


