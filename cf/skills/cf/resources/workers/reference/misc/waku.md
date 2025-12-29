# Waku


In this guide, you will create a new [Waku](https://waku.gg/) application and deploy to Cloudflare Workers (with the new [Workers Assets](https://developers.cloudflare.com/workers/static-assets/)). Waku is a minimal React framework built for [React 19](https://react.dev/blog/2024/12/05/react-19) and [React Server Components](https://react.dev/reference/rsc/server-components). The use of Server Components is completely optional. It can be configured to run Server Components during build and output static HTML or it can be configured to run with dynamic React server rendering. It is built on top of [Hono](https://hono.dev/) and [Vite](https://vite.dev/).

## 1. Set up a new project

Use the [`create-cloudflare`](https://www.npmjs.com/package/create-cloudflare) CLI (C3) to set up a new project. C3 will create a new project directory, initiate Waku's official setup tool, and provide the option to deploy instantly.

To use `create-cloudflare` to create a new Waku project with Workers Assets, run the following command:

* npm

  ```sh
  npm create cloudflare@latest my-waku-app -- --framework=waku
  ```

* yarn

  ```sh
  yarn create cloudflare my-waku-app --framework=waku
  ```

* pnpm

  ```sh
  pnpm create cloudflare@latest my-waku-app --framework=waku
  ```

For setup, select the following options:

* For *What would you like to start with?*, choose `Framework Starter`.
* For *Which development framework do you want to use?*, choose `Waku`.
* Complete the framework's own CLI wizard.
* For *Do you want to use git for version control?*, choose `Yes`.
* For *Do you want to deploy your application?*, choose `No` (we will be making some changes before deploying).

After setting up your project, change your directory by running the following command:

```sh
cd my-waku-app
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

## 3. Deploy your project

Your project can be deployed to a `*.workers.dev` subdomain or a [Custom Domain](https://developers.cloudflare.com/workers/configuration/routing/custom-domains/), from your own machine or from any CI/CD system, including [Cloudflare's own](https://developers.cloudflare.com/workers/ci-cd/builds/).

The following command will build and deploy your project. If you are using CI, ensure you update your ["deploy command"](https://developers.cloudflare.com/workers/ci-cd/builds/configuration/#build-settings) configuration appropriately.

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

***

## Bindings

Your Waku application can be fully integrated with the Cloudflare Developer Platform, in both local development and in production, by using product bindings. The [Waku Cloudflare documentation](https://waku.gg/guides/cloudflare#accessing-cloudflare-bindings-execution-context-and-request-response-objects) provides information about configuring bindings and how you can access them in your React Server Components.

## Static assets

You can serve static assets in your Waku application by adding them to the `./public/` directory. Common examples include images, stylesheets, fonts, and web manifests.

During the build process, Waku copies `.js`, `.css`, `.html`, and `.txt` files from this directory into the final assets output. `.txt` files are used for storing data used by Server Components that are rendered at build time.

By default, Cloudflare first tries to match a request path against a static asset path, which is based on the file structure of the uploaded asset directory. This is either the directory specified by `assets.directory` in your Wrangler config or, in the case of the [Cloudflare Vite plugin](https://developers.cloudflare.com/workers/vite-plugin/), the output directory of the client build. Failing that, we invoke a Worker if one is present. If there is no Worker, or the Worker then uses the asset binding, Cloudflare will fallback to the behaviour set by [`not_found_handling`](https://developers.cloudflare.com/workers/static-assets/#routing-behavior).

Refer to the [routing documentation](https://developers.cloudflare.com/workers/static-assets/routing/) for more information about how routing works with static assets, and how to customize this behavior.


