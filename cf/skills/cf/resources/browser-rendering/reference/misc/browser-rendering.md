# Browser Rendering


Run headless Chrome on [Cloudflare's global network](https://developers.cloudflare.com/workers/) for browser automation, web scraping, testing, and content generation.

Available on Free and Paid plans

Browser Rendering enables developers to programmatically control and interact with headless browser instances running on Cloudflare’s global network.

## Use Cases

Browser Rendering supports a wide range of use cases, including:

* Extract rendered HTML or convert webpages to Markdown using the [content endpoint](https://developers.cloudflare.com/browser-rendering/rest-api/content-endpoint/) and [markdown endpoint](https://developers.cloudflare.com/browser-rendering/rest-api/markdown-endpoint/)
* Create website thumbnails and social previews using the [screenshot endpoint](https://developers.cloudflare.com/browser-rendering/rest-api/screenshot-endpoint/)
* Generate PDFs from webpages and HTML content using the [pdf endpoint](https://developers.cloudflare.com/browser-rendering/rest-api/pdf-endpoint/)
* Archive complete webpage states with the [snapshot endpoint](https://developers.cloudflare.com/browser-rendering/rest-api/snapshot/) that captures both HTML and screenshots
* Build web scrapers that target specific elements or extract all links using the [scrape endpoint](https://developers.cloudflare.com/browser-rendering/rest-api/scrape-endpoint/) and [links endpoint](https://developers.cloudflare.com/browser-rendering/rest-api/links-endpoint/)
* Parse and structure webpage data into JSON format using the [json endpoint](https://developers.cloudflare.com/browser-rendering/rest-api/json-endpoint/)

Browser Rendering is also ideal for agentic workflows. Use [Puppeteer](https://developers.cloudflare.com/browser-rendering/puppeteer/), [Playwright](https://developers.cloudflare.com/browser-rendering/playwright/), [Playwright MCP](https://developers.cloudflare.com/browser-rendering/playwright/playwright-mcp/), or [Stagehand](https://developers.cloudflare.com/browser-rendering/stagehand/) to power AI agents that interact with web pages and extract data where APIs do not exist.

## Key features

* **Scale to thousands of browsers**: Instant access to a global pool of browsers with low cold-start time, ideal for high-volume screenshot generation, data extraction, or automation at scale
* **Global by default**: Browser sessions run on Cloudflare's edge network, opening close to your users for better speed and availability worldwide
* **Easy to integrate**: [REST APIs](https://developers.cloudflare.com/browser-rendering/rest-api/) for common actions, while [Puppeteer](https://developers.cloudflare.com/browser-rendering/puppeteer/) and [Playwright](https://developers.cloudflare.com/browser-rendering/playwright/) provide familiar automation libraries for complex workflows
* **Session management**: [Reuse browser sessions](https://developers.cloudflare.com/browser-rendering/workers-bindings/reuse-sessions/) across requests to improve performance and reduce cold-start overhead
* **Flexible pricing**: Pay only for browser time used with generous free tier ([view pricing](https://developers.cloudflare.com/browser-rendering/pricing/))

## Integration Methods

You can integrate Browser Rendering into your applications using one of the following methods:

* **[REST API](https://developers.cloudflare.com/browser-rendering/rest-api/)**: Ideal for simple, stateless tasks like capturing screenshots, generating PDFs, extracting HTML content, and more.
* **[Workers Bindings](https://developers.cloudflare.com/browser-rendering/workers-bindings/)**: Suitable for advanced browser automation within [Cloudflare Workers](https://developers.cloudflare.com/workers/). This method provides greater control, enabling more complex workflows and persistent sessions.

Choose the method that best fits your use case. For example, use the [REST API endpoints](https://developers.cloudflare.com/browser-rendering/rest-api/) for straightforward tasks from external applications and use [Workers Bindings](https://developers.cloudflare.com/browser-rendering/workers-bindings/) for complex automation within the Cloudflare ecosystem.

## Related products

**[Workers](https://developers.cloudflare.com/workers/)**

Build serverless applications and deploy instantly across the globe for exceptional performance, reliability, and scale.

**[Durable Objects](https://developers.cloudflare.com/durable-objects/)**

A globally distributed coordination API with strongly consistent storage. Using Durable Objects to [persist browser sessions](https://developers.cloudflare.com/browser-rendering/workers-bindings/browser-rendering-with-do/) improves performance by eliminating the time that it takes to spin up a new browser session.

**[Agents](https://developers.cloudflare.com/agents/)**

Build AI-powered agents that autonomously navigate websites and perform tasks using [Playwright MCP](https://developers.cloudflare.com/browser-rendering/playwright/playwright-mcp/) or [Stagehand](https://developers.cloudflare.com/browser-rendering/stagehand/).

## More resources

[Get started](https://developers.cloudflare.com/browser-rendering/get-started/)

Choose between REST API and Workers Bindings, then deploy your first project.

[Limits](https://developers.cloudflare.com/browser-rendering/limits/)

Learn about Browser Rendering limits.

[Pricing](https://developers.cloudflare.com/browser-rendering/pricing/)

Learn about Browser Rendering pricing.

[Playwright API](https://developers.cloudflare.com/browser-rendering/playwright/)

Use Cloudflare's fork of Playwright for testing and automation.

[Developer Discord](https://discord.cloudflare.com)

Connect with the Workers community on Discord to ask questions, show what you are building, and discuss the platform with other developers.

[@CloudflareDev](https://x.com/cloudflaredev)

Follow @CloudflareDev on Twitter to learn about product announcements, and what is new in Cloudflare Workers.


