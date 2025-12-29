# `logout`

Remove Wrangler's authorization for accessing your account. This command will invalidate your current OAuth token.

```txt
wrangler logout
```

The following global flags work on every command:

* `--help` boolean
  * Show help.
* `--config` string (not supported by Pages)
  * Path to your [Wrangler configuration file](https://developers.cloudflare.com/workers/wrangler/configuration/).
* `--cwd` string
  * Run as if Wrangler was started in the specified directory instead of the current working directory.

If you are using `CLOUDFLARE_API_TOKEN` instead of OAuth, and you can logout by deleting your API token in the Cloudflare dashboard:

1. In the Cloudflare dashboard, go to the **Account API tokens** page.

   [Go to **Account API tokens**](https://dash.cloudflare.com/?to=/:account/api-tokens)

2. Select the three-dot menu on your Wrangler token.

3. Select **Delete**.

***


