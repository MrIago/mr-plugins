# Compatibility flags


Compatibility flags enable specific features. They can be useful if you want to help the Workers team test upcoming changes that are not yet enabled by default, or if you need to hold back a change that your code depends on but still want to apply other compatibility changes.

Compatibility flags will often have a date in which they are enabled by default, and so, by specifying a [`compatibility_date`](https://developers.cloudflare.com/workers/configuration/compatibility-dates) for your Worker, you can quickly enable all of these various compatibility flags up to, and including, that date.

## Setting compatibility flags

You may provide a list of `compatibility_flags`, which enable or disable specific changes.

#### Via Wrangler

Compatibility flags can be set in a Worker's [Wrangler configuration file](https://developers.cloudflare.com/workers/wrangler/configuration/).

This example enables the specific flag `formdata_parser_supports_files`, which is described [below](https://developers.cloudflare.com/workers/configuration/compatibility-flags/#formdata-parsing-supports-file). As of the specified date, `2021-09-14`, this particular flag was not yet enabled by default, but, by specifying it in `compatibility_flags`, we can enable it anyway. `compatibility_flags` can also be used to disable changes that became the default in the past.

* wrangler.jsonc

  ```jsonc
  {
    "$schema": "./node_modules/wrangler/config-schema.json",
    "compatibility_date": "2021-09-14",
    "compatibility_flags": [
      "formdata_parser_supports_files"
    ]
  }
  ```

* wrangler.toml

  ```toml
  # Opt into backwards-incompatible changes through September 14, 2021.
  compatibility_date = "2021-09-14"
  # Also opt into an upcoming fix to the FormData API.
  compatibility_flags = [ "formdata_parser_supports_files" ]
  ```

#### Via the Cloudflare Dashboard

Compatibility flags can be updated in the Workers settings on the [Cloudflare dashboard](https://dash.cloudflare.com/).

#### Via the Cloudflare API

Compatibility flags can be set when uploading a Worker using the [Workers Script API](https://developers.cloudflare.com/api/resources/workers/subresources/scripts/methods/update/) or [Workers Versions API](https://developers.cloudflare.com/api/resources/workers/subresources/scripts/subresources/versions/methods/create/) in the request body's `metadata` field.

## Node.js compatibility flag

Note

[The `nodejs_compat` flag](https://developers.cloudflare.com/workers/runtime-apis/nodejs/) also enables `nodejs_compat_v2` as long as your compatibility date is 2024-09-23 or later. The v2 flag improves runtime Node.js compatibility by bundling additional polyfills and globals into your Worker. However, this improvement increases bundle size.

If your compatibility date is 2024-09-22 or before and you want to enable v2, add the `nodejs_compat_v2` in addition to the `nodejs_compat` flag. If your compatibility date is after 2024-09-23, but you want to disable v2 to avoid increasing your bundle size, add the `no_nodejs_compat_v2` in addition to the `nodejs_compat flag`.

A [growing subset](https://developers.cloudflare.com/workers/runtime-apis/nodejs/) of Node.js APIs are available directly as [Runtime APIs](https://developers.cloudflare.com/workers/runtime-apis/nodejs), with no need to add polyfills to your own code. To enable these APIs in your Worker, add the `nodejs_compat` compatibility flag to your [Wrangler configuration file](https://developers.cloudflare.com/workers/wrangler/configuration/):

To enable both built-in runtime APIs and polyfills for your Worker or Pages project, add the [`nodejs_compat`](https://developers.cloudflare.com/workers/configuration/compatibility-flags/#nodejs-compatibility-flag) [compatibility flag](https://developers.cloudflare.com/workers/configuration/compatibility-flags/#nodejs-compatibility-flag) to your [Wrangler configuration file](https://developers.cloudflare.com/workers/wrangler/configuration/), and set your compatibility date to September 23rd, 2024 or later. This will enable [Node.js compatibility](https://developers.cloudflare.com/workers/runtime-apis/nodejs/) for your Workers project.

* wrangler.jsonc

  ```jsonc
  {
    "$schema": "./node_modules/wrangler/config-schema.json",
    "compatibility_flags": [
      "nodejs_compat"
    ],
    "compatibility_date": "2024-09-23"
  }
  ```

* wrangler.toml

  ```toml
  compatibility_flags = [ "nodejs_compat" ]
  compatibility_date = "2024-09-23"
  ```

- wrangler.jsonc

  ```jsonc
  {
    "$schema": "./node_modules/wrangler/config-schema.json",
    "compatibility_flags": [
      "nodejs_compat"
    ]
  }
  ```

- wrangler.toml

  ```toml
  compatibility_flags = [ "nodejs_compat" ]
  ```

As additional Node.js APIs are added, they will be made available under the `nodejs_compat` compatibility flag. Unlike most other compatibility flags, we do not expect the `nodejs_compat` to become active by default at a future date.

The Node.js `AsyncLocalStorage` API is a particularly useful feature for Workers. To enable only the `AsyncLocalStorage` API, use the `nodejs_als` compatibility flag.

* wrangler.jsonc

  ```jsonc
  {
    "$schema": "./node_modules/wrangler/config-schema.json",
    "compatibility_flags": [
      "nodejs_als"
    ]
  }
  ```

* wrangler.toml

  ```toml
  compatibility_flags = [ "nodejs_als" ]
  ```

## Flags history

Newest flags are listed first.

### Enable ctx.exports

| | |
| - | - |
| **Default as of** | 2025-11-17 |
| **Flag to enable** | `enable_ctx_exports` |
| **Flag to disable** | `disable_ctx_exports` |

This flag enables [the `ctx.exports` API](https://developers.cloudflare.com/workers/runtime-apis/context/#exports), which contains automatically-configured loopback bindings for your Worker's top-level exports. This allows you to skip configuring explicit bindings for your `WorkerEntrypoint`s and Durable Object namespaces defined in the same Worker.

### Automatic tracing

| | |
| - | - |
| **Flag to enable** | `enable_workers_observability_tracing` |

This flag will enable [Workers Tracing](https://developers.cloudflare.com/workers/observability/traces/) by default if you have the following configured in your Wrangler configuration file:

```json
{
  "observability": {
    "enabled": true
  }
}
```

You can also explictly turn on automatic tracing without the flag and with older compatibility dates by setting the following:

```json
{
  "observability": {
    "traces": {
      "enabled": true
    }
  }
}
```

### Enable `process` v2 implementation

| | |
| - | - |
| **Default as of** | 2025-09-15 |
| **Flag to enable** | `enable_nodejs_process_v2` |
| **Flag to disable** | `disable_nodejs_process_v2` |

When enabled after 2025-09-15, the `enable_nodejs_process_v2` flag along with the [`nodejs_compat`](https://developers.cloudflare.com/workers/runtime-apis/nodejs/) compat flag ensures a comprehensive Node.js-compatible `process` implementation, updating from the previous minimal process implementation that only provided the limited `nextTick`, `env`, `exit`, `getBuiltinModule`, `platform` and `features` properties.

To continue using the previous minimal implementation after the compat date, set the `disable_nodejs_process_v2` flag instead.

Most Node.js-supported process properties are implemented where possible, with undefined exports for unsupported features. See the [process documentation](https://developers.cloudflare.com/workers/runtime-apis/nodejs/process/) for Workers-specific implementation details.

### Enable Node.js HTTP server modules

| | |
| - | - |
| **Default as of** | 2025-09-01 |
| **Flag to enable** | `enable_nodejs_http_server_modules` |
| **Flag to disable** | `disable_nodejs_http_server_modules` |

The `enable_nodejs_http_server_modules` flag enables the availability of Node.js HTTP server modules such as `node:_http_server` in Workers.

The `disable_nodejs_http_server_modules` flag disables the availability of these server modules.

This enables compatibility with Node.js libraries and existing code that use the standard Node.js HTTP server APIs. The available functionality includes:

* `http.createServer()` for creating HTTP servers
* `http.Server` class for server instances
* `http.ServerResponse` for handling server responses

This flag must be used in combination with the `enable_nodejs_http_modules` flag to enable full features of `node:http`.

This flag is automatically enabled for Workers using a compatibility date of 2025-09-01 or later when `nodejs_compat` is enabled.

See the [Node.js documentation](https://nodejs.org/docs/latest/api/http.html) for more details about the Node.js HTTP APIs.

### Enable availability of `node:http` and `node:https` modules

| | |
| - | - |
| **Default as of** | 2025-08-15 |
| **Flag to enable** | `enable_nodejs_http_modules` |
| **Flag to disable** | `disable_nodejs_http_modules` |

The `enable_nodejs_http_modules` flag enables the availability of Node.js `node:http` and `node:https` modules in Workers (client APIS only).

The `disable_nodejs_http_modules` flag disables the availability of these modules.

This enables compatibility with Node.js libraries and existing code that use the standard node:http and node:https APIs for making HTTP requests. The available functionality includes:

* `http.request()` and `https.request()` for making HTTP/HTTPS requests
* `http.get()` and `https.get()` for making GET requests
* Request and response objects with standard Node.js APIs
* Support for standard HTTP methods, headers, and options

See the [Node.js documentation](https://nodejs.org/docs/latest/api/http.html) for more details about the Node.js APIs.

### Expose global MessageChannel and MessagePort

| | |
| - | - |
| **Default as of** | 2025-08-15 |
| **Flag to enable** | `expose_global_message_channel` |
| **Flag to disable** | `no_expose_global_message_channel` |

When the `expose_global_message_channel` flag is set, Workers will expose the `MessageChannel` and `MessagePort` constructors globally.

When the `no_expose_global_message_channel` flag is set, Workers will not expose these.

### Disable global handlers for Python Workers

| | |
| - | - |
| **Default as of** | 2025-08-14 |
| **Flag to enable** | `python_no_global_handlers` |
| **Flag to disable** | `disable_python_no_global_handlers` |

When the `python_no_global_handlers` flag is set, Python Workers will disable the global handlers and enforce their use via default entrypoint classes.

### Enable `cache: no-cache` HTTP standard API

| | |
| - | - |
| **Default as of** | 2025-08-07 |
| **Flag to enable** | `cache_no_cache_enabled` |
| **Flag to disable** | `cache_no_cache_disabled` |

When you enable the `cache_no_cache_enabled` compatibility flag, you can specify the `no-cache` value for the `cache` property of the Request interface. When this compatibility flag is not enabled, or `cache_option_disabled` is set, the Workers runtime will throw a `TypeError` saying `Unsupported cache mode: no-cache`.

When this flag is enabled you can instruct Cloudflare to force its cache to revalidate the response from a subrequest you make from your Worker using the [`fetch()` API](https://developers.cloudflare.com/workers/runtime-apis/fetch/):

When `no-cache` is specified:

* All requests have the headers `Pragma: no-cache` and `Cache-Control: no-cache` are set on them.

* Subrequests to origins not hosted by Cloudflare force Cloudflare's cache to revalidate with the origin.

Revalidating with the origin means that the Worker request will first look for a match in Cloudflare's cache, then:

* If there is a match, a conditional request is sent to the origin, regardless of whether or not the match is fresh or stale. If the resource has not changed, the cached version is returned. If the resource has changed, it will be downloaded from the origin, updated in the cache, and returned.
* If there is no match, Workers will make a standard request to the origin and cache the response.

Examples using `cache: 'no-cache'`:

```js
const response = await fetch("https://example.com", { cache: "no-cache" });
```

The cache value can also be set on a `Request` object.

```js
const request = new Request("https://example.com", { cache: "no-cache" });
const response = await fetch(request);
```

### Set the `this` value of EventTarget event handlers

| | |
| - | - |
| **Default as of** | 2025-08-01 |
| **Flag to enable** | `set_event_target_this` |
| **Flag to disable** | `no_set_event_target_this` |

When the `set_event_target_this` flag is se, Workers will set the `this` value of event handlers to the `EventTarget` instance that the event is being dispatched on. This is compliant with the specification.

When then `no_set_event_target_this` flag is set, Workers will not set the `this` value of event handlers, and it will be `undefined` instead.

### Set forwardable email full headers

| | |
| - | - |
| **Default as of** | 2025-08-01 |
| **Flag to enable** | `set_forwardable_email_full_headers` |
| **Flag to disable** | `set_forwardable_email_single_headers` |

The original version of the headers sent to edgeworker were truncated to a single value for specific header names, such as To and Cc. With the `set_forwardable_email_full_headers` flag set, Workers will receive the full header values to the worker script.

### Pedantic Web Platform Tests (WPT) compliance

| | |
| - | - |
| **Flag to enable** | `pedantic_wpt` |
| **Flag to disable** | `non_pedantic_wpt` |

The `pedantic_wpt` flag enables strict compliance with Web Platform Tests (WPT) in Workers. Initially this only effects `Event` and `EventTarget` APIs but will be expanded to other APIs in the future. There is no default enable date for this flag.

### Bind AsyncLocalStorage snapshots to the request

| | |
| - | - |
| **Default as of** | 2025-06-16 |
| **Flag to enable** | `bind_asynclocalstorage_snapshot_to_request` |
| **Flag to disable** | `do_not_bind_asynclocalstorage_snapshot_to` |

The AsyncLocalStorage frame can capture values that are bound to the current request context. This is not always in the users control since we use the ALS storage frame to propagate internal trace spans as well as user-provided values. When the `bind_asynclocalstorage_snapshot_to_request` flag is set, the runtime binds the snapshot / bound functions to the current request context and will throw an error if the bound functions are called outside of the request in which they were created.

The `do_not_bind_asynclocalstorage_snapshot_to` flag disables this behavior.

### Throw on unrecognized import assertions

| | |
| - | - |
| **Default as of** | 2025-06-16 |
| **Flag to enable** | `throw_on_unrecognized_import_assertion` |
| **Flag to disable** | `ignore_unrecognized_import_assertion` |

The `throw_on_unrecognized_import_assertion` flag controls how Workers handle import attributes that are not recognized by the runtime. Previously, Workers would ignore all import attributes, which is not compliant with the specification. Runtimes are expected to throw an error when an import attribute is encountered that is not recognized.

When the `ignore_unrecognized_import_assertion` flag is set, Workers will ignore unrecognized import attributes.

### Enable eval during startup

| | |
| - | - |
| **Default as of** | 2025-06-01 |
| **Flag to enable** | `allow_eval_during_startup` |
| **Flag to disable** | `disallow_eval_during_startup` |

When the `allow_eval_during_startup` flag is set, Workers can use `eval()` and `new Function(text)` during the startup phase of a Worker script. This allows for dynamic code execution at the beginning of a Worker lifecycle.

When the `disallow_eval_during_startup` flag is set, using `eval()` or `new Function(text)` during the startup phase will throw an error.

### Enable `Request.signal` for incoming requests

| | |
| - | - |
| **Flag to enable** | `enable_request_signal` |
| **Flag to disable** | `disable_request_signal` |

When you use the `enable_request_signal` compatibility flag, you can attach an event listener to [`Request`](https://developers.cloudflare.com/workers/runtime-apis/request/) objects, using the [`signal` property](https://developer.mozilla.org/en-US/docs/Web/API/Request/signal). This allows you to perform tasks when the request to your Worker is canceled by the client.

### Enable `navigator.language`

| | |
| - | - |
| **Default as of** | 2025-05-19 |
| **Flag to enable** | `enable_navigator_language` |
| **Flag to disable** | `disable_navigator_language` |

When the `enable_navigator_language` flag is set, the `navigator.language` property will be available in Workers. For now, the value of `navigator.language` will always be `en`.

When the `disable_navigator_language` flag is set, the `navigator.language` property will not be available.

### Disallowing importable environment

| | |
| - | - |
| **Flag to enable** | `disallow_importable_env` |
| **Flag to disable** | `allow_importable_env` |

When the `disallow_importable_env` flag is enabled, Workers will not allow importing the environment variables via the `cloudflare:workers` module and will not populate the environment variables in the global `process.env` object when Node.js compatibility is enabled.

There is no default enabled date for this flag.

### Enable `FinalizationRegistry` and `WeakRef`

| | |
| - | - |
| **Default as of** | 2025-05-05 |
| **Flag to enable** | `enable_weak_ref` |
| **Flag to disable** | `disable_weak_ref` |

Enables the use of [`FinalizationRegistry`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/FinalizationRegistry) and [`WeakRef`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WeakRef) built-ins.

* `FinalizationRegistry` allows you to register a cleanup callback that runs after an object has been garbage-collected.
* `WeakRef` creates a weak reference to an object, allowing it to be garbage-collected if no other strong references exist.

Behaviour

`FinalizationRegistry` cleanup callbacks may execute at any point during your request lifecycle, even after your invoked handler has completed (similar to `ctx.waitUntil()`). These callbacks do not have an associated async context. You cannot perform any I/O within them, including emitting events to a tail Worker.

These APIs are fundamentally non-deterministic. The timing and execution of garbage collection are unpredictable, and you **should not rely on them for essential program logic**. Additionally, cleanup callbacks registered with `FinalizationRegistry` may **never be executed**, including but not limited to cases where garbage collection is not triggered, or your Worker gets evicted.

### Passthrough AbortSignal of incoming request to subrequests

| | |
| - | - |
| **Flag to enable** | `request_signal_passthrough` |
| **Flag to disable** | `no_request_signal_passthrough` |

When the `request_signal_passthrough` flag set, the `AbortSignal` of an incoming request will be passed through to subrequests when the request is forwarded to a subrequest using the `fetch()` API.

The the `no_request_signal_passthrough` flag is set, the `AbortSignal` of the incoming request will not be passed through.

### Navigation requests prefer asset serving

| | |
| - | - |
| **Default as of** | 2025-04-01 |
| **Flag to enable** | `assets_navigation_prefers_asset_serving` |
| **Flag to disable** | `assets_navigation_has_no_effect` |

For Workers with [static assets](https://developers.cloudflare.com/workers/static-assets/) and this compatibility flag enabled, navigation requests (requests which have a `Sec-Fetch-Mode: navigate` header) will prefer to be served by our asset-serving logic, even when an exact asset match cannot be found. This is particularly useful for applications which operate in either [Single Page Application (SPA) mode](https://developers.cloudflare.com/workers/static-assets/routing/single-page-application/) or have [custom 404 pages](https://developers.cloudflare.com/workers/static-assets/routing/static-site-generation/#custom-404-pages), as this now means the fallback pages of `200 /index.html` and `404 /404.html` will be served ahead of invoking a Worker script and will therefore avoid incurring a charge.

Without this flag, the runtime will continue to apply the old behavior of invoking a Worker script (if present) for any requests which do not exactly match a static asset.

When `assets.run_worker_first = true` is set, this compatibility flag has no effect. The `assets.run_worker_first = true` setting ensures the Worker script executes before any asset-serving logic.

### Enable auto-populating `process.env`

| | |
| - | - |
| **Default as of** | 2025-04-01 |
| **Flag to enable** | `nodejs_compat_populate_process_env` |
| **Flag to disable** | `nodejs_compat_do_not_populate_process_env` |

When you enable the `nodejs_compat_populate_process_env` compatibility flag and the [`nodejs_compat`](https://developers.cloudflare.com/workers/runtime-apis/nodejs/) flag is also enabled, `process.env` will be populated with values from any bindings with text or JSON values. This means that if you have added [environment variables](https://developers.cloudflare.com/workers/configuration/environment-variables/), [secrets](https://developers.cloudflare.com/workers/configuration/secrets/), or [version metadata](https://developers.cloudflare.com/workers/runtime-apis/bindings/version-metadata/) bindings, these values can be accessed on `process.env`.

```js
const apiClient = ApiClient.new({ apiKey: process.env.API_KEY });
const LOG_LEVEL = process.env.LOG_LEVEL || "info";
```

This makes accessing these values easier and conforms to common Node.js patterns, which can reduce toil and help with compatibility for existing Node.js libraries.

If users do not wish for these values to be accessible via `process.env`, they can use the `nodejs_compat_do_not_populate_process_env` flag. In this case, `process.env` will still be available, but will not have values automatically added.

If the `disallow_importable_env` compatibility flag is set, the `process.env` will also not be populated.

### Queue consumers don't wait for `ctx.waitUntil()` to resolve

| | |
| - | - |
| **Flag to enable** | `queue_consumer_no_wait_for_wait_until` |

By default, [Queues](https://developers.cloudflare.com/queues/) Consumer Workers acknowledge messages only after promises passed to [`ctx.waitUntil()`](https://developers.cloudflare.com/workers/runtime-apis/context) have resolved. This behavior can cause queue consumers which utilize `ctx.waitUntil()` to process messages slowly. The default behavior is documented in the [Queues Consumer Configuration Guide](https://developers.cloudflare.com/queues/configuration/javascript-apis#consumer).

This Consumer Worker is an example of a Worker which utilizes `ctx.waitUntil()`. Under the default behavior, this consumer Worker will only acknowledge a batch of messages after the sleep function has resolved.

```js
export default {
  async fetch(request, env, ctx) {
    // omitted
  },


  async queue(batch, env, ctx) {
    console.log(`received batch of ${batch.messages.length} messages to queue ${batch.queue}`);
    for (let i = 0; i < batch.messages.length; ++i) {
      console.log(`message #${i}: ${JSON.stringify(batch.messages[i])}`);
    }
    ctx.waitUntil(sleep(30 * 1000));
  }
};


function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}
```

If the `queue_consumer_no_wait_for_wait_until` flag is enabled, Queues consumers will no longer wait for promises passed to `ctx.waitUntil()` to resolve before acknowledging messages. This can improve the performance of queue consumers which utilize `ctx.waitUntil()`. With the flag enabled, in the above example, the consumer Worker will acknowledge the batch without waiting for the sleep function to resolve.

Using this flag will not affect the behavior of `ctx.waitUntil()`. `ctx.waitUntil()` will continue to extend the lifetime of your consumer Worker to continue to work even after the batch of messages has been acknowledged.

### Apply TransformStream backpressure fix

| | |
| - | - |
| **Default as of** | 2024-12-16 |
| **Flag to enable** | `fixup-transform-stream-backpressure` |
| **Flag to disable** | `original-transform-stream-backpressure` |

The original implementation of `TransformStream` included a bug that would cause backpressure signaling to fail after the first write to the transform. Unfortunately, the fix can cause existing code written to address the bug to fail. Therefore, the `fixup-transform-stream-backpressure` compat flag is provided to enable the fix.

The fix is enabled by default with compatibility dates of 2024-12-16 or later.

To restore the original backpressure logic, disable the fix using the `original-transform-stream-backpressure` flag.

### Disable top-level await in require(...)

| | |
| - | - |
| **Default as of** | 2024-12-02 |
| **Flag to enable** | `disable_top_level_await_in_require` |
| **Flag to disable** | `enable_top_level_await_in_require` |

Workers implements the ability to use the Node.js style `require(...)` method to import modules in the Worker bundle. Historically, this mechanism allowed required modules to use top-level await. This, however, is not Node.js compatible.

The `disable_top_level_await_in_require` compat flag will cause `require()` to fail if the module uses a top-level await. This flag is default enabled with a compatibility date of 2024-12-02 or later.

To restore the original behavior allowing top-level await, use the `enable_top_level_await_in_require` compatibility flag.

### Enable `cache: no-store` HTTP standard API

| | |
| - | - |
| **Default as of** | 2024-11-11 |
| **Flag to enable** | `cache_option_enabled` |
| **Flag to disable** | `cache_option_disabled` |

When you enable the `cache_option_enabled` compatibility flag, you can specify a value for the `cache` property of the Request interface. When this compatibility flag is not enabled, or `cache_option_disabled` is set, the Workers runtime will throw an `Error` saying `The 'cache' field on 'RequestInitializerDict' is not implemented.`

When this flag is enabled you can instruct Cloudflare not to cache the response from a subrequest you make from your Worker using the [`fetch()` API](https://developers.cloudflare.com/workers/runtime-apis/fetch/):

The only cache option enabled with `cache_option_enabled` is `'no-store'`. Specifying any other value will cause the Workers runtime to throw a `TypeError` with the message `Unsupported cache mode: <the-mode-you-specified>`.

When `no-store` is specified:

* All requests have the headers `Pragma: no-cache` and `Cache-Control: no-cache` are set on them.

* Subrequests to origins not hosted by Cloudflare bypass Cloudflare's cache.

Examples using `cache: 'no-store'`:

```js
const response = await fetch("https://example.com", { cache: "no-store" });
```

The cache value can also be set on a `Request` object.

```js
const request = new Request("https://example.com", { cache: "no-store" });
const response = await fetch(request);
```

### Global fetch() strictly public

| | |
| - | - |
| **Flag to enable** | `global_fetch_strictly_public` |
| **Flag to disable** | `global_fetch_private_origin` |

When the `global_fetch_strictly_public` compatibility flag is enabled, the global [`fetch()` function](https://developers.cloudflare.com/workers/runtime-apis/fetch/) will strictly route requests as if they were made on the public Internet.

This means requests to a Worker's own zone will loop back to the "front door" of Cloudflare and will be treated like a request from the Internet, possibly even looping back to the same Worker again.

When the `global_fetch_strictly_public` is not enabled, such requests are routed to the zone's origin server, ignoring any Workers mapped to the URL and also bypassing Cloudflare security settings.

### Upper-case HTTP methods

| | |
| - | - |
| **Default as of** | 2024-10-14 |
| **Flag to enable** | `upper_case_all_http_methods` |
| **Flag to disable** | `no_upper_case_all_http_methods` |

HTTP methods are expected to be upper-cased. Per the fetch spec, if the method is specified as `get`, `post`, `put`, `delete`, `head`, or `options`, implementations are expected to uppercase the method. All other method names would generally be expected to throw as unrecognized (for example, `patch` would be an error while `PATCH` is accepted). This is a bit restrictive, even if it is in the spec. This flag modifies the behavior to uppercase all methods prior to parsing so that the method is always recognized if it is a known method.

To restore the standard behavior, use the `no_upper_case_all_http_methods` compatibility flag.

### Automatically set the Symbol.toStringTag for Workers API objects

| | |
| - | - |
| **Default as of** | 2024-09-26 |
| **Flag to enable** | `set_tostring_tag` |
| **Flag to disable** | `do_not_set_tostring_tag` |

A change was made to set the Symbol.toStringTag on all Workers API objects in order to fix several spec compliance bugs. Unfortunately, this change was more breaking than anticipated. The `do_not_set_tostring_tag` compat flag restores the original behavior with compatibility dates of 2024-09-26 or earlier.

### Allow specifying a custom port when making a subrequest with the fetch() API

| | |
| - | - |
| **Default as of** | 2024-09-02 |
| **Flag to enable** | `allow_custom_ports` |
| **Flag to disable** | `ignore_custom_ports` |

When this flag is enabled, and you specify a port when making a subrequest with the [`fetch()` API](https://developers.cloudflare.com/workers/runtime-apis/fetch/), the port number you specify will be used.

When you make a subrequest to a website that uses Cloudflare ("Orange Clouded") — only [ports supported by Cloudflare's reverse proxy](https://developers.cloudflare.com/fundamentals/reference/network-ports/#network-ports-compatible-with-cloudflares-proxy) can be specified. If you attempt to specify an unsupported port, it will be ignored.

When you make a subrequest to a website that does not use Cloudflare ("Grey Clouded") - any port can be specified.

For example:

```js
const response = await fetch("https://example.com:8000");
```

With allow\_custom\_ports the above example would fetch `https://example.com:8000` rather than `https://example.com:443`.

Note that creating a WebSocket client with a call to `new WebSocket(url)` will also obey this flag.

### Properly extract blob MIME type from `content-type` headers

| | |
| - | - |
| **Default as of** | 2024-06-03 |
| **Flag to enable** | `blob_standard_mime_type` |
| **Flag to disable** | `blob_legacy_mime_type` |

When calling `response.blob.type()`, the MIME type will now be properly extracted from `content-type` headers, per the [WHATWG spec](https://fetch.spec.whatwg.org/#concept-header-extract-mime-type).

### Use standard URL parsing in `fetch()`

| | |
| - | - |
| **Default as of** | 2024-06-03 |
| **Flag to enable** | `fetch_standard_url` |
| **Flag to disable** | `fetch_legacy_url` |

The `fetch_standard_url` flag makes `fetch()` use [WHATWG URL Standard](https://url.spec.whatwg.org/) parsing rules. The original implementation would throw `TypeError: Fetch API cannot load` errors with some URLs where standard parsing does not, for instance with the inclusion of whitespace before the URL. URL errors will now be thrown immediately upon calling `new Request()` with an improper URL. Previously, URL errors were thrown only once `fetch()` was called.

### Returning empty Uint8Array on final BYOB read

| | |
| - | - |
| **Default as of** | 2024-05-13 |
| **Flag to enable** | `internal_stream_byob_return_view` |
| **Flag to disable** | `internal_stream_byob_return_undefined` |

In the original implementation of BYOB ("Bring your own buffer") `ReadableStreams`, the `read()` method would return `undefined` when the stream was closed and there was no more data to read. This behavior was inconsistent with the standard `ReadableStream` behavior, which returns an empty `Uint8Array` when the stream is closed.

When the `internal_stream_byob_return_view` flag is used, the BYOB `read()` will implement standard behavior.

```js
const resp = await fetch('https://example.org');
const reader = resp.body.getReader({ mode: 'byob' });
await result = await reader.read(new Uint8Array(10));


if (result.done) {
  // The result gives us an empty Uint8Array...
  console.log(result.value.byteLength); // 0


  // However, it is backed by the same underlying memory that was passed
  // into the read call.
  console.log(result.value.buffer.byteLength); // 10
}
```

### Brotli Content-Encoding support

| | |
| - | - |
| **Default as of** | 2024-04-29 |
| **Flag to enable** | `brotli_content_encoding` |
| **Flag to disable** | `no_brotli_content_encoding` |

When the `brotli_content_encoding` compatibility flag is enabled, Workers supports the `br` content encoding and can request and respond with data encoded using the [Brotli](https://developer.mozilla.org/en-US/docs/Glossary/Brotli_compression) compression algorithm. This reduces the amount of data that needs to be fetched and can be used to pass through the original compressed data to the client. See the Fetch API [documentation](https://developers.cloudflare.com/workers/runtime-apis/fetch/#how-the-accept-encoding-header-is-handled) for details.

### Durable Object stubs and Service Bindings support RPC

| | |
| - | - |
| **Default as of** | 2024-04-03 |
| **Flag to enable** | `rpc` |
| **Flag to disable** | `no_rpc` |

With this flag on, [Durable Object](https://developers.cloudflare.com/durable-objects/) stubs and [Service Bindings](https://developers.cloudflare.com/workers/runtime-apis/bindings/service-bindings/) support [RPC](https://developers.cloudflare.com/workers/runtime-apis/rpc/). This means that these objects now appear as if they define every possible method name. Calling any method name sends an RPC to the remote Durable Object or Worker service.

For most applications, this change will have no impact unless you use it. However, it is possible some existing code will be impacted if it explicitly checks for the existence of method names that were previously not defined on these types. For example, we have seen code in the wild which iterates over [bindings](https://developers.cloudflare.com/workers/runtime-apis/bindings/) and tries to auto-detect their types based on what methods they implement. Such code will now see service bindings as implementing every method, so may misinterpret service bindings as being some other type. In the cases we have seen, the impact was benign (nothing actually broke), but out of caution we are guarding this change behind a flag.

### Handling custom thenables

| | |
| - | - |
| **Default as of** | 2024-04-01 |
| **Flag to enable** | `unwrap_custom_thenables` |
| **Flag to disable** | `no_unwrap_custom_thenables` |

With the `unwrap_custom_thenables` flag set, various Workers APIs that accept promises will also correctly handle custom thenables (objects with a `then` method) that are not native promises, but are intended to be treated as such). For example, the `waitUntil` method of the `ExecutionContext` object will correctly handle custom thenables, allowing them to be used in place of native promises.

```js
async fetch(req, env, ctx) {
  ctx.waitUntil({ then(res) {
    // Resolve the thenable after 1 second
    setTimeout(res, 1000);
  } });
  // ...
}
```

### Fetchers no longer have get/put/delete helper methods

| | |
| - | - |
| **Default as of** | 2024-03-26 |
| **Flag to enable** | `fetcher_no_get_put_delete` |
| **Flag to disable** | `fetcher_has_get_put_delete` |

[Durable Object](https://developers.cloudflare.com/durable-objects/) stubs and [Service Bindings](https://developers.cloudflare.com/workers/runtime-apis/bindings/service-bindings/) both implement a `fetch()` method which behaves similarly to the global `fetch()` method, but requests are instead sent to the destination represented by the object, rather than being routed based on the URL.

Historically, API objects that had such a `fetch()` method also had methods `get()`, `put()`, and `delete()`. These methods were thin wrappers around `fetch()` which would perform the corresponding HTTP method and automatically handle writing/reading the request/response bodies as needed.

These methods were a very early idea from many years ago, but were never actually documented, and therefore rarely (if ever) used. Enabling the `fetcher_no_get_put_delete`, or setting a compatibility date on or after `2024-03-26` disables these methods for your Worker.

This change paves a future path for you to be able to define your own custom methods using these names. Without this change, you would be unable to define your own `get`, `put`, and `delete` methods, since they would conflict with these built-in helper methods.

### Queues send messages in `JSON` format

| | |
| - | - |
| **Default as of** | 2024-03-18 |
| **Flag to enable** | `queues_json_messages` |
| **Flag to disable** | `no_queues_json_messages` |

With the `queues_json_messages` flag set, Queue bindings will serialize values passed to `send()` or `sendBatch()` into JSON format by default (when no specific `contentType` is provided).

### Suppress global `importScripts()`

| | |
| - | - |
| **Default as of** | 2024-03-04 |
| **Flag to enable** | `no_global_importscripts` |
| **Flag to disable** | `global_importscripts` |

Suppresses the global `importScripts()` function. This method was included in the Workers global scope but was marked explicitly as non-implemented. However, the presence of the function could cause issues with some libraries. This compatibility flag removes the function from the global scope.

### Node.js AsyncLocalStorage

| | |
| - | - |
| **Flag to enable** | `nodejs_als` |
| **Flag to disable** | `no_nodejs_als` |

Enables the availability of the Node.js [AsyncLocalStorage](https://nodejs.org/api/async_hooks.html#async_hooks_class_asynclocalstorage) API in Workers.

### Python Workers

| | |
| - | - |
| **Default as of** | 2024-01-29 |
| **Flag to enable** | `python_workers` |

This flag enables first class support for Python. [Python Workers](https://developers.cloudflare.com/workers/languages/python/) implement the majority of Python's [standard library](https://developers.cloudflare.com/workers/languages/python/stdlib), support all [bindings](https://developers.cloudflare.com/workers/runtime-apis/bindings), [environment variable](https://developers.cloudflare.com/workers/configuration/environment-variables), and [secrets](https://developers.cloudflare.com/workers/configuration/secrets), and integration with JavaScript objects and functions via a [foreign function interface](https://developers.cloudflare.com/workers/languages/python/ffi).

### WebCrypto preserve publicExponent field

| | |
| - | - |
| **Default as of** | 2023-12-01 |
| **Flag to enable** | `crypto_preserve_public_exponent` |
| **Flag to disable** | `no_crypto_preserve_public_exponent` |

In the WebCrypto API, the `publicExponent` field of the algorithm of RSA keys would previously be an `ArrayBuffer`. Using this flag, `publicExponent` is a `Uint8Array` as mandated by the specification.

### `Vectorize` query with metadata optionally returned

| | |
| - | - |
| **Default as of** | 2023-11-08 |
| **Flag to enable** | `vectorize_query_metadata_optional` |
| **Flag to disable** | `vectorize_query_original` |

A set value on `vectorize_query_metadata_optional` indicates that the Vectorize query operation should accept newer arguments with `returnValues` and `returnMetadata` specified discretely over the older argument `returnVectors`. This also changes the return format. If the vector values have been indicated for return, the return value is now a flattened vector object with `score` attached where it previously contained a nested vector object.

### WebSocket Compression

| | |
| - | - |
| **Default as of** | 2023-08-15 |
| **Flag to enable** | `web_socket_compression` |
| **Flag to disable** | `no_web_socket_compression` |

The Workers runtime did not support WebSocket compression when the initial WebSocket implementation was released. Historically, the runtime has stripped or ignored the `Sec-WebSocket-Extensions` header -- but is now capable of fully complying with the WebSocket Compression RFC. Since many clients are likely sending `Sec-WebSocket-Extensions: permessage-deflate` to their Workers today (`new WebSocket(url)` automatically sets this in browsers), we have decided to maintain prior behavior if this flag is absent.

If the flag is present, the Workers runtime is capable of using WebSocket Compression on both inbound and outbound WebSocket connections.

Like browsers, calling `new WebSocket(url)` in a Worker will automatically set the `Sec-WebSocket-Extensions: permessage-deflate` header. If you are using the non-standard `fetch()` API to obtain a WebSocket, you can include the `Sec-WebSocket-Extensions` header with value `permessage-deflate` and include any of the compression parameters defined in [RFC-7692](https://datatracker.ietf.org/doc/html/rfc7692#section-7).

### Strict crypto error checking

| | |
| - | - |
| **Default as of** | 2023-08-01 |
| **Flag to enable** | `strict_crypto_checks` |
| **Flag to disable** | `no_strict_crypto_checks` |

Perform additional error checking in the Web Crypto API to conform with the specification and reject possibly unsafe key parameters:

* For RSA key generation, key sizes are required to be multiples of 128 bits as boringssl may otherwise truncate the key.
* The size of imported RSA keys must be at least 256 bits and at most 16384 bits, as with newly generated keys.
* The public exponent for imported RSA keys is restricted to the commonly used values `[3, 17, 37, 65537]`.
* In conformance with the specification, an error will be thrown when trying to import a public ECDH key with non-empty usages.

### Strict compression error checking

| | |
| - | - |
| **Default as of** | 2023-08-01 |
| **Flag to enable** | `strict_compression_checks` |
| **Flag to disable** | `no_strict_compression_checks` |

Perform additional error checking in the Compression Streams API and throw an error if a `DecompressionStream` has trailing data or gets closed before the full compressed data has been provided.

### Override cache rules cache settings in `request.cf` object for Fetch API

| | |
| - | - |
| **Default as of** | 2025-04-02 |
| **Flag to enable** | `request_cf_overrides_cache_rules` |
| **Flag to disable** | `no_request_cf_overrides_cache_rules` |

This flag changes the behavior of cache when requesting assets via the [Fetch API](https://developers.cloudflare.com/workers/runtime-apis/fetch). Cache settings specified in the `request.cf` object, such as `cacheEverything` and `cacheTtl`, are now given precedence over any [Cache Rules](https://developers.cloudflare.com/cache/how-to/cache-rules/) set.

### Bot Management data

| | |
| - | - |
| **Default as of** | 2023-08-01 |
| **Flag to enable** | `no_cf_botmanagement_default` |
| **Flag to disable** | `cf_botmanagement_default` |

This flag streamlines Workers requests by reducing unnecessary properties in the `request.cf` object.

With the flag enabled - either by default after 2023-08-01 or by setting the `no_cf_botmanagement_default` flag - Cloudflare will only include the [Bot Management object](https://developers.cloudflare.com/bots/reference/bot-management-variables/) in a Worker's `request.cf` if the account has access to Bot Management.

With the flag disabled, Cloudflare will include a default Bot Management object, regardless of whether the account is entitled to Bot Management.

### URLSearchParams delete() and has() value argument

| | |
| - | - |
| **Default as of** | 2023-07-01 |
| **Flag to enable** | `urlsearchparams_delete_has_value_arg` |
| **Flag to disable** | `no_urlsearchparams_delete_has_value_arg` |

The WHATWG introduced additional optional arguments to the `URLSearchParams` object [`delete()`](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/delete) and [`has()`](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/has) methods that allow for more precise control over the removal of query parameters. Because the arguments are optional and change the behavior of the methods when present there is a risk of breaking existing code. If your compatibility date is set to July 1, 2023 or after, this compatibility flag will be enabled by default.

For an example of how this change could break existing code, consider code that uses the `Array` `forEach()` method to iterate through a number of parameters to delete:

```js
const usp = new URLSearchParams();
// ...
['abc', 'xyz'].forEach(usp.delete.bind(usp));
```

The `forEach()` automatically passes multiple parameters to the function that is passed in. Prior to the addition of the new standard parameters, these extra arguments would have been ignored.

Now, however, the additional arguments have meaning and change the behavior of the function. With this flag, the example above would need to be changed to:

```js
const usp = new URLSearchParams();
// ...
['abc', 'xyz'].forEach((key) => usp.delete(key));
```

### Use a spec compliant URL implementation in redirects

| | |
| - | - |
| **Default as of** | 2023-03-14 |
| **Flag to enable** | `response_redirect_url_standard` |
| **Flag to disable** | `response_redirect_url_original` |

Change the URL implementation used in `Response.redirect()` to be spec-compliant (WHATWG URL Standard).

### Dynamic Dispatch Exception Propagation

| | |
| - | - |
| **Default as of** | 2023-03-01 |
| **Flag to enable** | `dynamic_dispatch_tunnel_exceptions` |
| **Flag to disable** | `dynamic_dispatch_treat_exceptions_as_500` |

Previously, when using Workers for Platforms' [dynamic dispatch API](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/get-started/dynamic-dispatch/) to send an HTTP request to a user Worker, if the user Worker threw an exception, the dynamic dispatch Worker would receive an HTTP `500` error with no body. When the `dynamic_dispatch_tunnel_exceptions` compatibility flag is enabled, the exception will instead propagate back to the dynamic dispatch Worker. The `fetch()` call in the dynamic dispatch Worker will throw the same exception. This matches the similar behavior of [service bindings](https://developers.cloudflare.com/workers/runtime-apis/bindings/service-bindings/) and [Durable Objects](https://developers.cloudflare.com/durable-objects/).

### `Headers` supports `getSetCookie()`

| | |
| - | - |
| **Default as of** | 2023-03-01 |
| **Flag to enable** | `http_headers_getsetcookie` |
| **Flag to disable** | `no_http_headers_getsetcookie` |

Adds the [`getSetCookie()`](https://developer.mozilla.org/en-US/docs/Web/API/Headers/getSetCookie) method to the [Headers](https://developer.mozilla.org/en-US/docs/Web/API/Headers) API in Workers.

```js
const response = await fetch("https://example.com");
let cookieValues = response.headers.getSetCookie();
```

### Node.js compatibility

| | |
| - | - |
| **Flag to enable** | `nodejs_compat` |
| **Flag to disable** | `no_nodejs_compat` |

Enables [Node.js APIs](https://developers.cloudflare.com/workers/runtime-apis/nodejs/) in the Workers Runtime.

Note that some Node.js APIs are only enabled if your Worker's compatibility date is set to on or after the following dates:

| Node.js API | Enabled after |
| - | - |
| [`http.server`](https://developers.cloudflare.com/workers/configuration/compatibility-flags/#enable-nodejs-http-server-modules) | `2025-09-01` |
| [`node:http`, `node:https`](https://developers.cloudflare.com/workers/configuration/compatibility-flags/#enable-availability-of-nodehttp-and-nodehttps-modules) | `2025-08-15` |
| [`process.env`](https://developers.cloudflare.com/workers/configuration/compatibility-flags/#enable-auto-populating-processenv) | `2025-04-01` |
| [Disable Top-level Await in `require()`](https://developers.cloudflare.com/workers/configuration/compatibility-flags/#disable-top-level-await-in-require) | `2024-12-02` |

When enabling `nodejs_compat`, we recommend using the latest version of [Wrangler CLI](https://developers.cloudflare.com/workers/wrangler/), and the latest compatiblity date, in order to maximize compatibility. Some older versions of Wrangler inject additional polyfills that are no longer neccessary, as they are provided by the Workers runtime, if your Worker is using a more recent compatibility date.

If you see errors using a particular NPM package on Workers, you should first try updating your compatibility date and use the latest version of [Wrangler CLI](https://developers.cloudflare.com/workers/wrangler/) or the [Cloudflare Vite Plugin](https://developers.cloudflare.com/workers/vite-plugin/). If you still encounter issues, please report them by [opening a GitHub issue](https://github.com/cloudflare/workers-sdk/issues/new?template=bug-template.yaml).

### Streams Constructors

| | |
| - | - |
| **Default as of** | 2022-11-30 |
| **Flag to enable** | `streams_enable_constructors` |
| **Flag to disable** | `streams_disable_constructors` |

Adds the work-in-progress `new ReadableStream()` and `new WritableStream()` constructors backed by JavaScript underlying sources and sinks.

### Compliant TransformStream constructor

| | |
| - | - |
| **Default as of** | 2022-11-30 |
| **Flag to enable** | `transformstream_enable_standard_constructor` |
| **Flag to disable** | `transformstream_disable_standard_constructor` |

Previously, the `new TransformStream()` constructor was not compliant with the Streams API standard. Use the `transformstream_enable_standard_constructor` to opt-in to the backwards-incompatible change to make the constructor compliant. Must be used in combination with the `streams_enable_constructors` flag.

### CommonJS modules do not export a module namespace

| | |
| - | - |
| **Default as of** | 2022-10-31 |
| **Flag to enable** | `export_commonjs_default` |
| **Flag to disable** | `export_commonjs_namespace` |

CommonJS modules were previously exporting a module namespace (an object like `{ default: module.exports }`) rather than exporting only the `module.exports`. When this flag is enabled, the export is fixed.

### Do not throw from async functions

| | |
| - | - |
| **Default as of** | 2022-10-31 |
| **Flag to enable** | `capture_async_api_throws` |
| **Flag to disable** | `do_not_capture_async_api_throws` |

The `capture_async_api_throws` compatibility flag will ensure that, in conformity with the standards API, async functions will only ever reject if they throw an error. The inverse `do_not_capture_async_api_throws` flag means that async functions which contain an error may throw that error synchronously rather than rejecting.

### New URL parser implementation

| | |
| - | - |
| **Default as of** | 2022-10-31 |
| **Flag to enable** | `url_standard` |
| **Flag to disable** | `url_original` |

The original implementation of the [`URL`](https://developer.mozilla.org/en-US/docs/Web/API/URL) API in Workers was not fully compliant with the [WHATWG URL Standard](https://url.spec.whatwg.org/), differing in several ways, including:

* The original implementation collapsed sequences of multiple slashes into a single slash:

  `new URL("https://example.com/a//b").toString() === "https://example.com/a/b"`

* The original implementation would throw `"TypeError: Invalid URL string."` if it encountered invalid percent-encoded escape sequences, like `https://example.com/a%%b`.

* The original implementation would percent-encode or percent-decode certain content differently:

  `new URL("https://example.com/a%40b?c d%20e?f").toString() === "https://example.com/a@b?c+d+e%3Ff"`

* The original implementation lacked more recently implemented `URL` features, like [`URL.canParse()`](https://developer.mozilla.org/en-US/docs/Web/API/URL/canParse_static).

Set the compatibility date of your Worker to a date after `2022-10-31` or enable the `url_standard` compatibility flag to opt-in the fully spec compliant `URL` API implementation.

Refer to the [`response_redirect_url_standard` compatibility flag](https://developers.cloudflare.com/workers/configuration/compatibility-flags/#use-a-spec-compliant-url-implementation-in-redirects) , which affects the URL implementation used in `Response.redirect()`.

### `R2` bucket `list` respects the `include` option

| | |
| - | - |
| **Default as of** | 2022-08-04 |
| **Flag to enable** | `r2_list_honor_include` |

With the `r2_list_honor_include` flag set, the `include` argument to R2 `list` options is honored. With an older compatibility date and without this flag, the `include` argument behaves implicitly as `include: ["httpMetadata", "customMetadata"]`.

### Do not substitute `null` on `TypeError`

| | |
| - | - |
| **Default as of** | 2022-06-01 |
| **Flag to enable** | `dont_substitute_null_on_type_error` |
| **Flag to disable** | `substitute_null_on_type_error` |

There was a bug in the runtime that meant that when being passed into built-in APIs, invalid values were sometimes mistakenly coalesced with `null`. Instead, a `TypeError` should have been thrown. The `dont_substitute_null_on_type_error` fixes this behavior so that an error is correctly thrown in these circumstances.

### Minimal subrequests

| | |
| - | - |
| **Default as of** | 2022-04-05 |
| **Flag to enable** | `minimal_subrequests` |
| **Flag to disable** | `no_minimal_subrequests` |

With the `minimal_subrequests` flag set, `fetch()` subrequests sent to endpoints on the Worker's own zone (also called same-zone subrequests) have a reduced set of features applied to them. In general, these features should not have been initially applied to same-zone subrequests, and very few user-facing behavior changes are anticipated. Specifically, Workers might observe the following behavior changes with the new flag:

* Response bodies will not be opportunistically gzipped before being transmitted to the Workers runtime. If a Worker reads the response body, it will read it in plaintext, as has always been the case, so disabling this prevents unnecessary decompression. Meanwhile, if the Worker passes the response through to the client, Cloudflare's HTTP proxy will opportunistically gzip the response body on that side of the Workers runtime instead. The behavior change observable by a Worker script should be that some `Content-Encoding: gzip` headers will no longer appear.
* Automatic Platform Optimization may previously have been applied on both the Worker's initiating request and its subrequests in some circumstances. It will now only apply to the initiating request.
* Link prefetching will now only apply to the Worker's response, not responses to the Worker's subrequests.

### Global `navigator`

| | |
| - | - |
| **Default as of** | 2022-03-21 |
| **Flag to enable** | `global_navigator` |
| **Flag to disable** | `no_global_navigator` |

With the `global_navigator` flag set, a new global `navigator` property is available from within Workers. Currently, it exposes only a single `navigator.userAgent` property whose value is set to `'Cloudflare-Workers'`. This property can be used to reliably determine whether code is running within the Workers environment.

### Do not use the Custom Origin Trust Store for external subrequests

| | |
| - | - |
| **Default as of** | 2022-03-08 |
| **Flag to enable** | `no_cots_on_external_fetch` |
| **Flag to disable** | `cots_on_external_fetch` |

The `no_cots_on_external_fetch` flag disables the use of the [Custom Origin Trust Store](https://developers.cloudflare.com/ssl/origin-configuration/custom-origin-trust-store/) when making external (grey-clouded) subrequests from a Cloudflare Worker.

### Setters/getters on API object prototypes

| | |
| - | - |
| **Default as of** | 2022-01-31 |
| **Flag to enable** | `workers_api_getters_setters_on_prototype` |
| **Flag to disable** | `workers_api_getters_setters_on_instance` |

Originally, properties on Workers API objects were defined as instance properties as opposed to prototype properties. This broke subclassing at the JavaScript layer, preventing a subclass from correctly overriding the superclass getters/setters. This flag controls the breaking change made to set those getters/setters on the prototype template instead.

This changes applies to:

* `AbortSignal`
* `AbortController`
* `Blob`
* `Body`
* `DigestStream`
* `Event`
* `File`
* `Request`
* `ReadableStream`
* `ReadableStreamDefaultReader`
* `ReadableStreamBYOBReader`
* `Response`
* `TextDecoder`
* `TextEncoder`
* `TransformStream`
* `URL`
* `WebSocket`
* `WritableStream`
* `WritableStreamDefaultWriter`

### Durable Object `stub.fetch()` requires a full URL

| | |
| - | - |
| **Default as of** | 2021-11-10 |
| **Flag to enable** | `durable_object_fetch_requires_full_url` |
| **Flag to disable** | `durable_object_fetch_allows_relative_url` |

Originally, when making a request to a Durable Object by calling `stub.fetch(url)`, a relative URL was accepted as an input. The URL would be interpreted relative to the placeholder URL `http://fake-host`, and the resulting absolute URL was delivered to the destination object's `fetch()` handler. This behavior was incorrect — full URLs were meant to be required. This flag makes full URLs required.

### `fetch()` improperly interprets unknown protocols as HTTP

| | |
| - | - |
| **Default as of** | 2021-11-10 |
| **Flag to enable** | `fetch_refuses_unknown_protocols` |
| **Flag to disable** | `fetch_treats_unknown_protocols_as_http` |

Originally, if the `fetch()` function was passed a URL specifying any protocol other than `http:` or `https:`, it would silently treat it as if it were `http:`. For example, `fetch()` would appear to accept `ftp:` URLs, but it was actually making HTTP requests instead.

Note that Cloudflare Workers supports a non-standard extension to `fetch()` to make it support WebSockets. However, when making an HTTP request that is intended to initiate a WebSocket handshake, you should still use `http:` or `https:` as the protocol, not `ws:` nor `wss:`.

The `ws:` and `wss:` URL schemes are intended to be used together with the `new WebSocket()` constructor, which exclusively supports WebSocket. The extension to `fetch()` is designed to support HTTP and WebSocket in the same request (the response may or may not choose to initiate a WebSocket), and so all requests are considered to be HTTP.

### Streams BYOB reader detaches buffer

| | |
| - | - |
| **Default as of** | 2021-11-10 |
| **Flag to enable** | `streams_byob_reader_detaches_buffer` |
| **Flag to disable** | `streams_byob_reader_does_not_detach_buffer` |

Originally, the Workers runtime did not detach the `ArrayBuffer`s from user-provided TypedArrays when using the [BYOB reader's `read()` method](https://developers.cloudflare.com/workers/runtime-apis/streams/readablestreambyobreader/#methods), as required by the Streams spec, meaning it was possible to inadvertently reuse the same buffer for multiple `read()` calls. This change makes Workers conform to the spec.

User code should never try to reuse an `ArrayBuffer` that has been passed into a [BYOB reader's `read()` method](https://developers.cloudflare.com/workers/runtime-apis/streams/readablestreambyobreader/#methods). Instead, user code can reuse the `ArrayBuffer` backing the result of the `read()` promise, as in the example below.

```js
// Consume and discard `readable` using a single 4KiB buffer.
let reader = readable.getReader({ mode: "byob" });
let arrayBufferView = new Uint8Array(4096);
while (true) {
  let result = await reader.read(arrayBufferView);
  if (result.done) break;
  // Optionally something with `result` here.
  // Re-use the same memory for the next `read()` by creating
  // a new Uint8Array backed by the result's ArrayBuffer.
  arrayBufferView = new Uint8Array(result.value.buffer);
}
```

The more recently added extension method `readAtLeast()` will always detach the `ArrayBuffer` and is unaffected by this feature flag setting.

### `FormData` parsing supports `File`

| | |
| - | - |
| **Default as of** | 2021-11-03 |
| **Flag to enable** | `formdata_parser_supports_files` |
| **Flag to disable** | `formdata_parser_converts_files_to_strings` |

[The `FormData` API](https://developer.mozilla.org/en-US/docs/Web/API/FormData) is used to parse data (especially HTTP request bodies) in `multipart/form-data` format.

Originally, the Workers runtime's implementation of the `FormData` API incorrectly converted uploaded files to strings. Therefore, `formData.get("filename")` would return a string containing the file contents instead of a `File` object. This change fixes the problem, causing files to be represented using `File` as specified in the standard.

### `HTMLRewriter` handling of `<esi:include>`

| | |
| - | - |
| **Flag to enable** | `html_rewriter_treats_esi_include_as_void_tag` |

The HTML5 standard defines a fixed set of elements as void elements, meaning they do not use an end tag: `<area>`, `<base>`, `<br>`, `<col>`, `<command>`, `<embed>`, `<hr>`, `<img>`, `<input>`, `<keygen>`, `<link>`, `<meta>`, `<param>`, `<source>`, `<track>`, and `<wbr>`.

HTML5 does not recognize XML self-closing tag syntax. For example, `<script src="foo.js" />` does not specify a script element with no body. A `</script>` ending tag is still required. The `/>` syntax simply is not recognized by HTML5 at all and it is treated the same as `>`. However, many developers still like to use this syntax, as a holdover from XHTML, a standard which failed to gain traction in the early 2000's.

`<esi:include>` and `<esi:comment>` are two tags that are not part of the HTML5 standard, but are instead used as part of [Edge Side Includes](https://en.wikipedia.org/wiki/Edge_Side_Includes), a technology for server-side HTML modification. These tags are not expected to contain any body and are commonly written with XML self-closing syntax.

`HTMLRewriter` was designed to parse standard HTML5, not ESI. However, it would be useful to be able to implement some parts of ESI using `HTMLRewriter`. To that end, this compatibility flag causes `HTMLRewriter` to treat `<esi:include>` and `<esi:comment>` as void tags, so that they can be parsed and handled properly.

## Experimental flags

These flags can be enabled via `compatibility_flags`, but are not yet scheduled to become default on any particular date.

### Queue consumers don't wait for `ctx.waitUntil()` to resolve

| | |
| - | - |
| **Flag to enable** | `queue_consumer_no_wait_for_wait_until` |

By default, [Queues](https://developers.cloudflare.com/queues/) Consumer Workers acknowledge messages only after promises passed to [`ctx.waitUntil()`](https://developers.cloudflare.com/workers/runtime-apis/context) have resolved. This behavior can cause queue consumers which utilize `ctx.waitUntil()` to process messages slowly. The default behavior is documented in the [Queues Consumer Configuration Guide](https://developers.cloudflare.com/queues/configuration/javascript-apis#consumer).

This Consumer Worker is an example of a Worker which utilizes `ctx.waitUntil()`. Under the default behavior, this consumer Worker will only acknowledge a batch of messages after the sleep function has resolved.

```js
export default {
  async fetch(request, env, ctx) {
    // omitted
  },


  async queue(batch, env, ctx) {
    console.log(`received batch of ${batch.messages.length} messages to queue ${batch.queue}`);
    for (let i = 0; i < batch.messages.length; ++i) {
      console.log(`message #${i}: ${JSON.stringify(batch.messages[i])}`);
    }
    ctx.waitUntil(sleep(30 * 1000));
  }
};


function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}
```

If the `queue_consumer_no_wait_for_wait_until` flag is enabled, Queues consumers will no longer wait for promises passed to `ctx.waitUntil()` to resolve before acknowledging messages. This can improve the performance of queue consumers which utilize `ctx.waitUntil()`. With the flag enabled, in the above example, the consumer Worker will acknowledge the batch without waiting for the sleep function to resolve.

Using this flag will not affect the behavior of `ctx.waitUntil()`. `ctx.waitUntil()` will continue to extend the lifetime of your consumer Worker to continue to work even after the batch of messages has been acknowledged.

### `HTMLRewriter` handling of `<esi:include>`

| | |
| - | - |
| **Flag to enable** | `html_rewriter_treats_esi_include_as_void_tag` |

The HTML5 standard defines a fixed set of elements as void elements, meaning they do not use an end tag: `<area>`, `<base>`, `<br>`, `<col>`, `<command>`, `<embed>`, `<hr>`, `<img>`, `<input>`, `<keygen>`, `<link>`, `<meta>`, `<param>`, `<source>`, `<track>`, and `<wbr>`.

HTML5 does not recognize XML self-closing tag syntax. For example, `<script src="foo.js" />` does not specify a script element with no body. A `</script>` ending tag is still required. The `/>` syntax simply is not recognized by HTML5 at all and it is treated the same as `>`. However, many developers still like to use this syntax, as a holdover from XHTML, a standard which failed to gain traction in the early 2000's.

`<esi:include>` and `<esi:comment>` are two tags that are not part of the HTML5 standard, but are instead used as part of [Edge Side Includes](https://en.wikipedia.org/wiki/Edge_Side_Includes), a technology for server-side HTML modification. These tags are not expected to contain any body and are commonly written with XML self-closing syntax.

`HTMLRewriter` was designed to parse standard HTML5, not ESI. However, it would be useful to be able to implement some parts of ESI using `HTMLRewriter`. To that end, this compatibility flag causes `HTMLRewriter` to treat `<esi:include>` and `<esi:comment>` as void tags, so that they can be parsed and handled properly.


