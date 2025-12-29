---
name: cf-sandbox
description: Cloudflare Sandbox SDK development. Use when creating sandboxes for code execution, Claude Code generations, streaming output, file operations, background processes, or isolated container environments.
---

# Sandbox SDK

Run untrusted code in isolated containers on Cloudflare Workers.

## Setup

```typescript
import { getSandbox, parseSSEStream } from '@cloudflare/sandbox';
export { Sandbox } from '@cloudflare/sandbox';

type Env = {
  Sandbox: DurableObjectNamespace<Sandbox>;
};

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const sandbox = getSandbox(env.Sandbox, 'user-123');
    // ...
  }
};
```

wrangler.jsonc:
```jsonc
{
  "containers": [{
    "class_name": "Sandbox",
    "image": "./Dockerfile",
    "instance_type": "lite",
    "max_instances": 1
  }],
  "durable_objects": {
    "bindings": [{ "name": "Sandbox", "class_name": "Sandbox" }]
  }
}
```

## Command Execution

```typescript
// Simple execution
const result = await sandbox.exec('python --version');
// { success, stdout, stderr, exitCode }

// With streaming callback
await sandbox.exec('npm install', {
  stream: true,
  onOutput: (stream, data) => console.log(`[${stream}] ${data}`)
});

// Stream to client (SSE)
const stream = await sandbox.execStream('npm run build');
return new Response(stream, {
  headers: { 'Content-Type': 'text/event-stream' }
});

// Parse stream events
for await (const event of parseSSEStream<ExecEvent>(stream)) {
  switch (event.type) {
    case 'stdout': console.log(event.data); break;
    case 'stderr': console.error(event.data); break;
    case 'complete': console.log('Exit:', event.exitCode); break;
    case 'error': console.error(event.error); break;
  }
}
```

## File Operations

```typescript
// Write file
await sandbox.writeFile('/workspace/app.py', 'print("hello")');

// Read file
const file = await sandbox.readFile('/workspace/app.py');
// { content: string }

// Create directory
await sandbox.mkdir('/workspace/project/src', { recursive: true });

// List directory
const files = await sandbox.listDir('/workspace');
// [{ name, type, size, modifiedAt }]

// Delete
await sandbox.deleteFile('/workspace/temp.txt');
await sandbox.deleteDir('/workspace/old', { recursive: true });
```

## Background Processes

```typescript
// Start process
const proc = await sandbox.startProcess('npm run dev', {
  cwd: '/workspace/app',
  env: { NODE_ENV: 'development' }
});
// { id, status }

// Get output stream
const output = await sandbox.getProcessOutput(proc.id);
for await (const event of parseSSEStream(output)) {
  console.log(event.data);
}

// Stop process
await sandbox.stopProcess(proc.id);

// List all processes
const processes = await sandbox.listProcesses();
```

## Claude Code Integration

```typescript
// Clone repo and run Claude Code
await sandbox.exec(`git clone ${repoUrl} /workspace/project`);

const result = await sandbox.exec(
  `claude --print "${task}"`,
  {
    cwd: '/workspace/project',
    env: { ANTHROPIC_API_KEY: env.ANTHROPIC_API_KEY },
    stream: true,
    onOutput: (_, data) => chunks.push(data)
  }
);

// Get diff of changes
const diff = await sandbox.exec('git diff', { cwd: '/workspace/project' });
```

## Code Interpreter

```typescript
// Create context (maintains state between executions)
const ctx = await sandbox.createCodeContext({ language: 'python' });

// Run code
const result = await sandbox.runCode(`
import pandas as pd
df = pd.DataFrame({'a': [1,2,3]})
df.sum()
`, { context: ctx });
// { results: [{ text, type }], logs: string[] }

// Stream code execution
const stream = await sandbox.runCodeStream(code, { context: ctx });
```

## Expose Services (Preview URLs)

```typescript
// Start server in sandbox
await sandbox.startProcess('npm run dev -- --port 3000');

// Expose port
const preview = await sandbox.exposePort(3000);
// { url: 'https://abc123.preview.workers.dev' }

// Proxy WebSocket
if (request.headers.get('Upgrade') === 'websocket') {
  return sandbox.wsConnect(request, 3000);
}
```

## Lifecycle

```typescript
// Pause sandbox (saves memory, keeps state)
await sandbox.pause();

// Resume from pause
await sandbox.resume();

// Destroy sandbox (clears all state)
await sandbox.destroy();
```



## Reference

```
reference/
├── api
│   ├── api-reference.md
│   ├── code-interpreter.md
│   ├── commands.md
│   ├── files.md
│   ├── lifecycle.md
│   ├── ports.md
│   ├── sessions.md
│   └── storage.md
├── concepts
│   ├── architecture.md
│   ├── concepts.md
│   ├── container-runtime.md
│   ├── preview-urls.md
│   ├── sandbox-lifecycle.md
│   ├── security-model.md
│   └── session-management.md
├── config
│   ├── configuration.md
│   ├── dockerfile-reference.md
│   ├── environment-variables.md
│   ├── sandbox-options.md
│   └── wrangler-configuration.md
├── getting-started.md
├── guides
│   ├── deploy-to-production.md
│   ├── execute-commands.md
│   ├── expose-services.md
│   ├── how-to-guides.md
│   ├── manage-files.md
│   ├── mount-buckets.md
│   ├── run-background-processes.md
│   ├── stream-output.md
│   ├── use-code-interpreter.md
│   ├── websocket-connections.md
│   └── work-with-git.md
├── overview.md
├── platform
│   ├── beta-information.md
│   ├── limits.md
│   ├── platform.md
│   └── pricing.md
└── tutorials
    ├── analyze-data-with-ai.md
    ├── automated-testing-pipeline.md
    ├── build-a-code-review-bot.md
    ├── build-an-ai-code-executor.md
    ├── data-persistence-with-r2.md
    ├── run-claude-code-on-a-sandbox.md
    └── tutorials.md
```
