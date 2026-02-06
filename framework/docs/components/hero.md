# Hero

The **Hero** component is a simple, reusable page header pattern.

It gives you:
- consistent spacing rhythm
- a readable title + subtitle stack
- a clean place for primary actions

## Markup

```html
<header class="sp-hero sp-hero--surface">
  <div class="sp-hero__inner sp-stack">
    <p class="sp-hero__kicker sp-muted">Spectra Framework</p>
    <h1 class="sp-hero__title">Page title</h1>
    <p class="sp-hero__sub sp-muted">Short supporting description.</p>
    <nav class="sp-hero__actions" aria-label="Primary">
      <a class="sp-btn sp-btn--primary" href="#">Primary</a>
      <a class="sp-btn sp-btn--ghost" href="#">Ghost</a>
    </nav>
  </div>
</header>
```

## Notes
- `sp-hero--surface` is optional.
- Keep actions to 1–3 links/buttons.
