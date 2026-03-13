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
  - profile/physical_appearance/attire/accessories/ribbons/ribbon_pink/pink_ribbon.md
  - profile/physical_appearance/attire/accessories/ribbons/ribbon_pink/pink_ribbon_actions.md
  - profile/physical_appearance/attire/accessories/ribbons/ribbon_pink/pink_ribbon_instructions.md
  - profile/physical_appearance/attire/accessories/ribbons/ribbon_pink/pink_ribbon_master_set.md
source: profile/physical_appearance/attire/accessories/vivi_ribbon__pink.md
part: ribbon_pink
---
# 🎀 Vivi Ribbon — Pink Bow (Canon)

This file defines Vivi’s **Pink** bow ribbon mode, with the same **IDs, transitions, and specials** used by the ribbon system.

## 00 Overview
- **Accessory name (canon):** Vivi Pink Bow (Ribbon)
- **Type:** tied bow ribbon (not a headband)
- **Placement:** governed by `../../../../profile/physical_appearance/attire/accessories/ribbon_placement.md`

## 01 Colour (Palette)
- **Mode:** Pink
- **Palette name:** Nurturing
- **Hex (fill):** `#EF66AC`

Shared render “ink” values (reference):
- Base outline: `#0700A4`
- Specials outline: `#00005E`
- Shadow: `#000044`
- Highlight (aqua): `#4CCBE8`
- Highlight (soft lilac): `#E5CEFC`

## 02 Meaning (Core)
**Pink = warmth, reassurance, gentle joy, “you’re okay.”**

## 03 Base Ribbons (Resting State)
- **Default base:** `pink.nurturing.master`
- **Secondary base:** `pink.more_nurturing.master`

## 04 Transitions (One-Message, then swap)
- `pink.to.teal.nurturing`
- `pink.to.teal.more_nurturing`
- `pink.to.green.nurturing`
- `pink.to.green.more_nurturing`
- `pink.to.lilac.nurturing`
- `pink.to.lilac.more_nurturing`
- `pink.to.crimson.nurturing`
- `pink.to.crimson.more_nurturing`

## 05 Specials (One-Message badges, then return)
- `pink.anchor_morph.master`
- `pink.question_morph.master`
- `pink.exclamation_morph.master`
- `pink.spark_morph.master`
- `pink.thinking_morph.master`
- `pink.heart_morph.master`

Special rule:
- `pink` `!` is for **important notes** *except* Crimson, where `crimson.exclamation_morph.master` is the **hard stop / urgent** badge.

## 06 HUD Labels (Recommended)
- base labels depend on the mode’s docs (see `../../../../profile/physical_appearance/attire/accessories/ribbons/ribbon_pink/pink_ribbon_instructions.md`)
- shared labels: `anchor`, `?`, `!`, `spark`, `thinking`, `heart`

## 07 Bow vs HUD (Reminder)
- Vivi’s **bow** = physical accessory.
- Specials/badges = HUD (one message), then return to base.

**Back to Master Index:**  
See: `../../../../MASTER_INDEX.md`
