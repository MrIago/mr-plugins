# Streams - Runtime APIs


The [Streams API](https://developer.mozilla.org/en-US/docs/Web/API/Streams_API) is a web standard API that allows JavaScript to programmatically access and process streams of data.

* [ReadableStream](https://developers.cloudflare.com/workers/runtime-apis/streams/readablestream/)
* [ReadableStream BYOBReader](https://developers.cloudflare.com/workers/runtime-apis/streams/readablestreambyobreader/)
* [ReadableStream DefaultReader](https://developers.cloudflare.com/workers/runtime-apis/streams/readablestreamdefaultreader/)
* [TransformStream](https://developers.cloudflare.com/workers/runtime-apis/streams/transformstream/)
* [WritableStream](https://developers.cloudflare.com/workers/runtime-apis/streams/writablestream/)
* [WritableStream DefaultWriter](https://developers.cloudflare.com/workers/runtime-apis/streams/writablestreamdefaultwriter/)

Workers do not need to prepare an entire response body before returning a `Response`. You can use a [`ReadableStream`](https://developers.cloudflare.com/workers/runtime-apis/streams/readablestream/) to stream a response body after sending the front matter (that is, HTTP status line and headers). This allows you to minimize:

* The visitor's time-to-first-byte.
* The buffering done in the Worker.

Minimizing buffering is especially important for processing or transforming response bodies larger than the Worker's memory limit. For these cases, streaming is the only implementation strategy.

Note

By default, Cloudflare Workers is capable of streaming responses using the [Streams APIs](https://developer.mozilla.org/en-US/docs/Web/API/Streams_API). To maintain the streaming behavior, you should only modify the response body using the methods in the Streams APIs. If your Worker only forwards subrequest responses to the client verbatim without reading their body text, then its body handling is already optimal and you do not have to use these APIs.

The worker can create a `Response` object using a `ReadableStream` as the body. Any data provided through the `ReadableStream` will be streamed to the client as it becomes available.

* Module Worker

  ```js
  export default {
    async fetch(request, env, ctx) {
      // Fetch from origin server.
      const response = await fetch(request);


      // ... and deliver our Response while that’s running.
      return new Response(response.body, response);
    },
  };
  ```

* Service Worker

  Service Workers are deprecated

  Service Workers are deprecated, but still supported. We recommend using [Module Workers](https://developers.cloudflare.com/workers/reference/migrate-to-module-workers/) instead. New features may not be supported for Service Workers.

  ```js
  addEventListener("fetch", (event) => {
    event.respondWith(fetchAndStream(event.request));
  });


  async function fetchAndStream(request) {
    // Fetch from origin server.
    const response = await fetch(request);


    // ... and deliver our Response while that’s running.
    return new Response(readable.body, response);
  }
  ```

A [`TransformStream`](https://developers.cloudflare.com/workers/runtime-apis/streams/transformstream/) and the [`ReadableStream.pipeTo()`](https://developers.cloudflare.com/workers/runtime-apis/streams/readablestream/#methods) method can be used to modify the response body as it is being streamed:

* Module Worker

  ```js
  export default {
    async fetch(request, env, ctx) {
      // Fetch from origin server.
      const response = await fetch(request);


      const { readable, writable } = new TransformStream({
        transform(chunk, controller) {
          controller.enqueue(modifyChunkSomehow(chunk));
        },
      });


      // Start pumping the body. NOTE: No await!
      response.body.pipeTo(writable);


      // ... and deliver our Response while that’s running.
      return new Response(readable, response);
    },
  };
  ```

* Service Worker

  Service Workers are deprecated

  Service Workers are deprecated, but still supported. We recommend using [Module Workers](https://developers.cloudflare.com/workers/reference/migrate-to-module-workers/) instead. New features may not be supported for Service Workers.

  ```js
  addEventListener("fetch", (event) => {
    event.respondWith(fetchAndStream(event.request));
  });


  async function fetchAndStream(request) {
    // Fetch from origin server.
    const response = await fetch(request);


    const { readable, writable } = new TransformStream({
      transform(chunk, controller) {
        controller.enqueue(modifyChunkSomehow(chunk));
      },
    });


    // Start pumping the body. NOTE: No await!
    response.body.pipeTo(writable);


    // ... and deliver our Response while that’s running.
    return new Response(readable, response);
  }
  ```

This example calls `response.body.pipeTo(writable)` but does not `await` it. This is so it does not block the forward progress of the remainder of the `fetchAndStream()` function. It continues to run asynchronously until the response is complete or the client disconnects.

The runtime can continue running a function (`response.body.pipeTo(writable)`) after a response is returned to the client. This example pumps the subrequest response body to the final response body. However, you can use more complicated logic, such as adding a prefix or a suffix to the body or to process it somehow.

***

## Common issues

Warning

The Streams API is only available inside of the [Request context](https://developers.cloudflare.com/workers/runtime-apis/request/), inside the `fetch` event listener callback.

***

## Related resources

* [MDN's Streams API documentation](https://developer.mozilla.org/en-US/docs/Web/API/Streams_API)
* [Streams API spec](https://streams.spec.whatwg.org/)
* Write your Worker code in [ES modules syntax](https://developers.cloudflare.com/workers/reference/migrate-to-module-workers/) for an optimized experience.


