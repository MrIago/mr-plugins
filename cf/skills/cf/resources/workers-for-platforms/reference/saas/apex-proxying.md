# Apex proxying


Apex proxying allows your customers to use their apex domains (`example.com`) with your SaaS application.

Note

Only certain customers have access to this feature. For more details, see the [Plans page](https://developers.cloudflare.com/cloudflare-for-platforms/cloudflare-for-saas/plans/).

## Benefits

In a normal Cloudflare for SaaS [setup](https://developers.cloudflare.com/cloudflare-for-platforms/cloudflare-for-saas/start/getting-started/), your customers route traffic to your hostname by creating a `CNAME` record pointing to your CNAME target.

However, most DNS providers do not allow `CNAME` records at the zone's root[1](#user-content-fn-1). This means that your customers have to use a subdomain as a vanity domain (`shop.example.com`) instead of their domain apex (`example.com`).

This limitation does not apply with apex proxying. Cloudflare assigns a set of IP prefixes - cost associated, reach out to your account team - to your account (or uses your own if you have [BYOIP](https://developers.cloudflare.com/byoip/)). This means that customers can create a standard `A` record to route traffic to your domain, which can support the domain apex.

## Setup

* [Set up Apex Proxying](https://developers.cloudflare.com/cloudflare-for-platforms/cloudflare-for-saas/start/advanced-settings/apex-proxying/setup/)

## Footnotes

1. Cloudflare offers this functionality through [CNAME flattening](https://developers.cloudflare.com/dns/cname-flattening/). [↩](#user-content-fnref-1)


