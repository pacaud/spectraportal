# Drawer

Drawers are fixed-position sliding panels used for navigation, settings, and temporary tool trays.

## Markup

Use a wrap + backdrop + drawer structure. The wrap controls open/close with `data-open="true"`.

```html
<div class="sp-drawer-wrap" id="drawerRight" data-open="false">
  <div class="sp-drawer-backdrop" data-drawer-close></div>
  <aside class="sp-drawer sp-drawer--right" role="dialog" aria-modal="true" aria-label="Drawer" tabindex="-1">
    <div class="sp-drawer__header">
      <h2 class="sp-drawer__title">Drawer title</h2>
      <button class="sp-btn sp-btn--ghost" data-drawer-close aria-label="Close">✕</button>
    </div>
    <div class="sp-drawer__body">
      ...
    </div>
    <div class="sp-drawer__footer">
      ...
    </div>
  </aside>
</div>
```

## Placements

Pick one placement modifier:

- `.sp-drawer--right`
- `.sp-drawer--left`
- `.sp-drawer--bottom`
- `.sp-drawer--top`

## Tokens

- `--sp-drawer-w` — width of left/right drawers (default `360px`)
- `--sp-drawer-h` — height of top/bottom drawers (default `320px`)
- `--sp-backdrop` — backdrop color (default `rgba(0,0,0,0.55)`)

## Accessibility notes

- Use `role="dialog"` + `aria-modal="true"` for modal-style drawers.
- Ensure there is a close button.
- For best keyboard behavior, focus the drawer (or first focusable control) on open and return focus on close.
- Nice-to-have polish: trap Tab focus inside the drawer while open.
- Recommended UX: lock background scrolling while a drawer is open.

See: `framework/demos/drawer.html` for a tiny example toggle helper.
