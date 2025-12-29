# Frequently asked questions about Cloudflare Browser Rendering


Below you will find answers to our most commonly asked questions about Browser Rendering.

For pricing questions, visit the [pricing FAQ](https://developers.cloudflare.com/browser-rendering/pricing/#faq). For usage limits questions, visit the [limits FAQ](https://developers.cloudflare.com/browser-rendering/limits/#faq). If you cannot find the answer you are looking for, join us on [Discord](https://discord.cloudflare.com).

***

## Getting started & Development

### Does local development support all Browser Rendering features?

Not yet. Local development currently has the following limitation(s):

* Requests larger than 1 MB are not supported.

Use real headless browser during local development

To interact with a real headless browser during local development, set `"remote" : true` in the Browser binding configuration. Learn more in our [remote bindings documentation](https://developers.cloudflare.com/workers/development-testing/#remote-bindings).

### Will Browser Rendering be detected by Bot Management?

Yes, Browser Rendering requests are always identified as bot traffic by Cloudflare. Cloudflare does not enforce bot protection by default — that is the customer's choice.

If you are attempting to scan your own zone and want Browser Rendering to access your website freely without your bot protection configuration interfering, you can create a WAF skip rule to [allowlist Browser Rendering](https://developers.cloudflare.com/browser-rendering/faq/#how-do-i-allowlist-browser-rendering).

### How do I allowlist Browser Rendering?

1. In the Cloudflare dashboard, go to the **Security rules** page of your account and domain.

   [Go to **Security rules**](https://dash.cloudflare.com/?to=/:account/:zone/security/security-rules)

2. To create a new empty rule, select **Create rule** > **Custom rules**.

3. Enter a descriptive name for the rule in **Rule name**, such as `Allow Browser Rendering`.

4. Under **When incoming requests match**, use the **Field** dropdown to choose *Bot Detection ID*. For **Operator**, select *equals*. For **Value**, enter `128292352`.

5. Under **Then take action**, in the **Choose action** dropdown, select **Skip**.

6. Under **Place at**, select the order of the rule in the **Select order** dropdown to be **First**. Setting the order as **First** allows this rule to be applied before subsequent rules.

7. To save and deploy your rule, select **Deploy**.

### Does Browser Rendering rotate IP addresses for outbound requests?

No. Browser Rendering requests originate from Cloudflare's global network and you cannot configure per-request IP rotation. All rendering traffic comes from Cloudflare IP ranges and requests include [automatic headers](https://developers.cloudflare.com/browser-rendering/reference/automatic-request-headers/), such as `cf-biso-request-id` and `cf-biso-devtools` so origin servers can identify them.

### Is there a limit to how many requests a single browser session can handle?

There is no fixed limit on the number of requests per browser session. A single browser can handle multiple requests as long as it stays within available compute and memory limits.

### Can I use custom fonts in Browser Rendering?

Yes. If your webpage or PDF requires a font that is not pre-installed, you can load custom fonts at render time using `addStyleTag`. This works with both the [REST API](https://developers.cloudflare.com/browser-rendering/rest-api/) and [Workers Bindings](https://developers.cloudflare.com/browser-rendering/workers-bindings/). For instructions and examples, refer to [Use your own custom font](https://developers.cloudflare.com/browser-rendering/reference/supported-fonts/#use-your-own-custom-font).

### How can I manage concurrency and session isolation with Browser Rendering?

If you are hitting concurrency [limits](https://developers.cloudflare.com/browser-rendering/limits/#workers-paid), or want to optimize concurrent browser usage with the [Workers Binding method](https://developers.cloudflare.com/browser-rendering/workers-bindings/), here are a few tips:

* Optimize with tabs or shared browsers: Instead of launching a new browser for each task, consider opening multiple tabs or running multiple actions within the same browser instance.
* [Reuse sessions](https://developers.cloudflare.com/browser-rendering/workers-bindings/reuse-sessions/): You can optimize your setup and decrease startup time by reusing sessions instead of launching a new browser every time. If you are concerned about maintaining test isolation (for example, for tests that depend on a clean environment), we recommend using [incognito browser contexts](https://pptr.dev/api/puppeteer.browser.createbrowsercontext), which isolate cookies and cache with other sessions.

If you are still running into concurrency limits you can [request a higher limit](https://forms.gle/CdueDKvb26mTaepa9).

***

## Errors & Troubleshooting

### `Cannot read properties of undefined (reading 'fetch')`

This error typically occurs because your Puppeteer launch is not receiving the Browser binding. To resolve: Pass your Browser binding into `puppeteer.launch`.

### `Error processing the request: Unable to create new browser: code: 429: message: Browser time limit exceeded for today`

This error indicates you have hit the daily browser-instance limit on the Workers Free plan. [Free-plan accounts are capped at free plan limit is 10 minutes of browser use a day](https://developers.cloudflare.com/browser-rendering/limits/#workers-free) once you exceed those, further creation attempts return a 429 until the next UTC day.

To resolve: [Upgrade to a Workers Paid plan](https://developers.cloudflare.com/workers/platform/pricing/) which allows for more than 10 minutes of usage a day and has higher [limits](https://developers.cloudflare.com/browser-rendering/limits/#workers-paid). If you recently upgraded but still see this error, try redeploying your Worker to ensure your usage is correctly associated with your new plan.

### `422 Unprocessable Entity`

A `422 Unprocessable Entity` error usually means that Browser Rendering wasn’t able to complete an action because of an issue with the site.

This can happen if:

* The website consumes too much memory during rendering.
* The page itself crashed or returned an error before the action completed.
* The request exceeded one of the [timeout limits](https://developers.cloudflare.com/browser-rendering/reference/timeouts/) for page load, element load, or an action.

Most often, this error is caused by a timeout. You can review the different timers and their limits in the [REST API timeouts reference](https://developers.cloudflare.com/browser-rendering/reference/timeouts/).


