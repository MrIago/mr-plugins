# `secrets-store secret`

With the release of [Secrets Store](https://developers.cloudflare.com/secrets-store/) in open beta, you can use the following commands to manage your account secrets.

`--remote` option

In order to interact with Secrets Store in production, you should append `--remote` to your command. Without it, your command will default to [local development mode](https://developers.cloudflare.com/workers/development-testing/).

### `secrets-store secret create`

Create a secret within a store

* npm

  ```sh
  npx wrangler secrets-store secret create [STORE-ID]
  ```

* pnpm

  ```sh
  pnpm wrangler secrets-store secret create [STORE-ID]
  ```

* yarn

  ```sh
  yarn wrangler secrets-store secret create [STORE-ID]
  ```

- `[STORE-ID]` string required

  ID of the store in which the secret resides

- `--name` string required

  Name of the secret

- `--value` string

  Value of the secret (Note: Only for testing. Not secure as this will leave secret value in plain-text in terminal history, exclude this flag and use automatic prompt instead)

- `--scopes` string required

  Scopes for the secret (comma-separated list of scopes eg:"workers")

- `--comment` string

  Comment for the secret

- `--remote` boolean default: false

  Execute command against remote Secrets Store

- `--persist-to` string

  Directory for local persistence

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

The following is an example of using the `create` command to create an account-level secret.

```sh
npx wrangler secrets-store secret create 8f7a1cdced6342c18d223ece462fd88d --name ServiceA_key-1 --scopes workers --remote
```

```sh
✓ Enter a secret value: › ***


🔐 Creating secret... (Name: ServiceA_key-1, Value: REDACTED, Scopes: workers, Comment: undefined)
✓ Select an account: › My account
✅ Created secret! (ID: 13bc7498c6374a4e9d13be091c3c65f1)
```

### `secrets-store secret update`

Update a secret within a store

* npm

  ```sh
  npx wrangler secrets-store secret update [STORE-ID]
  ```

* pnpm

  ```sh
  pnpm wrangler secrets-store secret update [STORE-ID]
  ```

* yarn

  ```sh
  yarn wrangler secrets-store secret update [STORE-ID]
  ```

- `[STORE-ID]` string required

  ID of the store in which the secret resides

- `--secret-id` string required

  ID of the secret to update

- `--value` string

  Updated value of the secret (Note: Only for testing. Not secure as this will leave secret value in plain-text in terminal history, exclude this flag and use automatic prompt instead)

- `--scopes` string

  Updated scopes for the secret (comma-separated list of scopes eg:"workers")

- `--comment` string

  Updated comment for the secret

- `--remote` boolean default: false

  Execute command against remote Secrets Store

- `--persist-to` string

  Directory for local persistence

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

### `secrets-store secret duplicate`

Duplicate a secret within a store

* npm

  ```sh
  npx wrangler secrets-store secret duplicate [STORE-ID]
  ```

* pnpm

  ```sh
  pnpm wrangler secrets-store secret duplicate [STORE-ID]
  ```

* yarn

  ```sh
  yarn wrangler secrets-store secret duplicate [STORE-ID]
  ```

- `[STORE-ID]` string required

  ID of the store in which the secret resides

- `--secret-id` string required

  ID of the secret to duplicate the secret value of

- `--name` string required

  Name of the new secret

- `--scopes` string required

  Scopes for the new secret

- `--comment` string

  Comment for the new secret

- `--remote` boolean default: false

  Execute command against remote Secrets Store

- `--persist-to` string

  Directory for local persistence

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

### `secrets-store secret get`

Get a secret within a store

* npm

  ```sh
  npx wrangler secrets-store secret get [STORE-ID]
  ```

* pnpm

  ```sh
  pnpm wrangler secrets-store secret get [STORE-ID]
  ```

* yarn

  ```sh
  yarn wrangler secrets-store secret get [STORE-ID]
  ```

- `[STORE-ID]` string required

  ID of the store in which the secret resides

- `--secret-id` string required

  ID of the secret to retrieve

- `--remote` boolean default: false

  Execute command against remote Secrets Store

- `--persist-to` string

  Directory for local persistence

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

The following is an example with the expected output:

```sh
npx wrangler secrets-store secret get 8f7a1cdced6342c18d223ece462fd88d --secret-id 13bc7498c6374a4e9d13be091c3c65f1 --remote
```

```sh
🔐 Getting secret... (ID: 13bc7498c6374a4e9d13be091c3c65f1)
✓ Select an account: › My account
| Name                        | ID                                  | StoreID                             | Comment | Scopes  | Status  | Created                | Modified               |
|-----------------------------|-------------------------------------|-------------------------------------|---------|---------|---------|------------------------|------------------------|
| ServiceA_key-1          | 13bc7498c6374a4e9d13be091c3c65f1    | 8f7a1cdced6342c18d223ece462fd88d    |         | workers | active  | 4/9/2025, 10:06:01 PM  | 4/15/2025, 09:13:05 AM |
```

### `secrets-store secret delete`

Delete a secret within a store

* npm

  ```sh
  npx wrangler secrets-store secret delete [STORE-ID]
  ```

* pnpm

  ```sh
  pnpm wrangler secrets-store secret delete [STORE-ID]
  ```

* yarn

  ```sh
  yarn wrangler secrets-store secret delete [STORE-ID]
  ```

- `[STORE-ID]` string required

  ID of the store in which the secret resides

- `--secret-id` string required

  ID of the secret to delete

- `--remote` boolean default: false

  Execute command against remote Secrets Store

- `--persist-to` string

  Directory for local persistence

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

### `secrets-store secret list`

List secrets within a store

* npm

  ```sh
  npx wrangler secrets-store secret list [STORE-ID]
  ```

* pnpm

  ```sh
  pnpm wrangler secrets-store secret list [STORE-ID]
  ```

* yarn

  ```sh
  yarn wrangler secrets-store secret list [STORE-ID]
  ```

- `[STORE-ID]` string required

  ID of the store in which to list secrets

- `--page` number default: 1

  Page number of secrets listing results, can configure page size using "per-page"

- `--per-page` number default: 10

  Number of secrets to show per page

- `--remote` boolean default: false

  Execute command against remote Secrets Store

- `--persist-to` string

  Directory for local persistence

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


