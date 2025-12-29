---
name: cf-workers-for-platforms
description: Cloudflare Workers for Platforms development. Use when creating dispatch namespaces, user workers, dynamic routing, custom domains for SaaS, or multi-tenant platforms.
---

# Workers for Platforms

Run user code in isolated Workers. Each customer gets own Worker + resources.

## Core Concepts

- **Dispatch Namespace**: Collection of user workers (bypasses 500 script limit)
- **Dynamic Dispatch Worker**: Routes requests to user workers
- **User Worker**: Code uploaded by your customers

## Setup

### 1. Create Dispatch Namespace

```bash
npx wrangler dispatch-namespace create my-namespace
```

### 2. Create Dynamic Dispatch Worker

wrangler.jsonc:
```jsonc
{
  "dispatch_namespaces": [{
    "binding": "DISPATCHER",
    "namespace": "my-namespace"
  }]
}
```

### 3. Dispatch Worker Code

```typescript
export default {
  async fetch(request: Request, env: Env) {
    const url = new URL(request.url);

    // Route by subdomain: customer1.example.com -> customer1
    const workerName = url.hostname.split('.')[0];

    try {
      const userWorker = env.DISPATCHER.get(workerName);
      return await userWorker.fetch(request);
    } catch (e) {
      if (e.message.startsWith('Worker not found')) {
        return new Response('Not found', { status: 404 });
      }
      return new Response(e.message, { status: 500 });
    }
  }
};
```

### 4. Upload User Worker

```bash
cd user-worker-project
npx wrangler deploy --dispatch-namespace my-namespace
```

## Routing Patterns

### KV-Based Routing

```typescript
export default {
  async fetch(request: Request, env: Env) {
    const url = new URL(request.url);

    // Lookup worker name from KV
    const workerName = await env.ROUTING.get(url.hostname);
    if (!workerName) {
      return new Response('Route not configured', { status: 404 });
    }

    const userWorker = env.DISPATCHER.get(workerName);
    return await userWorker.fetch(request);
  }
};
```

### Path-Based Routing

```typescript
// example.com/customer-1/... -> customer-1 worker
const pathParts = url.pathname.split('/').filter(Boolean);
const workerName = pathParts[0];
const userWorker = env.DISPATCHER.get(workerName);
return await userWorker.fetch(request);
```

## User Worker Bindings

Each user worker can have isolated resources:

### Via API (production)

```bash
curl -X PUT \
  "https://api.cloudflare.com/client/v4/accounts/<account>/workers/dispatch/namespaces/<namespace>/scripts/<script>" \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: multipart/form-data" \
  -F 'metadata={
    "main_module": "worker.js",
    "bindings": [
      { "type": "kv_namespace", "name": "KV", "namespace_id": "<id>" },
      { "type": "d1", "name": "DB", "id": "<id>" },
      { "type": "r2_bucket", "name": "STORAGE", "bucket_name": "<name>" }
    ]
  }' \
  -F 'worker.js=@worker.js'
```

### Preserve existing bindings

```json
{
  "bindings": [{ "type": "r2_bucket", "name": "NEW", "bucket_name": "x" }],
  "keep_bindings": ["kv_namespace", "d1"]
}
```

## Outbound Workers

Intercept fetch() calls from user workers:

wrangler.jsonc:
```jsonc
{
  "dispatch_namespaces": [{
    "binding": "DISPATCHER",
    "namespace": "my-namespace",
    "outbound": {
      "service": "outbound-worker",
      "parameters": ["customerId"]
    }
  }]
}
```

Outbound worker:
```typescript
export default {
  async fetch(request: Request, env: Env) {
    // Intercept all fetch() from user workers
    console.log('User fetch:', request.url);
    console.log('Customer:', env.customerId);

    // Forward, modify, or block
    return fetch(request);
  }
};
```

## Custom Limits

Set per-user limits:

```bash
curl -X PUT ".../scripts/<script>" \
  -F 'metadata={
    "main_module": "worker.js",
    "limits": {
      "cpu_ms": 50,
      "memory_mb": 128
    }
  }'
```

## Custom Domains (Cloudflare for SaaS)

### Create Fallback Origin

```bash
# Add DNS record for fallback
# A record: fallback.yourdomain.com -> your origin IP

# Enable SSL for SaaS
curl -X PATCH "https://api.cloudflare.com/client/v4/zones/<zone>/custom_hostnames/fallback_origin" \
  -H "Authorization: Bearer <token>" \
  -d '{"origin": "fallback.yourdomain.com"}'
```

### Add Custom Hostname

