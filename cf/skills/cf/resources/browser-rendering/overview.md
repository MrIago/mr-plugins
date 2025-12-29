---
name: cf-browser-rendering
description: Cloudflare Browser Rendering development. Use when taking screenshots, generating PDFs, web scraping, headless browser automation, Puppeteer, or Playwright.
---

# Cloudflare Browser Rendering

Headless browser on Workers. Screenshots, PDFs, scraping, automation.

## Two Options

1. **REST API**: Simple one-off tasks (screenshot, PDF, scrape)
2. **Workers Binding + Puppeteer/Playwright**: Complex multi-step automation

## Setup (Workers Binding)

```jsonc
// wrangler.jsonc
{
  "compatibility_flags": ["nodejs_compat"],
  "browser": {
    "binding": "MYBROWSER"
  }
}
```

```bash
npm i -D @cloudflare/puppeteer
```

## Basic Puppeteer Usage

```typescript
import puppeteer from '@cloudflare/puppeteer';

interface Env {
  MYBROWSER: Fetcher;
}

export default {
  async fetch(request: Request, env: Env) {
    const browser = await puppeteer.launch(env.MYBROWSER);
    const page = await browser.newPage();
    await page.goto('https://example.com');

    const screenshot = await page.screenshot();
    await browser.close();

    return new Response(screenshot, {
      headers: { 'content-type': 'image/png' }
    });
  }
};
```

## Screenshot

```typescript
// Basic screenshot
const screenshot = await page.screenshot();

// Full page
const screenshot = await page.screenshot({ fullPage: true });

// Specific element
const element = await page.$('#my-element');
const screenshot = await element.screenshot();

// JPEG with quality
const screenshot = await page.screenshot({
  type: 'jpeg',
  quality: 80
});
```

## Generate PDF

```typescript
const browser = await puppeteer.launch(env.MYBROWSER);
const page = await browser.newPage();
await page.goto('https://example.com');

const pdf = await page.pdf({
  format: 'A4',
  printBackground: true
});

await browser.close();

return new Response(pdf, {
  headers: { 'content-type': 'application/pdf' }
});
```

## Extract Content

```typescript
// Get HTML
const html = await page.content();

// Get text from element
const text = await page.$eval('h1', el => el.textContent);

// Get all links
const links = await page.$$eval('a', anchors =>
  anchors.map(a => ({ href: a.href, text: a.textContent }))
);

// Evaluate custom JavaScript
const data = await page.evaluate(() => {
  return document.title;
});
```

## Page Interactions

```typescript
// Click
await page.click('button#submit');

// Type
await page.type('input#search', 'hello world');

// Wait for selector
await page.waitForSelector('.loaded');

// Wait for navigation
await Promise.all([
  page.waitForNavigation(),
  page.click('a.next-page')
]);
```

## Viewport & User Agent

```typescript
// Set viewport
await page.setViewport({ width: 1280, height: 720 });

// Set user agent
await page.setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64)...');
```

## Keep Alive (Reuse Sessions)

```typescript
// Keep browser open for 10 minutes
const browser = await puppeteer.launch(env.MYBROWSER, {
  keep_alive: 600000
});

// Later: connect to existing session instead of closing
browser.disconnect();  // NOT browser.close()

// Reconnect to existing session
const sessions = await puppeteer.sessions(env.MYBROWSER);
const freeSession = sessions.find(s => !s.connectionId);
if (freeSession) {
  const browser = await puppeteer.connect(env.MYBROWSER, freeSession.sessionId);
}
```

## Session Management

```typescript
// List active sessions
const sessions = await puppeteer.sessions(env.MYBROWSER);

// List recent sessions (open and closed)
const history = await puppeteer.history(env.MYBROWSER);

// Check limits
const limits = await puppeteer.limits(env.MYBROWSER);
// { maxConcurrentSessions: 2, activeSessions: [...], allowedBrowserAcquisitions: 1 }
```

## REST API (No Worker Needed)

