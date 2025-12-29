# RedwoodSDK


In this guide, you will create a new [RedwoodSDK](https://rwsdk.com/) application and deploy it to Cloudflare Workers.

RedwoodSDK is a composable framework for building server-side web apps on Cloudflare. It starts as a Vite plugin that unlocks SSR, React Server Components, Server Functions, and realtime capabilities.

## Deploy a new RedwoodSDK application on Workers

1. **Create a new project.**

   Run the following command, replacing `<project-name>` with your desired project name:

   * npm

     ```sh
     npx degit redwoodjs/sdk/starters/standard#main <project-name>
     ```

   * yarn

     ```sh
     yarn dlx degit redwoodjs/sdk/starters/standard#main <project-name>
     ```

   * pnpm

     ```sh
     pnpx degit redwoodjs/sdk/starters/standard#main <project-name>
     ```

2. **Change the directory.**

   ```sh
   cd <project-name>
   ```

3. **Install dependencies.**

   * npm

     ```sh
     npm install
     ```

   * yarn

     ```sh
     yarn install
     ```

   * pnpm

     ```sh
     pnpm install
     ```

4. **Develop locally.**

   Run the following command in the project directory to start a local development server. RedwoodSDK is just a plugin for Vite, so you can use the same dev workflow as any other Vite project:

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

5. **Deploy your project.**

   You can deploy your project to a `*.workers.dev` subdomain or a [Custom Domain](https://developers.cloudflare.com/workers/configuration/routing/custom-domains/), either from your local machine or from any CI/CD system, including [Cloudflare Workers CI/CD](https://developers.cloudflare.com/workers/ci-cd/builds/).

   Use the following command to build and deploy. If you are using CI, make sure to update your [deploy command](https://developers.cloudflare.com/workers/ci-cd/builds/configuration/#build-settings) configuration accordingly.

   * npm

     ```sh
     npm run release
     ```

   * yarn

     ```sh
     yarn run release
     ```

   * pnpm

     ```sh
     pnpm run release
     ```


