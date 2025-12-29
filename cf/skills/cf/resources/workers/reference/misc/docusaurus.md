# Docusaurus


**Start from CLI**: Scaffold a Docusaurus project on Workers, and pick your template.

* npm

  ```sh
  npm create cloudflare@latest -- my-docusaurus-app --framework=docusaurus
  ```

* yarn

  ```sh
  yarn create cloudflare my-docusaurus-app --framework=docusaurus
  ```

* pnpm

  ```sh
  pnpm create cloudflare@latest my-docusaurus-app --framework=docusaurus
  ```

**Or just deploy**: Create a documentation site with Docusaurus and deploy it on Cloudflare Workers, with CI/CD and previews all set up for you.

[![Deploy to Workers](https://deploy.workers.cloudflare.com/button)](https://dash.cloudflare.com/?to=/:account/workers-and-pages/create/deploy-to-workers\&repository=https://github.com/cloudflare/templates/tree/staging/astro-blog-starter-template)

## What is Docusaurus?

[Docusaurus](https://docusaurus.io/) is an open-source framework for building, deploying, and maintaining documentation websites. It is built on React and provides an intuitive way to create static websites with a focus on documentation.

Docusaurus is designed to be easy to use and customizable, making it a popular choice for developers and organizations looking to create documentation sites quickly.

## Deploy a new Docusaurus project on Workers

1. **Create a new project with the create-cloudflare CLI (C3).**

   * npm

     ```sh
     npm create cloudflare@latest -- my-docusaurus-app -- --framework=docusaurus --platform=workers
     ```

   * yarn

     ```sh
     yarn create cloudflare my-docusaurus-app -- --framework=docusaurus --platform=workers
     ```

   * pnpm

     ```sh
     pnpm create cloudflare@latest my-docusaurus-app -- --framework=docusaurus --platform=workers
     ```

   What's happening behind the scenes?

   When you run this command, C3 creates a new project directory, initiates [Docusaurus' official setup tool](https://docusaurus.io/docs/installation), and configures the project for Cloudflare. It then offers the option to instantly deploy your application to Cloudflare.

2. **Develop locally.**

   After creating your project, run the following command in your project directory to start a local development server.

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

3. **Deploy your project.**

   Your project can be deployed to a [\*.workers.dev subdomain](https://developers.cloudflare.com/workers/configuration/routing/workers-dev/) or a [Custom Domain](https://developers.cloudflare.com/workers/configuration/routing/custom-domains/), from your local machine or any CI/CD system, (including [Workers Builds](https://developers.cloudflare.com/workers/ci-cd/#workers-builds/)).

   Use the following command to build and deploy your project. If you're using a CI service, be sure to update your "deploy command" accordingly.

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

## Deploy an existing Docusaurus project on Workers

### If you have a static site

If your Docusaurus project is entirely pre-rendered (which it usually is), follow these steps:

1. **Add a Wrangler configuration file.**

   In your project root, create a Wrangler configuration file with the following content:

   * wrangler.jsonc

     ```jsonc
       {
         "name": "my-docusaurus-app",
         // Update to today's date
         "compatibility_date": "2025-12-13",
         "assets": {
           "directory": "./build"
         }
       }
     ```

   * wrangler.toml

     ```toml
     name = "my-docusaurus-app"
     compatibility_date = "2025-12-13"


     [assets]
     directory = "./build"
     ```

   What's this configuration doing?

   The key part of this config is the `assets` field, which tells Wrangler where to find your static assets. In this case, we're telling Wrangler to look in the `./build` directory. If your assets are in a different directory, update the `directory` value accordingly. Refer to other [asset configuration options](https://developers.cloudflare.com/workers/static-assets/routing/).

   Also note how there's no `main` field in this config - this is because you're only serving static assets, so no Worker code is needed for on demand rendering/SSR.

2. **Build and deploy your project.**

   You can deploy your project to a [`*.workers.dev` subdomain](https://developers.cloudflare.com/workers/configuration/routing/workers-dev/) or a [custom domain](https://developers.cloudflare.com/workers/configuration/routing/custom-domains/) from your local machine or any CI/CD system (including [Workers Builds](https://developers.cloudflare.com/workers/ci-cd/#workers-builds)). Use the following command to build and deploy. If you're using a CI service, be sure to update your "deploy command" accordingly.

   * npm

     ```sh
     npx docusaurus build
     ```

   * yarn

     ```sh
     yarn docusaurus build
     ```

   * pnpm

     ```sh
     pnpm docusaurus build
     ```

   - npm

     ```sh
     npx wrangler@latest deploy
     ```

   - yarn

     ```sh
     yarn wrangler@latest deploy
     ```

   - pnpm

     ```sh
     pnpm wrangler@latest deploy
     ```

## Use bindings with Docusaurus

Bindings are a way to connect your Docusaurus project to other Cloudflare services, enabling you to store and retrieve data within your application.

With bindings, your application can be fully integrated with the Cloudflare Developer Platform, giving you access to compute, storage, AI and more.

[Bindings ](https://developers.cloudflare.com/workers/runtime-apis/bindings/)Access to compute, storage, AI and more.


