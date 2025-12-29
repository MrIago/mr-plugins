# flux-2-dev


![Black Forest Labs logo](https://developers.cloudflare.com/_astro/blackforestlabs.Ccs-Y4-D.svg)

# flux-2-dev

Text-to-Image • Black Forest Labs

@cf/black-forest-labs/flux-2-dev

FLUX.2 \[dev] is an image model from Black Forest Labs where you can generate highly realistic and detailed images, with multi-reference support.

| Model Info | |
| - | - |
| Terms and License | [link](https://bfl.ai/legal/terms-of-service) |
| Partner | Yes |
| Unit Pricing | $0.00021 per input 512x512 tile, per step, $0.00041 per output 512x512 tile, per step |

## Usage

Workers - TypeScript

```ts
export interface Env {
  AI: Ai;
}


export default {
  async fetch(request, env): Promise<Response> {
    const form = new FormData();
    form.append('prompt', 'a sunset with a dog');
    form.append('width', '1024');
    form.append('height', '1024');


    const formRequest = new Request('http://dummy', {
      method: 'POST',
      body: form
    });
    const formStream = formRequest.body;
    const formContentType = formRequest.headers.get('content-type') || 'multipart/form-data';


    const resp = await env.AI.run("@cf/black-forest-labs/flux-2-dev", {
      multipart: {
        body: formStream,
        contentType: formContentType
      }
    });


    return Response.json(resp);
  },
} satisfies ExportedHandler<Env>;
```

curl

```sh
curl --request POST \
  --url 'https://api.cloudflare.com/client/v4/accounts/{ACCOUNT}/ai/run/@cf/black-forest-labs/flux-2-dev' \
  --header 'Authorization: Bearer {TOKEN}' \
  --header 'Content-Type: multipart/form-data' \
  --form 'prompt=a sunset at the alps' \
  --form steps=25 \
  --form width=1024 \
  --form height=1024
```

## Parameters

\* indicates a required field

### Input

* `multipart` object

  * `body` object required

  * `contentType` string required

### Output

* `image` string

  Generated image as Base64 string.

## API Schemas

The following schemas are based on JSON Schema

* Input

  ```json
  {
      "type": "object",
      "properties": {
          "multipart": {
              "type": "object",
              "properties": {
                  "body": {
                      "type": "object"
                  },
                  "contentType": {
                      "type": "string"
                  }
              },
              "required": [
                  "body",
                  "contentType"
              ]
          },
          "required": [
              "multipart"
          ]
      }
  }
  ```

* Output

  ```json
  {
      "type": "object",
      "properties": {
          "image": {
              "type": "string",
              "description": "Generated image as Base64 string."
          }
      }
  }
  ```


