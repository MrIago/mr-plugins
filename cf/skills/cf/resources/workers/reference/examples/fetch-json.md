# Fetch JSON


If you want to get started quickly, click on the button below.

[![Deploy to Cloudflare](https://deploy.workers.cloudflare.com/button)](https://deploy.workers.cloudflare.com/?url=https://github.com/cloudflare/docs-examples/tree/main/workers/fetch-json)

This creates a repository in your GitHub account and deploys the application to Cloudflare Workers.

* JavaScript

  ```js
  export default {
    async fetch(request, env, ctx) {
      const url = "https://jsonplaceholder.typicode.com/todos/1";


      // gatherResponse returns both content-type & response body as a string
      async function gatherResponse(response) {
        const { headers } = response;
        const contentType = headers.get("content-type") || "";
        if (contentType.includes("application/json")) {
          return { contentType, result: JSON.stringify(await response.json()) };
        }
        return { contentType, result: await response.text() };
      }


      const response = await fetch(url);
      const { contentType, result } = await gatherResponse(response);


      const options = { headers: { "content-type": contentType } };
      return new Response(result, options);
    },
  };
  ```

* TypeScript

  ```ts
  interface Env {}
  export default {
    async fetch(request, env, ctx): Promise<Response> {
      const url = "https://jsonplaceholder.typicode.com/todos/1";


      // gatherResponse returns both content-type & response body as a string
      async function gatherResponse(response) {
        const { headers } = response;
        const contentType = headers.get("content-type") || "";
        if (contentType.includes("application/json")) {
          return { contentType, result: JSON.stringify(await response.json()) };
        }
        return { contentType, result: await response.text() };
      }


      const response = await fetch(url);
      const { contentType, result } = await gatherResponse(response);


      const options = { headers: { "content-type": contentType } };
      return new Response(result, options);
    },
  } satisfies ExportedHandler<Env>;
  ```

* Python

  ```py
  from workers import WorkerEntrypoint, Response, fetch
  import json


  class Default(WorkerEntrypoint):
      async def fetch(self, request):
          url = "https://jsonplaceholder.typicode.com/todos/1"


          # gather_response returns both content-type & response body as a string
          async def gather_response(response):
              headers = response.headers
              content_type = headers["content-type"] or ""


              if "application/json" in content_type:
                  return (content_type, json.dumps(await response.json()))
              return (content_type, await response.text())


          response = await fetch(url)
          content_type, result = await gather_response(response)


          headers = {"content-type": content_type}
          return Response(result, headers=headers)
  ```

* Hono

  ```ts
  import { Hono } from 'hono';


  type Env = {};


  const app = new Hono<{ Bindings: Env }>();


  app.get('*', async (c) => {
    const url = "https://jsonplaceholder.typicode.com/todos/1";


    // gatherResponse returns both content-type & response body as a string
    async function gatherResponse(response: Response) {
      const { headers } = response;
      const contentType = headers.get("content-type") || "";


      if (contentType.includes("application/json")) {
        return { contentType, result: JSON.stringify(await response.json()) };
      }


      return { contentType, result: await response.text() };
    }


    const response = await fetch(url);
    const { contentType, result } = await gatherResponse(response);


    return new Response(result, {
      headers: { "content-type": contentType }
    });
  });


  export default app;
  ```


