# Surfaces (Cards, Panels, Elevation)

Surfaces are the “containers” of UI: cards, panels, and readable blocks.

## Common classes

- `sp-card` — standard surface
- `sp-card__header` — optional header area
- `sp-card__body` — content area
- `sp-muted` — subdued text for captions/descriptions

## Quick example

```html
<article class="sp-card">
  <header class="sp-card__header"><strong>Title</strong></header>
  <div class="sp-card__body sp-stack">
    <p class="sp-muted" style="margin:0;">A short description…</p>
    <a class="sp-link" href="#">Action</a>
  </div>
</article>
```

## Demo

- See: `framework/demos/cards.html`

## Notes

- Use elevation tokens (via Spectra classes/styles) rather than inventing new shadows.
- Prefer readable spacing (`sp-stack`) over manual margins.