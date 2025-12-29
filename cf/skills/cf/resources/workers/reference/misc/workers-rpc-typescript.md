# Workers RPC — TypeScript


Running [`wrangler types`](https://developers.cloudflare.com/workers/languages/typescript/#generate-types) generates runtime types including the `Service` and `DurableObjectNamespace` types, each of which accepts a single type parameter for the [`WorkerEntrypoint`](https://developers.cloudflare.com/workers/runtime-apis/bindings/service-bindings/rpc) or [`DurableObject`](https://developers.cloudflare.com/durable-objects/best-practices/create-durable-object-stubs-and-send-requests/#call-rpc-methods) types.

Using higher-order types, we automatically generate client-side stub types (e.g., forcing all methods to be async).

[`wrangler types`](https://developers.cloudflare.com/workers/languages/typescript/#generate-types) also generates types for the `env` object. You can pass in the path to the config files of the Worker or Durable Object being called so that the generated types include the type parameters for the `Service` and `DurableObjectNamespace` types.

For example, if your client Worker had bindings to a Worker in `../sum-worker/` and a Durable Object in `../counter/`, you should generate types for the client Worker's `env` by running:

* npm

  ```sh
  npx wrangler types -c ./client/wrangler.jsonc -c ../sum-worker/wrangler.jsonc -c ../counter/wrangler.jsonc
  ```

* yarn

  ```sh
  yarn wrangler types -c ./client/wrangler.jsonc -c ../sum-worker/wrangler.jsonc -c ../counter/wrangler.jsonc
  ```

* pnpm

  ```sh
  pnpm wrangler types -c ./client/wrangler.jsonc -c ../sum-worker/wrangler.jsonc -c ../counter/wrangler.jsonc
  ```

This will produce a `worker-configuration.d.ts` file that includes:

```ts
interface Env {
  SUM_SERVICE: Service<import("../sum-worker/src/index").SumService>;
  COUNTER_OBJECT: DurableObjectNamespace<
    import("../counter/src/index").Counter
  >;
}
```

Now types for RPC method like the `env.SUM_SERVICE.sum` method will be exposed to the client Worker.

```ts
export default {
  async fetch(req, env, ctx): Promise<Response> {
    const result = await env.SUM_SERVICE.sum(1, 2);
    return new Response(result.toString());
  },
} satisfies ExportedHandler<Env>;
```


