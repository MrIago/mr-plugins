# dispatch namespace

### `dispatch-namespace list`

List all dispatch namespaces

* npm

  ```sh
  npx wrangler dispatch-namespace list
  ```

* pnpm

  ```sh
  pnpm wrangler dispatch-namespace list
  ```

* yarn

  ```sh
  yarn wrangler dispatch-namespace list
  ```

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

### `dispatch-namespace get`

Get information about a dispatch namespace

* npm

  ```sh
  npx wrangler dispatch-namespace get [NAME]
  ```

* pnpm

  ```sh
  pnpm wrangler dispatch-namespace get [NAME]
  ```

* yarn

  ```sh
  yarn wrangler dispatch-namespace get [NAME]
  ```

- `[NAME]` string required

  Name of the dispatch namespace

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

### `dispatch-namespace create`

Create a dispatch namespace

* npm

  ```sh
  npx wrangler dispatch-namespace create [NAME]
  ```

* pnpm

  ```sh
  pnpm wrangler dispatch-namespace create [NAME]
  ```

* yarn

  ```sh
  yarn wrangler dispatch-namespace create [NAME]
  ```

- `[NAME]` string required

  Name of the dispatch namespace

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

### `dispatch-namespace delete`

Delete a dispatch namespace

* npm

  ```sh
  npx wrangler dispatch-namespace delete [NAME]
  ```

* pnpm

  ```sh
  pnpm wrangler dispatch-namespace delete [NAME]
  ```

* yarn

  ```sh
  yarn wrangler dispatch-namespace delete [NAME]
  ```

- `[NAME]` string required

  Name of the dispatch namespace

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

Note

You must delete all user Workers in the dispatch namespace before it can be deleted.

### `dispatch-namespace rename`

Rename a dispatch namespace

* npm

  ```sh
  npx wrangler dispatch-namespace rename [OLDNAME] [NEWNAME]
  ```

* pnpm

  ```sh
  pnpm wrangler dispatch-namespace rename [OLDNAME] [NEWNAME]
  ```

* yarn

  ```sh
  yarn wrangler dispatch-namespace rename [OLDNAME] [NEWNAME]
  ```

- `[OLDNAME]` string required

  Name of the dispatch namespace

- `[NEWNAME]` string required

  New name of the dispatch namespace

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

***


