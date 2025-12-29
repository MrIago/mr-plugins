## Performance tips

They are a lot of features and knobs you can tune to improve the performance of your app. This page lists some of the recommend settings.

### General

You should regularly update to the latest available version of [`@opennextjs/cloudflare`](https://www.npmjs.com/package/@opennextjs/cloudflare) to benefit from the latest performance and security updates.

### Caching

Caching can drastically improves the performance of your application by only fetching data / re-generating your pages when they change.

To get the most out of caching, you should start by reading how Next.js implements caching. The ["Caching in Next.js" guide](https://nextjs.org/docs/app/guides/caching) is a good place to start.

You should then check [how to configure caching](/cloudflare/caching) for the OpenNext adapter. See below for some advice.

#### [Incremental Cache](/cloudflare/caching#incremental-static-regeneration-isr)

The Incremental cache is the store containing all the cached data (i.e. pages, `fetch`, `unstable_cache`).

You should use the Workers Static Assets based cache if your site is SSG. It is the fastest available option. Note that as Workers Static Assets are read-only, this option can not be used with revalidation.

When your app uses re-validation, use the R2 based store instead. We recommend the following settings to get the best perfomance:

- use regional cache by wrapping the handler into `withRegionalCache(...)`
  - use the `long-lived` mode
  - you should not need to explicitly set `shouldLazilyUpdateOnCacheHit` nor `bypassTagCacheOnCacheHit` as they are set to the most performant mode by default
- setup [automatic cache purge](/cloudflare/caching#automatic-cache-purge)

<Callout type="info">
  Using KV is not recommended as it is eventually consistent. It could cause stale data to be persisted
  indefinitely
</Callout>

#### [Tag Cache](/cloudflare/caching#tag-cache-for-on-demand-revalidation)

The Tag Cache is not properly a cache. It only stores the timestamp at which tags have been revalidated.

It should be configured for App-Router based app using `revalidateTag` or `revalidatePath`.

The D1 based tag cache should only be used if your site receives low traffic. The Durable Object based tag cache is the recommend option for most sites. See [the reference guide](/cloudflare/caching#tag-cache-for-on-demand-revalidation) for the available configuration options.

Application using `revalidateTag` exclusively (and not `revalidatePath`) will benefit from using the `withFilter` wrapper with the `softTagFilter` filter.

#### [Static Assets](/cloudflare/caching#static-assets-caching)

You should add a `public/_headers` file to cache the static assets served by your app.

See the [Cloudflare documentation](https://developers.cloudflare.com/workers/static-assets/headers/) for a detailed explanation of the default and the syntax.

### [Multiple Workers](https://opennext.js.org/cloudflare/howtos/multi-worker)

Deploying the middleware and the main server to distinct Workers can help with performance. As when a page can be retrieved from the cache, the main server can be fully bypassed.

### Troubleshooting performance

You can profile the code to troubleshoot performance issues.

#### Building unminified code

Code profiles are much easier to read when the code is not minified, you can use the following settings to generate unminified code

**next.config.ts**

```ts
const nextConfig = {
  // ...
  experimental: {
    serverMinification: false,
  },
  webpack: (config) => {
    config.optimization.minimize = false;
    return config;
  },
};
```

**CLI**

Use the `--noMinify` option when building the app:

```bash
opennextjs-cloudflare build --noMinify
```

#### Record a profile

You should first launch a local version of your application by running

```bash
opennextjs-cloudflare preview
```

Once the app is running, follow [the steps from the Workers doc](https://developers.cloudflare.com/workers/observability/dev-tools/cpu-usage/) to record a CPU profile.

You can then inspect the profile and check if any particular section of the application is unexpectedly slow.

---


### Known issues

#### Caching Durable Objects (`DOQueueHandler` and `DOShardedTagCache`)

If your app uses [Durable Objects](https://developers.cloudflare.com/durable-objects/) for caching, you might see a warning while building your app:

```text
┌─────────────────────────────────┐
│ OpenNext — Building Next.js app │
└─────────────────────────────────┘


> next build

   ▲ Next.js 15.2.4

▲ [WARNING] 				You have defined bindings to the following internal Durable Objects:

  				- {"name":"NEXT_CACHE_DO_QUEUE","class_name":"DOQueueHandler"}
  				These will not work in local development, but they should work in production.

  				If you want to develop these locally, you can define your DO in a separate Worker, with a
  separate configuration file.
  				For detailed instructions, refer to the Durable Objects section here:
  https://developers.cloudflare.com/workers/wrangler/api#supported-bindings

   Creating an optimized production build ...
workerd/server/server.c++:1951: warning: A DurableObjectNamespace in the config referenced the class "DOQueueHandler", but no such Durable Object class is exported from the worker. Please make sure the class name matches, it is exported, and the class extends 'DurableObject'. Attempts to call to this Durable Object class will fail at runtime, but historically this was not a startup-time error. Future versions of workerd may make this a startup-time error.
```

The warning can be safely ignored as the caching Durable Objects are not used during the build.


---


import { Callout } from "nextra/components";

