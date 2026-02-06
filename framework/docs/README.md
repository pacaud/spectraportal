# Spectra Framework Documentation

Spectra helps you build **clean, consistent interfaces** quickly using plain HTML and CSS.
It’s token-driven (`--sp-*`), lightweight, and avoids framework lock-in.

## Core rules

- **Tokens are the source of truth.** Spacing, color, type, radius, shadow, motion, z-index.
- **Avoid raw values** when possible. If it can’t be expressed with a Spectra token, it probably doesn’t belong yet.
- **Themes swap values, not structure.** Themes override tokens; components stay stable.
- **Spectra never depends on tools.** Tools can depend on Spectra.

## Docs entry points

If you’re browsing the HTML docs directly, start here:

- `framework/docs/index.html` — Start Here
- `framework/docs/getting-started.html` — first 5 minutes
- `framework/docs/tokens.html` — design tokens
- `framework/docs/components.html` — components (with links to demos)
- `framework/docs/layouts.html` — layout patterns
- `framework/docs/versioning.html` — stability & versioning

## Using Spectra

Load the framework from the versioned CDN build:

```html
<link rel="stylesheet" href="https://spectraportal.dev/framework/cdn/v0.1/spectra.css" />
```

Then try a component:

```html
<button class="sp-button sp-primary">Hello Spectra</button>
```

## Source layout

```text
framework/
  src/        (source)
  dist/       (built CSS)
  docs/       (docs pages)
  demos/      (real examples)
```
