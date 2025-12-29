# `triggers`

Note

The minimum required wrangler version to use these commands is 3.40.0. For versions before 3.73.0, you will need to add the `--x-versions` flag.

### `triggers deploy`

Experimental

Updates the triggers of your current deployment

* npm

  ```sh
  npx wrangler triggers deploy
  ```

* pnpm

  ```sh
  pnpm wrangler triggers deploy
  ```

* yarn

  ```sh
  yarn wrangler triggers deploy
  ```

- `--name` string

  Name of the worker

- `--triggers` string aliases: --schedule, --schedules

  cron schedules to attach

- `--routes` string alias: --route

  Routes to upload

- `--dry-run` boolean

  Don't actually deploy

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


