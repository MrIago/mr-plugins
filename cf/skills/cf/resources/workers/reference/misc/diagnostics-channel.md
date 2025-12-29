# Diagnostics Channel


Note

To enable built-in Node.js APIs and polyfills, add the nodejs\_compat compatibility flag to your [Wrangler configuration file](https://developers.cloudflare.com/workers/wrangler/configuration/). This also enables nodejs\_compat\_v2 as long as your compatibility date is 2024-09-23 or later. [Learn more about the Node.js compatibility flag and v2](https://developers.cloudflare.com/workers/configuration/compatibility-flags/#nodejs-compatibility-flag).

The [`diagnostics_channel`](https://nodejs.org/dist/latest-v20.x/docs/api/diagnostics_channel.html) module provides an API to create named channels to report arbitrary message data for diagnostics purposes. The API is essentially a simple event pub/sub model that is specifically designed to support low-overhead diagnostics reporting.

```js
import {
  channel,
  hasSubscribers,
  subscribe,
  unsubscribe,
  tracingChannel,
} from "node:diagnostics_channel";


// For publishing messages to a channel, acquire a channel object:
const myChannel = channel("my-channel");


// Any JS value can be published to a channel.
myChannel.publish({ foo: "bar" });


// For receiving messages on a channel, use subscribe:


subscribe("my-channel", (message) => {
  console.log(message);
});
```

All `Channel` instances are singletons per each Isolate/context (for example, the same entry point). Subscribers are always invoked synchronously and in the order they were registered, much like an `EventTarget` or Node.js `EventEmitter` class.

## Integration with Tail Workers

When using [Tail Workers](https://developers.cloudflare.com/workers/observability/logs/tail-workers/), all messages published to any channel will be forwarded also to the [Tail Worker](https://developers.cloudflare.com/workers/observability/logs/tail-workers/). Within the Tail Worker, the diagnostic channel messages can be accessed via the `diagnosticsChannelEvents` property:

```js
export default {
  async tail(events) {
    for (const event of events) {
      for (const messageData of event.diagnosticsChannelEvents) {
        console.log(
          messageData.timestamp,
          messageData.channel,
          messageData.message,
        );
      }
    }
  },
};
```

Note that message published to the tail worker is passed through the [structured clone algorithm](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Structured_clone_algorithm) (same mechanism as the [`structuredClone()`](https://developer.mozilla.org/en-US/docs/Web/API/structuredClone) API) so only values that can be successfully cloned are supported.

## `TracingChannel`

Per the Node.js documentation, "[`TracingChannel`](https://nodejs.org/api/diagnostics_channel.html#class-tracingchannel) is a collection of \[Channels] which together express a single traceable action. `TracingChannel` is used to formalize and simplify the process of producing events for tracing application flow."

```js
import { tracingChannel } from "node:diagnostics_channel";
import { AsyncLocalStorage } from "node:async_hooks";


const channels = tracingChannel("my-channel");
const requestId = new AsyncLocalStorage();
channels.start.bindStore(requestId);


channels.subscribe({
  start(message) {
    console.log(requestId.getStore()); // { requestId: '123' }
    // Handle start message
  },
  end(message) {
    console.log(requestId.getStore()); // { requestId: '123' }
    // Handle end message
  },
  asyncStart(message) {
    console.log(requestId.getStore()); // { requestId: '123' }
    // Handle asyncStart message
  },
  asyncEnd(message) {
    console.log(requestId.getStore()); // { requestId: '123' }
    // Handle asyncEnd message
  },
  error(message) {
    console.log(requestId.getStore()); // { requestId: '123' }
    // Handle error message
  },
});


// The subscriber handlers will be invoked while tracing the execution of the async
// function passed into `channel.tracePromise`...
channel.tracePromise(
  async () => {
    // Perform some asynchronous work...
  },
  { requestId: "123" },
);
```

Refer to the [Node.js documentation for `diagnostics_channel`](https://nodejs.org/dist/latest-v20.x/docs/api/diagnostics_channel.html) for more information.


