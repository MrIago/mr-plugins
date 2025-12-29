# `secrets-store store`

Use the following commands to manage your store.

Store limitation

[Secrets Store](https://developers.cloudflare.com/secrets-store/) is in open beta. Currently, you can only have one store per Cloudflare account.

### `secrets-store store create`

Create a store within an account

* npm

  ```sh
  npx wrangler secrets-store store create [NAME]
  ```

* pnpm

  ```sh
  pnpm wrangler secrets-store store create [NAME]
  ```

* yarn

  ```sh
  yarn wrangler secrets-store store create [NAME]
  ```

- `[NAME]` string required

  Name of the store

- `--remote` boolean default: false

  Execute command against remote Secrets Store

Global flags

* `--v` boolean alias: --version

  Show version number

* `--cwd` string

  Run as if Wrangler was started in the specified directory instead of the current working directory

* `--config` string alias: --c

  Path to Wrangler configuration file

* `--env` string alias: --e

  Environment to use for operations, and for selecting .env and .dev.vars files

* `--env-file` string

  Path to an .env file to load - can be specified multiple times - values from earlier files are overridden by values in later files

* `--experimental-provision` boolean aliases: --x-provision default: true

  Experimental: Enable automatic resource provisioning

* `--experimental-auto-create` boolean alias: --x-auto-create default: true

  Automatically provision draft bindings with new resources

The following is an example of using the `create` command to create a store.

```sh
npx wrangler secrets-store store create default --remote
```

```sh
🔐 Creating store... (Name: default)
✅ Created store! (Name: default, ID: 2e2a82d317134506b58defbe16982d54)
```

### `secrets-store store delete`

Delete a store within an account

* npm

  ```sh
  npx wrangler secrets-store store delete [STORE-ID]
  ```

* pnpm

  ```sh
  pnpm wrangler secrets-store store delete [STORE-ID]
  ```

* yarn

  ```sh
  yarn wrangler secrets-store store delete [STORE-ID]
  ```

- `[STORE-ID]` string required

  ID of the store

- `--remote` boolean default: false

  Execute command against remote Secrets Store

Global flags

* `--v` boolean alias: --version

  Show version number

* `--cwd` string

  Run as if Wrangler was started in the specified directory instead of the current working directory

* `--config` string alias: --c

  Path to Wrangler configuration file

* `--env` string alias: --e

  Environment to use for operations, and for selecting .env and .dev.vars files

* `--env-file` string

  Path to an .env file to load - can be specified multiple times - values from earlier files are overridden by values in later files

* `--experimental-provision` boolean aliases: --x-provision default: true

  Experimental: Enable automatic resource provisioning

* `--experimental-auto-create` boolean alias: --x-auto-create default: true

  Automatically provision draft bindings with new resources

The following is an example of using the `delete` command to delete a store.

```sh
npx wrangler secrets-store store delete d2dafaeac9434de2b6d08b292ce08211 --remote
```

```sh
🔐 Deleting store... (Name: d2dafaeac9434de2b6d08b292ce08211)
✅ Deleted store! (ID: d2dafaeac9434de2b6d08b292ce08211)
```

### `secrets-store store list`

List stores within an account

* npm

  ```sh
  npx wrangler secrets-store store list
  ```

* pnpm

  ```sh
  pnpm wrangler secrets-store store list
  ```

* yarn

  ```sh
  yarn wrangler secrets-store store list
  ```

- `--page` number default: 1

  Page number of stores listing results, can configure page size using "per-page"

- `--per-page` number default: 10

  Number of stores to show per page

- `--remote` boolean default: false

  Execute command against remote Secrets Store

Global flags

* `--v` boolean alias: --version

  Show version number

* `--cwd` string

  Run as if Wrangler was started in the specified directory instead of the current working directory

* `--config` string alias: --c

  Path to Wrangler configuration file

* `--env` string alias: --e

  Environment to use for operations, and for selecting .env and .dev.vars files

* `--env-file` string

  Path to an .env file to load - can be specified multiple times - values from earlier files are overridden by values in later files

* `--experimental-provision` boolean aliases: --x-provision default: true

  Experimental: Enable automatic resource provisioning

* `--experimental-auto-create` boolean alias: --x-auto-create default: true

  Automatically provision draft bindings with new resources

The following is an example of using the `list` command to list stores.

```sh
npx wrangler secrets-store store list --remote
```

```sh
🔐 Listing stores...
┌─────────┬──────────────────────────────────┬──────────────────────────────────┬──────────────────────┬──────────────────────┐
│ Name    │ ID                               │ AccountID                        │ Created              │ Modified             │
├─────────┼──────────────────────────────────┼──────────────────────────────────┼──────────────────────┼──────────────────────┤
│ default │ 8876bad33f164462bf0743fe8adf98f4 │ REDACTED │ 4/9/2025, 1:11:48 PM  │ 4/9/2025, 1:11:48 PM │
└─────────┴──────────────────────────────────┴──────────────────────────────────┴──────────────────────┴──────────────────────┘
```


