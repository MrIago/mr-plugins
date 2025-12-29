---
name: cf-agents
description: Cloudflare Agents SDK development. Use when building AI agents, chat bots, real-time WebSocket apps, stateful agents, MCP servers/clients, or human-in-the-loop workflows.
---

# Cloudflare Agents SDK

Build AI-powered agents with real-time state, WebSockets, scheduling, SQL, and MCP support.

## Setup

```bash
npm i agents
```

```jsonc
// wrangler.jsonc
{
  "durable_objects": {
    "bindings": [{ "name": "MyAgent", "class_name": "MyAgent" }]
  },
  "migrations": [{ "tag": "v1", "new_sqlite_classes": ["MyAgent"] }]
}
```

## Basic Agent

```typescript
import { Agent } from 'agents';

interface Env {
  AI: Ai;
}

interface State {
  messages: string[];
  count: number;
}

export class MyAgent extends Agent<Env, State> {
  initialState: State = { messages: [], count: 0 };

  // Called when agent starts
  async onStart() {
    console.log('Agent started with state:', this.state);
  }

  // Handle HTTP requests
  async onRequest(request: Request): Promise<Response> {
    return new Response(JSON.stringify(this.state));
  }

  // Handle WebSocket connection
  async onConnect(connection: Connection, ctx: ConnectionContext) {
    // ctx.request has original HTTP request
  }

  // Handle WebSocket messages
  async onMessage(connection: Connection, message: WSMessage) {
    connection.send('Received: ' + message);
  }

  // Called when state changes
  onStateUpdate(state: State, source: 'server' | Connection) {
    console.log('State updated by', source);
  }
}
```

## State Management

```typescript
export class MyAgent extends Agent<Env, State> {
  initialState = { count: 0, items: [] };

  // Read state
  getCount() {
    return this.state.count;
  }

  // Update state (auto-syncs to clients)
  increment() {
    this.setState({
      ...this.state,
      count: this.state.count + 1
    });
  }
}
```

## Built-in SQL Database

```typescript
export class MyAgent extends Agent<Env, State> {
  async setupDatabase() {
    this.sql`
      CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT UNIQUE
      )
    `;
  }

  async createUser(id: string, name: string, email: string) {
    this.sql`INSERT INTO users (id, name, email) VALUES (${id}, ${name}, ${email})`;
  }

  async getUser(id: string) {
    const users = this.sql<User>`SELECT * FROM users WHERE id = ${id}`;
    return users[0];
  }
}
```

## Scheduling Tasks

```typescript
export class MyAgent extends Agent<Env, State> {
  // Schedule one-time task
  async scheduleReminder(userId: string, message: string) {
    const inTwoHours = new Date(Date.now() + 2 * 60 * 60 * 1000);
    await this.schedule(inTwoHours, 'sendReminder', { userId, message });
  }

  // Schedule recurring task (cron)
  async scheduleDailyReport() {
    await this.schedule('0 8 * * *', 'generateReport', { type: 'daily' });
  }

  // Get/cancel schedules
  async manageSchedules() {
    const schedules = this.getSchedules();
    await this.cancelSchedule('schedule-id');
  }

  // Called by scheduler
  async sendReminder(data: { userId: string; message: string }) {
    // Send notification
  }
}
```

## Chat Agent (AI)

```typescript
import { AIChatAgent } from 'agents/ai-chat-agent';
import { streamText } from 'ai';
import { openai } from '@ai-sdk/openai';

export class ChatAgent extends AIChatAgent<Env> {
  async onChatMessage(onFinish) {
    const result = streamText({
      model: openai('gpt-4o'),
      system: 'You are a helpful assistant.',
      messages: this.messages  // Built-in message history
    });

    return result.toUIMessageStreamResponse();
  }
}
```

## Client Connection (React)

```typescript
import { useAgent, useAgentChat } from 'agents/react';

function ChatUI() {
  const agent = useAgent({
    agent: 'chat-agent',
    name: 'user-session-123'
  });

  const { messages, input, handleInputChange, handleSubmit, isLoading } = useAgentChat({
    agent
  });

  return (
    <form onSubmit={handleSubmit}>
      {messages.map((m, i) => <div key={i}>{m.content}</div>)}
      <input value={input} onChange={handleInputChange} />
      <button disabled={isLoading}>Send</button>
    </form>
  );
}
```

## Client Connection (Vanilla JS)

```typescript
import { AgentClient, agentFetch } from 'agents/client';

// WebSocket connection
const client = new AgentClient({
  agent: 'my-agent',
  name: 'instance-123',
  host: window.location.host
});

client.onmessage = (event) => {
  const data = JSON.parse(event.data);
  console.log('Received:', data);
};

client.send(JSON.stringify({ type: 'action', data: 'hello' }));

// HTTP request
const response = await agentFetch({ agent: 'my-agent', name: 'instance-123' });
```

