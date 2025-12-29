---
name: cf-workers-ai
description: Cloudflare Workers AI development. Use when running AI models, LLM inference, text generation, embeddings, image generation, speech recognition, function calling, or streaming responses.
---

# Cloudflare Workers AI

Run 50+ open-source AI models on Cloudflare's serverless GPUs. Text, images, speech, embeddings.

## Setup

```jsonc
// wrangler.jsonc
{
  "ai": {
    "binding": "AI"
  }
}
```

## Text Generation

```typescript
export default {
  async fetch(request: Request, env: Env) {
    // Chat completion
    const response = await env.AI.run('@cf/meta/llama-3.1-8b-instruct', {
      messages: [
        { role: 'system', content: 'You are a helpful assistant' },
        { role: 'user', content: 'What is Cloudflare?' }
      ]
    });

    return Response.json(response);
  }
};
```

## Streaming Response

```typescript
export default {
  async fetch(request: Request, env: Env) {
    const stream = await env.AI.run('@cf/meta/llama-3.1-8b-instruct', {
      messages: [{ role: 'user', content: 'Write a story' }],
      stream: true
    });

    return new Response(stream, {
      headers: { 'content-type': 'text/event-stream' }
    });
  }
};
```

## Text Embeddings

```typescript
export default {
  async fetch(request: Request, env: Env) {
    const embeddings = await env.AI.run('@cf/baai/bge-base-en-v1.5', {
      text: ['Hello world', 'Goodbye world']
    });

    // embeddings.data = [[0.1, 0.2, ...], [0.3, 0.4, ...]]
    return Response.json(embeddings);
  }
};
```

## Image Generation

```typescript
export default {
  async fetch(request: Request, env: Env) {
    const image = await env.AI.run('@cf/black-forest-labs/flux-1-schnell', {
      prompt: 'A sunset over mountains'
    });

    return new Response(image, {
      headers: { 'content-type': 'image/png' }
    });
  }
};
```

## Speech Recognition

```typescript
export default {
  async fetch(request: Request, env: Env) {
    const audioData = await request.arrayBuffer();

    const result = await env.AI.run('@cf/openai/whisper', {
      audio: [...new Uint8Array(audioData)]
    });

    return Response.json(result);
  }
};
```

## JSON Mode

Force structured JSON output:

```typescript
const response = await env.AI.run('@cf/meta/llama-3.1-8b-instruct', {
  messages: [
    { role: 'system', content: 'Extract data about a country.' },
    { role: 'user', content: 'Tell me about Japan.' }
  ],
  response_format: {
    type: 'json_schema',
    json_schema: {
      type: 'object',
      properties: {
        name: { type: 'string' },
        capital: { type: 'string' },
        population: { type: 'number' }
      },
      required: ['name', 'capital']
    }
  }
});
```

## Function Calling

### Traditional

```typescript
const response = await env.AI.run('@hf/nousresearch/hermes-2-pro-mistral-7b', {
  messages: [{ role: 'user', content: 'What is the weather in Tokyo?' }],
  tools: [{
    name: 'getWeather',
    description: 'Get weather for a location',
    parameters: {
      type: 'object',
      properties: {
        location: { type: 'string', description: 'City name' }
      },
      required: ['location']
    }
  }]
});

// response.tool_calls = [{ name: 'getWeather', arguments: { location: 'Tokyo' } }]
```

### Embedded (Auto-Execute)

```typescript
import { runWithTools, createToolsFromOpenAPISpec } from '@cloudflare/ai-utils';

const response = await runWithTools(
  env.AI,
  '@hf/nousresearch/hermes-2-pro-mistral-7b',
  {
    messages: [{ role: 'user', content: 'Who is Cloudflare on GitHub?' }],
    tools: await createToolsFromOpenAPISpec('https://api.github.com/openapi.json')
  }
);
```

## OpenAI Compatible API

Use OpenAI SDK with Workers AI:

```typescript
import OpenAI from 'openai';

const openai = new OpenAI({
  apiKey: env.CLOUDFLARE_API_KEY,
  baseURL: `https://api.cloudflare.com/client/v4/accounts/${env.ACCOUNT_ID}/ai/v1`
});

// Chat completions
const chat = await openai.chat.completions.create({
  model: '@cf/meta/llama-3.1-8b-instruct',
  messages: [{ role: 'user', content: 'Hello!' }]
});

