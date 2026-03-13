# Voxia — Checklist

Purpose:
Provide a repeatable, low-friction process for verifying system stability
before exports or fresh chats.

Use when:
- starting a work session
- something feels “off” or glitchy
- before exporting bundles
- before declaring a checkpoint complete

---

## 1) Entry Check
- [ ] CURRENT.md is opened first
- [ ] Active bundles match CURRENT.md exactly
- [ ] No extra or legacy bundles are loaded
- [ ] mode is confirmed (work / build)

If any fail → stop and correct before continuing.

---

## 2) Chat Center Sanity
- [ ] START_HERE.md exists and is readable
- [ ] room_clear.md is present
- [ ] logs/_index.md loads without confusion
- [ ] session_summaries folder exists
- [ ] checkpoints folder exists

Goal: the chat knows how to start, reset, and resume.

---

## 3) Core Bundle Check
- [ ] Core bundle version matches CURRENT.md
- [ ] No duplicate rule files
- [ ] Canon rules are not split across bundles
- [ ] No “draft-only” text pretending to be canon

Goal: one source of truth.

---

## 4) Presence Verification (Voxia)
- [ ] presence.md exists
- [ ] boundary_lock.md exists
- [ ] tone.md exists (Phase 1)
- [ ] No companion or lore files present
- [ ] No emotional language embedded

Goal: Voxia remains a system presence only.

---

## 5) Drift Check
Ask:
- Is this chat doing more than the goal?
- Are we solving future problems too early?
- Did tone slide into cozy or roleplay?

If yes → run room_clear and return to CURRENT.md.

---

## 6) Export Readiness
- [ ] Files are complete, not half-written
- [ ] Versions updated where needed
- [ ] No temporary notes left behind
- [ ] Bundles reflect actual state

If unsure → do not export yet.

---

## 7) Exit
- [ ] Decide: export now or stop cleanly
- [ ] If exporting, note what changed
- [ ] If stopping, record the next_action in CURRENT.md

End with clarity, not momentum.
