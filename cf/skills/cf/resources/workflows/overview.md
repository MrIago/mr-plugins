---
name: cf-workflows
description: Cloudflare Workflows development. Use when creating durable multi-step workflows, retries, sleeping, waiting for events, human-in-the-loop approval, background jobs.
---

# Cloudflare Workflows

Durable multi-step execution on Workers. Auto-retries, sleeps, waits for events.

## Basic Structure

```typescript
import { WorkflowEntrypoint, WorkflowEvent, WorkflowStep } from 'cloudflare:workers';

interface Params { userId: string; }

export class MyWorkflow extends WorkflowEntrypoint<Env, Params> {
  async run(event: WorkflowEvent<Params>, step: WorkflowStep) {
    const user = await step.do('fetch user', async () => {
      return await this.env.DB.prepare('SELECT * FROM users WHERE id = ?')
        .bind(event.payload.userId).first();
    });

    await step.do('send email', async () => {
      await sendEmail(user.email, 'Welcome!');
    });

    return { success: true, userId: user.id };
  }
}
```

## Wrangler Config

```jsonc
{
  "workflows": [{
    "name": "my-workflow",
    "binding": "MY_WORKFLOW",
    "class_name": "MyWorkflow"
  }]
}
```

## Trigger from Worker

```typescript
export default {
  async fetch(request: Request, env: Env) {
    // Create instance with auto-generated ID
    const instance = await env.MY_WORKFLOW.create({
      params: { userId: '123' }
    });

    // Or with custom ID (idempotent)
    const instance = await env.MY_WORKFLOW.create({
      id: `order-${orderId}`,
      params: { orderId }
    });

    return Response.json({ instanceId: instance.id });
  }
}
```

## Step API

```typescript
async run(event: WorkflowEvent<Params>, step: WorkflowStep) {
  // Basic step - auto retries on failure
  const result = await step.do('step name', async () => {
    return await someOperation();
  });

  // With retry config
  const result = await step.do('risky step', {
    retries: { limit: 5, delay: '10s', backoff: 'exponential' },
    timeout: '30s'
  }, async () => {
    return await riskyOperation();
  });

  // Sleep
  await step.sleep('wait 1 hour', '1 hour');
  await step.sleepUntil('wait until midnight', new Date('2024-12-31T00:00:00Z'));

  // Wait for external event
  const approval = await step.waitForEvent('await approval', {
    type: 'approved',
    timeout: '24 hours'
  });
}
```

## Send Events to Running Workflow

```typescript
// From Worker
const instance = await env.MY_WORKFLOW.get(instanceId);
await instance.sendEvent({ type: 'approved', payload: { approvedBy: 'admin' } });

// Query status
const status = await instance.status();
// { status: 'running' | 'paused' | 'complete' | 'errored' | 'terminated' }
```

## Error Handling

```typescript
import { NonRetryableError } from 'cloudflare:workers';

await step.do('validate', async () => {
  if (!isValid) {
    // Stop retries, fail workflow
    throw new NonRetryableError('Invalid input');
  }
});

// Try-catch in run() for graceful handling
async run(event, step) {
  try {
    await step.do('risky', async () => { ... });
  } catch (e) {
    await step.do('handle error', async () => {
      await notifyAdmin(e.message);
    });
  }
}
```

## Instance Management

```typescript
// List instances
const instances = await env.MY_WORKFLOW.list();

// Get specific instance
const instance = await env.MY_WORKFLOW.get(instanceId);

// Pause/Resume
await instance.pause();
await instance.resume();

// Terminate
await instance.terminate();

// Status
const status = await instance.status();
// { status, output, error }
```

## Common Patterns

### Retry with Backoff

```typescript
await step.do('call api', {
  retries: { limit: 3, delay: '1s', backoff: 'exponential' }
}, async () => {
  return await fetch('https://api.example.com/data');
});
```

### Human in the Loop

```typescript
await step.do('request approval', async () => {
  await sendSlackMessage('Please approve order #123');
});

const response = await step.waitForEvent('await approval', {
  type: 'order-approval',
  timeout: '7 days'
});

if (response.payload.approved) {
  await step.do('process order', ...);
}
```

### Scheduled Processing

```typescript
await step.do('process batch', async () => {
  await processBatch();
});

await step.sleep('wait for next batch', '1 hour');

// Loop continues...
```

## Rules

1. Steps must be idempotent (may re-run on retry)
2. Return serializable data only (no functions, symbols)
3. Don't use external state between steps (use step returns)
4. Step names must be unique within workflow

## Reference

```
reference/
├── examples
│   ├── agents.md
│   ├── examples.md
│   ├── export-and-save-d1-database.md
│   ├── human-in-the-loop-image-tagging-with-waitforevent.md
│   ├── integrate-workflows-with-twilio.md
│   └── pay-cart-and-send-invoice.md
├── misc
│   ├── build-with-workflows.md
│   ├── call-workflows-from-pages.md
│   ├── cli-quick-start.md
│   ├── dag-workflows.md
│   ├── events-and-parameters.md
│   ├── get-started.md
│   ├── guide.md
│   ├── interact-with-a-workflow.md
│   ├── local-development.md
│   ├── overview.md
│   ├── python-workers-api.md
│   ├── python-workflows-sdk.md
│   ├── rules-of-workflows.md
│   ├── sleeping-and-retrying.md
│   ├── test-workflows.md
│   ├── trigger-workflows.md
│   ├── videos.md
│   ├── workers-api.md
│   └── workflows-rest-api.md
├── observability
│   ├── metrics-and-analytics.md
│   └── observability.md
└── reference
    ├── changelog.md
    ├── event-subscriptions.md
    ├── glossary.md
    ├── limits.md
    ├── platform.md
    ├── pricing.md
    └── wrangler-commands.md
```
