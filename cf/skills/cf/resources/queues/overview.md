---
name: cf-queues
description: Cloudflare Queues development. Use when implementing message queues, background jobs, async processing, batching, retries, dead letter queues, or event-driven architectures.
---

# Cloudflare Queues

Message queues with guaranteed delivery. Producer/consumer pattern for Workers.

## Setup

### 1. Create Queue

```bash
npx wrangler queues create my-queue
```

### 2. Wrangler Config

```jsonc
{
  "queues": {
    "producers": [{
      "queue": "my-queue",
      "binding": "MY_QUEUE"
    }],
    "consumers": [{
      "queue": "my-queue",
      "max_batch_size": 10,
      "max_batch_timeout": 30
    }]
  }
}
```

## Producer (Send Messages)

```typescript
export default {
  async fetch(request: Request, env: Env) {
    // Send single message
    await env.MY_QUEUE.send({
      userId: '123',
      action: 'process'
    });

    // Send with delay (seconds)
    await env.MY_QUEUE.send({ data: 'delayed' }, {
      delaySeconds: 60
    });

    // Send batch (up to 100 messages)
    await env.MY_QUEUE.sendBatch([
      { body: { id: 1 } },
      { body: { id: 2 } },
      { body: { id: 3 }, options: { delaySeconds: 30 } }
    ]);

    return new Response('Queued!');
  }
};
```

## Consumer (Receive Messages)

```typescript
export default {
  async queue(batch: MessageBatch, env: Env, ctx: ExecutionContext) {
    for (const message of batch.messages) {
      try {
        await processMessage(message.body);
        message.ack();  // Acknowledge success
      } catch (e) {
        message.retry({ delaySeconds: 60 });  // Retry later
      }
    }
  }
};
```

## Message API

```typescript
interface Message<T> {
  id: string;
  timestamp: Date;
  body: T;
  attempts: number;
  ack(): void;                              // Mark as processed
  retry(options?: { delaySeconds: number }): void;  // Retry message
}

interface MessageBatch<T> {
  queue: string;
  messages: Message<T>[];
  ackAll(): void;    // Ack all messages
  retryAll(): void;  // Retry all messages
}
```

## Batch Configuration

```jsonc
{
  "queues": {
    "consumers": [{
      "queue": "my-queue",
      "max_batch_size": 10,        // 1-100 messages per batch
      "max_batch_timeout": 30,     // Wait up to 30s to fill batch
      "max_retries": 3,            // Retry failed messages 3 times
      "dead_letter_queue": "my-dlq" // Send failed messages here
    }]
  }
}
```

## Dead Letter Queue

```jsonc
{
  "queues": {
    "consumers": [{
      "queue": "my-queue",
      "max_retries": 3,
      "dead_letter_queue": "failed-messages"
    }]
  }
}
```

Consumer for DLQ:
```typescript
export default {
  async queue(batch: MessageBatch, env: Env) {
    for (const message of batch.messages) {
      await logFailedMessage(message);
      await alertAdmin(message);
      message.ack();
    }
  }
};
```

## Concurrency

```jsonc
{
  "queues": {
    "consumers": [{
      "queue": "my-queue",
      "max_concurrency": 10  // Up to 10 parallel invocations
    }]
  }
}
```

## Pull Consumer (HTTP)

Pull messages from external systems:

```bash
# Create pull consumer
npx wrangler queues consumer add my-queue --type=pull
```

```typescript
// Pull via HTTP
const response = await fetch(
  `https://api.cloudflare.com/client/v4/accounts/${accountId}/queues/${queueId}/messages/pull`,
  {
    method: 'POST',
    headers: { 'Authorization': `Bearer ${apiToken}` },
    body: JSON.stringify({
      batch_size: 10,
      visibility_timeout_ms: 30000
    })
  }
);

const { messages } = await response.json();
```

## Content Types

```typescript
// JSON (default)
await env.MY_QUEUE.send({ key: 'value' });

// Text
await env.MY_QUEUE.send('plain text', { contentType: 'text' });

// Binary
await env.MY_QUEUE.send(new ArrayBuffer(8), { contentType: 'bytes' });

// V8 serialized (Date, Map, Set, etc.)
await env.MY_QUEUE.send(new Map(), { contentType: 'v8' });
```

## R2 Event Notifications

Trigger queue on R2 bucket changes:

```bash
npx wrangler r2 bucket notification create my-bucket \
  --event-type object-create \
  --queue my-queue
```

```typescript
export default {
  async queue(batch: MessageBatch<R2EventNotification>, env: Env) {
    for (const message of batch.messages) {
      const { bucket, object, action } = message.body;
      console.log(`${action}: ${bucket}/${object.key}`);
    }
  }
};
```

## Common Patterns

### Background Job Processing

```typescript
// Producer: Enqueue job
await env.JOBS.send({
  type: 'send-email',
  to: user.email,
  template: 'welcome'
});

// Consumer: Process job
async queue(batch: MessageBatch) {
  for (const msg of batch.messages) {
    switch (msg.body.type) {
      case 'send-email':
        await sendEmail(msg.body);
        break;
    }
    msg.ack();
  }
}
```

### Rate Limiting with Delays

```typescript
async queue(batch: MessageBatch) {
  for (const msg of batch.messages) {
    const result = await callRateLimitedAPI(msg.body);
    if (result.rateLimited) {
      msg.retry({ delaySeconds: result.retryAfter });
    } else {
      msg.ack();
    }
  }
}
```

## Reference

```
reference/
├── examples
│   ├── cloudflare-queues-examples.md
│   ├── cloudflare-queues-listing-and-acknowledging-messages-from-the-dashboard.md
│   ├── cloudflare-queues-queues-r2.md
│   ├── cloudflare-queues-sending-messages-from-the-dashboard.md
│   ├── queues-publish-directly-via-a-worker.md
│   ├── queues-publish-directly-via-http.md
│   ├── queues-use-queues-and-durable-objects.md
│   └── serverless-etl-pipelines.md
├── misc
│   ├── batching-retries-and-delays.md
│   ├── cloudflare-queues-configuration.md
│   ├── cloudflare-queues-javascript-apis.md
│   ├── cloudflare-queues-pull-consumers.md
│   ├── configuration.md
│   ├── consumer-concurrency.md
│   ├── dead-letter-queues.md
│   ├── demos-and-architectures.md
│   ├── events-schemas.md
│   ├── event-subscriptions-overview.md
│   ├── getting-started.md
│   ├── glossary.md
│   ├── local-development.md
│   ├── manage-event-subscriptions.md
│   ├── overview.md
│   ├── pause-and-purge.md
│   ├── queues-rest-api.md
│   └── r2-event-notifications.md
├── observability
│   ├── metrics.md
│   └── observability.md
├── platform
│   ├── audit-logs.md
│   ├── changelog.md
│   ├── choose-a-data-or-storage-product.md
│   ├── cloudflare-queues-pricing.md
│   ├── limits.md
│   └── platform.md
├── reference
│   ├── delivery-guarantees.md
│   ├── how-queues-works.md
│   ├── reference.md
│   └── wrangler-commands.md
└── tutorials
    ├── cloudflare-queues-queues-browser-rendering.md
    ├── cloudflare-queues-queues-rate-limits.md
    └── tutorials.md
```
