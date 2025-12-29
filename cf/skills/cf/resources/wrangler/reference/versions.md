# `versions`

Note

The minimum required wrangler version to use these commands is 3.40.0. For versions before 3.73.0, you will need to add the `--x-versions` flag.

### `versions upload`

Upload a new [version](https://developers.cloudflare.com/workers/configuration/versions-and-deployments/#versions) of your Worker that is not deployed immediately.

* npm

  ```sh
  npx wrangler versions upload [SCRIPT]
  ```

* pnpm

  ```sh
  pnpm wrangler versions upload [SCRIPT]
  ```

* yarn

  ```sh
  yarn wrangler versions upload [SCRIPT]
  ```

- `[SCRIPT]` string

  The path to an entry point for your Worker

- `--name` string

  Name of the Worker

- `--tag` string

  A tag for this Worker Gradual Rollouts Version

- `--message` string

  A descriptive message for this Worker Gradual Rollouts Version

- `--preview-alias` string

  Name of an alias for this Worker version

- `--no-bundle` boolean default: false

  Skip internal build steps and directly upload Worker

- `--outdir` string

  Output directory for the bundled Worker

- `--outfile` string

  Output file for the bundled worker

- `--compatibility-date` string

  Date to use for compatibility checks

- `--compatibility-flags` string alias: --compatibility-flag

  Flags to use for compatibility checks

- `--latest` boolean default: false

  Use the latest version of the Worker runtime

- `--assets` string

  Static assets to be served. Replaces Workers Sites.

- `--var` string

  A key-value pair to be injected into the script as a variable

- `--define` string

  A key-value pair to be substituted in the script

- `--alias` string

  A module pair to be substituted in the script

- `--jsx-factory` string

  The function that is called for each JSX element

- `--jsx-fragment` string

  The function that is called for each JSX fragment

- `--tsconfig` string

  Path to a custom tsconfig.json file

- `--minify` boolean

  Minify the Worker

- `--upload-source-maps` boolean

  Include source maps when uploading this Worker Gradual Rollouts Version.

- `--dry-run` boolean

  Compile a project without actually uploading the version.

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

### `versions deploy`

Deploy a previously created [version](https://developers.cloudflare.com/workers/configuration/versions-and-deployments/#versions) of your Worker all at once or create a [gradual deployment](https://developers.cloudflare.com/workers/configuration/versions-and-deployments/gradual-deployments/) to incrementally shift traffic to a new version by following an interactive prompt.

* npm

  ```sh
  npx wrangler versions deploy [VERSION-SPECS]
  ```

* pnpm

  ```sh
  pnpm wrangler versions deploy [VERSION-SPECS]
  ```

* yarn

  ```sh
  yarn wrangler versions deploy [VERSION-SPECS]
  ```

- `--name` string

  Name of the worker

- `--version-id` string

  Worker Version ID(s) to deploy

- `--percentage` number

  Percentage of traffic to split between Worker Version(s) (0-100)

- `[VERSION-SPECS]` string

  Shorthand notation to deploy Worker Version(s) \[\<version-id>@\<percentage>..]

- `--message` string

  Description of this deployment (optional)

- `--yes` boolean alias: --y default: false

  Automatically accept defaults to prompts

- `--dry-run` boolean default: false

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

Note

The non-interactive version of this prompt is: `wrangler versions deploy version-id-1@percentage-1% version-id-2@percentage-2 -y`

For example: `wrangler versions deploy 095f00a7-23a7-43b7-a227-e4c97cab5f22@10% 1a88955c-2fbd-4a72-9d9b-3ba1e59842f2@90% -y`

### `versions list`

Retrieve details for the 10 most recent versions. Details include `Version ID`, `Created on`, `Author`, `Source`, and optionally, `Tag` or `Message`.

* npm

  ```sh
  npx wrangler versions list
  ```

* pnpm

  ```sh
  pnpm wrangler versions list
  ```

* yarn

  ```sh
  yarn wrangler versions list
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

### `versions view`

View the details of a specific version of your Worker

* npm

  ```sh
  npx wrangler versions view [VERSION-ID]
  ```

* pnpm

  ```sh
  pnpm wrangler versions view [VERSION-ID]
  ```

* yarn

  ```sh
  yarn wrangler versions view [VERSION-ID]
  ```

- `[VERSION-ID]` string required

  The Worker Version ID to view

- `--name` string

  Name of the worker

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

### `versions secret put`

Create or update a secret variable for a Worker

* npm

  ```sh
  npx wrangler versions secret put [KEY]
  ```

* pnpm

  ```sh
  pnpm wrangler versions secret put [KEY]
  ```

* yarn

  ```sh
  yarn wrangler versions secret put [KEY]
  ```

- `[KEY]` string

  The variable name to be accessible in the Worker

- `--name` string

  Name of the Worker

- `--message` string

  Description of this deployment

- `--tag` string

  A tag for this version

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

### `versions secret delete`

Delete a secret variable from a Worker

* npm

  ```sh
  npx wrangler versions secret delete [KEY]
  ```

* pnpm

  ```sh
  pnpm wrangler versions secret delete [KEY]
  ```

* yarn

  ```sh
  yarn wrangler versions secret delete [KEY]
  ```

- `[KEY]` string

  The variable name to be accessible in the Worker

- `--name` string

  Name of the Worker

- `--message` string

  Description of this deployment

- `--tag` string

  A tag for this version

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

### `versions secret bulk`

Create or update a secret variable for a Worker

* npm

  ```sh
  npx wrangler versions secret bulk [FILE]
  ```

* pnpm

  ```sh
  pnpm wrangler versions secret bulk [FILE]
  ```

* yarn

  ```sh
  yarn wrangler versions secret bulk [FILE]
  ```

- `[FILE]` string

  The file of key-value pairs to upload, as JSON in form {"key": value, ...} or .dev.vars file in the form KEY=VALUE

- `--name` string

  Name of the Worker

- `--message` string

  Description of this deployment

- `--tag` string

  A tag for this version

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


