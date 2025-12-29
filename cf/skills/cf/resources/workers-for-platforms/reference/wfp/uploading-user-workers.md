# Uploading User Workers


[User Workers](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/reference/how-workers-for-platforms-works/#user-workers) contain code written by your end users (end developers).

## Upload User Workers

You can upload user Workers to a namespace via Wrangler or the Cloudflare API. Workers uploaded to a namespace will not appear on the **Workers & Pages** section of the Cloudflare dashboard. Instead, they will appear in a namespace under the [Workers for Platforms](https://dash.cloudflare.com/?to=/:account/workers-for-platforms) tab.

To run Workers uploaded to a namespace, you will need to first create a [dispatch Worker](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/reference/how-workers-for-platforms-works/#dynamic-dispatch-worker) with a [dispatch namespace binding](https://developers.cloudflare.com/workers/wrangler/configuration/#dispatch-namespace-bindings-workers-for-platforms).

### Upload user Workers via Wrangler

Uploading user Workers is supported through [wrangler](https://developers.cloudflare.com/workers/wrangler/) by running the following command:

```sh
npx wrangler deploy --dispatch-namespace <NAMESPACE_NAME>
```

For simplicity, start with wrangler when [getting started](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/get-started/configuration/).

### Upload user Workers via the API

Since you will be deploying Workers on behalf of your users, you will likely want to use the [Workers for Platforms script upload APIs](https://developers.cloudflare.com/api/resources/workers_for_platforms/subresources/dispatch/subresources/namespaces/subresources/scripts/subresources/content/methods/update/) directly instead of Wrangler to have more control over the upload process. The Workers for Platforms script upload API is the same as the [Worker upload API](https://developers.cloudflare.com/api/resources/workers/subresources/scripts/methods/update/), but it will upload the Worker to a [dispatch namespace](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/reference/how-workers-for-platforms-works/#dispatch-namespace) instead of to your account directly. See an example of the REST API [here](https://developers.cloudflare.com/workers/platform/infrastructure-as-code#workers-for-platforms).

## Bindings

You can use any Workers [bindings](https://developers.cloudflare.com/workers/runtime-apis/bindings/) with the dynamic dispatch Worker or any [user Workers](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/get-started/bindings/).

To learn how to extend KV, D1, R2, and other resources to your User Workers through bindings, see [Bindings](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/get-started/bindings/).


