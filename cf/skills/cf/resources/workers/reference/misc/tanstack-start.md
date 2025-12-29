# TanStack Start


[TanStack Start](https://tanstack.com/start) is a full-stack framework for building web applications. It comes with features like server-side rendering, streaming, server functions, bundling, and more. In this guide, you learn to deploy a TanStack Start application to Cloudflare Workers.

## 1. Set up a TanStack Start project

If you have an existing TanStack Start application, skip to the [Configuring an existing TanStack Start application](#configuring-an-existing-tanstack-start-application) section.

### Creating a new TanStack Start application

Use the [`create-cloudflare`](https://www.npmjs.com/package/create-cloudflare) CLI (C3) to set up a new project. C3 will create a new project directory, initiate TanStack Start's official setup tool, and provide the option to deploy instantly.

To use `create-cloudflare` to create a new TanStack Start project with Workers Assets, run the following command:

* npm

  ```sh
  npm create cloudflare@latest -- my-tanstack-start-app --framework=tanstack-start
  ```

* yarn

  ```sh
  yarn create cloudflare my-tanstack-start-app --framework=tanstack-start
  ```

* pnpm

  ```sh
  pnpm create cloudflare@latest my-tanstack-start-app --framework=tanstack-start
  ```

After setting up your project, change your directory by running the following command:

```sh
cd my-tanstack-start-app
```

### Configuring an existing TanStack Start application

If you have an existing TanStack Start application, you can configure it to run on Cloudflare Workers by following these steps:

1. Add the `wrangler.jsonc` configuration file to the root of your project with the following content:

   * wrangler.jsonc

     ```jsonc
     {
       "$schema": "./node_modules/wrangler/config-schema.json",
       "name": "<YOUR_PROJECT_NAME>",
       "compatibility_date": "2025-12-13",
       "compatibility_flags": [
         "nodejs_compat"
       ],
       "main": "@tanstack/react-start/server-entry",
       "observability": {
         "enabled": true
       }
     }
     ```

   * wrangler.toml

     ```toml
       name = "<YOUR_PROJECT_NAME>"
       compatibility_date = "2025-12-13"
       compatibility_flags = ["nodejs_compat"]
       main = "@tanstack/react-start/server-entry"
       [observability]
       enabled = true
     ```

2. Install `wrangler` as a development dependency:

   * npm

     ```sh
     npm i -D wrangler@latest
     ```

   * yarn

     ```sh
     yarn add -D wrangler@latest
     ```

   * pnpm

     ```sh
     pnpm add -D wrangler@latest
     ```

3. Install the `@cloudflare/vite-plugin` package as a dependency:

   * npm

     ```sh
     npm i @cloudflare/vite-plugin@latest
     ```

   * yarn

     ```sh
     yarn add @cloudflare/vite-plugin@latest
     ```

   * pnpm

     ```sh
     pnpm add @cloudflare/vite-plugin@latest
     ```

4. Update your `vite.config.ts` file to include the Cloudflare Vite plugin:

   ```ts
   import { defineConfig } from "vite";
   import { cloudflare } from "@cloudflare/vite-plugin";
   ...


   export default defineConfig({
     plugins: [cloudflare({ viteEnvironment: { name: 'ssr' } }), ...],
     // ... other configurations
   });
   ```

5. Update the `scripts` section of your `package.json` file to include the following commands:

   ```jsonc
   "scripts": {
     ...
     "deploy": "npm run build && wrangler deploy",
     "preview": "npm run build && vite preview",
     "cf-typegen": "wrangler types"
   }
   ```

## 2. Develop locally

After you have created your project, run the following command in the project directory to start a local development server. This will allow you to preview your project locally during development.

* npm

  ```sh
  npm run dev
  ```

* yarn

  ```sh
  yarn run dev
  ```

* pnpm

  ```sh
  pnpm run dev
  ```

## 3. Deploy your Project

You can deploy your project to a `*.workers.dev` subdomain or a [Custom Domain](https://developers.cloudflare.com/workers/configuration/routing/custom-domains/) from your own machine or from any CI/CD system, including Cloudflare's own [Workers Builds](https://developers.cloudflare.com/workers/ci-cd/builds/).

The following command will build and deploy your project. If you are using CI, ensure you update your [**Deploy command**](https://developers.cloudflare.com/workers/ci-cd/builds/configuration/#build-settings) configuration appropriately.

* npm

  ```sh
  npm run deploy
  ```

* yarn

  ```sh
  yarn run deploy
  ```

* pnpm

  ```sh
  pnpm run deploy
  ```

Note

Before deploying your application, you can also run the `preview` script to preview the built output locally before deploying it. This can help you making sure that your application will work as intended once it's been deployed to the Cloudflare network:

* npm

  ```sh
  npm run preview
  ```

* yarn

  ```sh
  yarn run preview
  ```

* pnpm

  ```sh
  pnpm run preview
  ```

***

## Bindings

Your TanStack Start application can be fully integrated with the Cloudflare Developer Platform, in both local development and in production, by using bindings.

You can use bindings simply by [importing the `env` object](https://developers.cloudflare.com/workers/runtime-apis/bindings/#importing-env-as-a-global) and accessing it in your server side code.

For example in the following way:

```tsx
import { createFileRoute } from "@tanstack/react-router";
import { createServerFn } from "@tanstack/react-start";
import { env } from "cloudflare:workers";


export const Route = createFileRoute("/")({
  loader: () => getData(),
  component: RouteComponent,
});


const getData = createServerFn().handler(() => {
  // Use env here
});


function RouteComponent() {
  // ...
}
```

Note

Running the `cf-typegen` script:

* npm

  ```sh
  npm run cf-typegen
  ```

* yarn

  ```sh
  yarn run cf-typegen
  ```

* pnpm

  ```sh
  pnpm run cf-typegen
  ```

Will populate the `env` object with the various bindings based on your configuration.

With bindings, your application can be fully integrated with the Cloudflare Developer Platform, giving you access to compute, storage, AI and more.

[Bindings ](https://developers.cloudflare.com/workers/runtime-apis/bindings/)Access to compute, storage, AI and more.


