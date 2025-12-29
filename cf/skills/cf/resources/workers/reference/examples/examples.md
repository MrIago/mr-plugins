# Examples


Explore the following examples for Workers.

Filter resources...

[HTTP Basic Authentication](https://developers.cloudflare.com/workers/examples/basic-auth/)

[Shows how to restrict access using the HTTP Basic schema.](https://developers.cloudflare.com/workers/examples/basic-auth/)

[Fetch HTML](https://developers.cloudflare.com/workers/examples/fetch-html/)

[Send a request to a remote server, read HTML from the response, and serve that HTML.](https://developers.cloudflare.com/workers/examples/fetch-html/)

[Return small HTML page](https://developers.cloudflare.com/workers/examples/return-html/)

[Deliver an HTML page from an HTML string directly inside the Worker script.](https://developers.cloudflare.com/workers/examples/return-html/)

[Return JSON](https://developers.cloudflare.com/workers/examples/return-json/)

[Return JSON directly from a Worker script, useful for building APIs and middleware.](https://developers.cloudflare.com/workers/examples/return-json/)

[Sign requests](https://developers.cloudflare.com/workers/examples/signing-requests/)

[Verify a signed request using the HMAC and SHA-256 algorithms or return a 403.](https://developers.cloudflare.com/workers/examples/signing-requests/)

[103 Early Hints](https://developers.cloudflare.com/workers/examples/103-early-hints/)

[Allow a client to request static assets while waiting for the HTML response.](https://developers.cloudflare.com/workers/examples/103-early-hints/)

[A/B testing with same-URL direct access](https://developers.cloudflare.com/workers/examples/ab-testing/)

[Set up an A/B test by controlling what response is served based on cookies. This version supports passing the request through to test and control on the origin, bypassing random assignment.](https://developers.cloudflare.com/workers/examples/ab-testing/)

[Accessing the Cloudflare Object](https://developers.cloudflare.com/workers/examples/accessing-the-cloudflare-object/)

[Access custom Cloudflare properties and control how Cloudflare features are applied to every request.](https://developers.cloudflare.com/workers/examples/accessing-the-cloudflare-object/)

[Aggregate requests](https://developers.cloudflare.com/workers/examples/aggregate-requests/)

[Send two GET request to two urls and aggregates the responses into one response.](https://developers.cloudflare.com/workers/examples/aggregate-requests/)

[Alter headers](https://developers.cloudflare.com/workers/examples/alter-headers/)

[Example of how to add, change, or delete headers sent in a request or returned in a response.](https://developers.cloudflare.com/workers/examples/alter-headers/)

[Auth with headers](https://developers.cloudflare.com/workers/examples/auth-with-headers/)

[Allow or deny a request based on a known pre-shared key in a header. This is not meant to replace the WebCrypto API.](https://developers.cloudflare.com/workers/examples/auth-with-headers/)

[Block on TLS](https://developers.cloudflare.com/workers/examples/block-on-tls/)

[Inspects the incoming request's TLS version and blocks if under TLSv1.2.](https://developers.cloudflare.com/workers/examples/block-on-tls/)

[Bulk origin override](https://developers.cloudflare.com/workers/examples/bulk-origin-proxy/)

[Resolve requests to your domain to a set of proxy third-party origin URLs.](https://developers.cloudflare.com/workers/examples/bulk-origin-proxy/)

[Bulk redirects](https://developers.cloudflare.com/workers/examples/bulk-redirects/)

[Redirect requests to certain URLs based on a mapped object to the request's URL.](https://developers.cloudflare.com/workers/examples/bulk-redirects/)

[Using the Cache API](https://developers.cloudflare.com/workers/examples/cache-api/)

[Use the Cache API to store responses in Cloudflare's cache.](https://developers.cloudflare.com/workers/examples/cache-api/)

[Cache POST requests](https://developers.cloudflare.com/workers/examples/cache-post-request/)

[Cache POST requests using the Cache API.](https://developers.cloudflare.com/workers/examples/cache-post-request/)

[Cache Tags using Workers](https://developers.cloudflare.com/workers/examples/cache-tags/)

[Send Additional Cache Tags using Workers](https://developers.cloudflare.com/workers/examples/cache-tags/)

[Cache using fetch](https://developers.cloudflare.com/workers/examples/cache-using-fetch/)

[Determine how to cache a resource by setting TTLs, custom cache keys, and cache headers in a fetch request.](https://developers.cloudflare.com/workers/examples/cache-using-fetch/)

[Conditional response](https://developers.cloudflare.com/workers/examples/conditional-response/)

[Return a response based on the incoming request's URL, HTTP method, User Agent, IP address, ASN or device type.](https://developers.cloudflare.com/workers/examples/conditional-response/)

[CORS header proxy](https://developers.cloudflare.com/workers/examples/cors-header-proxy/)

[Add the necessary CORS headers to a third party API response.](https://developers.cloudflare.com/workers/examples/cors-header-proxy/)

[Country code redirect](https://developers.cloudflare.com/workers/examples/country-code-redirect/)

[Redirect a response based on the country code in the header of a visitor.](https://developers.cloudflare.com/workers/examples/country-code-redirect/)

[Data loss prevention](https://developers.cloudflare.com/workers/examples/data-loss-prevention/)

[Protect sensitive data to prevent data loss, and send alerts to a webhooks server in the event of a data breach.](https://developers.cloudflare.com/workers/examples/data-loss-prevention/)

[Setting Cron Triggers](https://developers.cloudflare.com/workers/examples/cron-trigger/)

[Set a Cron Trigger for your Worker.](https://developers.cloudflare.com/workers/examples/cron-trigger/)

[Debugging logs](https://developers.cloudflare.com/workers/examples/debugging-logs/)

[Send debugging information in an errored response to a logging service.](https://developers.cloudflare.com/workers/examples/debugging-logs/)

[Cookie parsing](https://developers.cloudflare.com/workers/examples/extract-cookie-value/)

[Given the cookie name, get the value of a cookie. You can also use cookies for A/B testing.](https://developers.cloudflare.com/workers/examples/extract-cookie-value/)

[Fetch JSON](https://developers.cloudflare.com/workers/examples/fetch-json/)

[Send a GET request and read in JSON from the response. Use to fetch external data.](https://developers.cloudflare.com/workers/examples/fetch-json/)

[Geolocation: Weather application](https://developers.cloudflare.com/workers/examples/geolocation-app-weather/)

[Fetch weather data from an API using the user's geolocation data.](https://developers.cloudflare.com/workers/examples/geolocation-app-weather/)

[Geolocation: Custom Styling](https://developers.cloudflare.com/workers/examples/geolocation-custom-styling/)

[Personalize website styling based on localized user time.](https://developers.cloudflare.com/workers/examples/geolocation-custom-styling/)

[Geolocation: Hello World](https://developers.cloudflare.com/workers/examples/geolocation-hello-world/)

[Get all geolocation data fields and display them in HTML.](https://developers.cloudflare.com/workers/examples/geolocation-hello-world/)

[Hot-link protection](https://developers.cloudflare.com/workers/examples/hot-link-protection/)

[Block other websites from linking to your content. This is useful for protecting images.](https://developers.cloudflare.com/workers/examples/hot-link-protection/)

[Custom Domain with Images](https://developers.cloudflare.com/workers/examples/images-workers/)

[Set up custom domain for Images using a Worker or serve images using a prefix path and Cloudflare registered domain.](https://developers.cloudflare.com/workers/examples/images-workers/)

[Logging headers to console](https://developers.cloudflare.com/workers/examples/logging-headers/)

[Examine the contents of a Headers object by logging to console with a Map.](https://developers.cloudflare.com/workers/examples/logging-headers/)

[Modify request property](https://developers.cloudflare.com/workers/examples/modify-request-property/)

[Create a modified request with edited properties based off of an incoming request.](https://developers.cloudflare.com/workers/examples/modify-request-property/)

[Modify response](https://developers.cloudflare.com/workers/examples/modify-response/)

[Fetch and modify response properties which are immutable by creating a copy first.](https://developers.cloudflare.com/workers/examples/modify-response/)

[Multiple Cron Triggers](https://developers.cloudflare.com/workers/examples/multiple-cron-triggers/)

[Set multiple Cron Triggers on three different schedules.](https://developers.cloudflare.com/workers/examples/multiple-cron-triggers/)

[Stream OpenAI API Responses](https://developers.cloudflare.com/workers/examples/openai-sdk-streaming/)

[Use the OpenAI v4 SDK to stream responses from OpenAI.](https://developers.cloudflare.com/workers/examples/openai-sdk-streaming/)

[Post JSON](https://developers.cloudflare.com/workers/examples/post-json/)

[Send a POST request with JSON data. Use to share data with external servers.](https://developers.cloudflare.com/workers/examples/post-json/)

[Read POST](https://developers.cloudflare.com/workers/examples/read-post/)

[Serve an HTML form, then read POST requests. Use also to read JSON or POST data from an incoming request.](https://developers.cloudflare.com/workers/examples/read-post/)

[Using timingSafeEqual](https://developers.cloudflare.com/workers/examples/protect-against-timing-attacks/)

[Protect against timing attacks by safely comparing values using `timingSafeEqual`.](https://developers.cloudflare.com/workers/examples/protect-against-timing-attacks/)

[Redirect](https://developers.cloudflare.com/workers/examples/redirect/)

[Redirect requests from one URL to another or from one set of URLs to another set.](https://developers.cloudflare.com/workers/examples/redirect/)

[Respond with another site](https://developers.cloudflare.com/workers/examples/respond-with-another-site/)

[Respond to the Worker request with the response from another website (example.com in this example).](https://developers.cloudflare.com/workers/examples/respond-with-another-site/)

[Rewrite links](https://developers.cloudflare.com/workers/examples/rewrite-links/)

[Rewrite URL links in HTML using the HTMLRewriter. This is useful for JAMstack websites.](https://developers.cloudflare.com/workers/examples/rewrite-links/)

[Set security headers](https://developers.cloudflare.com/workers/examples/security-headers/)

[Set common security headers (X-XSS-Protection, X-Frame-Options, X-Content-Type-Options, Permissions-Policy, Referrer-Policy, Strict-Transport-Security, Content-Security-Policy).](https://developers.cloudflare.com/workers/examples/security-headers/)

[Turnstile with Workers](https://developers.cloudflare.com/workers/examples/turnstile-html-rewriter/)

[Inject Turnstile implicitly into HTML elements using the HTMLRewriter runtime API.](https://developers.cloudflare.com/workers/examples/turnstile-html-rewriter/)

[Using the WebSockets API](https://developers.cloudflare.com/workers/examples/websockets/)

[Use the WebSockets API to communicate in real time with your Cloudflare Workers.](https://developers.cloudflare.com/workers/examples/websockets/)


