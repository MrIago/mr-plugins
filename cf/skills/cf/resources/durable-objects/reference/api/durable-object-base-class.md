# Durable Object Base Class


The `DurableObject` base class is an abstract class which all Durable Objects inherit from. This base class provides a set of optional methods, frequently referred to as handler methods, which can respond to events, for example a webSocketMessage when using the [WebSocket Hibernation API](https://developers.cloudflare.com/durable-objects/best-practices/websockets/#websocket-hibernation-api). To provide a concrete example, here is a Durable Object `MyDurableObject` which extends `DurableObject` and implements the fetch handler to return "Hello, World!" to the calling Worker.

* JavaScript

  ```js
  export class MyDurableObject extends DurableObject {
    constructor(ctx, env) {
      super(ctx, env);
    }


    async fetch(request) {
      return new Response("Hello, World!");
    }
  }
  ```

* TypeScript

  ```ts
  export class MyDurableObject extends DurableObject {
    constructor(ctx: DurableObjectState, env: Env) {
      super(ctx, env);
    }


    async fetch(request: Request) {
      return new Response("Hello, World!");
    }
  }
  ```

* Python

  ```python
  from workers import DurableObject, Response


  class MyDurableObject(DurableObject):
    def __init__(self, ctx, env):
      super().__init__(ctx, env)


    async def fetch(self, request):
      return Response("Hello, World!")
  ```

## Methods

### `fetch`

* `fetch(Request)`: Response | Promise \<Response>

  * Takes an HTTP request object and returns an HTTP response object. This method allows the Durable Object to emulate an HTTP server where a Worker with a binding to that object is the client.

  * This method can be `async`.

  * Durable Objects support [RPC calls](https://developers.cloudflare.com/durable-objects/best-practices/create-durable-object-stubs-and-send-requests/) as of a compatibility date greater or equal to [2024-04-03](https://developers.cloudflare.com/workers/configuration/compatibility-flags/#durable-object-stubs-and-service-bindings-support-rpc). Users should call RPC methods over `fetch()` if their application design does not follow HTTP request/response flow.

### `alarm`

* `alarm(alarmInfoObject)`: Promise \<void>

  * Called by the system when a scheduled alarm time is reached.

  * The optional parameter `alarmInfo` object has two properties:

    * `retryCount` number: The number of times this alarm event has been retried.
    * `isRetry` boolean: A boolean value to indicate if the alarm has been retried. This value is `true` if this alarm event is a retry.

  * The `alarm()` handler has guaranteed at-least-once execution and will be retried upon failure using exponential backoff, starting at two second delays for up to six retries. Retries will be performed if the method fails with an uncaught exception.

  * This method can be `async`.

  * Refer to [`alarm`](https://developers.cloudflare.com/durable-objects/api/alarms/#alarm) for more information.

### `webSocketMessage`

* `webSocketMessage(ws WebSocket, message string | ArrayBuffer)`: void

  * Called by the system when an accepted WebSocket receives a message.

  * This method can be `async`.

  * This method is not called for WebSocket control frames. The system will respond to an incoming [WebSocket protocol ping](https://www.rfc-editor.org/rfc/rfc6455#section-5.5.2) automatically without interrupting hibernation.

### `webSocketClose`

* `webSocketClose(ws WebSocket, code number, reason string, wasClean boolean)`: void

  * Called by the system when a WebSocket is closed. `wasClean()` is true if the connection closed cleanly, false otherwise.

  * This method can be `async`.

### `webSocketError`

* `webSocketError(ws WebSocket, error any)` : void

  * Called by the system when any non-disconnection related errors occur.

  * This method can be `async`.

## Properties

### `DurableObjectState`

See [`DurableObjectState` documentation](https://developers.cloudflare.com/durable-objects/api/state/).

### `Env`

A list of bindings which are available to the Durable Object.

## Related resources

* Refer to [Use WebSockets](https://developers.cloudflare.com/durable-objects/best-practices/websockets/) for more information on examples of WebSocket methods and best practices.


