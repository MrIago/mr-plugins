# Limits


Limits that apply to authoring, deploying, and running Workflows are detailed below.

Many limits are inherited from those applied to Workers scripts and as documented in the [Workers limits](https://developers.cloudflare.com/workers/platform/limits/) documentation.

| Feature | Workers Free | Workers Paid |
| - | - | - |
| Workflow class definitions per script | 3MB max script size per [Worker size limits](https://developers.cloudflare.com/workers/platform/limits/#account-plan-limits) | 10MB max script size per [Worker size limits](https://developers.cloudflare.com/workers/platform/limits/#account-plan-limits) |
| Total scripts per account | 100 | 500 (shared with [Worker script limits](https://developers.cloudflare.com/workers/platform/limits/#account-plan-limits) |
| Compute time per step [1](#user-content-fn-3) | 10 ms | 30 seconds (default) / configurable to 5 minutes of [active CPU time](https://developers.cloudflare.com/workers/platform/limits/#cpu-time) |
| Duration (wall clock) per step [1](#user-content-fn-3) | Unlimited | Unlimited - for example, waiting on network I/O calls or querying a database |
| Maximum persisted state per step | 1MiB (2^20 bytes) | 1MiB (2^20 bytes) |
| Maximum event [payload size](https://developers.cloudflare.com/workflows/build/events-and-parameters/) | 1MiB (2^20 bytes) | 1MiB (2^20 bytes) |
| Maximum state that can be persisted per Workflow instance | 100MB | 1GB |
| Maximum `step.sleep` duration | 365 days (1 year) | 365 days (1 year) |
| Maximum steps per Workflow [2](#user-content-fn-5) | 1024 | 1024 |
| Maximum Workflow executions | 100,000 per day [shared with Workers daily limit](https://developers.cloudflare.com/workers/platform/limits/#worker-limits) | Unlimited |
| Concurrent Workflow instances (executions) per account [3](#user-content-fn-7) | 25 | 10,000 |
| Maximum Workflow instance creation rate [4](#user-content-fn-8) | 100 per second [5](#user-content-fn-6) | 100 per second [5](#user-content-fn-6) |
| Maximum number of [queued instances](https://developers.cloudflare.com/workflows/observability/metrics-analytics/#event-types) | 100,000 | 1,000,000 |
| Retention limit for completed Workflow instance state | 3 days | 30 days [6](#user-content-fn-2) |
| Maximum length of a Workflow name [7](#user-content-fn-4) | 64 characters | 64 characters |
| Maximum length of a Workflow instance ID [7](#user-content-fn-4) | 100 characters | 100 characters |
| Maximum number of subrequests per Workflow instance | 50/request | 1000/request |

Need a higher limit?

To request an adjustment to a limit, complete the [Limit Increase Request Form](https://forms.gle/ukpeZVLWLnKeixDu7). If the limit can be increased, Cloudflare will contact you with next steps.

### `waiting` instances do not count towards instance concurrency limits

Instances that are in a `waiting` state — either sleeping via `step.sleep`, waiting for a retry, or waiting for an event via `step.waitForEvent` — do **not** count towards concurrency limits. This means you can have millions of Workflow instances sleeping or waiting for events simultaneously, as only actively `running` instances count toward the 10,000 concurrent instance limit. However, if there are 10,000 concurrent instances actively running, an instance that has been in a `waiting` state will be queued instead of resuming immediately. When an instance transitions from `running` to `waiting`, other `queued` instances will be scheduled (usually the oldest queued instance, on a best-effort basis). This state transition may not occur if the wait duration is very short.

For example, consider a Workflow that does some work, waits for 30 days, and then continues with more work:

```ts
import {
  WorkflowEntrypoint,
  WorkflowStep,
  WorkflowEvent,
} from "cloudflare:workers";


type Env = {
  MY_WORKFLOW: Workflow;
};


export class MyWorkflow extends WorkflowEntrypoint<Env> {
  async run(event: WorkflowEvent<unknown>, step: WorkflowStep) {
    const apiResponse = await step.do("initial work", async () => {
      let resp = await fetch("https://api.cloudflare.com/client/v4/ips");
      return await resp.json<any>();
    });


    await step.sleep("wait 30 days", "30 days");


    await step.do(
      "make a call to write that could maybe, just might, fail",
      {
        retries: {
          limit: 5,
          delay: "5 second",
          backoff: "exponential",
        },
        timeout: "15 minutes",
      },
      async () => {
        if (Math.random() > 0.5) {
          throw new Error("API call to $STORAGE_SYSTEM failed");
        }
      },
    );
  }
}
```

While a given Workflow instance is waiting for 30 days, it will transition to the `waiting` state, allowing other `queued` instances to run if concurrency limits are reached.

### Increasing Workflow CPU limits

Workflows are Worker scripts, and share the same [per invocation CPU limits](https://developers.cloudflare.com/workers/platform/limits/#worker-limits) as any Workers do. Note that CPU time is active processing time: not time spent waiting on network requests, storage calls, or other general I/O, which don't count towards your CPU time or Workflows compute consumption.

By default, the maximum CPU time per Workflow invocation is set to 30 seconds, but can be increased for all invocations associated with a Workflow definition by setting `limits.cpu_ms` in your Wrangler configuration:

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

## Footnotes

1. A Workflow instance can run forever, as long as each step does not take more than the CPU time limit and the maximum number of steps per Workflow is not reached. [↩](#user-content-fnref-3) [↩2](#user-content-fnref-3-2)

2. `step.sleep` do not count towards the max. steps limit [↩](#user-content-fnref-5)

3. Only instances with a `running` state count towards the concurrency limits. Instances in the `waiting` state are excluded from these limits. [↩](#user-content-fnref-7)

4. Each instance created or restarted counts towards this limit [↩](#user-content-fnref-8)

5. Workflows will return a HTTP 429 rate limited error if you exceed the rate of new Workflow instance creation. [↩](#user-content-fnref-6) [↩2](#user-content-fnref-6-2)

6. Workflow instance state and logs will be retained for 3 days on the Workers Free plan and for 30 days on the Workers Paid plan. [↩](#user-content-fnref-2)

7. Match pattern: \_`^[a-zA-Z0-9_][a-zA-Z0-9-_]\*$`\_ [↩](#user-content-fnref-4) [↩2](#user-content-fnref-4-2)


