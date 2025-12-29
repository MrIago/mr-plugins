---
name: cf-wrangler-commands
description: Wrangler CLI commands reference. Use when deploying Workers, managing D1, KV, R2, Queues, secrets, or any Cloudflare resource via CLI.
---

# Wrangler Commands

CLI for Cloudflare Workers. Deploy, develop, manage resources.

## Core Commands

```bash
# Development
npx wrangler dev                    # Start local dev server
npx wrangler dev --remote           # Dev with remote resources

# Deploy
npx wrangler deploy                 # Deploy Worker
npx wrangler deploy --dry-run       # Test build without deploying

# Auth
npx wrangler login                  # Authenticate
npx wrangler logout                 # Remove auth
npx wrangler whoami                 # Check auth status
```

## D1 (SQLite)

```bash
# Database management
npx wrangler d1 create <NAME>                    # Create database
npx wrangler d1 list                             # List all databases
npx wrangler d1 info <NAME>                      # Get database info
npx wrangler d1 delete <NAME>                    # Delete database

# Queries
npx wrangler d1 execute <NAME> --command "SELECT * FROM users"
npx wrangler d1 execute <NAME> --file ./schema.sql
npx wrangler d1 execute <NAME> --command "..." --remote  # Run on production

# Migrations
npx wrangler d1 migrations create <NAME> <DESCRIPTION>
npx wrangler d1 migrations list <NAME>
npx wrangler d1 migrations apply <NAME>
npx wrangler d1 migrations apply <NAME> --remote

# Backup & Export
npx wrangler d1 backup create <NAME>
npx wrangler d1 backup list <NAME>
npx wrangler d1 export <NAME> --output ./backup.sql
```

## KV (Key-Value)

```bash
# Namespace management
npx wrangler kv namespace create <NAMESPACE>
npx wrangler kv namespace create <NAMESPACE> --preview
npx wrangler kv namespace list
npx wrangler kv namespace delete --namespace-id <ID>

# Key operations
npx wrangler kv key put <KEY> <VALUE> --namespace-id <ID>
npx wrangler kv key put <KEY> --path ./file.txt --namespace-id <ID>
npx wrangler kv key get <KEY> --namespace-id <ID>
npx wrangler kv key delete <KEY> --namespace-id <ID>
npx wrangler kv key list --namespace-id <ID>

# Bulk operations
npx wrangler kv bulk put ./data.json --namespace-id <ID>
npx wrangler kv bulk delete ./keys.json --namespace-id <ID>
```

## R2 (Object Storage)

```bash
# Bucket management
npx wrangler r2 bucket create <NAME>
npx wrangler r2 bucket list
npx wrangler r2 bucket delete <NAME>

# Object operations
npx wrangler r2 object put <BUCKET>/<KEY> --file ./file.txt
npx wrangler r2 object get <BUCKET>/<KEY>
npx wrangler r2 object delete <BUCKET>/<KEY>
```

## Secrets

```bash
# Manage secrets
npx wrangler secret put <KEY>                    # Prompts for value
echo "value" | npx wrangler secret put <KEY>     # Pipe value
npx wrangler secret list
npx wrangler secret delete <KEY>

# Bulk secrets from JSON
npx wrangler secret bulk ./secrets.json
# Format: { "KEY1": "value1", "KEY2": "value2" }
```

## Queues

```bash
# Queue management
npx wrangler queues create <NAME>
npx wrangler queues list
npx wrangler queues delete <NAME>

# Consumer management
npx wrangler queues consumer add <QUEUE> <SCRIPT>
npx wrangler queues consumer remove <QUEUE> <SCRIPT>
```

## Containers

```bash
npx wrangler containers list                     # List containers
npx wrangler containers images list              # List container images
```

## Hyperdrive

```bash
npx wrangler hyperdrive create <NAME> --connection-string <POSTGRES_URL>
npx wrangler hyperdrive list
npx wrangler hyperdrive get <ID>
npx wrangler hyperdrive update <ID> --origin-password <PASSWORD>
npx wrangler hyperdrive delete <ID>
```

## Workflows

```bash
npx wrangler workflows list
npx wrangler workflows describe <NAME>
npx wrangler workflows trigger <NAME>            # Start workflow
npx wrangler workflows trigger <NAME> --params '{"key": "value"}'
npx wrangler workflows instances list <NAME>
npx wrangler workflows instances describe <NAME> <INSTANCE_ID>
npx wrangler workflows instances terminate <NAME> <INSTANCE_ID>
```

## Vectorize

```bash
npx wrangler vectorize create <NAME> --dimensions 768 --metric cosine
npx wrangler vectorize list
npx wrangler vectorize get <NAME>
npx wrangler vectorize delete <NAME>
npx wrangler vectorize insert <NAME> --file ./vectors.ndjson
npx wrangler vectorize query <NAME> --vector "[0.1, 0.2, ...]" --top-k 5
```

## Workers for Platforms

```bash
# Dispatch namespaces
npx wrangler dispatch-namespace create <NAME>
npx wrangler dispatch-namespace list
npx wrangler dispatch-namespace get <NAME>
npx wrangler dispatch-namespace delete <NAME>

# Deploy to namespace
npx wrangler deploy --dispatch-namespace <NAMESPACE>
```

## Versions & Deployments

```bash
# View versions
npx wrangler versions list
npx wrangler versions view <VERSION_ID>

# View deployments
npx wrangler deployments list
npx wrangler deployments view <DEPLOYMENT_ID>

# Rollback
npx wrangler rollback <VERSION_ID>
```

## Logs & Debugging

```bash
npx wrangler tail                    # Stream live logs
npx wrangler tail --format json      # JSON format
npx wrangler tail --status error     # Filter by status
```

## Types & Validation

```bash
npx wrangler types                   # Generate TypeScript types from bindings
npx wrangler check                   # Validate Worker
```

## Dev Options

```bash
npx wrangler dev \
  --port 8787 \                      # Custom port
  --ip 0.0.0.0 \                     # Listen on all interfaces
  --remote \                         # Use remote resources
  --persist-to ./data \              # Persist local state
  --test-scheduled                   # Enable /__scheduled endpoint
```

## Deploy Options

```bash
npx wrangler deploy \
  --name my-worker \                 # Override name
  --env production \                 # Deploy to environment
  --var KEY:value \                  # Inject variables
  --minify \                         # Minify output
  --keep-vars                        # Keep dashboard vars
```

## Global Flags

```bash
--help                               # Show help
--config <path>                      # Custom config path
--env <name>                         # Select environment
--cwd <path>                         # Change working directory
```



## Reference

```
reference/
├── cert.md
├── check.md
├── containers.md
├── d1.md
├── delete.md
├── deploy.md
├── deployments.md
├── dev.md
├── dispatch-namespace.md
├── docs.md
├── how-to-run-wrangler-commands.md
├── hyperdrive.md
├── init.md
├── kv-bulk.md
├── kv-key.md
├── kv-namespace.md
├── login.md
├── logout.md
├── mtls-certificate.md
├── pages.md
├── pipelines.md
├── queues.md
├── r2-bucket.md
├── r2-object.md
├── r2-sql.md
├── rollback.md
├── secret.md
├── secrets-store-secret.md
├── secrets-store-store.md
├── tail.md
├── telemetry.md
├── triggers.md
├── types.md
├── vectorize.md
├── versions.md
├── whoami.md
└── workflows.md
```
