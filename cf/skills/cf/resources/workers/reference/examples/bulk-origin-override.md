# Bulk origin override


* JavaScript

  ```js
  export default {
    async fetch(request) {
      /**
       * An object with different URLs to fetch
       * @param {Object} ORIGINS
       */
      const ORIGINS = {
        "starwarsapi.yourdomain.com": "swapi.dev",
        "google.yourdomain.com": "www.google.com",
      };


      const url = new URL(request.url);


      // Check if incoming hostname is a key in the ORIGINS object
      if (url.hostname in ORIGINS) {
        const target = ORIGINS[url.hostname];
        url.hostname = target;
        // If it is, proxy request to that third party origin
        return fetch(url.toString(), request);
      }
      // Otherwise, process request as normal
      return fetch(request);
    },
  };
  ```

* TypeScript

  ```ts
  export default {
    async fetch(request): Promise<Response> {
      /**
       * An object with different URLs to fetch
       * @param {Object} ORIGINS
       */
      const ORIGINS = {
        "starwarsapi.yourdomain.com": "swapi.dev",
        "google.yourdomain.com": "www.google.com",
      };


      const url = new URL(request.url);


      // Check if incoming hostname is a key in the ORIGINS object
      if (url.hostname in ORIGINS) {
        const target = ORIGINS[url.hostname];
        url.hostname = target;
        // If it is, proxy request to that third party origin
        return fetch(url.toString(), request);
      }
      // Otherwise, process request as normal
      return fetch(request);
    },
  } satisfies ExportedHandler;
  ```

* Hono

  ```ts
  import { Hono } from "hono";
  import { proxy } from "hono/proxy";


  // An object with different URLs to fetch
  const ORIGINS: Record<string, string> = {
    "starwarsapi.yourdomain.com": "swapi.dev",
    "google.yourdomain.com": "www.google.com",
  };


  const app = new Hono();


  app.all("*", async (c) => {
    const url = new URL(c.req.url);


    // Check if incoming hostname is a key in the ORIGINS object
    if (url.hostname in ORIGINS) {
      const target = ORIGINS[url.hostname];
      url.hostname = target;


      // If it is, proxy request to that third party origin
      return proxy(url, c.req.raw);
    }


    // Otherwise, process request as normal
    return proxy(c.req.raw);
  });


  export default app;
  ```

* Python

  ```py
  from workers import WorkerEntrypoint
  from js import fetch, URL


  class Default(WorkerEntrypoint):
      async def fetch(self, request):
          # A dict with different URLs to fetch
          ORIGINS = {
            "starwarsapi.yourdomain.com": "swapi.dev",
            "google.yourdomain.com": "www.google.com",
          }


          url = URL.new(request.url)


          # Check if incoming hostname is a key in the ORIGINS object
          if url.hostname in ORIGINS:
              url.hostname = ORIGINS[url.hostname]
              # If it is, proxy request to that third party origin
              return fetch(url.toString(), request)


          # Otherwise, process request as normal
          return fetch(request)
  ```


