# Changelog


This is a detailed changelog of every update to Browser Rendering. For a higher-level summary of major updates to every Cloudflare product, including Browser Rendering, visit [developers.cloudflare.com/changelog](https://developers.cloudflare.com/changelog/).

[Subscribe to RSS](https://developers.cloudflare.com/browser-rendering/changelog/index.xml)

## 2025-12-04

**Added guidance on allowlisting Browser Rendering in Bot Management**

* Added [FAQ guidance](https://developers.cloudflare.com/browser-rendering/faq/#how-do-i-allowlist-browser-rendering) on how to create a WAF skip rule to allowlist Browser Rendering requests when using Bot Management on your zone.

## 2025-12-03

**Improved AI JSON response parsing and debugging**

* Added `rawAiResponse` field to [`/json` endpoint](https://developers.cloudflare.com/browser-rendering/rest-api/json-endpoint/) error responses, allowing you to inspect the unparsed AI output when JSON parsing fails for easier debugging.
* Improved AI response handling to better distinguish between valid JSON objects, arrays, and invalid payloads, increasing type safety and reliability.

## 2025-10-21

**Added guidance on REST API timeouts and custom fonts**

* Added [REST API timeouts](https://developers.cloudflare.com/browser-rendering/reference/timeouts/) page explaining how Browser Rendering uses independent timers (for page load, selectors, and actions) and how to configure them.
* Updated [Supported fonts](https://developers.cloudflare.com/browser-rendering/reference/supported-fonts/) guide with instructions on using your own custom fonts via `addStyleTag()` in [Playwright](https://developers.cloudflare.com/browser-rendering/playwright/) or [Puppeteer](https://developers.cloudflare.com/browser-rendering/puppeteer/).

## 2025-09-25

**Updates to Playwright, new support for Stagehand, and increased limits**

* [Playwright](https://developers.cloudflare.com/browser-rendering/playwright/) support in Browser Rendering is now GA. We've upgraded to [Playwright v1.55](https://playwright.dev/docs/release-notes#version-155).
* Added support for [Stagehand](https://developers.cloudflare.com/browser-rendering/stagehand/), an open source browser automation framework, powered by [Workers AI](https://developers.cloudflare.com/workers-ai). Stagehand enables developers to build more reliably and flexibly by combining code with natural-language instructions.
* Increased [limits](https://developers.cloudflare.com/browser-rendering/limits/#workers-paid) for paid plans on both the [REST API](https://developers.cloudflare.com/browser-rendering/rest-api/) and [Workers Bindings](https://developers.cloudflare.com/browser-rendering/workers-bindings/).

## 2025-09-22

**Added \`excludeExternalLinks\` parameter to \`/links\` REST endpoint**

* Added `excludeExternalLinks` parameter when using the [`/links` endpoint](https://developers.cloudflare.com/browser-rendering/rest-api/links-endpoint/). When set to `true`, links pointing to outside the domain of the requested URL are excluded.

## 2025-09-02

**Added \`X-Browser-Ms-Used\` response header**

* Each REST API response now includes the `X-Browser-Ms-Used` response header, which reports the browser time (in milliseconds) used by the request.

## 2025-08-20

**Browser Rendering billing goes live**

* Billing for Browser Rendering begins today, August 20th, 2025. See [pricing page](https://developers.cloudflare.com/browser-rendering/pricing/) for full details. You can monitor usage via the [Cloudflare dashboard](https://dash.cloudflare.com/?to=/:account/workers/browser-rendering).

## 2025-08-18

**Wrangler updates to local dev**

* Improved the local development experience by updating the method for downloading the dev mode browser and added support for [`/v1/sessions` endpoint](https://developers.cloudflare.com/platform/puppeteer/#list-open-sessions), allowing you to list open browser rendering sessions. Upgrade to `wrangler@4.31.0` to get started.

## 2025-07-29

**Updates to Playwright, local dev support, and REST API**

* [Playwright](https://developers.cloudflare.com/browser-rendering/playwright/) upgraded to [Playwright v1.54.1](https://github.com/microsoft/playwright/releases/tag/v1.54.1) and [Playwright MCP](https://developers.cloudflare.com/browser-rendering/playwright/playwright-mcp/) upgraded to be in sync with upstream Playwright MCP v0.0.30.
* Local development with `npx wrangler dev` now supports [Playwright](https://developers.cloudflare.com/browser-rendering/playwright/) when using Browser Rendering. Upgrade to the latest version of wrangler to get started.
* The [`/content` endpoint](https://developers.cloudflare.com/browser-rendering/rest-api/content-endpoint/) now returns the page's title, making it easier to identify pages.
* The [`/json` endpoint](https://developers.cloudflare.com/browser-rendering/rest-api/json-endpoint/) now allows you to specify your own AI model for the extraction, using the `custom_ai` parameter.
* The default viewport size on the [`/screenshot` endpoint](https://developers.cloudflare.com/browser-rendering/rest-api/screenshot-endpoint/) has been increased from 800x600 to 1920x1080. You can still override the viewport via request options.

## 2025-07-25

**@cloudflare/puppeteer 1.0.4 released**

* We have released version 1.0.4 of [`@cloudflare/puppeteer`](https://github.com/cloudflare/puppeteer), now in sync with Puppeteer v22.13.1.

## 2025-07-24

**Playwright now supported in local development**

* You can now use Playwright with local development. Upgrade to <wrangler@4.26.0> to get started.

## 2025-07-16

**Pricing update to Browser Rendering**

* Billing for Browser Rendering starts on August 20, 2025, with usage beyond the included [limits](https://developers.cloudflare.com/browser-rendering/limits/) charged according to the new [pricing rates](https://developers.cloudflare.com/browser-rendering/pricing/).

## 2025-07-03

**Local development support**

* We added local development support to Browser Rendering, making it simpler than ever to test and iterate before deploying.

## 2025-06-30

**New Web Bot Auth headers**

* Browser Rendering now supports [Web Bot Auth](https://developers.cloudflare.com/reference/automatic-request-headers/) by automatically attaching `Signature-agent`, `Signature`, and `Signature-input `headers to verify that a request originates from Cloudflare Browser Rendering.

## 2025-06-27

**Bug fix to debug log noise in Workers**

* Fixed an issue where all debug logging was on by default and would flood logs. Debug logs is now off by default but can be re-enabled by setting [`process.env.DEBUG`](https://pptr.dev/guides/debugging#log-devtools-protocol-traffic) when needed.

## 2025-05-26

**Playwright MCP**

* You can now deploy [Playwright MCP](https://developers.cloudflare.com/browser-rendering/playwright/playwright-mcp/) and use any MCP client to get AI models to interact with Browser Rendering.

## 2025-04-30

**Automatic Request Headers**

* [Clarified Automatic Request headers](https://developers.cloudflare.com/browser-rendering/reference/automatic-request-headers/) in Browser Rendering. These headers are unique to Browser Rendering, and are automatically included and cannot be removed or overridden.

## 2025-04-07

**New free tier and REST API GA with additional endpoints**

* Browser Rendering now has a new free tier.
* The [REST API](https://developers.cloudflare.com/browser-rendering/rest-api/) is Generally Available.
* Released new endpoints [`/json`](https://developers.cloudflare.com/browser-rendering/rest-api/json-endpoint/), [`/links`](https://developers.cloudflare.com/browser-rendering/rest-api/links-endpoint/), and [`/markdown`](https://developers.cloudflare.com/browser-rendering/rest-api/markdown-endpoint/).

## 2025-04-04

**Playwright support**

* You can now use [Playwright's](https://developers.cloudflare.com/browser-rendering/playwright/) browser automation capabilities from Cloudflare Workers.

## 2025-02-27

**New Browser Rendering REST API**

* Released a new [REST API](https://developers.cloudflare.com/browser-rendering/rest-api/) in open beta. Available to all customers with a Workers Paid Plan.

## 2025-01-31

**Increased limits**

* Increased the limits on the number of concurrent browsers, and browsers per minute from 2 to 10.

## 2024-08-08

**Update puppeteer to 21.1.0**

* Rebased the fork on the original implementation up till version 21.1.0

## 2024-04-02

**Browser Rendering Available for everyone**

* Browser Rendering is now out of beta and available to all customers with Workers Paid Plan. Analytics and logs are available in Cloudflare's dashboard, under "Worker & Pages".

## 2023-05-19

**Browser Rendering Beta**

* Beta Launch


