# Event subscriptions overview


Event subscriptions allow you to receive messages when events occur across your Cloudflare account. Cloudflare products (e.g., [KV](https://developers.cloudflare.com/kv/), [Workers AI](https://developers.cloudflare.com/workers-ai), [Workers](https://developers.cloudflare.com/workers)) can publish structured events to a queue, which you can then consume with Workers or [HTTP pull consumers](https://developers.cloudflare.com/queues/configuration/pull-consumers/) to build custom workflows, integrations, or logic.

![Event subscriptions architecture](https://developers.cloudflare.com/_astro/queues-event-subscriptions.3aVidnXJ_1iozIn.webp)

## What is an event?

An event is a structured record of something happening in your Cloudflare account – like a Workers AI batch request being queued, a Worker build completing, or an R2 bucket being created. When you subscribe to these events, your queue will automatically start receiving messages when the events occur.

## Learn more

[Manage event subscriptions ](https://developers.cloudflare.com/queues/event-subscriptions/manage-event-subscriptions/)Learn how to create, configure, and manage event subscriptions for your queues.

[Events & schemas ](https://developers.cloudflare.com/queues/event-subscriptions/events-schemas/)Explore available event types and their corresponding data schemas.


