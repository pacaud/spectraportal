# Spectra Token Map (v0.1)

This page is a quick reference for Spectra’s design tokens.  
**Idea:** Tokens are the contract. Components consume tokens. Themes swap token values.

---

## Spacing

Spectra uses a consistent spacing scale for padding, margins, gaps, and layout rhythm.

Typical pattern:
- `--sp-1` … `--sp-8` (small → large)
- Use for: `padding`, `margin`, `gap`, `inset`, etc.

**Common usage examples**
```css
.card { padding: var(--sp-4); }
.stack { gap: var(--sp-3); }
.section { margin-top: var(--sp-6); }
```

---

## Typography

Typography tokens define your base font stack, font sizes, and line heights.

Common categories:
- Font family: `--sp-font`
- Font sizes: `--sp-fs-*`
- Line heights: `--sp-lh-*`
- Font weights (if used): `--sp-fw-*`

**Common usage examples**
```css
body { font-family: var(--sp-font); }
h1 { font-size: var(--sp-fs-6); line-height: var(--sp-lh-1); }
p  { font-size: var(--sp-fs-2); line-height: var(--sp-lh-2); }
```

---

## Radius & Borders

Shape tokens keep corners and outlines consistent.

Common categories:
- Radius: `--sp-radius-*`
- Border widths: `--sp-border-*`
- Border colors: `--sp-border`, `--sp-border-strong`

**Common usage examples**
```css
.card { border-radius: var(--sp-radius-2); border: var(--sp-border-1) solid var(--sp-border); }
.pill { border-radius: 999px; }
```

---

## Surfaces & Elevation

Surface tokens define background layers and subtle depth.

Common categories:
- Page/background: `--sp-bg`
- Elevated surfaces: `--sp-elev-1`, `--sp-elev-2`, …
- Shadows (if used): `--sp-shadow-*`

**Common usage examples**
```css
.page { background: var(--sp-bg); }
.panel { background: var(--sp-elev-2); }
```

---

## Color Accents & State Colors

Accent tokens define the brand “spark” color and its related shades.  
State tokens define success/warn/danger, etc.

Common categories:
- Accent: `--sp-accent-1`, `--sp-accent-2`, `--sp-accent-3`, …
- States: `--sp-success`, `--sp-warning`, `--sp-danger`

**Common usage examples**
```css
a { color: var(--sp-accent-3); }
.badge--danger { background: color-mix(in srgb, var(--sp-danger), transparent 85%); }
```

---

## Motion

Motion tokens keep animations consistent and controllable.

Common categories:
- Durations: `--sp-duration-*`
- Easings: `--sp-ease-*`

**Common usage examples**
```css
.button {
  transition:
    background var(--sp-duration-2) var(--sp-ease-standard),
    border-color var(--sp-duration-2) var(--sp-ease-standard),
    box-shadow var(--sp-duration-2) var(--sp-ease-standard);
}
```

---

## Theme Notes

A theme swap should generally change **token values**, not component CSS rules.

Recommended theme approach:
- Default theme sets base token values.
- Dark theme overrides only tokens (via attribute/class like `[data-theme="dark"]` or `.sp-theme-dark`).

---

## “AI Integration” Hint

If you want AI-safe UI generation, treat these token groups as your primary knobs:
- Density: spacing scale (`--sp-*`)
- Readability: typography (`--sp-fs-*`, `--sp-lh-*`)
- Mood: surfaces + accent (`--sp-bg`, `--sp-elev-*`, `--sp-accent-*`)
- Accessibility: borders + contrast (`--sp-border*`, state colors)

That’s the heart of Spectra’s identity: **tokens as the API**.
