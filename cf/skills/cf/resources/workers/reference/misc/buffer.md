# Buffer


Note

To enable built-in Node.js APIs and polyfills, add the nodejs\_compat compatibility flag to your [Wrangler configuration file](https://developers.cloudflare.com/workers/wrangler/configuration/). This also enables nodejs\_compat\_v2 as long as your compatibility date is 2024-09-23 or later. [Learn more about the Node.js compatibility flag and v2](https://developers.cloudflare.com/workers/configuration/compatibility-flags/#nodejs-compatibility-flag).

The [`Buffer`](https://nodejs.org/docs/latest/api/buffer.html) API in Node.js is one of the most commonly used Node.js APIs for manipulating binary data. Every `Buffer` instance extends from the standard [`Uint8Array`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Uint8Array) class, but adds a range of unique capabilities such as built-in base64 and hex encoding/decoding, byte-order manipulation, and encoding-aware substring searching.

```js
import { Buffer } from "node:buffer";


const buf = Buffer.from("hello world", "utf8");


console.log(buf.toString("hex"));
// Prints: 68656c6c6f20776f726c64
console.log(buf.toString("base64"));
// Prints: aGVsbG8gd29ybGQ=
```

A Buffer extends from `Uint8Array`. Therefore, it can be used in any Workers API that currently accepts `Uint8Array`, such as creating a new Response:

```js
const response = new Response(Buffer.from("hello world"));
```

You can also use the `Buffer` API when interacting with streams:

```js
const writable = getWritableStreamSomehow();
const writer = writable.getWriter();
writer.write(Buffer.from("hello world"));
```

One key difference between the Workers implementation of `Buffer` and the Node.js implementation is that some methods of creating a `Buffer` in Node.js will allocate those from a global memory pool as a performance optimization. The Workers implementation does not use a memory pool and all `Buffer` instances are allocated independently.

Further, in Node.js it is possible to allocate a `Buffer` with uninitialized memory using the `Buffer.allocUnsafe()` method. This is not supported in Workers and `Buffer` instances are always initialized so that the `Buffer` is always filled with null bytes (`0x00`) when allocated.

Refer to the [Node.js documentation for `Buffer`](https://nodejs.org/dist/latest-v19.x/docs/api/buffer.html) for more information.


