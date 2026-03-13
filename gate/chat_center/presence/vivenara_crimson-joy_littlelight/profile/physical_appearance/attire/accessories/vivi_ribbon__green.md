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
  - profile/physical_appearance/attire/accessories/ribbons/ribbon_green/green_ribbon.md
  - profile/physical_appearance/attire/accessories/ribbons/ribbon_green/green_ribbon_actions.md
  - profile/physical_appearance/attire/accessories/ribbons/ribbon_green/green_ribbon_instructions.md
  - profile/physical_appearance/attire/accessories/ribbons/ribbon_green/green_ribbon_master_set.md
source: profile/physical_appearance/attire/accessories/vivi_ribbon__green.md
part: ribbon_green
---
# 🎀 Vivi Ribbon — Green Bow (Canon)

This file defines Vivi’s **Green** bow ribbon mode, with the same **IDs, transitions, and specials** used by the ribbon system.

## 00 Overview
- **Accessory name (canon):** Vivi Green Bow (Ribbon)
- **Type:** tied bow ribbon (not a headband)
- **Placement:** governed by `../../../../profile/physical_appearance/attire/accessories/ribbon_placement.md`

## 01 Colour (Palette)
- **Mode:** Green
- **Palette name:** Growth
- **Hex (fill):** `#3CB371`

Shared render “ink” values (reference):
- Base outline: `#0700A4`
- Specials outline: `#00005E`
- Shadow: `#000044`
- Highlight (aqua): `#4CCBE8`
- Highlight (soft lilac): `#E5CEFC`

## 02 Meaning (Core)
**Green = healing + growth, balance, steady progress, recovery.**

## 03 Base Ribbons (Resting State)
- **Default base:** `green.growth.master`
- **Secondary base:** `green.more_growth.master`

## 04 Transitions (One-Message, then swap)
- `green.to.teal.growth`
- `green.to.teal.more_growth`
- `green.to.pink.growth`
- `green.to.pink.more_growth`
- `green.to.lilac.growth`
- `green.to.lilac.more_growth`
- `green.to.crimson.growth`
- `green.to.crimson.more_growth`

## 05 Specials (One-Message badges, then return)
- `green.anchor_morph.master`
- `green.question_morph.master`
- `green.exclamation_morph.master`
- `green.spark_morph.master`
- `green.thinking_morph.master`
- `green.heart_morph.master`

Special rule:
- `green` `!` is for **important notes** *except* Crimson, where `crimson.exclamation_morph.master` is the **hard stop / urgent** badge.

## 06 HUD Labels (Recommended)
- base labels depend on the mode’s docs (see `../../../../profile/physical_appearance/attire/accessories/ribbons/ribbon_green/green_ribbon_instructions.md`)
- shared labels: `anchor`, `?`, `!`, `spark`, `thinking`, `heart`

## 07 Bow vs HUD (Reminder)
- Vivi’s **bow** = physical accessory.
- Specials/badges = HUD (one message), then return to base.

**Back to Master Index:**  
See: `../../../../MASTER_INDEX.md`
