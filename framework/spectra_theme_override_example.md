# Spectra Theme Override Example  
## How a Theme Actually Changes the UI (Tokens first)

This page is an add-on to the main architecture doc.  
It shows how a theme should flow through Spectra without “override wars”.

---

# The Core Idea

A theme should mostly change **semantic tokens**.

Components should already be written to **consume tokens**.

So the theme becomes a small set of remaps, not a rewrite.

---

# Diagram: Theme Overrides (Preferred Path)

```
  Base Tokens (framework/src/tokens/*)
  ┌─────────────────────────────────────────────┐
  │ --sp-bg           --sp-surface-1            │
  │ --sp-surface-2    --sp-text                 │
  │ --sp-border-1     --sp-shadow-2             │
  └───────────────────────┬─────────────────────┘
                          │ used by
                          ▼
  Components (framework/src/components/*)
  ┌─────────────────────────────────────────────┐
  │ .sp-header  background: var(--sp-surface-1) │
  │ .sp-card    border: 1px solid --sp-border-1 │
  │ .sp-btn     color: var(--sp-text)           │
  └───────────────────────┬─────────────────────┘
                          │ then theme remaps
                          ▼
  Theme Tokens (themes/spectra-midnight/theme-bits/tokens.css)
  ┌─────────────────────────────────────────────┐
  │ --sp-surface-1  -> #0B1020                  │
  │ --sp-text       -> #F1F5F9                  │
  │ --sp-border-1   -> rgba(255,255,255,.10)    │
  └───────────────────────┬─────────────────────┘
                          │ optional tiny polish
                          ▼
  Theme Bits (themes/.../theme-bits/header.css)
  ┌─────────────────────────────────────────────┐
  │ only if needed: small tweaks that tokens     │
  │ can't express (e.g., header blur, glow)      │
  └─────────────────────────────────────────────┘
```

---

# Rules of Thumb

### 1) Token-first always
If you can solve it by remapping:
- surfaces
- text tiers
- borders
- shadows

…do that first.

### 2) Theme-bits are the exception
Theme-bits exist for the last 10–20% polish:
- subtle glow
- backdrop blur
- a component-only accent ring

### 3) If you’re rewriting layout, stop
Themes should not change:
- display types
- grid layouts
- DOM structure assumptions

If you feel forced to do that, the base component needs better token hooks.

---

# Mini Example: Midnight Header

**Base component:**
```css
.sp-header{
  background: var(--sp-surface-1);
  border-bottom: 1px solid var(--sp-border-1);
  color: var(--sp-text);
}
```

**Midnight theme token remap:**
```css
.sp-theme--midnight{
  --sp-surface-1: #0B1020;
  --sp-border-1: rgba(255,255,255,.10);
  --sp-text: #F1F5F9;
}
```

**Optional theme-bit (only if needed):**
```css
.sp-theme--midnight .sp-header{
  backdrop-filter: blur(10px);
}
```
