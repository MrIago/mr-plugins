# distilbert-sst-2-int8


![HuggingFace logo](https://developers.cloudflare.com/_astro/huggingface.DHiS2HZA.svg)

# distilbert-sst-2-int8

Text Classification • HuggingFace

@cf/huggingface/distilbert-sst-2-int8

Distilled BERT model that was finetuned on SST-2 for sentiment classification

| Model Info | |
| - | - |
| More information | [link](https://huggingface.co/Intel/distilbert-base-uncased-finetuned-sst-2-english-int8-static) |
| Unit Pricing | $0.026 per M input tokens |

## Usage

Workers - TypeScript

```ts
export interface Env {
  AI: Ai;
}


export default {
  async fetch(request, env): Promise<Response> {


    const response = await env.AI.run(
      "@cf/huggingface/distilbert-sst-2-int8",
      {
        text: "This pizza is great!",
      }
    );


    return Response.json(response);
  },
} satisfies ExportedHandler<Env>;
```

Python

```py
API_BASE_URL = "https://api.cloudflare.com/client/v4/accounts/{ACCOUNT_ID}/ai/run/"
headers = {"Authorization": "Bearer {API_KEY}"}


def run(model, input):
    response = requests.post(f"{API_BASE_URL}{model}", headers=headers, json=input)
    return response.json()


output = run("@cf/huggingface/distilbert-sst-2-int8", { "text": "This pizza is great!" })
print(output)
```

curl

```sh
curl https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/ai/run/@cf/huggingface/distilbert-sst-2-int8  \
  -X POST  \
  -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN"  \
  -d '{ "text": "This pizza is great!" }'
```

## Parameters

\* indicates a required field

### Input

* `text` string required min 1

  The text that you want to classify

### Output

* `items` object

  * `score` number

    Confidence score indicating the likelihood that the text belongs to the specified label

  * `label` string

    The classification label assigned to the text (e.g., 'POSITIVE' or 'NEGATIVE')

## API Schemas

The following schemas are based on JSON Schema

* Input

  ```json
  {
      "type": "object",
      "properties": {
          "text": {
              "type": "string",
              "minLength": 1,
              "description": "The text that you want to classify"
          }
      },
      "required": [
          "text"
      ]
  }
  ```

* Output

  ```json
  {
      "type": "array",
      "contentType": "application/json",
      "description": "An array of classification results for the input text",
      "items": {
          "type": "object",
          "properties": {
              "score": {
                  "type": "number",
                  "description": "Confidence score indicating the likelihood that the text belongs to the specified label"
              },
              "label": {
                  "type": "string",
                  "description": "The classification label assigned to the text (e.g., 'POSITIVE' or 'NEGATIVE')"
              }
          }
      }
  }
  ```


