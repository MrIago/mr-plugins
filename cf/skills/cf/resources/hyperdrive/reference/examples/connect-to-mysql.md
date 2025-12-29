# Connect to MySQL


Hyperdrive supports MySQL and MySQL-compatible databases, [popular drivers](#supported-drivers), and Object Relational Mapper (ORM) libraries that use those drivers.

## Create a Hyperdrive

Note

New to Hyperdrive? Refer to the [Get started guide](https://developers.cloudflare.com/hyperdrive/get-started/) to learn how to set up your first Hyperdrive.

To create a Hyperdrive that connects to an existing MySQL database, use the [Wrangler](https://developers.cloudflare.com/workers/wrangler/install-and-update/) CLI or the [Cloudflare dashboard](https://dash.cloudflare.com/?to=/:account/workers/hyperdrive).

When using Wrangler, replace the placeholder value provided to `--connection-string` with the connection string for your database:

```sh
# wrangler v3.11 and above required
npx wrangler hyperdrive create my-first-hyperdrive --connection-string="mysql://user:password@database.host.example.com:3306/databasenamehere"
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
| mysql2 (**recommended**) | [mysql2 documentation](https://github.com/sidorares/node-mysql2) | `mysql2@3.13.0` | Supported in both Workers & Pages. Using the Promise API is recommended. |
| mysql | [mysql documentation](https://github.com/mysqljs/mysql) | `mysql@2.18.0` | Requires `compatibility_flags = ["nodejs_compat"]` and `compatibility_date = "2024-09-23"` - refer to [Node.js compatibility](https://developers.cloudflare.com/workers/runtime-apis/nodejs). Requires wrangler `3.78.7` or later. |
| Drizzle | [Drizzle documentation](https://orm.drizzle.team/) | Requires `mysql2@3.13.0` | |
| Kysely | [Kysely documentation](https://kysely.dev/) | Requires `mysql2@3.13.0` | |

^ *The marked libraries can use either mysql or mysql2 as a dependency.*

Other drivers and ORMs not listed may also be supported: this list is not exhaustive.

### Database drivers and Node.js compatibility

[Node.js compatibility](https://developers.cloudflare.com/workers/runtime-apis/nodejs/) is required for database drivers, including mysql and mysql2, and needs to be configured for your Workers project.

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

## Supported TLS (SSL) modes

Hyperdrive supports the following MySQL TLS/SSL connection modes when connecting to your origin database:

| Mode | Supported | Details |
| - | - | - |
| `DISABLED` | No | Hyperdrive does not support insecure plain text connections. |
| `PREFERRED` | No (use `required`) | Hyperdrive will always use TLS. |
| `REQUIRED` | Yes (default) | TLS is required, and server certificates are validated (based on WebPKI). |
| `VERIFY_CA` | Not currently supported in beta | Verifies the server's TLS certificate is signed by a root CA on the client. |
| `VERIFY_IDENTITY` | Not currently supported in beta | Identical to `VERIFY_CA`, but also requires that the database hostname matches the certificate's Common Name (CN). |

Note

Hyperdrive does not currently support `VERIFY_CA` or `VERIFY_IDENTITY` for MySQL (beta).

## Driver examples

The following examples show you how to:

1. Create a database client with a database driver.
2. Pass the Hyperdrive connection string and connect to the database.
3. Query your database via Hyperdrive.

### `mysql2`

The following Workers code shows you how to use [mysql2](https://github.com/sidorares/node-mysql2) with Hyperdrive using the Promise API.

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

### `mysql`

The following Workers code shows you how to use [mysql](https://github.com/mysqljs/mysql) with Hyperdrive.

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

## Identify connections from Hyperdrive

To identify active connections to your MySQL database server from Hyperdrive:

* Hyperdrive's connections to your database will show up with `Cloudflare Hyperdrive` in the `PROGRAM_NAME` column in the `performance_schema.threads` table.
* Run `SELECT DISTINCT USER, HOST, PROGRAM_NAME FROM performance_schema.threads WHERE PROGRAM_NAME = 'Cloudflare Hyperdrive'` to show whether Hyperdrive is currently holding a connection (or connections) open to your database.

## Next steps

* Refer to the list of [supported database integrations](https://developers.cloudflare.com/workers/databases/connecting-to-databases/) to understand other ways to connect to existing databases.
* Learn more about how to use the [Socket API](https://developers.cloudflare.com/workers/runtime-apis/tcp-sockets) in a Worker.
* Understand the [protocols supported by Workers](https://developers.cloudflare.com/workers/reference/protocols/).


