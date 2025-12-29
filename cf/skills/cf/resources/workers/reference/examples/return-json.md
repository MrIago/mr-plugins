# Return JSON


If you want to get started quickly, click on the button below.

[![Deploy to Cloudflare](https://deploy.workers.cloudflare.com/button)](https://deploy.workers.cloudflare.com/?url=https://github.com/cloudflare/docs-examples/tree/main/workers/return-json)

This creates a repository in your GitHub account and deploys the application to Cloudflare Workers.

* JavaScript

  ```js
  export default {
    async fetch(request) {
      const data = {
        hello: "world",
      };


      return Response.json(data);
    },
  };
  ```

  [Run Worker in Playground](https://workers.cloudflare.com/playground#LYVwNgLglgDghgJwgegGYHsHALQBM4RwDcABAEbogB2+CAngLzbPYZb6HbW5QDGU2AAwBmAKwBOABwAmACyjhsgIwB2AFwsWbYBzhcafASIkz5i1QFgAUAGF0VCAFMH2ACJQAzjHQeo0e2ok2ngExCRUcMCODABEUDSOAB4AdABWHjGkqFBgzpHRcQkp6THWdg7OENgAKnQwjoFwMDBgfARQ9sipcABucB68CLAQANTA6LjgjtbWSd5IJLiOqHDgECQA3lYkJP10VLxBjhC8ABYAFAiOAI4gjh4QAJSb2zskvPYPi6EkDC9vb1OjjAYHQgRiAHdMGBcDEADSvHYAXyIVkRJCuEBACCoJAASvdvFQPI40h57OddI9UciESjrJpmNpdPoePwhGIpHIFMoVGV7E4XO4vD4-B0qIFgrpSBEorEooRdJkgjk8nKYmRQWRSrYBZUanUGrtmq1eO1Oul7DMrBsYsA4PEAPrjSa5GJqQpLYoZJEMxnM0Kswwckzc8wqZjWIA)

* TypeScript

  ```ts
  export default {
    async fetch(request): Promise<Response> {
      const data = {
        hello: "world",
      };


      return Response.json(data);
    },
  } satisfies ExportedHandler;
  ```

* Python

  ```py
  from workers import WorkerEntrypoint, Response
  import json


  class Default(WorkerEntrypoint):
      def fetch(self, request):
          data = json.dumps({"hello": "world"})
          headers = {"content-type": "application/json"}
          return Response(data, headers=headers)
  ```

* Rust

  ```rs
  use serde::{Deserialize, Serialize};
  use worker::*;


  #[derive(Deserialize, Serialize, Debug)]
  struct Json {
      hello: String,
  }


  #[event(fetch)]
  async fn fetch(_req: Request, _env: Env, _ctx: Context) -> Result<Response> {
      let data = Json {
          hello: String::from("world"),
      };
      Response::from_json(&data)
  }
  ```

* Hono

  ```ts
  import { Hono } from "hono";


  const app = new Hono();


  app.get("*", (c) => {
    const data = {
      hello: "world",
    };


    return c.json(data);
  });


  export default app;
  ```


