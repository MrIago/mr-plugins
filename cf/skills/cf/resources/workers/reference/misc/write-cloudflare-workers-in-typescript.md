# Write Cloudflare Workers in TypeScript


TypeScript is a first-class language on Cloudflare Workers. All APIs provided in Workers are fully typed, and type definitions are generated directly from [workerd](https://github.com/cloudflare/workerd), the open-source Workers runtime.

We recommend you generate types for your Worker by running [`wrangler types`](https://developers.cloudflare.com/workers/wrangler/commands/#types). Cloudflare also publishes type definitions to [GitHub](https://github.com/cloudflare/workers-types) and [npm](https://www.npmjs.com/package/@cloudflare/workers-types) (`npm install -D @cloudflare/workers-types`).

### Generate types that match your Worker's configuration

Cloudflare continuously improves [workerd](https://github.com/cloudflare/workerd), the open-source Workers runtime. Changes in workerd can introduce JavaScript API changes, thus changing the respective TypeScript types.

This means the correct types for your Worker depend on:

1. Your Worker's [compatibility date](https://developers.cloudflare.com/workers/configuration/compatibility-dates/).
2. Your Worker's [compatibility flags](https://developers.cloudflare.com/workers/configuration/compatibility-flags/).
3. Your Worker's bindings, which are defined in your [Wrangler configuration file](https://developers.cloudflare.com/workers/wrangler/configuration).
4. Any [module rules](https://developers.cloudflare.com/workers/wrangler/configuration/#bundling) you have specified in your Wrangler configuration file under `rules`.

For example, the runtime will only allow you to use the [`AsyncLocalStorage`](https://nodejs.org/api/async_context.html#class-asynclocalstorage) class if you have `compatibility_flags = ["nodejs_als"]` in your [Wrangler configuration file](https://developers.cloudflare.com/workers/wrangler/configuration/). This should be reflected in the type definitions.

To ensure that your type definitions always match your Worker's configuration, you can dynamically generate types by running:

* npm

  ```sh
  npx wrangler types
  ```

* yarn

  ```sh
  yarn wrangler types
  ```

* pnpm

  ```sh
  pnpm wrangler types
  ```

See [the `wrangler types` command docs](https://developers.cloudflare.com/workers/wrangler/commands/#types) for more details.

Note

If you are running a version of Wrangler that is greater than `3.66.0` but below `4.0.0`, you will need to include the `--experimental-include-runtime` flag. During its experimental release, runtime types were output to a separate file (`.wrangler/types/runtime.d.ts` by default). If you have an older version of Wrangler, you can access runtime types through the `@cloudflare/workers-types` package.

This will generate a `d.ts` file and (by default) save it to `worker-configuration.d.ts`. This will include `Env` types based on your Worker bindings *and* runtime types based on your Worker's compatibility date and flags.

You should then add that file to your `tsconfig.json`'s `compilerOptions.types` array. If you have the `nodejs_compat` compatibility flag, you should also install `@types/node`.

You can commit your types file to git if you wish.

Note

To ensure that your types are always up-to-date, make sure to run `wrangler types` after any changes to your config file.

### Migrating from `@cloudflare/workers-types` to `wrangler types`

We recommend you use `wrangler types` to generate runtime types, rather than using the `@cloudflare/workers-types` package, as it generates types based on your Worker's [compatibility date](https://github.com/cloudflare/workerd/tree/main/npm/workers-types#compatibility-dates) and `compatibility flags`, ensuring that types match the exact runtime APIs made available to your Worker.

Note

There are no plans to stop publishing the `@cloudflare/workers-types` package, which will still be the recommended way to type libraries and shared packages in the workers environment.

#### 1. Uninstall `@cloudflare/workers-types`

* npm

  ```sh
  npm uninstall @cloudflare/workers-types
  ```

* yarn

  ```sh
  yarn remove @cloudflare/workers-types
  ```

* pnpm

  ```sh
  pnpm remove @cloudflare/workers-types
  ```

#### 2. Generate runtime types using Wrangler

* npm

  ```sh
  npx wrangler types
  ```

* yarn

  ```sh
  yarn wrangler types
  ```

* pnpm

  ```sh
  pnpm wrangler types
  ```

This will generate a `.d.ts` file, saved to `worker-configuration.d.ts` by default. This will also generate `Env` types. If for some reason you do not want to include those, you can set `--include-env=false`.

You can now remove any imports from `@cloudflare/workers-types` in your Worker code.

Note

If you are running a version of Wrangler that is greater than `3.66.0` but below `4.0.0`, you will need to include the `--experimental-include-runtime` flag. During its experimental release, runtime types were output to a separate file (`.wrangler/types/runtime.d.ts` by default). If you have an older version of Wrangler, you can access runtime types through the `@cloudflare/workers-types` package.

#### 3. Make sure your `tsconfig.json` includes the generated types

```json
{
  "compilerOptions": {
    "types": ["./worker-configuration.d.ts"]
  }
}
```

Note that if you have specified a custom path for the runtime types file, you should use that in your `compilerOptions.types` array instead of the default path.

#### 4. Add @types/node if you are using [`nodejs_compat`](https://developers.cloudflare.com/workers/runtime-apis/nodejs/) (Optional)

If you are using the `nodejs_compat` compatibility flag, you should also install `@types/node`.

* npm

  ```sh
  npm i @types/node
  ```

* yarn

  ```sh
  yarn add @types/node
  ```

* pnpm

  ```sh
  pnpm add @types/node
  ```

Then add this to your `tsconfig.json`.

```json
{
  "compilerOptions": {
    "types": ["./worker-configuration.d.ts", "node"]
  }
}
```

#### 5. Update your scripts and CI pipelines

Regardless of your specific framework or build tools, you should run the `wrangler types` command before any tasks that rely on TypeScript.

Most projects will have existing build and development scripts, as well as some type-checking. In the example below, we're adding the `wrangler types` before the type-checking script in the project:

```json
{
  "scripts": {
    "dev": "existing-dev-command",
    "build": "existing-build-command",
    "generate-types": "wrangler types",
    "type-check": "generate-types && tsc"
  }
}
```

We recommend you commit your generated types file for use in CI. Alternatively, you can run `wrangler types` before other CI commands, as it should not take more than a few seconds. For example:

* npm

  ```yaml
  - run: npm run generate-types
  - run: npm run build
  - run: npm test
  ```

* yarn

  ```yaml
  - run: yarn generate-types
  - run: yarn build
  - run: yarn test
  ```

* pnpm

  ```yaml
  - run: pnpm run generate-types
  - run: pnpm run build
  - run: pnpm test
  ```

### Resources

* [TypeScript template](https://github.com/cloudflare/workers-sdk/tree/main/packages/create-cloudflare/templates/hello-world/ts)
* [@cloudflare/workers-types](https://github.com/cloudflare/workers-types)
* [Runtime APIs](https://developers.cloudflare.com/workers/runtime-apis/)
* [TypeScript Examples](https://developers.cloudflare.com/workers/examples/?languages=TypeScript)


