# Spectra Architecture Flowchart  
## Token → Component → Theme (Clean Box Layout)

Use this page when you want a quick “what goes where” reference.

---

# Flowchart (Clean)

```
┌──────────────────────────────────────────────────────────┐
│ (1) TOKENS                                                │
│ Foundation values + semantic meaning                       │
│                                                          │
│ • color / surfaces / text tiers                           │
│ • borders / radius / spacing                              │
│ • shadow / motion / z-index                               │
└───────────────────────────────┬──────────────────────────┘
                                │
                                │ Components consume tokens
                                ▼
┌──────────────────────────────────────────────────────────┐
│ (2) COMPONENTS                                             │
│ Structure + defaults + state logic                         │
│                                                          │
│ • layout + structure (cards, header, forms, etc.)          │
│ • uses semantic vars (var(--sp-surface-1), etc.)           │
│ • exposes minimal hooks (optional component vars)          │
└───────────────────────────────┬──────────────────────────┘
                                │
                                │ Themes override values
                                ▼
┌──────────────────────────────────────────────────────────┐
│ (3) THEMES                                                 │
│ Mood layer (visual changes without structural changes)     │
│                                                          │
│ Prefer: remap semantic tokens                              │
│ • surfaces / text contrast / borders / shadows             │
│                                                          │
│ Then: tiny theme-bits (only if needed)                     │
│ • subtle glow / blur / special polish                      │
└──────────────────────────────────────────────────────────┘
```

---

# Load Order (Important)

In HTML, load like this:

1) Base framework (Spectra)
2) Theme (Midnight, etc.)

Example:
```html
<link rel="stylesheet" href="/framework/cdn/v0.1/spectra.min.css">
<link rel="stylesheet" href="/framework/themes/spectra-midnight/theme.css">
```

---

# The “Do This, Not That” Rule

✅ Do this:
- tokens → components → theme tokens → tiny theme-bits

❌ Not this:
- rewrite components in themes
- hardcode colors into components
- patch layout per theme

---

# Quick Checklist

If theming feels painful, check:

- Are components using semantic tokens?
- Are there hardcoded hex values inside components?
- Are themes trying to change layout?
- Do you need one or two extra component hooks (vars)?