```bash
# Screenshot
curl -X POST 'https://api.cloudflare.com/client/v4/accounts/<accountId>/browser-rendering/screenshot' \
  -H 'Authorization: Bearer <apiToken>' \
  -H 'Content-Type: application/json' \
  -d '{ "url": "https://example.com" }' \
  --output screenshot.png

# PDF
curl -X POST 'https://api.cloudflare.com/client/v4/accounts/<accountId>/browser-rendering/pdf' \
  -H 'Authorization: Bearer <apiToken>' \
  -d '{ "url": "https://example.com" }' \
  --output page.pdf

# Get HTML content
curl -X POST 'https://api.cloudflare.com/client/v4/accounts/<accountId>/browser-rendering/content' \
  -H 'Authorization: Bearer <apiToken>' \
  -d '{ "url": "https://example.com" }'

# Extract markdown
curl -X POST 'https://api.cloudflare.com/client/v4/accounts/<accountId>/browser-rendering/markdown' \
  -H 'Authorization: Bearer <apiToken>' \
  -d '{ "url": "https://example.com" }'

# Scrape elements
curl -X POST 'https://api.cloudflare.com/client/v4/accounts/<accountId>/browser-rendering/scrape' \
  -H 'Authorization: Bearer <apiToken>' \
  -d '{ "url": "https://example.com", "elements": [{ "selector": "h1" }] }'
```

## REST API Endpoints

| Endpoint | Purpose |
|----------|---------|
| `/screenshot` | Capture screenshot |
| `/pdf` | Generate PDF |
| `/content` | Get HTML content |
| `/markdown` | Extract as markdown |
| `/scrape` | Scrape specific elements |
| `/links` | Get all links |
| `/json` | Structured data with AI |
| `/snapshot` | Full page snapshot |

## Durable Objects (Persistent Browser)

```typescript
export class BrowserDO extends DurableObject {
  browser: puppeteer.Browser | null = null;

  async ensureBrowser() {
    if (!this.browser) {
      this.browser = await puppeteer.launch(this.env.MYBROWSER, {
        keep_alive: 600000
      });
    }
    return this.browser;
  }

  async fetch(request: Request) {
    const browser = await this.ensureBrowser();
    const page = await browser.newPage();
    // ... use page
    await page.close();
    return new Response('OK');
  }
}
```

## Local Development

Browser Rendering requires `remote: true` for local dev:

```jsonc
{
  "browser": {
    "binding": "MYBROWSER",
    "remote": true
  }
}
```

## Limits

- Max concurrent sessions: 2 (Free), 4+ (Paid)
- Browser idle timeout: 1 minute (default), 10 minutes (max with keep_alive)
- Request timeout: 30 seconds


## Reference

```
reference/
├── misc
│   ├── browser-rendering.md
│   ├── build-a-web-crawler-with-queues-and-browser-rendering.md
│   ├── changelog.md
│   ├── content-fetch-html.md
│   ├── deploy-a-browser-rendering-worker.md
│   ├── deploy-a-browser-rendering-worker-with-durable-objects.md
│   ├── frequently-asked-questions-about-cloudflare-browser-rendering.md
│   ├── generate-pdfs-using-html-and-css.md
│   ├── get-started.md
│   ├── json-capture-structured-data-using-ai.md
│   ├── limits.md
│   ├── links-retrieve-links-from-a-webpage.md
│   ├── markdown-extract-markdown-from-a-webpage.md
│   ├── mcp-server.md
│   ├── pdf-render-pdf.md
│   ├── playwright-mcp.md
│   ├── playwright.md
│   ├── pricing.md
│   ├── puppeteer.md
│   ├── reference.md
│   ├── rest-api.md
│   ├── reuse-sessions.md
│   ├── scrape-scrape-html-elements.md
│   ├── screenshot-capture-screenshot.md
│   ├── snapshot-take-a-webpage-snapshot.md
│   ├── stagehand.md
│   ├── tutorials.md
│   ├── use-browser-rendering-with-ai.md
│   └── workers-bindings.md
└── reference
    ├── automatic-request-headers.md
    ├── browser-close-reasons.md
    ├── reference.md
    ├── rest-api-timeouts.md
    ├── supported-fonts.md
    └── wrangler.md
```
