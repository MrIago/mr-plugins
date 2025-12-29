# Demos and architectures


Workers AI can be used to build dynamic and performant services. The following demo applications and reference architectures showcase how to use Workers AI optimally within your architecture.

## Demos

Explore the following demo applications for Workers AI.

* [Gamertown Customer Support Assistant:](https://github.com/craigsdennis/gamertown-workers-ai-vectorize) A RAG based AI Chat app that uses Vectorize to access video game data for employees of Gamertown.
* [Jobs At Conf:](https://github.com/harshil1712/jobs-at-conf-demo) A job lisiting website to add jobs you find at in-person conferences. Built with Cloudflare Pages, R2, D1, Queues, and Workers AI.
* [LoRA News Summarizer:](https://github.com/elizabethsiegle/cf-ai-lora-news-summarizer) This application uses Cloudflare Workers AI, Streamlit, and Beautiful Soup to summarize input news article URLs in a variety of tones.
* [shrty.dev:](https://github.com/craigsdennis/shorty-dot-dev) A URL shortener that makes use of KV and Workers Analytics Engine. The admin interface uses Function Calling. Go Shorty!
* [Fanfic Generator:](https://github.com/elizabethsiegle/star-wars-fanfic-generator-streamlit-astra-cf) This application uses Cloudflare Workers AI, Streamlit, and AstraDB to generate personal scifi fanfiction.
* [Homie - Home Automation using Function Calling:](https://github.com/craigsdennis/lightbulb-moment-tool-calling) A home automation tool that uses AI Function calling to change the color of lightbulbs in your home.
* [Hackathon Helper:](https://github.com/craigsdennis/hackathon-helper-workers-ai) A series of starters for Hackathons. Get building quicker! Python, Streamlit, Workers, and Pages starters for all your AI needs!
* [NBA Finals Polling and Predictor:](https://github.com/elizabethsiegle/nbafinals-cloudflare-ai-hono-durable-objects) This stateful polling application uses Cloudflare Workers AI, Cloudflare Pages, Cloudflare Durable Objects, and Hono to keep track of users' votes for different basketball teams and generates personal predictions for the series.
* [Multimodal AI Translator:](https://github.com/elizabethsiegle/cfworkers-ai-translate) This application uses Cloudflare Workers AI to perform multimodal translation of languages via audio and text in the browser.
* [Floor is Llava:](https://github.com/craigsdennis/floor-is-llava-workers-ai) This is an example repo to explore using the AI Vision model Llava hosted on Cloudflare Workers AI. This is a SvelteKit app hosted on Pages.
* [Workers AI Object Detector:](https://github.com/elizabethsiegle/cf-workers-ai-obj-detection-webcam) Detect objects from a webcam in a Cloudflare Worker web app with detr-resnet-50 hosted on Cloudflare using Cloudflare Workers AI.
* [Comically Bad Art Generation:](https://github.com/craigsdennis/comically-bad-art-workers-ai-streamlit) This app uses the wonderful Python UI Framework Streamlit and Cloudflare Workers AI.
* [Whatever-ify:](https://github.com/craigsdennis/whatever-ify-workers-ai) Turn yourself into...whatever. Take a photo, get a description, generate a scene and character, then generate an image based on that calendar.
* [Phoney AI:](https://github.com/craigsdennis/phoney-ai) This application uses Cloudflare Workers AI, Twilio, and AssemblyAI. Your phone is an input and output device.
* [Image Model Streamlit starters:](https://github.com/craigsdennis/image-model-streamlit-workers-ai) Collection of Streamlit applications that are making use of Cloudflare Workers AI.
* [Vanilla JavaScript Chat Application using Cloudflare Workers AI:](https://github.com/craigsdennis/vanilla-chat-workers-ai) A web based chat interface built on Cloudflare Pages that allows for exploring Text Generation models on Cloudflare Workers AI. Design is built using tailwind.

## Reference architectures

Explore the following reference architectures that use Workers AI:

[Fullstack applications](https://developers.cloudflare.com/reference-architecture/diagrams/serverless/fullstack-application/)

[A practical example of how these services come together in a real fullstack application architecture.](https://developers.cloudflare.com/reference-architecture/diagrams/serverless/fullstack-application/)

[Storing user generated content](https://developers.cloudflare.com/reference-architecture/diagrams/storage/storing-user-generated-content/)

[Store user-generated content in R2 for fast, secure, and cost-effective architecture.](https://developers.cloudflare.com/reference-architecture/diagrams/storage/storing-user-generated-content/)

[Optimizing and securing connected transportation systems](https://developers.cloudflare.com/reference-architecture/diagrams/iot/optimizing-and-securing-connected-transportation-systems/)

[This diagram showcases Cloudflare components optimizing connected transportation systems. It illustrates how their technologies minimize latency, ensure reliability, and strengthen security for critical data flow.](https://developers.cloudflare.com/reference-architecture/diagrams/iot/optimizing-and-securing-connected-transportation-systems/)

[Ingesting BigQuery Data into Workers AI](https://developers.cloudflare.com/reference-architecture/diagrams/ai/bigquery-workers-ai/)

[You can connect a Cloudflare Worker to get data from Google BigQuery and pass it to Workers AI, to run AI Models, powered by serverless GPUs.](https://developers.cloudflare.com/reference-architecture/diagrams/ai/bigquery-workers-ai/)

[Multi-vendor AI observability and control](https://developers.cloudflare.com/reference-architecture/diagrams/ai/ai-multivendor-observability-control/)

[By shifting features such as rate limiting, caching, and error handling to the proxy layer, organizations can apply unified configurations across services and inference service providers.](https://developers.cloudflare.com/reference-architecture/diagrams/ai/ai-multivendor-observability-control/)

[Composable AI architecture](https://developers.cloudflare.com/reference-architecture/diagrams/ai/ai-composable/)

[The architecture diagram illustrates how AI applications can be built end-to-end on Cloudflare, or single services can be integrated with external infrastructure and services.](https://developers.cloudflare.com/reference-architecture/diagrams/ai/ai-composable/)

[Content-based asset creation](https://developers.cloudflare.com/reference-architecture/diagrams/ai/ai-asset-creation/)

[AI systems combine text-generation and text-to-image models to create visual content from text. They generate prompts, moderate content, and produce images for various applications.](https://developers.cloudflare.com/reference-architecture/diagrams/ai/ai-asset-creation/)

[Retrieval Augmented Generation (RAG)](https://developers.cloudflare.com/reference-architecture/diagrams/ai/ai-rag/)

[RAG combines retrieval with generative models for better text. It uses external knowledge to create factual, relevant responses, improving coherence and accuracy in NLP tasks like chatbots.](https://developers.cloudflare.com/reference-architecture/diagrams/ai/ai-rag/)

[Automatic captioning for video uploads](https://developers.cloudflare.com/reference-architecture/diagrams/ai/ai-video-caption/)

[By integrating automatic speech recognition technology into video platforms, content creators, publishers, and distributors can reach a broader audience, including individuals with hearing impairments or those who prefer to consume content in different languages.](https://developers.cloudflare.com/reference-architecture/diagrams/ai/ai-video-caption/)

[Serverless image content management](https://developers.cloudflare.com/reference-architecture/diagrams/serverless/serverless-image-content-management/)

[Leverage various components of Cloudflare's ecosystem to construct a scalable image management solution](https://developers.cloudflare.com/reference-architecture/diagrams/serverless/serverless-image-content-management/)


