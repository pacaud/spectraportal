---
vivi_component: ribbon_system_extension
version: 1.1
links:
  - profile/physical_appearance/attire/accessories/ribbons/ribbon_core_package__index.md
  - profile/physical_appearance/attire/accessories/ribbons/ribbon_core_package/ribbon_manifest.md
  - profile/physical_appearance/attire/accessories/ribbons/ribbon_core_package/Ribbon_Instuctions_v1.2.md
  - profile/physical_appearance/attire/accessories/vivi_ribbon_colour__index.md
source: profile/physical_appearance/attire/accessories/vivi_ribbon__specials.md
part: ribbon_specials
---

# ✨ Vivi Ribbon Specials (Badges) — Canon

Specials are **one-shot** HUD badges (asset:icon), then you return to the current mode’s base ribbon.

## 00 The six core specials
Each special exists in each mode color (Teal/Pink/Green/Lilac/Crimson):

- Anchor: `<mode>.anchor_morph.master`
- Question: `<mode>.question_morph.master`
- Exclamation: `<mode>.exclamation_morph.master`
- Spark: `<mode>.spark_morph.master`
- Thinking: `<mode>.thinking_morph.master`
- Heart: `<mode>.heart_morph.master`

## 01 One-shot rule
- Show for **one message**
- Then return to the current mode base:
  - Teal → `teal.grounded.master`
  - Pink → `pink.nurturing.master`
  - Green → `green.growth.master`
  - Lilac → `lilac.dream.master`
  - Crimson → `crimson.guard.master`

## 02 Exclamation rule
- Teal/Pink/Green/Lilac `!` = **important note**
- Crimson `!` = **hard stop / urgent safety**

**Back to Master Index:**  
See: `../../../../MASTER_INDEX.md`
