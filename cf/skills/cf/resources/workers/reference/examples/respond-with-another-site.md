# Respond with another site


If you want to get started quickly, click on the button below.

[![Deploy to Cloudflare](https://deploy.workers.cloudflare.com/button)](https://deploy.workers.cloudflare.com/?url=https://github.com/cloudflare/docs-examples/tree/main/workers/respond-with-another-site)

This creates a repository in your GitHub account and deploys the application to Cloudflare Workers.

* JavaScript

  ```js
  export default {
    async fetch(request) {
      function MethodNotAllowed(request) {
        return new Response(`Method ${request.method} not allowed.`, {
          status: 405,
          headers: {
            Allow: "GET",
          },
        });
      }
      // Only GET requests work with this proxy.
      if (request.method !== "GET") return MethodNotAllowed(request);
      return fetch(`https://example.com`);
    },
  };
  ```

  [Run Worker in Playground](https://workers.cloudflare.com/playground#LYVwNgLglgDghgJwgegGYHsHALQBM4RwDcABAEbogB2+CAngLzbPYZb6HbW5QDGU2AAwAOYQEYA7AE4AbIICsw+QCYAXCxZtgHOFxp8BI8dLmKVAWABQAYXRUIAU3vYAIlADOMdO6jQ7qki08AmISKjhgBwYAIigaBwAPADoAK3do0lQoMCcIqNj45LToq1t7JwhsABU6GAcAuBgYMD4CKDtkFLgANzh3XgRYCABqYHRccAcrK0SvJBJcB1Q4cAgSAG9LEhI+uipeQIcIXgALAAoEBwBHEAd3CABKDa3twOpePyoSAFkjk-GAHLoCAAQTAYHQAHcHLgLtdbvcnptXq9LhAQAgvlQHJCSAAlO5eKjuBxnAAGvwg-1wJAAJOtLjc7hAkpEqeMAL5hYE7cFQmFJMkAGmeKJR9wIIHcAQALAohS8xSQTg44IsENLRUrXmCIZCAtEAOIAUSq0QV2pIHItYo5DyIiqtjuQyBIAHkqGA6CQTVUSIyERB3CRIZgANYh3wnEhUjwkGAIdAJOhJR1QVAkOFM+6sv7jEgAQgYDBIRtN0SeaIxX0p1KBoL50NhAeZ9sdVcxh2O5zJJwgEBg0pdiQizQcSV46GAZLb22tlg5RCsGmYWh0eh4-CEokksgUSmUpTsjmcbk83l87SoASCOlI4UiMTZapCGUC2Vyj+iZAhZBKNmPCpqlqeodiaFpeDaDo0jsaZLHWaJgDgOIAH0xgmHJolUApFiKdIOWXFc1xCDcDG3Yw9zMZRmCsIA)

* TypeScript

  ```ts
  export default {
    async fetch(request): Promise<Response> {
      function MethodNotAllowed(request) {
        return new Response(`Method ${request.method} not allowed.`, {
          status: 405,
          headers: {
            Allow: "GET",
          },
        });
      }
      // Only GET requests work with this proxy.
      if (request.method !== "GET") return MethodNotAllowed(request);
      return fetch(`https://example.com`);
    },
  } satisfies ExportedHandler;
  ```

* Python

  ```py
  from workers import WorkerEntrypoint, Response, fetch


  class Default(WorkerEntrypoint):
      def fetch(self, request):
          def method_not_allowed(request):
              msg = f'Method {request.method} not allowed.'
              headers = {"Allow": "GET"}
              return Response(msg, headers=headers, status=405)


          # Only GET requests work with this proxy.
          if request.method != "GET":
              return method_not_allowed(request)


          return fetch("https://example.com")
  ```


