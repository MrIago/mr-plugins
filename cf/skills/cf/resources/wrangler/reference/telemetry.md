# `telemetry`

Cloudflare collects anonymous usage data to improve Wrangler. You can learn more about this in our [data policy](https://github.com/cloudflare/workers-sdk/tree/main/packages/wrangler/telemetry.md).

You can manage sharing of usage data at any time using these commands.

### `disable`

Disable telemetry collection for Wrangler.

```txt
wrangler telemetry disable
```

### `enable`

Enable telemetry collection for Wrangler.

```txt
wrangler telemetry enable
```

### `status`

Check whether telemetry collection is currently enabled. The return result is specific to the directory where you have run the command.

This will resolve the global status set by `wrangler telemetry disable / enable`, the environment variable [`WRANGLER_SEND_METRICS`](https://developers.cloudflare.com/workers/wrangler/system-environment-variables/#supported-environment-variables), and the [`send_metrics`](https://developers.cloudflare.com/workers/wrangler/configuration/#top-level-only-keys) key in the [Wrangler configuration file](https://developers.cloudflare.com/workers/wrangler/configuration/).

```txt
wrangler telemetry status
```

The following global flags work on every command:

* `--help` boolean
  * Show help.
* `--config` string (not supported by Pages)
  * Path to your [Wrangler configuration file](https://developers.cloudflare.com/workers/wrangler/configuration/).
* `--cwd` string
  * Run as if Wrangler was started in the specified directory instead of the current working directory.

***


