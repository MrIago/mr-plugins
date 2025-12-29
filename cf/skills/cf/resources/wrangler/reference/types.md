# `types`

Generate types based on your Worker configuration, including `Env` types based on your bindings, module rules, and [runtime types](https://developers.cloudflare.com/workers/languages/typescript/) based on the`compatibility_date` and `compatibility_flags` in your [config file](https://developers.cloudflare.com/workers/wrangler/configuration/).

```txt
wrangler types [<PATH>] [OPTIONS]
```

Note

If you are running a version of Wrangler that is greater than `3.66.0` but below `4.0.0`, you will need to include the `--experimental-include-runtime` flag. During its experimental release, runtime types were output to a separate file (`.wrangler/types/runtime.d.ts` by default). If you have an older version of Wrangler, you can access runtime types through the `@cloudflare/workers-types` package.

* `PATH` string (default: \`./worker-configuration.d.ts\`)

  * The path to where types for your Worker will be written.
  * The path must have a `d.ts` extension.

* `--env-interface` string (default: \`Env\`)

  * The name of the interface to generate for the environment object.
  * Not valid if the Worker uses the Service Worker syntax.

* `--include-runtime` boolean (default: true)
  * Whether to generate runtime types based on the`compatibility_date` and `compatibility_flags` in your [config file](https://developers.cloudflare.com/workers/wrangler/configuration/).

* `--include-env` boolean (default: true)
  * Whether to generate `Env` types based on your Worker bindings.

* `--strict-vars` boolean optional (default: true)

  * Control the types that Wrangler generates for `vars` bindings.
  * If `true`, (the default) Wrangler generates literal and union types for bindings (e.g. `myVar: 'my dev variable' | 'my prod variable'`).
  * If `false`, Wrangler generates generic types (e.g. `myVar: string`). This is useful when variables change frequently, especially when working across multiple environments.

* `--config`, `-c` string\[] optional

  * Path(s) to [Wrangler configuration file](https://developers.cloudflare.com/workers/wrangler/configuration/). If the Worker you are generating types for has service bindings or bindings to Durable Objects, you can also provide the paths to those configuration files so that the generated `Env` type will include RPC types. For example, given a Worker with a service binding, `wrangler types -c wrangler.toml -c ../bound-worker/wrangler.toml` will generate an `Env` type like this:

  ```ts
  interface Env {
    SERVICE_BINDING: Service<import("../bound-worker/src/index").Entrypoint>;
  }
  ```

***


