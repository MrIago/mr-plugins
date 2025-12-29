# 3rd Party Integrations


## Background

Connect to databases by configuring connection strings and credentials as [secrets](https://developers.cloudflare.com/workers/configuration/secrets/) in your Worker.

Connecting to a regional database from a Worker?

If your Worker is connecting to a regional database, you can reduce your query latency by using [Hyperdrive](https://developers.cloudflare.com/hyperdrive) and [Smart Placement](https://developers.cloudflare.com/workers/configuration/smart-placement/) which are both included in any Workers plan. Hyperdrive will pool your databases connections globally across Cloudflare's network. Smart Placement will monitor your application to run your Workers closest to your backend infrastructure when this reduces the latency of your Worker invocations. Learn more about [how Smart Placement works](https://developers.cloudflare.com/workers/configuration/smart-placement/).

## Database credentials

When you rotate or update database credentials, you must update the corresponding [secrets](https://developers.cloudflare.com/workers/configuration/secrets/) in your Worker. Use the [`wrangler secret put`](https://developers.cloudflare.com/workers/wrangler/commands/#secret) command to update secrets securely or update the secret directly in the [Cloudflare dashboard](https://dash.cloudflare.com/?to=/:account/workers/services/view/:worker/production/settings).

## Database limits

You can connect to multiple databases by configuring separate sets of secrets for each database connection. Use descriptive secret names to distinguish between different database connections (for example, `DATABASE_URL_PROD` and `DATABASE_URL_STAGING`).

## Popular providers

* [Neon](https://developers.cloudflare.com/workers/databases/third-party-integrations/neon/)
* [PlanetScale](https://developers.cloudflare.com/workers/databases/third-party-integrations/planetscale/)
* [Supabase](https://developers.cloudflare.com/workers/databases/third-party-integrations/supabase/)
* [Turso](https://developers.cloudflare.com/workers/databases/third-party-integrations/turso/)
* [Upstash](https://developers.cloudflare.com/workers/databases/third-party-integrations/upstash/)
* [Xata](https://developers.cloudflare.com/workers/databases/third-party-integrations/xata/)


