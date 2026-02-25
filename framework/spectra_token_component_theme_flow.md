# Spectra Architecture Flow

## Token → Component → Theme

Spectra is built on a three-layer styling model:

1.  Tokens (Foundation)
2.  Components (Structure + Defaults)
3.  Themes (Visual Overrides)

This document explains how they interact and why the order matters.

------------------------------------------------------------------------

# Architecture Diagram

                    ┌──────────────────────┐
                    │        TOKENS        │
                    │----------------------│
                    │ Color                │
                    │ Surface tiers        │
                    │ Text tiers           │
                    │ Radius               │
                    │ Space                │
                    │ Shadow               │
                    │ Motion               │
                    │ Z-index              │
                    └────────────┬─────────┘
                                 │
                                 │ consumed by
                                 ▼
                    ┌──────────────────────┐
                    │      COMPONENTS      │
                    │----------------------│
                    │ Layout               │
                    │ Structure            │
                    │ Default styling      │
                    │ State logic          │
                    │ Uses semantic vars   │
                    └────────────┬─────────┘
                                 │
                                 │ overridden by
                                 ▼
                    ┌──────────────────────┐
                    │        THEMES        │
                    │----------------------│
                    │ Token remapping      │
                    │ Contrast adjustments │
                    │ Accent shifts        │
                    │ Light/Dark modes     │
                    └──────────────────────┘

Flow direction:

Tokens → Components → Themes

Themes should primarily override tokens. If themes must override
components heavily, the components are not token-driven enough.

------------------------------------------------------------------------

# 1) Tokens --- The Foundation Layer

Tokens define raw design values and semantic mappings.

They answer questions like: - What is a primary surface? - What is a
secondary text color? - What is the default spacing unit? - What radius
scale do we use?

Tokens should not know about components.

They define: - Color - Surface tiers - Text tiers - Borders - Radius -
Space - Shadow - Motion - Z-index

Example:

``` css
--sp-surface-1: #111827;
--sp-text: #E6EDF7;
--sp-radius-3: 12px;
--sp-space-3: 1rem;
```

Tokens are global and reusable.

If tokens are correct, theming becomes easy.

------------------------------------------------------------------------

# 2) Components --- Structure + Defaults

Components consume tokens.

They define: - Layout - Structure - State logic - Default styling
behavior

Components should: - Use semantic tokens - Avoid hardcoded values -
Expose minimal theme hooks

Example:

``` css
.sp-card {
  background: var(--sp-surface-1);
  color: var(--sp-text);
  border: 1px solid var(--sp-border-1);
  border-radius: var(--sp-radius-3);
  padding: var(--sp-space-4);
}
```

Important rule:

Components should never hardcode hex colors or pixel values unless they
are derived from tokens.

Components define structure. Tokens define values.

------------------------------------------------------------------------

# 3) Themes --- Visual Overrides

Themes override tokens first.

Themes should: - Remap semantic tokens - Adjust contrast - Change
surface hierarchy - Modify accent behavior

Themes should NOT: - Rewrite layout - Redefine component structure -
Change display logic

Theme example:

``` css
.sp-theme--midnight {
  --sp-surface-1: #0B1020;
  --sp-text: #F1F5F9;
  --sp-border-1: rgba(255,255,255,0.1);
}
```

Because components use tokens, changing tokens changes the entire
system.

This keeps themes lightweight.

------------------------------------------------------------------------

# Override Flow Rule

When styling something new, follow this order:

1)  Try solving it with tokens.
2)  If not possible, adjust the component using existing tokens.
3)  Only then create a small theme override (theme-bit).
4)  Never hardcode style directly into HTML.

Flow:

Tokens → Components → Theme Bits

Not:

Component hacks → Token patches → Layout rewrites

------------------------------------------------------------------------

# Separation of Responsibility

Tokens: - Define meaning.

Components: - Define structure.

Themes: - Define mood.

If these boundaries stay clean, Spectra remains stable and scalable.

------------------------------------------------------------------------

# Mental Model

Tokens = Paint palette\
Components = Furniture\
Theme = Lighting

You do not rebuild furniture when you change the lighting. You change
how the palette is interpreted.

------------------------------------------------------------------------

# Final Principle

If a theme requires rewriting most components, the components are not
token-driven enough.

Fix the token usage first.
