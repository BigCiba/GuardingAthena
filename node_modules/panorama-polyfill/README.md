# `panorama-polyfill`

> Polyfills for common JavaScript features for Valve's Panorama UI (for Dota 2 Custom Games).

## Installation

This package can be used only with a ESM bundler, such as webpack. Check out
[this tutorial](https://moddota.com/panorama/webpack) for configuration instructions.

```shell
npm install panorama-polyfill
```

## Usage

Functionality of this module is split across multiple entry points:

### `panorama-polyfill/lib/console`

A polyfill for `console` object, featuring pretty value formatting.

```js
import 'panorama-polyfill/lib/console';

console.log('Hello, world!'); // => Hello, world!
console.log('Hello, %s!', 'world'); // => Hello, world!
console.log([1, 2, 3]); // => [1, 2, 3]
console.log({ foo: { bar: /baz/ } }); // => { foo: { bar: /baz/ } }
```

### `panorama-polyfill/lib/timers`

Polyfills for web timers (using `$.Schedule`):

- `setInterval` and `clearInterval`
- `setTimeout` and `clearTimeout`
- `setImmediate` and `clearImmediate`

### `panorama-polyfill/lib/es`

Polyfills for standard EcmaScript features that are missing from Panorama (> ES2017).
