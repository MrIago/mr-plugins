# StringDecoder


Note

To enable built-in Node.js APIs and polyfills, add the nodejs\_compat compatibility flag to your [Wrangler configuration file](https://developers.cloudflare.com/workers/wrangler/configuration/). This also enables nodejs\_compat\_v2 as long as your compatibility date is 2024-09-23 or later. [Learn more about the Node.js compatibility flag and v2](https://developers.cloudflare.com/workers/configuration/compatibility-flags/#nodejs-compatibility-flag).

The [`node:string_decoder`](https://nodejs.org/api/string_decoder.html) is a legacy utility module that predates the WHATWG standard [TextEncoder](https://developers.cloudflare.com/workers/runtime-apis/encoding/#textencoder) and [TextDecoder](https://developers.cloudflare.com/workers/runtime-apis/encoding/#textdecoder) API. In most cases, you should use `TextEncoder` and `TextDecoder` instead. `StringDecoder` is available in the Workers runtime primarily for compatibility with existing npm packages that rely on it. `StringDecoder` can be accessed using:

```js
const { StringDecoder } = require("node:string_decoder");
const decoder = new StringDecoder("utf8");


const cent = Buffer.from([0xc2, 0xa2]);
console.log(decoder.write(cent));


const euro = Buffer.from([0xe2, 0x82, 0xac]);
console.log(decoder.write(euro));
```

Refer to the [Node.js documentation for `string_decoder`](https://nodejs.org/dist/latest-v20.x/docs/api/string_decoder.html) for more information.


