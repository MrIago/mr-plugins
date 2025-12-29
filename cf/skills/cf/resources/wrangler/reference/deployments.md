# `deployments`

[Deployments](https://developers.cloudflare.com/workers/configuration/versions-and-deployments/#deployments) track the version(s) of your Worker that are actively serving traffic.

Note

The minimum required wrangler version to use these commands is 3.40.0. For versions before 3.73.0, you will need to add the `--x-versions` flag.

### `deployments list`

Displays the 10 most recent deployments of your Worker

* npm

  ```sh
  npx wrangler deployments list
  ```

* pnpm

  ```sh
  pnpm wrangler deployments list
  ```

* yarn

  ```sh
  yarn wrangler deployments list
  ```

- `--name` string

  Name of the Worker

- `--json` boolean default: false

  Display output as clean JSON

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

### `deployments status`

View the current state of your production

* npm

  ```sh
  npx wrangler deployments status
  ```

* pnpm

  ```sh
  pnpm wrangler deployments status
  ```

* yarn

  ```sh
  yarn wrangler deployments status
  ```

- `--name` string

  Name of the Worker

- `--json` boolean default: false

  Display output as clean JSON

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


