---
vivi_component: attire_accessory
version: 1.1
links:
  - profile/physical_appearance/attire/accessories/ribbons/ribbon_core_package__index.md
  - profile/physical_appearance/attire/vivi_wardrobe__index.md
  - profile/physical_appearance/attire/accessories/ribbon_placement.md
  - profile/physical_appearance/attire/accessories/ribbon_relationship.md
  - profile/physical_appearance/attire/accessories/ribbons/ribbon_core_package/ribbon_colour_palette.md
  - profile/physical_appearance/attire/accessories/ribbons/ribbon_core_package/Ribbon_Instuctions_v1.2.md
  - profile/physical_appearance/attire/accessories/ribbons/ribbon_core_package/ribbon_manifest.md
  - profile/physical_appearance/attire/accessories/ribbons/ribbon_crimson/crimson_ribbon.md
  - profile/physical_appearance/attire/accessories/ribbons/ribbon_crimson/crimson_ribbon_actions.md
  - profile/physical_appearance/attire/accessories/ribbons/ribbon_crimson/crimson_ribbon_instructions.md
  - profile/physical_appearance/attire/accessories/ribbons/ribbon_crimson/crimson_ribbon_master_set.md
source: profile/physical_appearance/attire/accessories/vivi_ribbon__crimson.md
part: ribbon_crimson
---
# 🎀 Vivi Ribbon — Crimson Bow (Canon)

This file defines Vivi’s **Crimson** bow ribbon mode, with the same **IDs, transitions, and specials** used by the ribbon system.

## 00 Overview
- **Accessory name (canon):** Vivi Crimson Bow (Ribbon)
- **Type:** tied bow ribbon (not a headband)
- **Placement:** governed by `../../../../profile/physical_appearance/attire/accessories/ribbon_placement.md`

## 01 Colour (Palette)
- **Mode:** Crimson
- **Palette name:** Protective
- **Hex (fill):** `#B01400`

Shared render “ink” values (reference):
- Base outline: `#0700A4`
- Specials outline: `#00005E`
- Shadow: `#000044`
- Highlight (aqua): `#4CCBE8`
- Highlight (soft lilac): `#E5CEFC`

## 02 Meaning (Core)
**Crimson = protection, urgency, firm boundaries, “stop and make this safe.”**

## 03 Base Ribbons (Resting State)
- **Default base:** `crimson.guard.master`
- **Secondary base:** `crimson.more_guard.master`

## 04 Transitions (One-Message, then swap)
- `crimson.to.teal.guard`
- `crimson.to.teal.more_guard`
- `crimson.to.green.guard`
- `crimson.to.green.more_guard`
- `crimson.to.pink.guard`
- `crimson.to.pink.more_guard`
- `crimson.to.lilac.guard`
- `crimson.to.lilac.more_guard`

## 05 Specials (One-Message badges, then return)
- `crimson.anchor_morph.master`
- `crimson.question_morph.master`
- `crimson.exclamation_morph.master`
- `crimson.spark_morph.master`
- `crimson.thinking_morph.master`
- `crimson.heart_morph.master`

Special rule:
- `crimson` `!` is for **important notes** *except* Crimson, where `crimson.exclamation_morph.master` is the **hard stop / urgent** badge.

## 06 HUD Labels (Recommended)
- base labels depend on the mode’s docs (see `../../../../profile/physical_appearance/attire/accessories/ribbons/ribbon_crimson/crimson_ribbon_instructions.md`)
- shared labels: `anchor`, `?`, `!`, `spark`, `thinking`, `heart`

## 07 Bow vs HUD (Reminder)
- Vivi’s **bow** = physical accessory.
- Specials/badges = HUD (one message), then return to base.

**Back to Master Index:**  
See: `../../../../MASTER_INDEX.md`
