# Prisma Postgres


This example shows you how to connect Hyperdrive to a [Prisma Postgres](https://www.prisma.io/postgres) database.

## 1. Allow Hyperdrive access

You can connect Hyperdrive to any existing Prisma Postgres database by using your existing database connection string.

### Prisma Data Platform

1. Go to the [**Prisma Data Platform Console**](https://console.prisma.io/) and select the project (database) you wish to connect to.
2. Select **Connect to your database** > **Any client**.
3. Select **Generate database credentials**. Copy the connection string for your Prisma Postgres database.
4. Edit the connection string to make it compatible with Hyperdrive.

* Add the database name after the port. You may remove any query parameters, such as `?sslmode=require`.
* The final string will look like:

```txt
postgres://USERNAME:PASSWORD@HOSTNAME_OR_IP_ADDRESS:PORT/
```

Note

An alternative to the Prisma Data Platform is to use the [`create-db`](https://www.npmjs.com/package/create-db) package. This package will generate a quick temporary Prisma Postgres database for you to use.

```bash
npx create-db@latest
```

With this connection string, you can now create a Hyperdrive database configuration.

## 2. Create a database configuration

To configure Hyperdrive, you will need:

* The IP address (or hostname) and port of your database.
* The database username (for example, `hyperdrive-demo`) you configured in a previous step.
* The password associated with that username.
* The name of the database you want Hyperdrive to connect to. For example, `postgres`.

Hyperdrive accepts the combination of these parameters in the common connection string format used by database drivers:

```txt
postgres://USERNAME:PASSWORD@HOSTNAME_OR_IP_ADDRESS:PORT/database_name
```

Most database providers will provide a connection string you can directly copy-and-paste directly into Hyperdrive.

* Dashboard

  To create a Hyperdrive configuration with the Cloudflare dashboard:

  1. In the Cloudflare dashboard, go to the **Hyperdrive** page.

     [Go to **Hyperdrive**](https://dash.cloudflare.com/?to=/:account/workers/hyperdrive)

  2. Select **Create Configuration**.

  3. Fill out the form, including the connection string.

  4. Select **Create**.

* Wrangler CLI

  To create a Hyperdrive configuration with the [Wrangler CLI](https://developers.cloudflare.com/workers/wrangler/install-and-update/):

  1. Open your terminal and run the following command. Replace `<NAME_OF_HYPERDRIVE_CONFIG>` with a name for your Hyperdrive configuration and paste the connection string provided from your database host, or replace `user`, `password`, `HOSTNAME_OR_IP_ADDRESS`, `port`, and `database_name` placeholders with those specific to your database:

     ```sh
     npx wrangler hyperdrive create <NAME_OF_HYPERDRIVE_CONFIG> --connection-string="postgres://user:password@HOSTNAME_OR_IP_ADDRESS:PORT/database_name"
     ```

  2. This command outputs a binding for the [Wrangler configuration file](https://developers.cloudflare.com/workers/wrangler/configuration/):

     * wrangler.jsonc

       ```jsonc
       {
         "$schema": "./node_modules/wrangler/config-schema.json",
         "name": "hyperdrive-example",
         "main": "src/index.ts",
         "compatibility_date": "2024-08-21",
         "compatibility_flags": [
           "nodejs_compat"
         ],
         "hyperdrive": [
           {
             "binding": "HYPERDRIVE",
             "id": "<ID OF THE CREATED HYPERDRIVE CONFIGURATION>"
           }
         ]
       }
       ```

     * wrangler.toml

       ```toml
       name = "hyperdrive-example"
       main = "src/index.ts"
       compatibility_date = "2024-08-21"
       compatibility_flags = ["nodejs_compat"]


       # Pasted from the output of `wrangler hyperdrive create <NAME_OF_HYPERDRIVE_CONFIG> --connection-string=[...]` above.
       [[hyperdrive]]
       binding = "HYPERDRIVE"
       id = "<ID OF THE CREATED HYPERDRIVE CONFIGURATION>"
       ```

* wrangler.jsonc

  ```jsonc
  {
    "$schema": "./node_modules/wrangler/config-schema.json",
    "name": "hyperdrive-example",
    "main": "src/index.ts",
    "compatibility_date": "2024-08-21",
    "compatibility_flags": [
      "nodejs_compat"
    ],
    "hyperdrive": [
      {
        "binding": "HYPERDRIVE",
        "id": "<ID OF THE CREATED HYPERDRIVE CONFIGURATION>"
      }
    ]
  }
  ```

* wrangler.toml

  ```toml
  name = "hyperdrive-example"
  main = "src/index.ts"
  compatibility_date = "2024-08-21"
  compatibility_flags = ["nodejs_compat"]


  # Pasted from the output of `wrangler hyperdrive create <NAME_OF_HYPERDRIVE_CONFIG> --connection-string=[...]` above.
  [[hyperdrive]]
  binding = "HYPERDRIVE"
  id = "<ID OF THE CREATED HYPERDRIVE CONFIGURATION>"
  ```

Note

Hyperdrive will attempt to connect to your database with the provided credentials to verify they are correct before creating a configuration. If you encounter an error when attempting to connect, refer to Hyperdrive's [troubleshooting documentation](https://developers.cloudflare.com/hyperdrive/observability/troubleshooting/) to debug possible causes.

## 3. Use Hyperdrive from your Worker

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

## 4. Configure Hyperdrive maximum connections

Prisma Postgres has limits on the number of direct connections that can be made to the database using Hyperdrive. Refer to [Prisma Postgres limits](https://www.prisma.io/docs/postgres/database/direct-connections?utm_source=website\&utm_medium=postgres-page#connection-limit).

Note

There are two limits to consider here.

* Origin database's connection limit, set by the origin database provider. This is the maximum number of direct database connections that can be made to the origin database.
* Hyperdrive's origin connection limit, set by Hyperdrive. This is the maximum number of database connections that Hyperdrive can make to your origin database (in this case, Prisma Postgres).

Hyperdrive's origin connection limit should be lower than the Prisma Postgres connection limit, since Hyperdrive's origin connection limit is a soft limit, and Hyperdrive may create more connections if there are network disruptions that prevent existing connections from being used.

* Dashboard

  1. From the [Cloudflare Hyperdrive dashboard](https://dash.cloudflare.com/?to=/:account/workers/hyperdrive), select your newly created Hyperdrive configuration.
  2. Go to **Settings**.
  3. In **Origin connection limit**, select **Edit Settings**, and set your maximum connections to a number that is lower than your Prisma connection limit.

* Wrangler CLI

  1. Edit your existing Hyperdrive configuration with the `--origin-connection-limit` parameter:

     ```bash
     npx wrangler hyperdrive update <HYPERDRIVE_ID> --origin-connection-limit=10
     ```

     Replace `<HYPERDRIVE_ID>` with your Hyperdrive configuration ID and set the connection limit to a number that is less than your Prisma connection limit.

  2. Verify the configuration change:

     ```bash
     npx wrangler hyperdrive get <HYPERDRIVE_ID>
     ```

Note

When connecting to a Prisma Postgres database with Hyperdrive, you should use a driver like [node-postgres (pg)](https://developers.cloudflare.com/hyperdrive/examples/connect-to-postgres/postgres-drivers-and-libraries/node-postgres/) or [Postgres.js](https://developers.cloudflare.com/hyperdrive/examples/connect-to-postgres/postgres-drivers-and-libraries/postgres-js/) to connect directly to the underlying PostgreSQL database, instead of the Prisma Accelerate extension. Hyperdrive is optimized for database access for Workers, and connects directly to your database to perform global connection pooling and fast query routing.

## Next steps

* Learn more about [How Hyperdrive Works](https://developers.cloudflare.com/hyperdrive/concepts/how-hyperdrive-works/).
* Refer to the [troubleshooting guide](https://developers.cloudflare.com/hyperdrive/observability/troubleshooting/) to debug common issues.
* Understand more about other [storage options](https://developers.cloudflare.com/workers/platform/storage-options/) available to Cloudflare Workers.


