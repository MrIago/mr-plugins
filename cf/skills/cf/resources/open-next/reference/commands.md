## commands

`opennextjs-cloudflare` support multiple commands, invoked via `opennextjs-cloudflare <command>`.

The currently supported commands are `build`, `populateCache`, `preview`, `deploy`, and `upload`.

You can list the commands by invoking `pnpm opennextjs-cloudflare` and get help with a given command by invoking `pnpm opennextjs-cloudflare <command> --help`.

Most commands take command specific options (i.e. `pnpm opennextjs-cloudflare build --skipNextBuild --noMinify`) and also accept wrangler options (i.e. `pnpm opennextjs-cloudflare build --config=/path/to/wrangler.jsonc --env=prod`).

### `build` command

It first builds the Next.js application by invoking the `build` script of the `package.json` - which typically execute `next build`. It then runs the Cloudflare specific build step to update the built files to run on the Cloudflare runtime.

### `populateCache` command

It populates the configured [Open Next cache components](/cloudflare/caching) so that caching works at runtime. It can populate the local bindings (`populateCache local`) used during development on your local machine or the remote bindings (`populateCache remote`) used by the deployed application. Note that this command is implicitly called by the `preview`, `deploy`, and `upload` commands so there is no need to explicitly call `populateCache` when one of those is used.

<Callout type='info'>

From version 1.13.0 of the Cloudflare adapter, R2 batch uploads are supported out of the box for preview and deploy without any additional setup.

Before version 1.13.0 of the Cloudflare adapter, the `populateCache` command was supporting R2 batch uploads via `rclone` which required the following additional setup:

The `populateCache` command supports R2 batching to speed up the upload of large number of files. To enable R2 batching, you need to create an R2 Account API token as described [in the docs](https://developers.cloudflare.com/r2/api/tokens/) and provide the following environment variables:

- `R2_ACCESS_KEY_ID`: The access key ID of the R2 API token
- `R2_SECRET_ACCESS_KEY`: The secret access key of the R2 API token
- `CLOUDFLARE_ACCOUNT_ID`: The [account ID](https://developers.cloudflare.com/fundamentals/account/find-account-and-zone-ids/#copy-your-account-id) where the R2 bucket is located

</Callout>

### `preview` command

It starts by populating the local cache and then launches a local development server (via `wrangler dev`) so that you can preview the application locally.

### `deploy` command

It starts by populating the remote cache and then deploys your application to Cloudflare (via `wrangler deploy`). The application will start serving as soon as it is deployed.

### `upload` command

It starts by populating the remote cache and then uploads a version of your application to Cloudflare (via `wrangler upload`). Note that the application will not automatically be served on uploads. See [Gradual deployments](https://developers.cloudflare.com/workers/configuration/versions-and-deployments/gradual-deployments/) to learn more about how to serve an uploaded version.

---

import { Callout } from "nextra/components";

### Bindings

[Bindings](https://developers.cloudflare.com/workers/runtime-apis/bindings/) allow your Worker to interact with resources on the Cloudflare Developer Platform. When you declare a binding on your Worker, you grant it a specific capability, such as being able to read and write files to an [R2](https://developers.cloudflare.com/r2/) bucket.

#### How to configure your Next.js app so it can access bindings

Install [@opennextjs/cloudflare](https://www.npmjs.com/package/@opennextjs/cloudflare), and then add a [wrangler configuration file](https://developers.cloudflare.com/workers/wrangler/configuration/) in the root directory of your Next.js app, as described in [Get Started](/cloudflare/get-started#3-create-a-wranglerjson-file).

#### How to access bindings in your Next.js app

You can access [bindings](https://developers.cloudflare.com/workers/runtime-apis/bindings/) from any route of your Next.js app via `getCloudflareContext`:

```js
import { getCloudflareContext } from "@opennextjs/cloudflare";

export async function GET(request) {
  const myKv = getCloudflareContext().env.MY_KV_NAMESPACE;
  await myKv.put("foo", "bar");
  const foo = await myKv.get("foo");

  return new Response(foo);
}
```

<Callout type='info'>
	`getCloudflareContext` can only be used in SSG routes in "async mode" (making it return a promise), to run the function in such a way simply provide an options argument with `async` set to `true`:
	```js
	const context = await getCloudflareContext({ async: true });
	```

    **WARNING**: During SSG caution is advised since secrets (stored in `.dev.vars` files) and local development
    values from bindings (like values saved in a local KV) will be used for the pages static generation.

</Callout>

#### How to add bindings to your Worker

Add bindings to your Worker by adding them to your [wrangler configuration file](https://developers.cloudflare.com/workers/wrangler/configuration/).

