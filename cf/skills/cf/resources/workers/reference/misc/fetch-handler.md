# Fetch Handler


## Background

Incoming HTTP requests to a Worker are passed to the `fetch()` handler as a [`Request`](https://developers.cloudflare.com/workers/runtime-apis/request/) object. To respond to the request with a response, return a [`Response`](https://developers.cloudflare.com/workers/runtime-apis/response/) object:

```js
export default {
  async fetch(request, env, ctx) {
    return new Response('Hello World!');
  },
};
```

Note

The Workers runtime does not support `XMLHttpRequest` (XHR). Learn the difference between `XMLHttpRequest` and `fetch()` in the [MDN](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest) documentation.

### Parameters

* `request` Request

  * The incoming HTTP request.

* `env` object

  * The [bindings](https://developers.cloudflare.com/workers/configuration/environment-variables/) available to the Worker. As long as the [environment](https://developers.cloudflare.com/workers/wrangler/environments/) has not changed, the same object (equal by identity) may be passed to multiple requests.

* `ctx.waitUntil(promisePromise)` : void

  * Refer to [`waitUntil`](https://developers.cloudflare.com/workers/runtime-apis/context/#waituntil).

* `ctx.passThroughOnException()` : void

  * Refer to [`passThroughOnException`](https://developers.cloudflare.com/workers/runtime-apis/context/#passthroughonexception).


