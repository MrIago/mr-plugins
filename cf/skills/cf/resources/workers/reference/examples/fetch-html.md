# Fetch HTML


If you want to get started quickly, click on the button below.

[![Deploy to Cloudflare](https://deploy.workers.cloudflare.com/button)](https://deploy.workers.cloudflare.com/?url=https://github.com/cloudflare/docs-examples/tree/main/workers/fetch-html)

This creates a repository in your GitHub account and deploys the application to Cloudflare Workers.

* JavaScript

  ```js
  export default {
    async fetch(request) {
      /**
       * Replace `remote` with the host you wish to send requests to
       */
      const remote = "https://example.com";


      return await fetch(remote, request);
    },
  };
  ```

  [Run Worker in Playground](https://workers.cloudflare.com/playground#LYVwNgLglgDghgJwgegGYHsHALQBM4RwDcABAEbogB2+CAngLzbPYZb6HbW5QDGU2AAwBOYQHYAHGIAs0gEwA2AKwBmAFwsWbYBzhcafASPFTZi1QFgAUAGF0VCAFMH2ACJQAzjHQeo0e2ok2ngExCRUcMCODABEUDSOAB4AdABWHjGkqFBgzpHRcQkp6THWdg7OENgAKnQwjoFwMDBgfARQ9sipcABucB68CLAQANTA6LjgjtbWSd5IJLiOqHDgECQA3lYkJP10VLxBjhC8ABYAFAiOAI4gjh4QAJSb2zskyABUH69vHyQASo4WnBeI4SAADK7jJzgkgAdz8pxIEFOYNOPnWdEo8M8SIg6BIHmcuBIV1u9wgHmR6B+Ow+yFpvHsD1JjmhYIYJBipwgEBgHjUyGQSUiLUcySZwEyVlpVwgIAQVF2cLgfiOJwuUPQTgANKzyQ9HkRXgBfHVWE1EayaZjaXT6Hj8ISiSQyeTKFRlexOFzuLw+PwdKiBYK6UgRKKxKKEXSZII5PKRmJkMDoMilWzeyo1OoNXbNVq8dqddL2GZWDYxYCqqgAfXGk1yMTUhSWxQyJutNrtoQdhmdJjd5hUzGsQA)

* TypeScript

  ```ts
  export default {
    async fetch(request: Request): Promise<Response> {
      /**
       * Replace `remote` with the host you wish to send requests to
       */
      const remote = "https://example.com";


      return await fetch(remote, request);
    },
  };
  ```

* Python

  ```py
  from workers import WorkerEntrypoint
  from js import fetch


  class Default(WorkerEntrypoint):
      async def fetch(self, request):
          # Replace `remote` with the host you wish to send requests to
          remote = "https://example.com"
          return await fetch(remote, request)
  ```

* Hono

  ```ts
  import { Hono } from "hono";


  const app = new Hono();


  app.all("*", async (c) => {
    /**
     * Replace `remote` with the host you wish to send requests to
     */
    const remote = "https://example.com";


    // Forward the request to the remote server
    return await fetch(remote, c.req.raw);
  });


  export default app;
  ```


