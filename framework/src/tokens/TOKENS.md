# Spectra Tokens (v0.1)

This file is a **practical index** of Spectra's token groups.

Spectra's “contract” is:

- Token names (the `--sp-*` variables) are the source of truth.
- Components and base styles should consume tokens, not raw values.

If you want a deeper, more narrative mapping, see:

- `framework/docs/Spectra_Token_Map_v0.1.md`

---

## Where tokens live

All tokens live in `framework/src/tokens/`:

- `core.css` — core primitives and shared defaults
- `space.css` — spacing scale (`--sp-1` …) and layout gaps/padding
- `type.css` — fonts, sizes, line heights
- `color.css` — color system (text, bg, borders, states)
- `radius.css` — border radius scale
- `shadow.css` — elevation and shadows
- `z.css` — z-index layers (overlays, drawers, etc.)
- `motion.css` — durations, easing
- `breakpoints.css` — documented breakpoint values (use literals in `@media`)
- `index.css` — import order

---

## Editing tokens safely

The safest workflow is:

1. Start by overriding **one** token in your app/site CSS (loaded after Spectra).
2. Keep overrides in one place.
3. Avoid inventing new one-off values unless you really need to.

Example:

```css
:root{
  --sp-primary: #7c5cff;
}
```

---

## Breakpoints note

For compatibility, avoid `var()` inside `@media`. Use the literal value and reference the token name in a comment.

```css
/* --sp-bp-sm (40rem) */
@media (min-width: 40rem){
  /* rules */
}
```
