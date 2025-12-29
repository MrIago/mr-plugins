# Serving a subdirectory


Note

This feature requires Wrangler v3.98.0 or later.

Like with any other Worker, [you can configure a Worker with assets to run on a path of your domain](https://developers.cloudflare.com/workers/configuration/routing/routes/). Assets defined for a Worker must be nested in a directory structure that mirrors the desired path.

For example, to serve assets from `example.com/blog/*`, create a `blog` directory in your asset directory.

With a [Wrangler configuration file](https://developers.cloudflare.com/workers/wrangler/configuration/) like so:

* wrangler.jsonc

  ```jsonc
  {
    "$schema": "./node_modules/wrangler/config-schema.json",
    "name": "assets-on-a-path-example",
    "main": "src/index.js",
    "route": "example.com/blog/*",
    "assets": {
      "directory": "dist"
    }
  }
  ```

* wrangler.toml

  ```toml
  name = "assets-on-a-path-example"
  main = "src/index.js"
  route = "example.com/blog/*"


  [assets]
  directory = "dist"
  ```

In this example, requests to `example.com/blog/` will serve the `index.html` file, and requests to `example.com/blog/posts/post1` will serve the `post1.html` file.

If you have a file outside the configured path, it will not be served, unless it is part of the `assets.not_found_handling` for [Single Page Applications](https://developers.cloudflare.com/workers/static-assets/routing/single-page-application/) or [custom 404 pages](https://developers.cloudflare.com/workers/static-assets/routing/static-site-generation/). For example, if you have a `home.html` file in the root of your asset directory, it will not be served when requesting `example.com/blog/home`. However, if needed, these files can still be manually fetched over [the binding](https://developers.cloudflare.com/workers/static-assets/binding/#binding).


