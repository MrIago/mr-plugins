# bart-large-cnn


f

# bart-large-cnn Beta

Summarization • facebook

@cf/facebook/bart-large-cnn

BART is a transformer encoder-encoder (seq2seq) model with a bidirectional (BERT-like) encoder and an autoregressive (GPT-like) decoder. You can use this model for text summarization.

| Model Info | |
| - | - |
| Beta | Yes |
| Unit Pricing | $0.00 per M input tokens |

## Usage

Workers - TypeScript

```ts
export interface Env {
  AI: Ai;
}


export default {
  async fetch(request, env): Promise<Response> {
    const response = await env.AI.run("@cf/facebook/bart-large-cnn", {
      input_text: "Workers AI allows you to run machine learning models, on the Cloudflare network, from your own code – whether that be from Workers, Pages, or anywhere via the Cloudflare API. With the launch of Workers AI, Cloudflare is slowly rolling out GPUs to its global network. This enables you to build and deploy ambitious AI applications that run near your users, wherever they are.",
      max_length: 14
    });
    return Response.json(response);
  },
} satisfies ExportedHandler<Env>;
```

curl

```sh
curl https://api.cloudflare.com/client/v4/accounts/{cf_account_id}/ai/run/@cf/facebook/bart-large-cnn \
  -H "Authorization: Bearer {cf_api_token}" \
  -d '{
    "input_text": "Workers AI allows you to run machine learning models, on the Cloudflare network, from your own code – whether that be from Workers, Pages, or anywhere via the Cloudflare API. With the launch of Workers AI, Cloudflare is slowly rolling out GPUs to its global network. This enables you to build and deploy ambitious AI applications that run near your users, wherever they are.",
    "max_length": 14
  }'
```

## Parameters

\* indicates a required field

### Input

* `input_text` string required min 1

  The text that you want the model to summarize

* `max_length` integer default 1024

  The maximum length of the generated summary in tokens

### Output

* `summary` string

  The summarized version of the input text

## API Schemas

The following schemas are based on JSON Schema

* Input

  ```json
  {
      "type": "object",
      "properties": {
          "input_text": {
              "type": "string",
              "minLength": 1,
              "description": "The text that you want the model to summarize"
          },
          "max_length": {
              "type": "integer",
              "default": 1024,
              "description": "The maximum length of the generated summary in tokens"
          }
      },
      "required": [
          "input_text"
      ]
  }
  ```

* Output

  ```json
  {
      "type": "object",
      "contentType": "application/json",
      "properties": {
          "summary": {
              "type": "string",
              "description": "The summarized version of the input text"
          }
      }
  }
  ```


