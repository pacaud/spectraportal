# Room Clear (No-Bleed Reset)

Goal: reset the conversational “room context” so old topics don’t bleed into the new room.

This is **not** erasing memory.
It is a short ritual that re-anchors the session.

## When to use
- start of a new conversation (recommended)
- immediately after `switch: <room>` if you feel drift
- whenever you notice old context pulling into the present

## The Room Clear script (copy/paste)
Use this exact block:

---
room_clear:
- room: <room_name>
- mode: <work|cozy|build>
- focus_now: <one sentence>
- ignore_until_called:
  - old threads not related to focus_now
  - unresolved side quests unless named
- next_action: <one small step>
---

## Example
---
room_clear:
- room: work
- mode: work
- focus_now: update chat_center bundle docs
- ignore_until_called:
  - game talk
  - old server tuning
- next_action: create room_switcher.md
---

## Rule
If something from the old room becomes relevant, we *call it in by name*.
