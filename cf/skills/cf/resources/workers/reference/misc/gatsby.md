# Gatsby


In this guide, you will create a new [Gatsby](https://www.gatsbyjs.com/) application and deploy to Cloudflare Workers (with the new [Workers Assets](https://developers.cloudflare.com/workers/static-assets/)).

## 1. Set up a new project

Use the [`create-cloudflare`](https://www.npmjs.com/package/create-cloudflare) CLI (C3) to set up a new project. C3 will create a new project directory, initiate Gatsby's official setup tool, and provide the option to deploy instantly.

To use `create-cloudflare` to create a new Gatsby project with Workers Assets, run the following command:

* npm

  ```sh
  npm create cloudflare@latest -- my-gatsby-app --framework=gatsby
  ```

* yarn

  ```sh
  yarn create cloudflare my-gatsby-app --framework=gatsby
  ```

* pnpm

  ```sh
  pnpm create cloudflare@latest my-gatsby-app --framework=gatsby
  ```

After setting up your project, change your directory by running the following command:

```sh
cd my-gatsby-app
```

## 2. Develop locally

After you have created your project, run the following command in the project directory to start a local server. This will allow you to preview your project locally during development.

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

Your project can be deployed to a `*.workers.dev` subdomain or a [Custom Domain](https://developers.cloudflare.com/workers/configuration/routing/custom-domains/), from your own machine or from any CI/CD system, including [Cloudflare's own](https://developers.cloudflare.com/workers/ci-cd/builds/).

The following command will build and deploy your project. If you're using CI, ensure you update your ["deploy command"](https://developers.cloudflare.com/workers/ci-cd/builds/configuration/#build-settings) configuration appropriately.

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


