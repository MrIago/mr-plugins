# Tail Workers


A Tail Worker receives information about the execution of other Workers (known as producer Workers), such as HTTP statuses, data passed to `console.log()` or uncaught exceptions. Tail Workers can process logs for alerts, debugging, or analytics.

Tail Workers are available to all customers on the Workers Paid and Enterprise tiers. Tail Workers are billed by [CPU time](https://developers.cloudflare.com/workers/platform/pricing/#workers), not by the number of requests.

![Tail Worker diagram](https://developers.cloudflare.com/_astro/tail-workers.CaYo-ajt_gkexF.webp)

A Tail Worker is automatically invoked after the invocation of a producer Worker (the Worker the Tail Worker will track) that contains the application logic. It captures events after the producer has finished executing. Events throughout the request lifecycle, including potential sub-requests via [Service Bindings](https://developers.cloudflare.com/workers/runtime-apis/bindings/service-bindings/) and [Dynamic Dispatch](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/get-started/configuration/), will be included. You can filter, change the format of the data, and send events to any HTTP endpoint. For quick debugging, Tail Workers can be used to send logs to [KV](https://developers.cloudflare.com/kv/api/) or any database.

Export batches of logs and traces to Sentry, Grafana, Honeycomb and more

If you are using Tail Workers to export logs and errors to observability tools like Sentry, Grafana, Honeycomb and more — you may not need to use Tail Workers.

Instead, you can configure your Worker to [export OpenTelemetry (OTEL) format logs and traces](https://developers.cloudflare.com/workers/observability/exporting-opentelemetry-data/) to these tools. Unlike Tail Workers, when you configure an OTEL destination, logs and traces are sent in batches to your destination, rather than sent after each invocation of the Worker.

You should think of Tail Workers as the advanced-mode option, for when you need to do something custom that is not built into the Workers observability platform.

## Configure Tail Workers

To configure a Tail Worker:

1. [Create a Worker](https://developers.cloudflare.com/workers/get-started/guide) to serve as the Tail Worker.
2. Add a [`tail()`](https://developers.cloudflare.com/workers/runtime-apis/handlers/tail/) handler to your Worker. The `tail()` handler is invoked every time the producer Worker to which a Tail Worker is connected is invoked. The following Worker code is a Tail Worker that sends its data to an HTTP endpoint:

```js
export default {
  async tail(events) {
    fetch("https://example.com/endpoint", {
      method: "POST",
      body: JSON.stringify(events),
    })
  }
}
```

The following Worker code is an example of what the `events` object may look like:

```json
[
  {
    "scriptName": "Example script",
    "outcome": "exception",
    "eventTimestamp": 1587058642005,
    "event": {
      "request": {
        "url": "https://example.com/some/requested/url",
        "method": "GET",
        "headers": {
          "cf-ray": "57d55f210d7b95f3",
          "x-custom-header-name": "my-header-value"
        },
        "cf": {
          "colo": "SJC"
        }
      }
    },
    "logs": [
      {
        "message": ["string passed to console.log()"],
        "level": "log",
        "timestamp": 1587058642005
      }
    ],
    "exceptions": [
      {
        "name": "Error",
        "message": "Threw a sample exception",
        "timestamp": 1587058642005
      }
    ],
    "diagnosticsChannelEvents": [
      {
        "channel": "foo",
        "message": "The diagnostic channel message",
        "timestamp": 1587058642005
      }
    ]
  }
]
```

1. Add the following to the Wrangler file of the producer Worker:

* wrangler.jsonc

  ```jsonc
  {
    "$schema": "./node_modules/wrangler/config-schema.json",
    "tail_consumers": [
      {
        "service": "<TAIL_WORKER_NAME>"
      }
    ]
  }
  ```

* wrangler.toml

  ```toml
  tail_consumers = [{service = "<TAIL_WORKER_NAME>"}]
  ```

Note

Workers added to the `tail_consumers` array must have a `tail()` handler defined.

## Related resources

* [`tail()`](https://developers.cloudflare.com/workers/runtime-apis/handlers/tail/) Handler API docs - Learn how to set up a `tail()` handler in your Worker.

- [Errors and exceptions](https://developers.cloudflare.com/workers/observability/errors/) - Review common Workers errors.
- [Local development and testing](https://developers.cloudflare.com/workers/development-testing/) - Develop and test you Workers locally.
- [Source maps and stack traces](https://developers.cloudflare.com/workers/observability/source-maps) - Learn how to enable source maps and generate stack traces for Workers.


