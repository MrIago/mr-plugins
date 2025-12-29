# `tail`

🦚 Start a log tailing session for a Worker

* npm

  ```sh
  npx wrangler tail [WORKER]
  ```

* pnpm

  ```sh
  pnpm wrangler tail [WORKER]
  ```

* yarn

  ```sh
  yarn wrangler tail [WORKER]
  ```

- `[WORKER]` string

  Name or route of the worker to tail

- `--format` "json" | "pretty"

  The format of log entries

- `--status` "ok" | "error" | "canceled"

  Filter by invocation status

- `--header` string

  Filter by HTTP header

- `--method` string

  Filter by HTTP method

- `--sampling-rate` number

  Adds a percentage of requests to log sampling rate

- `--search` string

  Filter by a text match in console.log messages

- `--ip` string

  Filter by the IP address the request originates from. Use "self" to filter for your own IP

- `--version-id` string

  Filter by Worker version

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

After starting `wrangler tail`, you will receive a live feed of console and exception logs for each request your Worker receives.

If your Worker has a high volume of traffic, the tail might enter sampling mode. This will cause some of your messages to be dropped and a warning to appear in your tail logs. To prevent messages from being dropped, add the options listed above to filter the volume of tail messages.

Note

It may take up to 1 minute (60 seconds) for a tail to exit sampling mode after adding an option to filter tail messages.

If sampling persists after using options to filter messages, consider using [instant logs](https://developers.cloudflare.com/logs/instant-logs/).

***


