## TypeScript type declarations for bindings

To ensure that the `env` object from `getCloudflareContext().env` above has accurate TypeScript types, run the following Wrangler command to [generate types that match your Worker's configuration](https://developers.cloudflare.com/workers/languages/typescript/#generate-types-that-match-your-workers-configuration-experimental):

```
npx wrangler types --env-interface CloudflareEnv
```

This will generate a `d.ts` file and save it to `worker-configuration.d.ts`.

To ensure that your types are always up-to-date, make sure to run `wrangler types --env-interface CloudflareEnv` after any changes to your config file.

