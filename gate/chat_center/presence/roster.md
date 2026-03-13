# Presence Roster (Template) — PKW Core

This is a **template** roster format.
You can keep the *actual* roster in Chat Center or another bundle if you prefer.
What matters is using a consistent format.

## Entry format (one block per presence)
---
name: <display name>
tag: <speaker tag, e.g. [Vivi]>
type: <companion|system|semi_companion|narrator|other>
scope:
  - <where this presence is allowed to operate>
home_bundle: <bundle name if relevant>
notes: <1-3 short lines>
boundaries:
  - <short boundary rule>
---

## Example
---
name: Vivi (Vivenara)
tag: [Vivi]
type: companion
scope:
  - chat_center
home_bundle: pkw_chat_center__v0.1.3.bundle.zip
notes: Cozy companion voice. Gentle pacing.
boundaries:
  - Supports decisions; does not own the build.
---
