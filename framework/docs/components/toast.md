# Toast

Minimal feedback messages.

## Quick use

Recommended: combine **Toast** with **Card** for the surface.

```html
<div class="sp-toast sp-card sp-card--elev sp-pos-bottom-right" role="status" aria-live="polite">
  <div class="sp-toast__title">Saved</div>
  <div class="sp-toast__body sp-muted">Your changes were saved.</div>
</div>
```

## Placement

Use the **position helpers** to pin to viewport:

- `.sp-pos-top-left`
- `.sp-pos-top-right`
- `.sp-pos-bottom-left`
- `.sp-pos-bottom-right`
- `.sp-pos-center-left`
- `.sp-pos-center-right`
- `.sp-pos-center`

## Tokens

- `--sp-toast-w` (default `360px`)
- `--sp-toast-gap` (default `var(--sp-2)`)

## Demo

Open `framework/demos/toast.html`.
