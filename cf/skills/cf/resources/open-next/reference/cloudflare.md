## Cloudflare

The [`@opennextjs/cloudflare`](https://www.npmjs.com/package/@opennextjs/cloudflare) adapter lets you deploy Next.js apps to [Cloudflare Workers](https://developers.cloudflare.com/workers) using the [Node.js "runtime" from Next.js](https://nextjs.org/docs/app/building-your-application/rendering/edge-and-nodejs-runtimes).

### Get Started

##### New apps

To create a new Next.js app, pre-configured to run on Cloudflare using `@opennextjs/cloudflare`, run:

```
npm create cloudflare@latest -- my-next-app --framework=next --platform=workers
```

##### Existing Next.js apps

Follow the guide [here](/cloudflare/get-started) to use [@opennextjs/cloudflare](https://www.npmjs.com/package/@opennextjs/cloudflare) with an existing Next.js app.

### Supported Next.js runtimes

Next.js has [two "runtimes"](https://nextjs.org/docs/app/building-your-application/rendering/edge-and-nodejs-runtimes) — "Edge" and "Node.js". When you use `@opennextjs/cloudflare`, your app should use the Node.js runtime, which is more fully featured, and allows you to use the [Node.js APIs](https://developers.cloudflare.com/workers/runtime-apis/nodejs/) that are provided by the Cloudflare Workers runtime.

This is an important difference from `@cloudflare/next-on-pages`, which only supports the "Edge" runtime. The Edge Runtime code in Next.js [intentionally constrains which APIs from Node.js can be used](https://github.com/vercel/next.js/blob/canary/packages/next/src/build/webpack/plugins/middleware-plugin.ts#L820), and the "Edge" runtime does not support all Next.js features.

### Supported Next.js versions

All minor and patch versions of Next.js 15 and the latest minor of Next.js 14 are supported.

To help improve compatibility, we encourage you to [report bugs](https://github.com/opennextjs/opennextjs-cloudflare/issues) and contribute code!

### Supported Next.js features

- [x] [App Router](https://nextjs.org/docs/app)
- [x] [Route Handlers](https://nextjs.org/docs/app/building-your-application/routing/route-handlers)
- [x] [Dynamic routes](https://nextjs.org/docs/app/building-your-application/routing/dynamic-routes)
- [x] [Static Site Generation (SSG)](https://nextjs.org/docs/app/building-your-application/rendering/server-components#static-rendering-default)
- [x] [Server-Side Rendering (SSR)](https://nextjs.org/docs/app/building-your-application/rendering/server-components)
- [x] [Middleware](https://nextjs.org/docs/app/building-your-application/routing/middleware)
- [ ] [Node Middleware](https://nextjs.org/docs/app/building-your-application/routing/middleware#runtime) introduced in 15.2 are not yet supported
- [x] [Image optimization](https://nextjs.org/docs/app/building-your-application/optimizing/images) (See [this guide](/cloudflare/howtos/image) to configure [Cloudflare Images](https://developers.cloudflare.com/images/))
- [x] [Partial Prerendering (PPR)](https://nextjs.org/docs/app/building-your-application/rendering/partial-prerendering)
- [x] [Pages Router](https://nextjs.org/docs/pages)
- [x] [Incremental Static Regeneration (ISR)](https://nextjs.org/docs/app/building-your-application/data-fetching/incremental-static-regeneration)
- [x] [Support for after](https://nextjs.org/blog/next-15-rc#executing-code-after-a-response-with-nextafter-experimental)
- [x] [Composable Caching](https://nextjs.org/blog/composable-caching) (`'use cache'`)

We welcome both contributions and feedback!

### Windows support

<WindowsSupport />

### How `@opennextjs/cloudflare` Works

The OpenNext Cloudflare adapter works by taking the Next.js build output and transforming it, so that it can run in Cloudflare Workers.

When you add [@opennextjs/cloudflare](https://www.npmjs.com/package/@opennextjs/cloudflare) as a dependency to your Next.js app, and then run `npx @opennextjs/cloudflare` the adapter first builds your app by running the `build` script in your `package.json`, and then transforms the build output to a format that you can run locally using [Wrangler](https://developers.cloudflare.com/workers/wrangler/), and deploy to Cloudflare.

You can view the code for `@opennextjs/cloudflare` [here](https://github.com/opennextjs/opennextjs-cloudflare/blob/main/packages/cloudflare/src) to understand what it does under the hood.

### Note on Worker Size Limits

The size limit of a Cloudflare Worker is 3 MiB on the Workers Free plan, and 10 MiB on the Workers Paid plan. After building your Worker, `wrangler` will show both the original and compressed sizes:

```
Total Upload: 13833.20 KiB / gzip: 2295.89 KiB
```

Only the latter (compressed size) matters for [the Worker size limit](https://developers.cloudflare.com/workers/platform/limits/#worker-size).

import { Callout } from "nextra/components";

### Get Started

#### New apps

To create a new Next.js app, pre-configured to run on Cloudflare using `@opennextjs/cloudflare`, run:

```sh
npm create cloudflare@latest -- my-next-app --framework=next --platform=workers
```

#### Existing Next.js apps

##### 1. Install @opennextjs/cloudflare

First, install [@opennextjs/cloudflare](https://www.npmjs.com/package/@opennextjs/cloudflare):

```sh
npm install @opennextjs/cloudflare@latest
```

##### 2. Install Wrangler

Install the [Wrangler CLI](https://developers.cloudflare.com/workers/wrangler/) as a devDependency:

```sh
npm install --save-dev wrangler@latest
```

<Callout>
  You must use Wrangler version `3.99.0` or later to deploy Next.js apps using `@opennextjs/cloudflare`.
</Callout>

##### 3. Create a wrangler configuration file

<Callout type="info">
  This step is optional since `@opennextjs/cloudflare` creates this file for you during the build process (if
  not already present).
</Callout>

A [wrangler configuration file](https://developers.cloudflare.com/workers/wrangler/configuration/) is needed for your
application to be previewed and deployed, it is also where you configure your Worker and define what resources it can access via [bindings](https://developers.cloudflare.com/workers/runtime-apis/bindings/service-bindings).

You can create one yourself in the root directory of your Next.js app with the name `wrangler.jsonc` and the following content:

```jsonc
{
  "$schema": "node_modules/wrangler/config-schema.json",
  "main": ".open-next/worker.js",
  "name": "my-app",
  "compatibility_date": "2024-12-30",
  "compatibility_flags": [
    // Enable Node.js API
    // see https://developers.cloudflare.com/workers/configuration/compatibility-flags/#nodejs-compatibility-flag
    "nodejs_compat",
    // Allow to fetch URLs in your app
    // see https://developers.cloudflare.com/workers/configuration/compatibility-flags/#global-fetch-strictly-public
    "global_fetch_strictly_public",
  ],
  "assets": {
    "directory": ".open-next/assets",
    "binding": "ASSETS",
  },
  "services": [
    {
      "binding": "WORKER_SELF_REFERENCE",
      // The service should match the "name" of your worker
      "service": "my-app",
    },
  ],
  "r2_buckets": [
    // Create a R2 binding with the binding name "NEXT_INC_CACHE_R2_BUCKET"
    // {
    //   "binding": "NEXT_INC_CACHE_R2_BUCKET",
    //   "bucket_name": "<BUCKET_NAME>",
    // },
  ],
  "images": {
    // Enable image optimization
    // see https://opennext.js.org/cloudflare/howtos/image
    "binding": "IMAGES",
  },
}
```

<Callout>
  As shown above: - You must enable the [`nodejs_compat` compatibility
  flag](https://developers.cloudflare.com/workers/runtime-apis/nodejs/) *and* set your [compatibility
  date](https://developers.cloudflare.com/workers/configuration/compatibility-dates/) to `2024-09-23` or
  later, in order for your Next.js app to work with @opennextjs/cloudflare - The `main` and `assets` values
  should also not be changed unless you modify the build output result in some way - You can add a binding
  named `NEXT_INC_CACHE_R2_BUCKET` to make use of Next.js' caching as described in the [Caching
  docs](/cloudflare/caching)
</Callout>

##### 4. Add an `open-next.config.ts` file

<Callout type="info">
  This step is optional since `@opennextjs/cloudflare` creates this file for you during the build process (if
  not already present).
</Callout>

Add a [`open-next.config.ts`](https://opennext.js.org/aws/config) file to the root directory of your Next.js app:

```ts
import { defineCloudflareConfig } from "@opennextjs/cloudflare";
import r2IncrementalCache from "@opennextjs/cloudflare/overrides/incremental-cache/r2-incremental-cache";

export default defineCloudflareConfig({
  incrementalCache: r2IncrementalCache,
});
```

<Callout>
  To use the `OpenNextConfig` type as illustrated above (which is not necessary), you need to install the
  `@opennextjs/aws` NPM package as a dev dependency.
</Callout>

##### 5. Add a `.dev.vars` file

Then, add a [`.dev.vars`](https://developers.cloudflare.com/workers/testing/local-development/#local-only-environment-variables) file to the root directory of your Next.js app:

```text
NEXTJS_ENV=development
```

The `NEXTJS_ENV` variable defines the environment to use when loading Next.js `.env` files. It defaults to "production" when not defined.

##### 6. Update the `package.json` file

Add the following to the scripts field of your `package.json` file:

```json
"build": "next build",
"preview": "opennextjs-cloudflare build && opennextjs-cloudflare preview",
"deploy": "opennextjs-cloudflare build && opennextjs-cloudflare deploy",
"upload": "opennextjs-cloudflare build && opennextjs-cloudflare upload",
"cf-typegen": "wrangler types --env-interface CloudflareEnv cloudflare-env.d.ts",
```

- The `build` script must invoke the Next.js build command, it will be invoked by [`opennextjs-cloudflare build`](/cloudflare/cli#build-command).
- `npm run preview`: Builds your app and serves it locally, allowing you to quickly preview your app running locally in the Workers runtime, via a single command.
- `npm run deploy`: Builds your app, and then immediately deploys it to Cloudflare.
- `npm run upload`: Builds your app, and then uploads a new [version](https://developers.cloudflare.com/workers/configuration/versions-and-deployments/#versions) of it to Cloudflare.
- `cf-typegen`: Generates a `cloudflare-env.d.ts` file at the root of your project containing [the types for the `env`](https://developers.cloudflare.com/workers/wrangler/commands/#types).

##### 7. Add Static Asset Caching

Add a `public/_headers` file, with at least the following headers:

```txt
/_next/static/*
  Cache-Control: public,max-age=31536000,immutable
```

See the [Static Assets Caching docs](/cloudflare/caching#static-assets-caching) for more information.

##### 8. Add caching with Cloudflare R2

See the [Caching docs](/cloudflare/caching) for information on enabling Next.js caching in your OpenNext project.

##### 9. Remove any `export const runtime = "edge";` if present

Before deploying your app, remove the `export const runtime = "edge";` line from any of your source files.

The edge runtime is not supported yet with `@opennextjs/cloudflare`.

##### 10. Add `.open-next` to `.gitignore`

You should add `.open-next` to your `.gitignore` file to prevent the build output from being committed to your repository.

##### 11. Remove `@cloudflare/next-on-pages` (if necessary)

If your Next.js app currently uses `@cloudflare/next-on-pages`, you'll want to remove it, and make a few changes.

Uninstalling the [`@cloudflare/next-on-pages`](https://www.npmjs.com/package/@cloudflare/next-on-pages) package as well as the [`eslint-plugin-next-on-pages`](https://www.npmjs.com/package/eslint-plugin-next-on-pages) package if present.

Remove any reference of these packages from your source and configuration files.
This includes:

- `setupDevPlatform()` calls in your Next.js config file
- `getRequestContext` imports from `@cloudflare/next-on-pages` from your source files
  (those can be replaced with `getCloudflareContext` calls from `@opennextjs/cloudflare`)
- next-on-pages eslint rules set in your Eslint config file

##### 12. Develop locally

You can continue to run `next dev` when developing locally.

Modify your Next.js configuration file to import and call the `initOpenNextCloudflareForDev` utility
from the `@opennextjs/cloudflare` package. This makes sure that the Next.js dev server can optimally integrate with the open-next cloudflare adapter and it is necessary for using bindings during local development.

This is an example of a Next.js configuration file calling the utility:

```ts
// next.config.ts
import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  /* config options here */
};

export default nextConfig;

import { initOpenNextCloudflareForDev } from "@opennextjs/cloudflare";
initOpenNextCloudflareForDev();
```

After having added the `initOpenNextCloudflareForDev()` call in your Next.js configuration file, you will be able, during local development, to access in any of your server code, local versions of Cloudflare bindings as indicated in the [bindings documentation](./bindings).

In step 3, we also added the `npm run preview`, which allows you to quickly preview your app running locally in the Workers runtime,
rather than in Node.js. This allows you to test changes in the same runtime as your app will run in when deployed to Cloudflare.

##### 13. Deploy to Cloudflare Workers

Either deploy via the command line:

```sh
npm run deploy
```

Or [connect a Github or Gitlab repository](https://developers.cloudflare.com/workers/ci-cd/), and Cloudflare will automatically build and deploy each pull request you merge to your production branch.

---

import { Callout } from "nextra/components";

