# Scheduled Handler


## Background

When a Worker is invoked via a [Cron Trigger](https://developers.cloudflare.com/workers/configuration/cron-triggers/), the `scheduled()` handler handles the invocation.

Testing scheduled() handlers in local development

You can test the behavior of your `scheduled()` handler in local development using Wrangler.

Cron Triggers can be tested using `Wrangler` by passing in the `--test-scheduled` flag to [`wrangler dev`](https://developers.cloudflare.com/workers/wrangler/commands/#dev). This will expose a `/__scheduled` (or `/cdn-cgi/handler/scheduled` for Python Workers) route which can be used to test using a http request. To simulate different cron patterns, a `cron` query parameter can be passed in.

```sh
npx wrangler dev --test-scheduled


curl "http://localhost:8787/__scheduled?cron=*+*+*+*+*"


curl "http://localhost:8787/cdn-cgi/handler/scheduled?cron=*+*+*+*+*" # Python Workers
```

***

## Syntax

* JavaScript

  ```js
  export default {
    async scheduled(controller, env, ctx) {
      ctx.waitUntil(doSomeTaskOnASchedule());
    },
  };
  ```

* TypeScript

  ```ts
  interface Env {}
  export default {
    async scheduled(
      controller: ScheduledController,
      env: Env,
      ctx: ExecutionContext,
    ) {
      ctx.waitUntil(doSomeTaskOnASchedule());
    },
  };
  ```

* Python

  ```python
  from workers import WorkerEntrypoint, Response, fetch


  class Default(WorkerEntrypoint):
      async def scheduled(self, controller, env, ctx):
          ctx.waitUntil(doSomeTaskOnASchedule())
  ```

### Properties

* `controller.cron` string

  * The value of the [Cron Trigger](https://developers.cloudflare.com/workers/configuration/cron-triggers/) that started the `ScheduledEvent`.

* `controller.type` string

  * The type of controller. This will always return `"scheduled"`.

* `controller.scheduledTime` number

  * The time the `ScheduledEvent` was scheduled to be executed in milliseconds since January 1, 1970, UTC. It can be parsed as `new Date(controller.scheduledTime)`.

* `env` object

  * An object containing the bindings associated with your Worker using ES modules format, such as KV namespaces and Durable Objects.

* `ctx` object

  * An object containing the context associated with your Worker using ES modules format. Currently, this object just contains the `waitUntil` function.

### Methods

When a Workers script is invoked by a [Cron Trigger](https://developers.cloudflare.com/workers/configuration/cron-triggers/), the Workers runtime starts a `ScheduledEvent` which will be handled by the `scheduled` function in your Workers Module class. The `ctx` argument represents the context your function runs in, and contains the following methods to control what happens next:

* `ctx.waitUntil(promisePromise)` : void - Use this method to notify the runtime to wait for asynchronous tasks (for example, logging, analytics to third-party services, streaming and caching). The first `ctx.waitUntil` to fail will be observed and recorded as the status in the [Cron Trigger](https://developers.cloudflare.com/workers/configuration/cron-triggers/) Past Events table. Otherwise, it will be reported as a success.


