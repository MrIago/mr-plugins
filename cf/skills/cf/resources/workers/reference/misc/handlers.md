# Handlers


Handlers are methods on Workers that can receive and process external inputs, and can be invoked from outside your Worker. For example, the `fetch()` handler receives an HTTP request, and can return a response:

```js
export default {
  async fetch(request, env, ctx) {
    return new Response('Hello World!');
  },
};
```

The following handlers are available within Workers:

* [Alarm Handler](https://developers.cloudflare.com/durable-objects/api/alarms/)
* [Email Handler](https://developers.cloudflare.com/email-routing/email-workers/runtime-api/)
* [Fetch Handler](https://developers.cloudflare.com/workers/runtime-apis/handlers/fetch/)
* [Queue Handler](https://developers.cloudflare.com/queues/configuration/javascript-apis/#consumer)
* [Scheduled Handler](https://developers.cloudflare.com/workers/runtime-apis/handlers/scheduled/)
* [Tail Handler](https://developers.cloudflare.com/workers/runtime-apis/handlers/tail/)

## Handlers in Python Workers

When you [write Workers in Python](https://developers.cloudflare.com/workers/languages/python/), handlers are placed in a class named `Default` that extends the [`WorkerEntrypoint` class](https://developers.cloudflare.com/workers/runtime-apis/bindings/service-bindings/rpc/) (which you can import from the `workers` SDK module).


