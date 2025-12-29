# dns


Note

To enable built-in Node.js APIs and polyfills, add the nodejs\_compat compatibility flag to your [Wrangler configuration file](https://developers.cloudflare.com/workers/wrangler/configuration/). This also enables nodejs\_compat\_v2 as long as your compatibility date is 2024-09-23 or later. [Learn more about the Node.js compatibility flag and v2](https://developers.cloudflare.com/workers/configuration/compatibility-flags/#nodejs-compatibility-flag).

You can use [`node:dns`](https://nodejs.org/api/dns.html) for name resolution via [DNS over HTTPS](https://developers.cloudflare.com/1.1.1.1/encryption/dns-over-https/) using [Cloudflare DNS](https://www.cloudflare.com/application-services/products/dns/) at 1.1.1.1.

* JavaScript

  ```js
  import dns from "node:dns";


  let responese = await dns.promises.resolve4("cloudflare.com", "NS");
  ```

* TypeScript

  ```ts
  import dns from 'node:dns';


  let responese = await dns.promises.resolve4('cloudflare.com', 'NS');
  ```

All `node:dns` functions are available, except `lookup`, `lookupService`, and `resolve` which throw "Not implemented" errors when called.

Note

DNS requests will execute a subrequest, counts for your [Worker's subrequest limit](https://developers.cloudflare.com/workers/platform/limits/#subrequests).

The full `node:dns` API is documented in the [Node.js documentation for `node:dns`](https://nodejs.org/api/dns.html).

```plaintext
```


