# test


Note

To enable built-in Node.js APIs and polyfills, add the nodejs\_compat compatibility flag to your [Wrangler configuration file](https://developers.cloudflare.com/workers/wrangler/configuration/). This also enables nodejs\_compat\_v2 as long as your compatibility date is 2024-09-23 or later. [Learn more about the Node.js compatibility flag and v2](https://developers.cloudflare.com/workers/configuration/compatibility-flags/#nodejs-compatibility-flag).

## `MockTracker`

The `MockTracker` API in Node.js provides a means of tracking and managing mock objects in a test environment.

```js
import { mock } from 'node:test';


const fn = mock.fn();
fn(1,2,3);  // does nothing... but


console.log(fn.mock.callCount());  // Records how many times it was called
console.log(fn.mock.calls[0].arguments));  // Recoreds the arguments that were passed each call
```

The full `MockTracker` API is documented in the [Node.js documentation for `MockTracker`](https://nodejs.org/docs/latest/api/test.html#class-mocktracker).

The Workers implementation of `MockTracker` currently does not include an implementation of the [Node.js mock timers API](https://nodejs.org/docs/latest/api/test.html#class-mocktimers).