```bash
curl -X POST "https://api.cloudflare.com/client/v4/zones/<zone>/custom_hostnames" \
  -H "Authorization: Bearer <token>" \
  -d '{
    "hostname": "app.customer.com",
    "ssl": {
      "method": "http",
      "type": "dv"
    }
  }'
```

### Route Custom Hostname to Worker

Use custom metadata to store worker mapping:
```bash
curl -X PATCH ".../custom_hostnames/<id>" \
  -d '{"custom_metadata": {"worker_name": "customer-worker"}}'
```

In dispatch worker:
```typescript
// Access via cf object
const workerName = request.cf?.hostMetadata?.worker_name;
```



## Reference

```
reference/
├── common
│   ├── api-reference.md
│   ├── certificate-statuses.md
│   └── troubleshooting.md
├── config
├── observability
│   └── observability.md
├── platform
│   ├── limits.md
│   ├── platform.md
│   ├── pricing.md
│   └── worker-isolation.md
├── reference
│   ├── certificate-and-hostname-priority.md
│   ├── certificate-authorities.md
│   ├── certificate-statuses.md
│   ├── connection-request-details.md
│   ├── custom-certificate-signing-requests.md
│   ├── deprecation-notice-for-ssl-for-saas-version-1.md
│   ├── domain-control-validation-backoff-schedule.md
│   ├── how-workers-for-platforms-works.md
│   ├── reference-cloudflare-for-saas.md
│   ├── reference.md
│   ├── status-codes-custom-hostnames.md
│   ├── status-codes.md
│   ├── token-validity-periods.md
│   ├── troubleshooting-cloudflare-for-saas.md
│   └── user-worker-metadata.md
├── saas
│   ├── advanced-settings.md
│   ├── analytics.md
│   ├── apex-proxying.md
│   ├── argo-smart-routing-for-saas.md
│   ├── backoff-schedule.md
│   ├── bigcommerce.md
│   ├── cache-for-saas.md
│   ├── certificate-management.md
│   ├── certificate-signing-requests-csrs-cloudflare-for-saas.md
│   ├── cloudflare-for-saas.md
│   ├── common-api-calls.md
│   ├── configuring-cloudflare-for-saas.md
│   ├── create-custom-hostnames.md
│   ├── custom-certificates.md
│   ├── custom-hostnames.md
│   ├── custom-metadata.md
│   ├── custom-origin-server.md
│   ├── delegated-domain-control-validation-dcv.md
│   ├── design-guide.md
│   ├── early-hints-for-saas.md
│   ├── enable-cloudflare-for-saas.md
│   ├── error-codes-custom-hostname-validation.md
│   ├── get-started-cloudflare-for-saas.md
│   ├── hostname-validation.md
│   ├── how-orange-to-orange-o2o-works.md
│   ├── http-domain-control-validation-dcv.md
│   ├── hubspot.md
│   ├── issue-and-validate-certificates.md
│   ├── issue-certificates.md
│   ├── kinsta.md
│   ├── manage-custom-certificates.md
│   ├── managed-rulesets-per-custom-hostname.md
│   ├── move-hostnames-between-zones.md
│   ├── performance.md
│   ├── plans-cloudflare-for-saas.md
│   ├── pre-validation-methods-custom-hostname-validation.md
│   ├── product-compatibility.md
│   ├── provider-guides.md
│   ├── real-time-validation-methods-custom-hostname-validation.md
│   ├── regional-services-for-saas.md
│   ├── remove-custom-hostnames.md
│   ├── remove-domain-from-saas-provider.md
│   ├── render.md
│   ├── renew-certificates.md
│   ├── resources-for-saas-customers.md
│   ├── salesforce-commerce-cloud.md
│   ├── secure-with-cloudflare-access.md
│   ├── security.md
│   ├── set-up-apex-proxying.md
│   ├── shopify.md
│   ├── tls-settings-cloudflare-for-saas.md
│   ├── txt-domain-control-validation-dcv.md
│   ├── validate-certificates.md
│   ├── validation-status-custom-hostname-validation.md
│   ├── waf-for-saas.md
│   ├── webflow.md
│   ├── webhook-definitions.md
│   ├── workers-as-your-fallback-origin.md
│   └── wp-engine.md
└── wfp
    ├── bindings.md
    ├── cloudflare-for-platforms.md
    ├── configure-workers-for-platforms.md
    ├── create-a-dynamic-dispatch-worker.md
    ├── custom-limits.md
    ├── demos-and-architectures.md
    ├── get-started.md
    ├── hostname-routing.md
    ├── local-development.md
    ├── outbound-workers.md
    ├── platform.md
    ├── static-assets.md
    ├── tags.md
    ├── uploading-user-workers.md
    ├── wfp-rest-api.md
    └── workers-for-platforms.md
```
