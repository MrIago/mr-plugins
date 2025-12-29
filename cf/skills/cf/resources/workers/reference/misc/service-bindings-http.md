# Service bindings - HTTP


Worker A that declares a Service binding to Worker B can forward a [`Request`](https://developers.cloudflare.com/workers/runtime-apis/request/) object to Worker B, by calling the `fetch()` method that is exposed on the binding object.

For example, consider the following Worker that implements a [`fetch()` handler](https://developers.cloudflare.com/workers/runtime-apis/handlers/fetch/):

* wrangler.jsonc

  ```jsonc
  {
    "$schema": "./node_modules/wrangler/config-schema.json",
    "name": "worker_b",
    "main": "./src/workerB.js"
  }
  ```

* wrangler.toml

  ```toml
  name = "worker_b"
  main = "./src/workerB.js"
  ```

```js
export default {
  async fetch(request, env, ctx) {
    return new Response("Hello World!");
  }
}
```

The following Worker declares a binding to the Worker above:

* wrangler.jsonc

  ```jsonc
  {
    "$schema": "./node_modules/wrangler/config-schema.json",
    "name": "worker_a",
    "main": "./src/workerA.js",
    "services": [
      {
        "binding": "WORKER_B",
        "service": "worker_b"
      }
    ]
  }
  ```

* wrangler.toml

  ```toml
  name = "worker_a"
  main = "./src/workerA.js"
  services = [
    { binding = "WORKER_B", service = "worker_b" }
  ]
  ```

And then can forward a request to it:

```js
export default {
  async fetch(request, env) {
    return await env.WORKER_B.fetch(request);
  },
};
```

Note

If you construct a new request manually, rather than forwarding an existing one, ensure that you provide a valid and fully-qualified URL with a hostname. For example:

```js
export default {
  async fetch(request, env) {
    // provide a valid URL
    let newRequest = new Request("https://valid-url.com", { method: "GET" });
    let response = await env.WORKER_B.fetch(newRequest);
    return response;
  }
};
```


