## Deploy a new Next.js project on Workers

1. **Create a new project with the create-cloudflare CLI (C3).**

   * npm

     ```sh
     npm create cloudflare@latest -- my-next-app --framework=next
     ```

   * yarn

     ```sh
     yarn create cloudflare my-next-app --framework=next
     ```

   * pnpm

     ```sh
     pnpm create cloudflare@latest my-next-app --framework=next
     ```

   What's happening behind the scenes?

   When you run this command, C3 creates a new project directory, initiates [Next.js's official setup tool](https://nextjs.org/docs/app/api-reference/cli/create-next-app), and configures the project for Cloudflare. It then offers the option to instantly deploy your application to Cloudflare.

2. **Develop locally.**

   After creating your project, run the following command in your project directory to start a local development server. The command uses the Next.js development server. It offers the best developer experience by quickly reloading your app every time the source code is updated.

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

3. **Test and preview your site with the Cloudflare adapter.**

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

   What's the difference between dev and preview?

   The command used in the previous step uses the Next.js development server, which runs in Node.js. However, your deployed application will run on Cloudflare Workers, which uses the `workerd` runtime. Therefore when running integration tests and previewing your application, you should use the preview command, which is more accurate to production, as it executes your application in the `workerd` runtime using `wrangler dev`.

4. **Deploy your project.**

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

