# REST API


The REST API is a RESTful interface that provides endpoints for common browser actions such as capturing screenshots, extracting HTML content, generating PDFs, and more. The following are the available options:

* [/content - Fetch HTML](https://developers.cloudflare.com/browser-rendering/rest-api/content-endpoint/)
* [/screenshot - Capture screenshot](https://developers.cloudflare.com/browser-rendering/rest-api/screenshot-endpoint/)
* [/pdf - Render PDF](https://developers.cloudflare.com/browser-rendering/rest-api/pdf-endpoint/)
* [/snapshot - Take a webpage snapshot](https://developers.cloudflare.com/browser-rendering/rest-api/snapshot/)
* [/scrape - Scrape HTML elements](https://developers.cloudflare.com/browser-rendering/rest-api/scrape-endpoint/)
* [/json - Capture structured data using AI](https://developers.cloudflare.com/browser-rendering/rest-api/json-endpoint/)
* [/links - Retrieve links from a webpage](https://developers.cloudflare.com/browser-rendering/rest-api/links-endpoint/)
* [/markdown - Extract Markdown from a webpage](https://developers.cloudflare.com/browser-rendering/rest-api/markdown-endpoint/)
* [Reference](https://developers.cloudflare.com/api/resources/browser_rendering/)

Use the REST API when you need a fast, simple way to perform common browser tasks such as capturing screenshots, extracting HTML, or generating PDFs without writing complex scripts. If you require more advanced automation, custom workflows, or persistent browser sessions, [Workers Bindings](https://developers.cloudflare.com/browser-rendering/workers-bindings/) are the better choice.

## Before you begin

Before you begin, make sure you [create a custom API Token](https://developers.cloudflare.com/fundamentals/api/get-started/create-token/) with the following permissions:

* `Browser Rendering - Edit`

Note

You can monitor Browser Rendering usage in two ways:

* In the Cloudflare dashboard, go to the **Browser Rendering** page to view aggregate metrics, including total REST API requests and total browser hours used. [Go to **Browser Rendering**](https://dash.cloudflare.com/?to=/:account/workers/browser-rendering)
* `X-Browser-Ms-Used` header: Returned in every REST API response, reporting browser time used for that request (in milliseconds).


