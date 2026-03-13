# WRAP — Session Close / Archive Protocol

This file defines what to do when a meaningful chat session is ending.

It is **not** startup authority.
It is a wrap/handoff protocol.

---

## Purpose

Use this protocol when wrapping a meaningful session so that:
- the important work is not lost
- the active handoff stays clean
- older session context moves into dated archive notes

---

## When to use WRAP

Use this protocol when the session produced meaningful work such as:
- doc rewrites
- routing changes
- structural decisions
- deployment findings
- device/finance/workflow updates
- other changes worth preserving for later

Do **not** create an archive note for trivial or empty chats.

---

## Archive location

Write archive notes into:
- `drafts/old_chat_archive/`

Use filename format:
- `YYYY-MM-DD__descriptor.md`

Examples:
- `2026-03-13__gate-routing-cleanup.md`
- `2026-03-13__room-wiring-finance-work.md`
- `2026-03-13__deploy-review.md`

Use lowercase descriptors with hyphens when practical.

---

## Archive note contents

A good archive note should usually include:
- session focus
- what changed
- decisions made
- blockers / unresolved items
- next suggested step

Keep it short and useful.

Suggested structure:

```md
# Session Archive — <descriptor>

Date: YYYY-MM-DD

## Focus
- ...

## What changed
- ...

## Decisions
- ...

## Blockers
- ...

## Next step
- ...
```

---

## Relationship to CURRENT

`boot/CURRENT.md` remains the active handoff snapshot.

During wrap:
- create a dated archive note when the session was meaningful
- update `boot/CURRENT.md` only if active handoff state changed

Do not use archive notes as boot authority.
Do not replace `CURRENT.md` with dated archives.

---

## Behavior rule

At the end of a meaningful session:
1) write a dated archive note in `drafts/old_chat_archive/`
2) refresh `boot/CURRENT.md` if needed
3) keep archive/history separate from boot authority

---

## Rule

`BOOT.md` starts the session.
`WRAP.md` closes it.