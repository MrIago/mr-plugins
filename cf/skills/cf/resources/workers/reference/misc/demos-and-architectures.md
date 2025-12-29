# Demos and architectures


Learn how you can use Workers within your existing application and architecture.

## Demos

Explore the following demo applications for Workers.

* [Starter code for D1 Sessions API:](https://github.com/cloudflare/templates/tree/main/d1-starter-sessions-api-template) An introduction to D1 Sessions API. This demo simulates purchase orders administration.
* [E-commerce Store:](https://github.com/harshil1712/e-com-d1) An application to showcase D1 read replication in the context of an online store.
* [Gamertown Customer Support Assistant:](https://github.com/craigsdennis/gamertown-workers-ai-vectorize) A RAG based AI Chat app that uses Vectorize to access video game data for employees of Gamertown.
* [shrty.dev:](https://github.com/craigsdennis/shorty-dot-dev) A URL shortener that makes use of KV and Workers Analytics Engine. The admin interface uses Function Calling. Go Shorty!
* [Homie - Home Automation using Function Calling:](https://github.com/craigsdennis/lightbulb-moment-tool-calling) A home automation tool that uses AI Function calling to change the color of lightbulbs in your home.
* [Hackathon Helper:](https://github.com/craigsdennis/hackathon-helper-workers-ai) A series of starters for Hackathons. Get building quicker! Python, Streamlit, Workers, and Pages starters for all your AI needs!
* [Multimodal AI Translator:](https://github.com/elizabethsiegle/cfworkers-ai-translate) This application uses Cloudflare Workers AI to perform multimodal translation of languages via audio and text in the browser.
* [Floor is Llava:](https://github.com/craigsdennis/floor-is-llava-workers-ai) This is an example repo to explore using the AI Vision model Llava hosted on Cloudflare Workers AI. This is a SvelteKit app hosted on Pages.
* [Workers AI Object Detector:](https://github.com/elizabethsiegle/cf-workers-ai-obj-detection-webcam) Detect objects from a webcam in a Cloudflare Worker web app with detr-resnet-50 hosted on Cloudflare using Cloudflare Workers AI.
* [JavaScript-native RPC on Cloudflare Workers <> Named Entrypoints:](https://github.com/cloudflare/js-rpc-and-entrypoints-demo) This is a collection of examples of communicating between multiple Cloudflare Workers using the remote-procedure call (RPC) system that is built into the Workers runtime.
* [Workers for Platforms Example Project:](https://github.com/cloudflare/workers-for-platforms-example) Explore how you could manage thousands of Workers with a single Cloudflare Workers account.
* [Whatever-ify:](https://github.com/craigsdennis/whatever-ify-workers-ai) Turn yourself into...whatever. Take a photo, get a description, generate a scene and character, then generate an image based on that calendar.
* [Cloudflare Workers Chat Demo:](https://github.com/cloudflare/workers-chat-demo) This is a demo app written on Cloudflare Workers utilizing Durable Objects to implement real-time chat with stored history.
* [Phoney AI:](https://github.com/craigsdennis/phoney-ai) This application uses Cloudflare Workers AI, Twilio, and AssemblyAI. Your phone is an input and output device.
* [Vanilla JavaScript Chat Application using Cloudflare Workers AI:](https://github.com/craigsdennis/vanilla-chat-workers-ai) A web based chat interface built on Cloudflare Pages that allows for exploring Text Generation models on Cloudflare Workers AI. Design is built using tailwind.
* [Turnstile Demo:](https://github.com/cloudflare/turnstile-demo-workers) A simple demo with a Turnstile-protected form, using Cloudflare Workers. With the code in this repository, we demonstrate implicit rendering and explicit rendering.
* [Wildebeest:](https://github.com/cloudflare/wildebeest) Wildebeest is an ActivityPub and Mastodon-compatible server whose goal is to allow anyone to operate their Fediverse server and identity on their domain without needing to keep infrastructure, with minimal setup and maintenance, and running in minutes.
* [D1 Northwind Demo:](https://github.com/cloudflare/d1-northwind) This is a demo of the Northwind dataset, running on Cloudflare Workers, and D1 - Cloudflare's SQL database, running on SQLite.
* [Multiplayer Doom Workers:](https://github.com/cloudflare/doom-workers) A WebAssembly Doom port with multiplayer support running on top of Cloudflare's global network using Workers, WebSockets, Pages, and Durable Objects.
* [Queues Web Crawler:](https://github.com/cloudflare/queues-web-crawler) An example use-case for Queues, a web crawler built on Browser Rendering and Puppeteer. The crawler finds the number of links to Cloudflare.com on the site, and archives a screenshot to Workers KV.
* [DMARC Email Worker:](https://github.com/cloudflare/dmarc-email-worker) A Cloudflare worker script to process incoming DMARC reports, store them, and produce analytics.
* [Access External Auth Rule Example Worker:](https://github.com/cloudflare/workers-access-external-auth-example) This is a worker that allows you to quickly setup an external evalutation rule in Cloudflare Access.

## Reference architectures

Explore the following reference architectures that use Workers:

[Fullstack applications](https://developers.cloudflare.com/reference-architecture/diagrams/serverless/fullstack-application/)

[A practical example of how these services come together in a real fullstack application architecture.](https://developers.cloudflare.com/reference-architecture/diagrams/serverless/fullstack-application/)

[Storing user generated content](https://developers.cloudflare.com/reference-architecture/diagrams/storage/storing-user-generated-content/)

[Store user-generated content in R2 for fast, secure, and cost-effective architecture.](https://developers.cloudflare.com/reference-architecture/diagrams/storage/storing-user-generated-content/)

[Optimizing and securing connected transportation systems](https://developers.cloudflare.com/reference-architecture/diagrams/iot/optimizing-and-securing-connected-transportation-systems/)

[This diagram showcases Cloudflare components optimizing connected transportation systems. It illustrates how their technologies minimize latency, ensure reliability, and strengthen security for critical data flow.](https://developers.cloudflare.com/reference-architecture/diagrams/iot/optimizing-and-securing-connected-transportation-systems/)

[Ingesting BigQuery Data into Workers AI](https://developers.cloudflare.com/reference-architecture/diagrams/ai/bigquery-workers-ai/)

[You can connect a Cloudflare Worker to get data from Google BigQuery and pass it to Workers AI, to run AI Models, powered by serverless GPUs.](https://developers.cloudflare.com/reference-architecture/diagrams/ai/bigquery-workers-ai/)

[Event notifications for storage](https://developers.cloudflare.com/reference-architecture/diagrams/storage/event-notifications-for-storage/)

[Use Cloudflare Workers or an external service to monitor for notifications about data changes and then handle them appropriately.](https://developers.cloudflare.com/reference-architecture/diagrams/storage/event-notifications-for-storage/)

[Extend ZTNA with external authorization and serverless computing](https://developers.cloudflare.com/reference-architecture/diagrams/sase/augment-access-with-serverless/)

[Cloudflare's ZTNA enhances access policies using external API calls and Workers for robust security. It verifies user authentication and authorization, ensuring only legitimate access to protected resources.](https://developers.cloudflare.com/reference-architecture/diagrams/sase/augment-access-with-serverless/)

[Cloudflare Security Architecture](https://developers.cloudflare.com/reference-architecture/architectures/security/)

[This document provides insight into how this network and platform are architected from a security perspective, how they are operated, and what services are available for businesses to address their own security challenges.](https://developers.cloudflare.com/reference-architecture/architectures/security/)

[Composable AI architecture](https://developers.cloudflare.com/reference-architecture/diagrams/ai/ai-composable/)

[The architecture diagram illustrates how AI applications can be built end-to-end on Cloudflare, or single services can be integrated with external infrastructure and services.](https://developers.cloudflare.com/reference-architecture/diagrams/ai/ai-composable/)

[A/B-testing using Workers](https://developers.cloudflare.com/reference-architecture/diagrams/serverless/a-b-testing-using-workers/)

[Cloudflare's low-latency, fully serverless compute platform, Workers offers powerful capabilities to enable A/B testing using a server-side implementation.](https://developers.cloudflare.com/reference-architecture/diagrams/serverless/a-b-testing-using-workers/)

[Serverless global APIs](https://developers.cloudflare.com/reference-architecture/diagrams/serverless/serverless-global-apis/)

[An example architecture of a serverless API on Cloudflare and aims to illustrate how different compute and data products could interact with each other.](https://developers.cloudflare.com/reference-architecture/diagrams/serverless/serverless-global-apis/)

[Serverless ETL pipelines](https://developers.cloudflare.com/reference-architecture/diagrams/serverless/serverless-etl/)

[Cloudflare enables fully serverless ETL pipelines, significantly reducing complexity, accelerating time to production, and lowering overall costs.](https://developers.cloudflare.com/reference-architecture/diagrams/serverless/serverless-etl/)

[Egress-free object storage in multi-cloud setups](https://developers.cloudflare.com/reference-architecture/diagrams/storage/egress-free-storage-multi-cloud/)

[Learn how to use R2 to get egress-free object storage in multi-cloud setups.](https://developers.cloudflare.com/reference-architecture/diagrams/storage/egress-free-storage-multi-cloud/)

[Retrieval Augmented Generation (RAG)](https://developers.cloudflare.com/reference-architecture/diagrams/ai/ai-rag/)

[RAG combines retrieval with generative models for better text. It uses external knowledge to create factual, relevant responses, improving coherence and accuracy in NLP tasks like chatbots.](https://developers.cloudflare.com/reference-architecture/diagrams/ai/ai-rag/)

[Automatic captioning for video uploads](https://developers.cloudflare.com/reference-architecture/diagrams/ai/ai-video-caption/)

[By integrating automatic speech recognition technology into video platforms, content creators, publishers, and distributors can reach a broader audience, including individuals with hearing impairments or those who prefer to consume content in different languages.](https://developers.cloudflare.com/reference-architecture/diagrams/ai/ai-video-caption/)

[Serverless image content management](https://developers.cloudflare.com/reference-architecture/diagrams/serverless/serverless-image-content-management/)

[Leverage various components of Cloudflare's ecosystem to construct a scalable image management solution](https://developers.cloudflare.com/reference-architecture/diagrams/serverless/serverless-image-content-management/)


