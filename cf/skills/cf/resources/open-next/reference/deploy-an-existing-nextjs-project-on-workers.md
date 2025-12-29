## Deploy an existing Next.js project on Workers

You can convert an existing Next.js application to run on Cloudflare

1. **Install [`@opennextjs/cloudflare`](https://www.npmjs.com/package/@opennextjs/cloudflare)**

   * npm

     ```sh
     npm i @opennextjs/cloudflare@latest
     ```

   * yarn

     ```sh
     yarn add @opennextjs/cloudflare@latest
     ```

   * pnpm

     ```sh
     pnpm add @opennextjs/cloudflare@latest
     ```

2. **Install [`wrangler CLI`](https://developers.cloudflare.com/workers/wrangler) as a devDependency**

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

3. **Add a Wrangler configuration file**

   In your project root, create a [Wrangler configuration file](https://developers.cloudflare.com/workers/wrangler/configuration/) with the following content:

   * wrangler.jsonc

     ```jsonc
     {
       "$schema": "./node_modules/wrangler/config-schema.json",
       "main": ".open-next/worker.js",
       "name": "my-app",
       "compatibility_date": "2025-12-15",
       "compatibility_flags": [
         "nodejs_compat"
       ],
       "assets": {
         "directory": ".open-next/assets",
         "binding": "ASSETS"
       }
     }
     ```

   * wrangler.toml

     ```toml
       main = ".open-next/worker.js"
       name = "my-app"
       compatibility_date = "2025-12-15"
       compatibility_flags = ["nodejs_compat"]
       [assets]
       directory = ".open-next/assets"
       binding = "ASSETS"
     ```

   Note

   As shown above, you must enable the [`nodejs_compat` compatibility flag](https://developers.cloudflare.com/workers/runtime-apis/nodejs/) *and* set your [compatibility date](https://developers.cloudflare.com/workers/configuration/compatibility-dates/) to `2024-09-23` or later for your Next.js app to work with @opennextjs/cloudflare.

4. **Add a configuration file for OpenNext**

   In your project root, create an OpenNext configuration file named `open-next.config.ts` with the following content:

   ```ts
   import { defineCloudflareConfig } from "@opennextjs/cloudflare";


   export default defineCloudflareConfig();
   ```

   Note

   `open-next.config.ts` is where you can configure the caching, see the [adapter documentation](https://opennext.js.org/cloudflare/caching) for more information

5. **Update `package.json`**

   You can add the following scripts to your `package.json`:

   ```json
   "preview": "opennextjs-cloudflare build && opennextjs-cloudflare preview",
   "deploy": "opennextjs-cloudflare build && opennextjs-cloudflare deploy",
   "cf-typegen": "wrangler types --env-interface CloudflareEnv cloudflare-env.d.ts"
   ```

   Usage

   * `preview`: Builds your app and serves it locally, allowing you to quickly preview your app running locally in the Workers runtime, via a single command.
   * `deploy`: Builds your app, and then deploys it to Cloudflare
   * `cf-typegen`: Generates a `cloudflare-env.d.ts` file at the root of your project containing the types for the env.

6. **Develop locally.**

   After creating your project, run the following command in your project directory to start a local development server. The command uses the Next.js development server. It offers the best developer experience by quickly reloading your app after your source code is updated.

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

7. **Test your site with the Cloudflare adapter.**

   The command used in the previous step uses the Next.js development server to offer a great developer experience. However your application will run on Cloudflare Workers so you want to run your integration tests and verify that your application works correctly in this environment.

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

8. **Deploy your project.**

   You can deploy your project to a [`*.workers.dev` subdomain](https://developers.cloudflare.com/workers/configuration/routing/workers-dev/) or a [custom domain](https://developers.cloudflare.com/workers/configuration/routing/custom-domains/) from your local machine or any CI/CD system (including [Workers Builds](https://developers.cloudflare.com/workers/ci-cd/#workers-builds)). Use the following command to build and deploy. If you're using a CI service, be sure to update your "deploy command" accordingly.

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

   [**Workers Builds**](https://developers.cloudflare.com/workers/ci-cd/builds/) requires you to configure environment variables in the ["Build Variables and secrets"](https://developers.cloudflare.com/workers/ci-cd/builds/configuration/#:~:text=Build%20variables%20and%20secrets) section.

   This ensures the Next build has the necessary access to both public `NEXT_PUBLC...` variables and [non-`NEXT_PUBLIC_...`](https://nextjs.org/docs/pages/guides/environment-variables#bundling-environment-variables-for-the-browser), which are essential for tasks like inlining and building SSG pages.

   Learn more in the [OpenNext environment variable guide](https://opennext.js.org/cloudflare/howtos/env-vars#workers-builds)

---

import { Callout } from "nextra/components";
import WindowsSupport from "../../shared/WindowsSupport.mdx";

