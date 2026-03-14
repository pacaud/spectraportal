# CURRENT — Session Handoff Snapshot

This file is **optional context**.
It is **not** part of required boot authority.

Use it only when:
- the user asks what we were working on
- prior session context is needed
- active handoff state matters
- a task depends on last-known working state

If this file conflicts with `boot/BOOT.md` or Chat Center authority files, the boot chain wins.
If this file has not been refreshed, treat it as potentially stale.

---

## Pre-Chat Handoff (edit before chat)

Update this section before starting a new chat when possible.
If it is not updated, say so and treat the rest of this file as carryover only.

- handoff_status: ACTIVE
- handoff_last_updated: 2026-03-13
- handoff_confidence: medium
- handoff_owner: Kevin
- current_focus: stabilize Gate boot/routing docs and keep deploy context available without making it boot authority
- immediate_next_step: continue doc cleanup and keep deploy notes as optional session context
- user_goal_in_progress: make Gate boot clean, truthful, and lightweight
- known_blockers:
  - GitHub is currently inactive / not hooked up
  - Drive is currently inactive / not hooked up
  - public Gate hostname/base URL is not formally locked yet
- source_status:
  - Gate loaded surface: ACTIVE
  - GitHub: INACTIVE
  - Drive: INACTIVE
- carryover_warning: older notes may reference GitHub-first workflow assumptions or local-bundle-first workflow assumptions; treat those as historical unless re-verified

---

## Archive recall (optional handoff memory)

Use `drafts/old_chat_archive/` as the dated session-history surface.

Latest archive note:
- `drafts/old_chat_archive/2026-03-13__gate-hollowverse-wiring.md`

When `boot/CURRENT.md` is opened for handoff/context:
- check `drafts/old_chat_archive/` only when prior session detail is actually needed
- prefer the most recent relevant archive note(s)
- start with the latest archive note above unless a different one is more relevant
- do not scan the entire archive unless the user explicitly asks for deeper history
- do not treat archive notes as boot authority

Important:
- archive recall is **not** part of required boot
- `boot/BOOT.md` still starts the session
- archive notes support memory and continuity only

Later, when useful:
- summarize relevant archive material into the appropriate room or doc
- examples:
  - work/deploy/device material → `chat_center/rooms/work/`
  - finance/subscription/tax material → `chat_center/rooms/finance/`

---

## Active content surface (current)

The active working surface is now **Gate / mounted capsules**, not local bundle zip files.

Use Gate-first language for current work:
- active source: loaded Gate surface
- active structure: root-relative capsules / mounted docs
- boot authority: `boot/BOOT.md`
- Chat Center hub: `chat_center/START_HERE.md`

Do not describe local bundle zip files as the primary active source unless the workflow explicitly switches back to bundle/export mode.

---

## Capsule / bundle lineage (historical export context)

These are the **last known local bundle/export names** from an earlier workflow.
They are useful as lineage/history notes, not as the current active working surface.

- Core: `pkw_core_v0.2.12.bundle.zip`
- Chat Center: `pkw_chat_center_v0.2.3.bundle.zip`
- Assets: `pkw_assets_v0.0.2.bundle.zip` (only if needed)
- Devices: `pkw_hollowverse_devices_v0.0.5.bundle.zip` (sanitized specs + index)
- World: `pkw_world_hollowverse__v0.0.59.bundle.zip`

If the workflow later returns to exports/capsules packaging, refresh this section as lineage metadata only.

---

## Chat Center starting points

These are useful navigation references, not extra boot authority.

- Chat Center hub: `chat_center/START_HERE.md`
- Chat Center index: `chat_center/_index.md`
- Work room: `chat_center/rooms/work/_index.md`
- Finance room: `chat_center/rooms/finance/_index.md`
- System manifest: `chat_center/system/system_manifest.md`

---

## Current room mappings

Use these as practical routing hints for current working material:

- `chat_center/rooms/work/`
  - devices
  - machine specs
  - regen commands
  - infra/deploy notes
  - structured work context

- `chat_center/rooms/finance/`
  - budgets
  - subscriptions
  - pricing
  - tax defaults
  - money-planning notes

---

## Device references

Device and machine references currently live in the work room surface.
Open only when device context is actually needed.

- `chat_center/rooms/work/_index.md`
- `chat_center/rooms/work/regen_commands.md`
- `chat_center/rooms/work/laptop_specs_sanitized.txt`
- `chat_center/rooms/work/desktop_specs_sanitized.txt`
- `chat_center/rooms/work/rasberry-pi4_specs_sanitized.txt`
- `chat_center/rooms/work/digitalocean_specs_sanitized.txt`

Optional future file:
- `chat_center/rooms/work/vivi_node_specs_sanitized.txt`

---

## Presence locks

- Voxia appearance lock: `chat_center/presence/voxia/appearance_lock.md`
  - If generating Voxia visuals, follow the lock.

---

## Last known working context

This section is a carryover note from the prior work session.
Use it as context only; re-check before treating any item as current truth.

- room: work
- mode: wrap
- focus_now: stabilize SpectraPortal deploy loop context and Gate doc routing cleanup

---

## Last confirmed technical state

These items were previously recorded as working-state notes.
They are useful for handoff, but should be re-verified if operational decisions depend on them.

- Droplet (`cos-world-current`) serves static site from: `/srv/spectraportal`
- cos-forge deploy source currently: `/opt/spectraportal-src`
- `/opt/spectraportal-src` was noted as **not a git repo** at last check
- rsync deploy had previously been verified via `stat` and `curl -I`

Important:
- older notes referenced GitHub as the canonical timeline/source-of-truth
- that should now be treated as a historical workflow note, not current active routing, until GitHub is re-enabled

---

## Known decisions / working assumptions

These are the current working assumptions for handoff purposes.
Update them when infrastructure or workflow changes.

- `boot/BOOT.md` is required startup authority
- `chat_center/START_HERE.md` is the Chat Center routing hub
- `boot/CURRENT.md` is optional session carryover only
- `boot/REDIRECT.md` is optional source-status / pointer context only
- `drafts/old_chat_archive/` is optional dated session history, not boot authority
- Gate loaded surface is the only active source currently assumed live
- Local bundle names are historical/export lineage unless explicitly reactivated
- GitHub should not be treated as active until re-enabled
- Drive should not be treated as active until re-enabled
- No public Gate hostname should be treated as authoritative until formally adopted
- DigitalOcean droplet remains the recorded host/deploy target for the static site
- Avoid manual edits in `/srv/spectraportal` unless that rule is explicitly changed

---

## Open issues

- cos-forge deploy source is not yet a real git checkout
- GitHub is inactive, so git-based deploy assumptions should not be treated as live workflow
- Drive is inactive, so Drive-based fallback assumptions should not be used
- some legacy docs may still read as if external sources or local bundles are the live primary surface

---

## Suggested next actions

Choose based on the actual chat goal:

1) Continue tightening boot / Chat Center docs until the routing chain is fully truthful
2) Re-verify deploy-state notes before using them for operational decisions
3) Only re-introduce GitHub or Drive into workflow docs after they are actually hooked up
4) Refresh this file whenever the focus, source status, or deploy reality changes
5) Keep bundle/export names here only as lineage metadata unless bundle mode becomes active again
6) Use the old chat archive when carryover detail is needed, then summarize relevant findings into rooms when that helps long-term organization

---

## Rule

Conversation is draft.
If it matters, write it into files.

`CURRENT.md` is memory, not authority.