## Local access to bindings

As presented in the [getting started](/cloudflare/get-started#12-develop-locally) your application can be both developed (`next dev`) and [previewed locally](/cloudflare/cli#preview-command), in both cases bindings will be accessible from your application's code.

Such bindings are by default local simulation that mimic the behavior of the actual Cloudflare resources.

### Remote bindings

As mentioned above, by default local emulations of the bindings are used.

However [remote bindings](https://developers.cloudflare.com/workers/development-testing/#remote-bindings) can also be
used, allowing your application code, while still running locally, to connect to remote resources associated to your
Cloudflare account.

All you then need to do to enable remote mode for any of your bindings is to set the `remote` configuration field to `true`, just
as documented in the [remote bindings documentation](https://developers.cloudflare.com/workers/development-testing/#remote-bindings).

<Callout type="info">
  The remote bindings APIs have been stabilized in wrangler `4.36.0`, so if you're using an earlier version of wrangler in order to use remote
  bindings you need to enabled it in your `next.config.ts` file:

```diff
- initOpenNextCloudflareForDev();
+ initOpenNextCloudflareForDev({
+  experimental: { remoteBindings: true }
+ });
```

And instead of setting `remote` to bindings configuration options you need to set `experimental_remote`.

</Callout>

<Callout type="info">
  Note that remote bindings will also be used during build, this can be very useful for example when using
  features such [ISR](https://nextjs.org/docs/app/guides/incremental-static-regeneration) so that read
  production data can be used for the site's static generation
</Callout>

