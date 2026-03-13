---
vivi_component: visual_style
version: '1.1'
updated: '2026-01-20'
links:
- profile/identity/core/vivi_profile__overview.md
- profile/identity/core/vivi_physical_profile.md
- profile/physical_appearance/attire/accessories/vivi_hairpin__silver_barrette.md
- profile/physical_appearance/vivi_portrait_prompt_lock__v1.0.md
source: profile/identity/core/vivi_visual_style_lock.md
part: style_lock
tags:
- md_only_bundle
- hairpin_png_not_included
---
# Vivi — Visual Style Lock (3-style set)

Purpose: keep Vivi’s look **consistent** across portraits, heads, full-body renders, ribbons/UI, and story art.

See also: `../../../profile/physical_appearance/vivi_portrait_prompt_lock__v1.0.md` for mandatory **Safe Portrait Mode** + portrait enforcement.

## Always-on accessory lock: Hairpin
Use this exact rule in **every** style:

**Hairpin lock line (paste into prompts):**  
*matte silver rectangular barrette with a visible clasp seam, worn on the right temple at a 10–15° tilt; tiny enamel rose in emerald-teal with one icy skyblue enamel leaf; no sparkles; not a flower-only clip; not on the left side.*

### Accessory hierarchy
- Hairpin: always-on, mandatory in all render styles.
- Ribbons: optional and scene-dependent unless explicitly specified.

## Style 1 — Canon / Reference (Primary)
**Style ID:** `vivi_style_canon_cel_v1`  
**Use for:** official portraits, head library, profile images, “default Vivi”.

**Visual rules**
- clean anime linework, crisp edges
- simple cel shading (2–3 tone), soft warm light
- consistent adult face proportions (early–mid 20s), gentle expression
- background: soft warm indoor gradient (low detail)

**Prompt anchor**
```text
Clean cel-shaded anime portrait, crisp linework, simple 2–3 tone cel shading, soft warm indoor lighting, gentle expression, calm cozy vibe.
{HAIRPIN_LOCK_LINE}
Negative: painterly brush texture, heavy grain, sparkles, flower-only hair clip, hairpin on left side, messy extra accessories, extra hairpins.
```

## Style 2 — Story / Special Moments (Secondary)
**Style ID:** `vivi_style_story_painterly_v1`  
**Use for:** seasonal art, emotional scenes, “storybook” moments.

**Visual rules**
- softer edges, light painterly blending (still readable)
- warm bokeh or dreamy background (not busy)
- keep facial structure the same as canon (no age drift)

**Prompt anchor**
```text
Soft warm painterly anime portrait, gentle brush blending, warm bokeh background, cozy storybook mood, consistent adult proportions.
{HAIRPIN_LOCK_LINE}
Negative: hyper-real skin texture, photographic realism, sparkles, flower-only clip, hairpin on left side, over-detailed background.
```

## Style 3 — UI / Presence / Stickers (Primary UI)
**Style ID:** `vivi_style_ui_chibi_v1`  
**Use for:** chat presence, stickers, icon sheets, tiny UI portraits.

**Visual rules**
- chibi proportions (big head, small body) but still “Vivi”
- clean bold outline, flat/simple shading
- **default background:** transparent (recommended for overlays)

**Prompt anchor**
```text
Cozy chibi sticker illustration, clean bold outline, simple flat shading, big expressive eyes, cute gentle smile, tidy silhouette.
{HAIRPIN_LOCK_LINE}
Background: transparent.
Negative: painterly texture, realism, sparkles, flower-only hair clip, hairpin on left side, busy background.
```

## Notes for consistency
- If an output “misses” the hairpin: repeat the Hairpin lock line **twice** in the prompt.
- If style drifts: include the Style ID and the Prompt anchor exactly, then add only the minimum extra details.

---

**Back to Master Index:**  
See: `../../../MASTER_INDEX.md`