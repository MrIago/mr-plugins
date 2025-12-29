# EventEmitter


Note

To enable built-in Node.js APIs and polyfills, add the nodejs\_compat compatibility flag to your [Wrangler configuration file](https://developers.cloudflare.com/workers/wrangler/configuration/). This also enables nodejs\_compat\_v2 as long as your compatibility date is 2024-09-23 or later. [Learn more about the Node.js compatibility flag and v2](https://developers.cloudflare.com/workers/configuration/compatibility-flags/#nodejs-compatibility-flag).

An [`EventEmitter`](https://nodejs.org/docs/latest/api/events.html#class-eventemitter) is an object that emits named events that cause listeners to be called.

```js
import { EventEmitter } from "node:events";


const emitter = new EventEmitter();
emitter.on("hello", (...args) => {
  console.log(...args); // 1 2 3
});


emitter.emit("hello", 1, 2, 3);
```

The implementation in the Workers runtime supports the entire Node.js `EventEmitter` API. This includes the [`captureRejections`](https://nodejs.org/docs/latest/api/events.html#capture-rejections-of-promises) option that allows improved handling of async functions as event handlers:

```js
const emitter = new EventEmitter({ captureRejections: true });
emitter.on("hello", async (...args) => {
  throw new Error("boom");
});
emitter.on("error", (err) => {
  // the async promise rejection is emitted here!
});
```

Like Node.js, when an `'error'` event is emitted on an `EventEmitter` and there is no listener for it, the error will be immediately thrown. However, in Node.js it is possible to add a handler on the `process` object for the `'uncaughtException'` event to catch globally uncaught exceptions. The `'uncaughtException'` event, however, is currently not implemented in the Workers runtime. It is strongly recommended to always add an `'error'` listener to any `EventEmitter` instance.

Refer to the [Node.js documentation for `EventEmitter`](https://nodejs.org/api/events.html#class-eventemitter) for more information.


