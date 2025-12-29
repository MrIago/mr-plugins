## Other Cloudflare APIs (`cf`, `ctx`)

You can access context about the incoming request from the [`cf` object](https://developers.cloudflare.com/workers/runtime-apis/request/#the-cf-property-requestinitcfproperties), as well as lifecycle methods from the [`ctx` object](https://developers.cloudflare.com/workers/runtime-apis/context) from the return value of [`getCloudflareContext()`](https://github.com/opennextjs/opennextjs-cloudflare/blob/main/packages/cloudflare/src/api/cloudflare-context.ts):

```js
import { getCloudflareContext } from "@opennextjs/cloudflare";

export async function GET(request) {
  const { env, cf, ctx } = getCloudflareContext();

  // ...
}
```

---

import { Callout } from "nextra/components";
import { Tabs } from "nextra/components";

