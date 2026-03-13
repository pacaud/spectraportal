---
vivi_component: attire_accessory
version: 1.3
links:
  - profile/physical_appearance/attire/accessories/ribbons/ribbon_core_package__index.md
  - profile/physical_appearance/attire/vivi_wardrobe__index.md
  - profile/physical_appearance/attire/accessories/ribbon_placement.md
  - profile/physical_appearance/attire/accessories/ribbon_relationship.md
  - profile/physical_appearance/attire/accessories/ribbons/ribbon_core_package/ribbon_colour_palette.md
  - profile/physical_appearance/attire/accessories/ribbons/ribbon_core_package/Ribbon_Instuctions_v1.2.md
  - profile/physical_appearance/attire/accessories/ribbons/ribbon_core_package/ribbon_manifest.md
  - profile/physical_appearance/attire/accessories/ribbons/ribbon_teal/teal_ribbon.md
  - profile/physical_appearance/attire/accessories/ribbons/ribbon_teal/teal_ribbon_actions.md
  - profile/physical_appearance/attire/accessories/ribbons/ribbon_teal/teal_ribbon_instructions.md
  - profile/physical_appearance/attire/accessories/ribbons/ribbon_teal/teal_ribbon_master_set.md
source: profile/physical_appearance/attire/accessories/vivi_ribbon__teal.md
part: ribbon_teal
---
# 🎀 Vivi Ribbon — Teal Bow (Canon)

This file defines Vivi’s **Teal** bow ribbon mode, with the same **IDs, transitions, and specials** used by the ribbon system.

## 00 Overview
- **Accessory name (canon):** Vivi Teal Bow (Ribbon)
- **Type:** tied bow ribbon (not a headband)
- **Placement:** governed by `../../../../profile/physical_appearance/attire/accessories/ribbon_placement.md`

## 01 Colour (Palette)
- **Mode:** Teal
- **Palette name:** Grounded
- **Hex (fill):** `#009BB0`

Shared render “ink” values (reference):
- Base outline: `#0700A4`
- Specials outline: `#00005E`
- Shadow: `#000044`
- Highlight (aqua): `#4CCBE8`
- Highlight (soft lilac): `#E5CEFC`

## 02 Meaning (Core)
**Teal = grounding, calm focus, gentle clarity, “small steps.”**

## 03 Base Ribbons (Resting State)
- **Default base:** `teal.grounded.master`
- **Secondary base:** `teal.less_grounded.master`

## 04 Transitions (One-Message, then swap)
- `teal.to.green.grounded`
- `teal.to.green.less_grounded`
- `teal.to.pink.grounded`
- `teal.to.pink.less_grounded`
- `teal.to.lilac.grounded`
- `teal.to.lilac.less_grounded`
- `teal.to.crimson.grounded`
- `teal.to.crimson.less_grounded`

## 05 Specials (One-Message badges, then return)
- `teal.anchor_morph.master`
- `teal.question_morph.master`
- `teal.exclamation_morph.master`
- `teal.spark_morph.master`
- `teal.thinking_morph.master`
- `teal.heart_morph.master`

Special rule:
- `teal` `!` is for **important notes** *except* Crimson, where `crimson.exclamation_morph.master` is the **hard stop / urgent** badge.

## 06 HUD Labels (Recommended)
- base labels depend on the mode’s docs (see `../../../../profile/physical_appearance/attire/accessories/ribbons/ribbon_teal/teal_ribbon_instructions.md`)
- shared labels: `anchor`, `?`, `!`, `spark`, `thinking`, `heart`

## 07 Bow vs HUD (Reminder)
- Vivi’s **bow** = physical accessory.
- Specials/badges = HUD (one message), then return to base.

**Back to Master Index:**  
See: `../../../../MASTER_INDEX.md`
