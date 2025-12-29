# Limits


| Feature | Limit |
| - | - |
| Queues | 10,000 per account |
| Message size | 128 KB 1 |
| Message retries | 100 |
| Maximum consumer batch size | 100 messages |
| Maximum messages per `sendBatch` call | 100 (or 256KB in total) |
| Maximum Batch wait time | 60 seconds |
| Per-queue message throughput | 5,000 messages per second 2 |
| Message retention period 3 | 4 days (default). [Configurable to 14 days](https://developers.cloudflare.com/queues/configuration/configure-queues/#queue-configuration) |
| Per-queue backlog size 4 | 25GB |
| Concurrent consumer invocations | 250 push-based only |
| Consumer duration (wall clock time) | 15 minutes 5 |
| [Consumer CPU time](https://developers.cloudflare.com/workers/platform/limits/#cpu-time) | 30 seconds (default). [Configurable to 5 minutes](https://developers.cloudflare.com/queues/platform/limits/#increasing-queue-consumer-worker-cpu-limits) |
| `visibilityTimeout` (pull-based queues) | 12 hours |
| `delaySeconds` (when sending or retrying) | 12 hours |
| Requests to the Queues API (excluding pull consumer operations)6 | [1200 requests / 5 mins](https://developers.cloudflare.com/fundamentals/api/reference/limits/) |

1 1 KB is measured as 1000 bytes. Messages can include up to \~100 bytes of internal metadata that counts towards total message limits.

2 Exceeding the maximum message throughput will cause the `send()` and `sendBatch()` methods to throw an exception with a `Too Many Requests` error until your producer falls below the limit.

3 Messages in a queue that reach the maximum message retention are deleted from the queue. Queues does not delete messages in the same queue that have not reached this limit.

4 Individual queues that reach this limit will receive a `Storage Limit Exceeded` error when calling `send()` or `sendBatch()` on the queue.

5 Refer to [Workers limits](https://developers.cloudflare.com/workers/platform/limits/#cpu-time).

6 [Pull Consumers](https://developers.cloudflare.com/queues/configuration/pull-consumers) allow you to consume messages from a queue over HTTP. Pulls, acknowledgements, and retries over HTTP are not subject to the API rate limit.

Need a higher limit?

To request an adjustment to a limit, complete the [Limit Increase Request Form](https://forms.gle/ukpeZVLWLnKeixDu7). If the limit can be increased, Cloudflare will contact you with next steps.

### Increasing Queue Consumer Worker CPU Limits

[Queue consumer Workers](https://developers.cloudflare.com/queues/reference/how-queues-works/#consumers) are Worker scripts, and share the same [per invocation CPU limits](https://developers.cloudflare.com/workers/platform/limits/#worker-limits) as any Workers do. Note that CPU time is active processing time: not time spent waiting on network requests, storage calls, or other general I/O.

By default, the maximum CPU time per consumer Worker invocation is set to 30 seconds, but can be increased by setting `limits.cpu_ms` in your Wrangler configuration:

* wrangler.jsonc

  ```jsonc
  {
    // ...rest of your configuration...
    "limits": {
      "cpu_ms": 300000, // 300,000 milliseconds = 5 minutes
    },
    // ...rest of your configuration...
  }
  ```

* wrangler.toml

  ```toml
  [limits]
  cpu_ms = 300_000
  ```

To learn more about CPU time and limits, [review the Workers documentation](https://developers.cloudflare.com/workers/platform/limits/#cpu-time).


