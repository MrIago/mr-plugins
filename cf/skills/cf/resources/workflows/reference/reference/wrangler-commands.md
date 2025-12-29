# Wrangler commands


## `workflows list`

List Workflows associated to account

* npm

  ```sh
  npx wrangler workflows list
  ```

* pnpm

  ```sh
  pnpm wrangler workflows list
  ```

* yarn

  ```sh
  yarn wrangler workflows list
  ```

- `--page` number default: 1

  Show a sepecific page from the listing, can configure page size using "per-page"

- `--per-page` number

  Configure the maximum number of workflows to show per page

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

## `workflows describe`

Describe Workflow resource

* npm

  ```sh
  npx wrangler workflows describe [NAME]
  ```

* pnpm

  ```sh
  pnpm wrangler workflows describe [NAME]
  ```

* yarn

  ```sh
  yarn wrangler workflows describe [NAME]
  ```

- `[NAME]` string required

  Name of the workflow

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

## `workflows delete`

Delete workflow - when deleting a workflow, it will also delete it's own instances

* npm

  ```sh
  npx wrangler workflows delete [NAME]
  ```

* pnpm

  ```sh
  pnpm wrangler workflows delete [NAME]
  ```

* yarn

  ```sh
  yarn wrangler workflows delete [NAME]
  ```

- `[NAME]` string required

  Name of the workflow

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

## `workflows trigger`

Trigger a workflow, creating a new instance. Can optionally take a JSON string to pass a parameter into the workflow instance

* npm

  ```sh
  npx wrangler workflows trigger [NAME] [PARAMS]
  ```

* pnpm

  ```sh
  pnpm wrangler workflows trigger [NAME] [PARAMS]
  ```

* yarn

  ```sh
  yarn wrangler workflows trigger [NAME] [PARAMS]
  ```

- `[NAME]` string required

  Name of the workflow

- `[PARAMS]` string default:

  Params for the workflow instance, encoded as a JSON string

- `--id` string

  Custom instance ID, if not provided it will default to a random UUIDv4

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

## `workflows instances list`

Instance related commands (list, describe, terminate, pause, resume)

* npm

  ```sh
  npx wrangler workflows instances list [NAME]
  ```

* pnpm

  ```sh
  pnpm wrangler workflows instances list [NAME]
  ```

* yarn

  ```sh
  yarn wrangler workflows instances list [NAME]
  ```

- `[NAME]` string required

  Name of the workflow

- `--reverse` boolean default: false

  Reverse order of the instances table

- `--status` string

  Filters list by instance status (can be one of: queued, running, paused, errored, terminated, complete)

- `--page` number default: 1

  Show a sepecific page from the listing, can configure page size using "per-page"

- `--per-page` number

  Configure the maximum number of instances to show per page

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

## `workflows instances describe`

Describe a workflow instance - see its logs, retries and errors

* npm

  ```sh
  npx wrangler workflows instances describe [NAME] [ID]
  ```

* pnpm

  ```sh
  pnpm wrangler workflows instances describe [NAME] [ID]
  ```

* yarn

  ```sh
  yarn wrangler workflows instances describe [NAME] [ID]
  ```

- `[NAME]` string required

  Name of the workflow

- `[ID]` string default: latest

  ID of the instance - instead of an UUID you can type 'latest' to get the latest instance and describe it

- `--step-output` boolean default: true

  Don't output the step output since it might clutter the terminal

- `--truncate-output-limit` number default: 5000

  Truncate step output after x characters

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

## `workflows instances terminate`

Terminate a workflow instance

* npm

  ```sh
  npx wrangler workflows instances terminate [NAME] [ID]
  ```

* pnpm

  ```sh
  pnpm wrangler workflows instances terminate [NAME] [ID]
  ```

* yarn

  ```sh
  yarn wrangler workflows instances terminate [NAME] [ID]
  ```

- `[NAME]` string required

  Name of the workflow

- `[ID]` string required

  ID of the instance - instead of an UUID you can type 'latest' to get the latest instance and describe it

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

## `workflows instances restart`

Restart a workflow instance

* npm

  ```sh
  npx wrangler workflows instances restart [NAME] [ID]
  ```

* pnpm

  ```sh
  pnpm wrangler workflows instances restart [NAME] [ID]
  ```

* yarn

  ```sh
  yarn wrangler workflows instances restart [NAME] [ID]
  ```

- `[NAME]` string required

  Name of the workflow

- `[ID]` string required

  ID of the instance - instead of an UUID you can type 'latest' to get the latest instance and describe it

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

## `workflows instances pause`

Pause a workflow instance

* npm

  ```sh
  npx wrangler workflows instances pause [NAME] [ID]
  ```

* pnpm

  ```sh
  pnpm wrangler workflows instances pause [NAME] [ID]
  ```

* yarn

  ```sh
  yarn wrangler workflows instances pause [NAME] [ID]
  ```

- `[NAME]` string required

  Name of the workflow

- `[ID]` string required

  ID of the instance - instead of an UUID you can type 'latest' to get the latest instance and pause it

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

## `workflows instances resume`

Resume a workflow instance

* npm

  ```sh
  npx wrangler workflows instances resume [NAME] [ID]
  ```

* pnpm

  ```sh
  pnpm wrangler workflows instances resume [NAME] [ID]
  ```

* yarn

  ```sh
  yarn wrangler workflows instances resume [NAME] [ID]
  ```

- `[NAME]` string required

  Name of the workflow

- `[ID]` string required

  ID of the instance - instead of an UUID you can type 'latest' to get the latest instance and resume it

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


