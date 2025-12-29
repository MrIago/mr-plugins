---
name: cf-containers
description: Cloudflare Containers development. Use when running Docker containers, custom runtimes, resource-intensive workloads, or any language on Workers with container images.
---

# Cloudflare Containers

Run Docker containers on Workers. Any language, any runtime, full Linux environment.

## Basic Structure

```typescript
import { Container, getContainer } from '@cloudflare/containers';

export class MyContainer extends Container {
  defaultPort = 8080;       // Container's listening port
  sleepAfter = '10m';       // Stop after 10min idle
}

export default {
  async fetch(request: Request, env: Env) {
    const container = getContainer(env.MY_CONTAINER, 'instance-id');
    return container.fetch(request);
  }
};
```

## Wrangler Config

```jsonc
{
  "containers": [{
    "class_name": "MyContainer",
    "image": "./Dockerfile",
    "instance_type": "basic",     // basic, standard, large
    "max_instances": 5
  }],
  "durable_objects": {
    "bindings": [{ "name": "MY_CONTAINER", "class_name": "MyContainer" }]
  },
  "migrations": [{ "tag": "v1", "new_sqlite_classes": ["MyContainer"] }]
}
```

## Dockerfile

```dockerfile
FROM node:20-slim
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 8080
CMD ["node", "server.js"]
```

## Container Class Options

```typescript
export class MyContainer extends Container {
  defaultPort = 8080;           // Required: port container listens on
  sleepAfter = '5m';            // Optional: idle timeout (default: never)

  // Optional: custom start command
  getStartParameters() {
    return {
      command: ['python', 'app.py'],
      env: { DEBUG: 'true' }
    };
  }

  // Optional: lifecycle hooks
  onStart() { console.log('Container started'); }
  onStop() { console.log('Container stopped'); }
  onError(error: Error) { console.error(error); }
}
```

## Routing Patterns

### By Session/User ID

```typescript
export default {
  async fetch(request: Request, env: Env) {
    const sessionId = request.headers.get('X-Session-ID') || 'default';
    const container = getContainer(env.MY_CONTAINER, sessionId);
    return container.fetch(request);
  }
};
```

### Load Balancing

```typescript
export default {
  async fetch(request: Request, env: Env) {
    // Random instance from pool
    const instanceId = `pool-${Math.floor(Math.random() * 5)}`;
    const container = getContainer(env.MY_CONTAINER, instanceId);
    return container.fetch(request);
  }
};
```

## Container API

```typescript
const container = getContainer(env.MY_CONTAINER, 'id');

// HTTP request to container
const response = await container.fetch(request);
const response = await container.fetch('http://container/api/data');

// Get container status
const status = await container.status();
// 'starting' | 'running' | 'sleeping' | 'stopped' | 'error'

// Force stop
await container.stop();

// Wake sleeping container
await container.wake();
```

## Environment Variables

```jsonc
{
  "containers": [{
    "class_name": "MyContainer",
    "image": "./Dockerfile",
    "env": {
      "NODE_ENV": "production",
      "API_KEY": { "secret": "my-secret" }
    }
  }]
}
```

## Instance Types

| Type | vCPU | Memory | Disk |
|------|------|--------|------|
| lite | 0.25 | 256MB | 1GB |
| basic | 0.5 | 512MB | 2GB |
| standard | 1 | 1GB | 4GB |
| large | 2 | 2GB | 8GB |

## WebSocket to Container

```typescript
export class MyContainer extends Container {
  defaultPort = 8080;

  async fetch(request: Request) {
    if (request.headers.get('Upgrade') === 'websocket') {
      return this.container.fetch(request);
    }
    return super.fetch(request);
  }
}
```

## Mount R2 Bucket

```typescript
export class MyContainer extends Container {
  defaultPort = 8080;

  getStartParameters() {
    return {
      mounts: [{
        path: '/data',
        bucket: 'my-bucket'
      }]
    };
  }
}
```

## Status Hooks

```typescript
export class MyContainer extends Container {
  defaultPort = 8080;

  onStart() {
    // Container started successfully
    console.log('Container is ready');
  }

  onStop() {
    // Container stopped (idle timeout or manual)
    console.log('Container stopped');
  }

  onError(error: Error) {
    // Container crashed or failed to start
    console.error('Container error:', error);
  }
}
```

## Local Development

```bash
# Start local development
npx wrangler dev

# Deploy
npx wrangler deploy

# List containers
npx wrangler containers list

# List images
npx wrangler containers images list
```

## Common Use Cases

- **AI/ML inference**: Run Python with GPU-accelerated models
- **Code execution**: Run untrusted code in isolated containers
- **Custom runtimes**: Run Rust, Go, Java, or any language
- **Legacy apps**: Containerize existing applications
- **Resource-heavy tasks**: Video processing, data analysis

## Reference

```
reference/
├── examples
│   ├── cron-container.md
│   ├── env-vars-and-secrets.md
│   ├── examples.md
│   ├── mount-r2-buckets-with-fuse.md
│   ├── stateless-instances.md
│   ├── static-frontend-container-backend.md
│   ├── status-hooks.md
│   ├── using-durable-objects-directly.md
│   └── websocket-to-container.md
└── misc
    ├── beta-info-roadmap.md
    ├── container-package.md
    ├── durable-object-interface.md
    ├── environment-variables.md
    ├── frequently-asked-questions.md
    ├── getting-started.md
    ├── image-management.md
    ├── lifecycle-of-a-container.md
    ├── limits-and-instance-types.md
    ├── local-development.md
    ├── overview.md
    ├── platform-reference.md
    ├── pricing.md
    ├── rollouts.md
    ├── scaling-and-routing.md
    ├── wrangler-commands.md
    └── wrangler-configuration.md
```