// Embeddings
const embeddings = await openai.embeddings.create({
  model: '@cf/baai/bge-large-en-v1.5',
  input: 'Hello world'
});
```

## Generation Parameters

```typescript
await env.AI.run('@cf/meta/llama-3.1-8b-instruct', {
  messages: [...],
  max_tokens: 512,           // Max output tokens (default: 256)
  temperature: 0.7,          // Randomness 0-5 (default: 0.6)
  top_p: 0.9,                // Nucleus sampling (default: none)
  top_k: 40,                 // Top-k sampling 1-50
  seed: 42,                  // Reproducibility
  repetition_penalty: 1.1,   // Reduce repetition 0-2
  frequency_penalty: 0.5,    // Reduce verbatim repeat 0-2
  presence_penalty: 0.5      // Encourage new topics 0-2
});
```

## Popular Models

### Text Generation
- `@cf/meta/llama-3.1-8b-instruct` - Fast, multilingual
- `@cf/meta/llama-3.1-70b-instruct` - High quality
- `@cf/meta/llama-3.3-70b-instruct-fp8-fast` - Best + function calling
- `@cf/deepseek-ai/deepseek-r1-distill-qwen-32b` - Reasoning
- `@cf/qwen/qwq-32b` - Reasoning model

### Embeddings
- `@cf/baai/bge-base-en-v1.5` - 768 dimensions
- `@cf/baai/bge-large-en-v1.5` - 1024 dimensions
- `@cf/baai/bge-m3` - Multilingual

### Image Generation
- `@cf/black-forest-labs/flux-1-schnell` - Fast
- `@cf/black-forest-labs/flux-2-dev` - High quality
- `@cf/bytedance/stable-diffusion-xl-lightning` - SDXL

### Speech
- `@cf/openai/whisper` - Speech-to-text
- `@cf/openai/whisper-large-v3-turbo` - High quality ASR

### Function Calling
- `@hf/nousresearch/hermes-2-pro-mistral-7b`
- `@cf/meta/llama-3.3-70b-instruct-fp8-fast`

## Local Development

Workers AI requires `remote: true` for local dev:

```jsonc
{
  "ai": {
    "binding": "AI",
    "remote": true
  }
}
```

## Pricing

- Text Generation: $0.28/M input, $0.83/M output tokens
- Embeddings: $0.067/M tokens
- Image Generation: varies by model

Free tier: 10,000 neurons/day


## Reference

```
reference/
├── misc
│   ├── agents.md
│   ├── asynchronous-batch-api.md
│   ├── aura-1.md
│   ├── aura-2-en.md
│   ├── aura-2-es.md
│   ├── bart-large-cnn.md
│   ├── bge-base-en-v1-5.md
│   ├── bge-large-en-v1-5.md
│   ├── bge-m3.md
│   ├── bge-reranker-base.md
│   ├── bge-small-en-v1-5.md
│   ├── changelog.md
│   ├── configuration.md
│   ├── deepseek-coder-6-7b-base-awq.md
│   ├── deepseek-coder-6-7b-instruct-awq.md
│   ├── deepseek-math-7b-instruct.md
│   ├── deepseek-r1-distill-qwen-32b.md
│   ├── demos-and-architectures.md
│   ├── detr-resnet-50.md
│   ├── discolm-german-7b-v1-awq.md
│   ├── distilbert-sst-2-int8.md
│   ├── dreamshaper-8-lcm.md
│   ├── embeddinggemma-300m.md
│   ├── falcon-7b-instruct.md
│   ├── features.md
│   ├── fine-tunes.md
│   ├── flux-1-schnell.md
│   ├── flux-2-dev.md
│   ├── flux.md
│   ├── function-calling.md
│   ├── gemma-2b-it-lora.md
│   ├── gemma-3-12b-it.md
│   ├── gemma-7b-it-lora.md
│   ├── gemma-7b-it.md
│   ├── gemma-sea-lion-v4-27b-it.md
│   ├── get-started-dashboard.md
│   ├── get-started-rest-api.md
│   ├── get-started-workers-and-wrangler.md
│   ├── getting-started.md
│   ├── gpt-oss-120b.md
│   ├── gpt-oss-20b.md
│   ├── granite-4-0-h-micro.md
│   ├── guides.md
│   ├── hermes-2-pro-mistral-7b.md
│   ├── hugging-face-chat-ui.md
│   ├── indictrans2-en-indic-1b.md
│   ├── json-mode.md
│   ├── llama-2-13b-chat-awq.md
│   ├── llama-2-7b-chat-fp16.md
│   ├── llama-2-7b-chat-hf-lora.md
│   ├── llama-2-7b-chat-int8.md
│   ├── llama-3-1-70b-instruct.md
│   ├── llama-3-1-8b-instruct-awq.md
│   ├── llama-3-1-8b-instruct-fast.md
│   ├── llama-3-1-8b-instruct-fp8.md
│   ├── llama-3-1-8b-instruct.md
│   ├── llama-3-2-11b-vision-instruct.md
│   ├── llama-3-2-1b-instruct.md
│   ├── llama-3-2-3b-instruct.md
│   ├── llama-3-3-70b-instruct-fp8-fast.md
│   ├── llama-3-8b-instruct-awq.md
│   ├── llama-3-8b-instruct.md
│   ├── markdown-conversion.md
│   ├── models.md
│   ├── openai-compatible-api-endpoints.md
│   ├── overview.md
│   ├── playground.md
│   ├── prompting.md
│   ├── rest-api-reference.md
│   ├── vercel-ai-sdk.md
│   └── workers-bindings.md
├── platform
│   ├── ai-gateway.md
│   ├── choose-a-data-or-storage-product.md
│   ├── errors.md
│   ├── event-subscriptions.md
│   ├── glossary.md
│   ├── limits.md
│   ├── platform.md
│   ├── pricing.md
│   └── your-data-and-workers-ai.md
└── tutorials
    └── tutorials.md
```