## Calling Agent from Worker

```typescript
import { routeAgentRequest } from 'agents';

export default {
  async fetch(request: Request, env: Env) {
    // Route to agent based on URL pattern
    return routeAgentRequest(request, env);
  }
};

// Or get specific instance
const agent = env.MyAgent.get(env.MyAgent.idFromName('user-123'));
const response = await agent.fetch(request);
```

## MCP Server

```typescript
import { McpAgent } from 'agents/mcp';
import { z } from 'zod';

export class MyMcpServer extends McpAgent<Env> {
  server = new McpServer({ name: 'my-server', version: '1.0.0' });

  async init() {
    this.server.tool('get_weather', { city: z.string() }, async ({ city }) => {
      return { temperature: 72, condition: 'sunny' };
    });

    this.server.resource('config', 'application/json', async () => {
      return JSON.stringify({ setting: 'value' });
    });
  }
}
```

## MCP Client

```typescript
export class MyAgent extends Agent<Env, State> {
  async connectToMcp() {
    // Connect to remote MCP server
    const { id, authUrl } = await this.addMcpServer(
      'github',
      'https://mcp.github.com/sse'
    );

    // Use tools from connected servers
    const servers = this.getMcpServers();

    // Disconnect
    await this.removeMcpServer(id);
  }
}
```

## Human-in-the-Loop

```typescript
export class ApprovalAgent extends Agent<Env, State> {
  async requestApproval(action: string) {
    this.setState({
      ...this.state,
      pendingApproval: { action, status: 'pending' }
    });

    // Wait for human via WebSocket or poll
  }

  async onMessage(connection: Connection, message: WSMessage) {
    const data = JSON.parse(message as string);

    if (data.type === 'approve') {
      await this.executeAction(this.state.pendingApproval.action);
    }
  }
}
```

## Wrangler Config

```jsonc
{
  "name": "my-agent-worker",
  "main": "src/index.ts",
  "compatibility_date": "2024-12-01",
  "durable_objects": {
    "bindings": [
      { "name": "MyAgent", "class_name": "MyAgent" },
      { "name": "ChatAgent", "class_name": "ChatAgent" }
    ]
  },
  "migrations": [
    { "tag": "v1", "new_sqlite_classes": ["MyAgent", "ChatAgent"] }
  ],
  "ai": { "binding": "AI" }
}
```

## Key Concepts

- **Agent Instance**: Each unique ID = separate stateful micro-server
- **State Sync**: `setState()` auto-syncs to all connected clients
- **SQL**: Built-in SQLite via `this.sql` template literal
- **Scheduling**: One-time, delayed, or cron-based task execution
- **WebSocket**: Real-time bidirectional communication
- **MCP**: Connect to/expose Model Context Protocol servers


## Reference

```
reference/
├── concepts
│   ├── agent-class-internals.md
│   ├── agents.md
│   ├── calling-llms.md
│   ├── concepts.md
│   ├── human-in-the-loop.md
│   ├── tools.md
│   └── workflows.md
├── misc
│   ├── agents-api.md
│   ├── agents.md
│   ├── api-reference.md
│   ├── authorization.md
│   ├── browse-the-web.md
│   ├── build-a-chat-agent.md
│   ├── build-a-human-in-the-loop-agent.md
│   ├── build-an-interactive-chatgpt-app.md
│   ├── build-a-remote-mcp-client.md
│   ├── build-a-remote-mcp-server.md
│   ├── build-a-slack-agent.md
│   ├── calling-agents.md
│   ├── cloudflare-s-own-mcp-servers.md
│   ├── configuration.md
│   ├── connect-to-an-mcp-server.md
│   ├── createmcphandler-api-reference.md
│   ├── getting-started.md
│   ├── guides.md
│   ├── handle-oauth-with-mcp-servers.md
│   ├── http-and-server-sent-events.md
│   ├── implement-effective-agent-patterns.md
│   ├── mcpagent-api-reference.md
│   ├── mcpclient-api-reference.md
│   ├── mcp-server-portals.md
│   ├── model-context-protocol-mcp.md
│   ├── patterns.md
│   ├── prompt-an-ai-model.md
│   ├── retrieval-augmented-generation.md
│   ├── run-workflows.md
│   ├── schedule-tasks.md
│   ├── store-and-sync-state.md
│   ├── test-a-remote-mcp-server.md
│   ├── testing-your-agents.md
│   ├── tools.md
│   ├── transport.md
│   ├── using-ai-models.md
│   ├── using-websockets.md
│   └── x402.md
└── platform
    ├── limits.md
    ├── platform.md
    ├── prompt-engineering.md
    └── prompt-txt.md
```
