# Chat Center — Index

Directory: `chat_center/`
Updated: 2026-03-13

---

## Purpose

Chat Center is the session and conversation layer.
It contains:
- startup handoff into Chat Center behavior
- system rules for style and routing
- room-based conversation buckets
- presence and supporting chat structures

This file is a **navigation hub**, not routing authority.

---

## Primary entry points

- Startup hub: `START_HERE.md`
- Rooms index: `rooms/_index.md`
- System layer: `system/_index.md`
- Presence: `presence/`

Boot authority is defined in:
- `boot/BOOT.md`

Chat Center session routing is defined in:
- `chat_center/START_HERE.md`
- `chat_center/system/routing_policy.md`

`GPTS_BOOT.md` is the assistant harness, not the Chat Center routing document.

---

## Rooms in current use

- `rooms/work/` — structured work, devices, specs, infra notes, deploy context
- `rooms/finance/` — pricing, budgets, subscriptions, taxes, money planning
- `rooms/just_chatting/` — casual conversation
- `rooms/playground/` — experiments and drafts
- `rooms/review/` — wrap-ups and checkpoints
- `rooms/recovery/` — grounding and overwhelm support
- `rooms/media/` — games, anime, and media talk
- `rooms/roleplay/` — RP sessions and scene work

---

## Notes

- Additive expansion allowed.
- Structural rewrites require review.
- Rooms are conversation buckets, not global authority files.
- If a room is not mounted or not populated yet, state that plainly.

---