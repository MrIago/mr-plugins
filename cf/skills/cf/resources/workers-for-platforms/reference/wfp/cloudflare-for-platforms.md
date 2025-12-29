# Cloudflare for Platforms


Build your own multitenant platform using Cloudflare as infrastructure

Cloudflare for Platforms lets you run untrusted code written by your customers, or by AI, in a secure, hosted sandbox, and give each customer their own subdomain or custom domain.

![Figure 1: Cloudflare for Platforms Architecture Diagram](https://developers.cloudflare.com/_astro/programmable-platforms-2.DGAT6ZDR_ZG0FdN.svg)

You can think of Cloudflare for Platforms as the exact same products and functionality that Cloudflare offers its own customers, structured so that you can offer it to your own customers, embedded within your own product. This includes:

* **Isolation and multitenancy** — each of your customers runs code in their own Worker — a [secure and isolated sandbox](https://developers.cloudflare.com/workers/reference/how-workers-works/)
* **Programmable routing, ingress, egress and limits** — you write code that dispatches requests to your customers' code, and can control [ingress](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/get-started/dynamic-dispatch/), [egress](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/configuration/outbound-workers/) and set [per-customer limits](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/configuration/custom-limits/)
* **Databases and storage** — you can provide [databases, object storage and more](https://developers.cloudflare.com/workers/runtime-apis/bindings/) to your customers as APIs they can call directly, without API tokens, keys, or external dependencies
* **Custom Domains and Subdomains** — you [call an API](https://developers.cloudflare.com/cloudflare-for-platforms/cloudflare-for-saas/) to create custom subdomains or configure custom domains for each of your customers

Cloudflare for Platforms is used by leading platforms big and small to:

* Build application development platforms tailored to specific domains, like ecommerce storefronts or mobile apps
* Power AI coding platforms that let anyone build and deploy software
* Customize product behavior by allowing any user to write a short code snippet
* Offer every customer their own isolated database
* Provide each customer with their own subdomain

***

## Products

### Workers for Platforms

Let your customers build and deploy their own applications to your platform, using Cloudflare's developer platform.

[Use Workers for Platforms](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/)

### Cloudflare for SaaS

Give your customers their own subdomain or custom domain, protected and accelerated by Cloudflare.

[Use Cloudflare for SaaS](https://developers.cloudflare.com/cloudflare-for-platforms/cloudflare-for-saas/)


