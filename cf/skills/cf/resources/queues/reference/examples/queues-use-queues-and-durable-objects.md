# Queues - Use Queues and Durable Objects


The following example shows you how to write a Worker script to publish to [Cloudflare Queues](https://developers.cloudflare.com/queues/) from within a [Durable Object](https://developers.cloudflare.com/durable-objects/).

Prerequisites:

* A [queue created](https://developers.cloudflare.com/queues/get-started/#3-create-a-queue) via the Cloudflare dashboard or the [wrangler CLI](https://developers.cloudflare.com/workers/wrangler/install-and-update/).
* A [configured **producer** binding](https://developers.cloudflare.com/queues/configuration/configure-queues/#producer-worker-configuration) in the Cloudflare dashboard or Wrangler file.
* A [Durable Object namespace binding](https://developers.cloudflare.com/workers/wrangler/configuration/#durable-objects).

Configure your Wrangler file as follows:

* wrangler.jsonc

  ```jsonc
  {
    "$schema": "./node_modules/wrangler/config-schema.json",
    "name": "my-worker",
    "queues": {
      "producers": [
        {
          "queue": "my-queue",
          "binding": "YOUR_QUEUE"
        }
      ]
    },
    "durable_objects": {
      "bindings": [
        {
          "name": "YOUR_DO_CLASS",
          "class_name": "YourDurableObject"
        }
      ]
    },
    "migrations": [
      {
        "tag": "v1",
        "new_sqlite_classes": [
          "YourDurableObject"
        ]
      }
    ]
  }
  ```

* wrangler.toml

  ```toml
  name = "my-worker"


  [[queues.producers]]
    queue = "my-queue"
    binding = "YOUR_QUEUE"


  [durable_objects]
  bindings = [
    { name = "YOUR_DO_CLASS", class_name = "YourDurableObject" }
  ]


  [[migrations]]
  tag = "v1"
  new_sqlite_classes = ["YourDurableObject"]
  ```

The following Worker script:

1. Creates a Durable Object stub, or retrieves an existing one based on a userId.
2. Passes request data to the Durable Object.
3. Publishes to a queue from within the Durable Object.

The `constructor()` in the Durable Object makes your `Environment` available (in scope) on `this.env` to the [`fetch()` handler](https://developers.cloudflare.com/durable-objects/best-practices/create-durable-object-stubs-and-send-requests/) in the Durable Object.

```ts
interface Env {
  YOUR_QUEUE: Queue;
  YOUR_DO_CLASS: DurableObjectNamespace;
}


export default {
  async fetch(req, env): Promise<Response> {
    // Assume each Durable Object is mapped to a userId in a query parameter
    // In a production application, this will be a userId defined by your application
    // that you validate (and/or authenticate) first.
    let url = new URL(req.url)
    let userIdParam = url.searchParams.get("userId")


    if (userIdParam) {
      // Get a stub that allows you to call that Durable Object
      let durableObjectStub = env.YOUR_DO_CLASS.getByName(userIdParam);


      // Pass the request to that Durable Object and await the response
      // This invokes the constructor once on your Durable Object class (defined further down)
      // on the first initialization, and the fetch method on each request.
      // We pass the original Request to the Durable Object's fetch method
      let response = await durableObjectStub.fetch(req);


      // This would return "wrote to queue", but you could return any response.
      return response;
    }
    return new Response("userId must be provided", { status: 400 });
  },
} satisfies ExportedHandler<Env>;


export class YourDurableObject implements DurableObject {
  constructor(private state: DurableObjectState, private env: Env) {}


  async fetch(req: Request): Promise<Response> {
    // Error handling elided for brevity.
    // Publish to your queue
    await this.env.YOUR_QUEUE.send({
      id: this.state.id.toString() // Write the ID of the Durable Object to your queue
      // Write any other properties to your queue
    });


    return new Response("wrote to queue")
  }
```


