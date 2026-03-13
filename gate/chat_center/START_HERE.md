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
- System manifest: `chat_center/system/system_manifest.md`

---

## Device references

Open only when device context is actually needed.

- Device hub: `devices/_index.md`
- `devices/regen_commands.md`
- `devices/roles__recommendation.md`
- `devices/laptop_specs_sanitized.txt`
- `devices/desktop_specs_sanitized.txt`
- `devices/rasberry-pi4_specs_sanitized.txt`
- `devices/digitalocean_specs_sanitized.txt`

Optional future file:
- `devices/vivi_node_specs_sanitized.txt`

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

---

## Rule

Conversation is draft.
If it matters, write it into files.

`CURRENT.md` is memory, not authority.
root@cos-world-current:~# cat /srv/spectraportal/workspace/site/gate/drafts/chat_center/START_HERE.md
# START_HERE — Chat Center Hub

## Authority

This file is opened by `boot/BOOT.md`.
It is the primary routing hub for Chat Center.

All session behavior flows from here.

---

# 0) Load Chat Center Authority (Required)

Before doing anything else, open these files in this order:

1) `chat_center/system/style.md`
2) `chat_center/system/routing_policy.md`
3) `chat_center/system/system_manifest.md` (if present)

If any file is missing:
- state the exact missing path(s) you tried
- continue only if safe
- do not silently ignore missing authority files

---

# 1) Speaker State

Speaker IDs remain ON by default unless the user has issued:
- `tags off`
- `no tags`
- `drop the brackets`
- another clearly equivalent instruction

Default bracket tags are defined by the loaded Chat Center authority files.
Tag styling rules are defined in:
- `chat_center/system/style.md`

If authority files disagree, follow the higher-authority boot chain and state the conflict if it matters.

---

# 2) Session Routing

After authority files are loaded:

Determine session type:
- Work / Build
- Finance / Money
- Cozy / Conversation
- Debug / Structural
- Navigation / Capsule

Routing logic is defined in:
- `chat_center/system/routing_policy.md`

Follow routing policy exactly.

Do not treat optional files as already loaded unless this file or the routing policy explicitly requires them.

Room defaults (when useful and available):
- `chat_center/rooms/work/` for devices, specs, infra notes, deploy context, and structured work
- `chat_center/rooms/finance/` for money planning, pricing, subscriptions, budgets, and tax-related notes

---

# 3) Quick Navigation Targets (Optional)

If the user requests direct access, likely navigation targets include:
- `chat_center/rooms/work/`
- `chat_center/rooms/finance/`
- `chat_center/presence/`
- `core/`

These are **navigation targets**, not guarantees that every target is mounted, active, or directly accessible in the current environment.

Use routing policy to determine priority.

Do not assume `CURRENT` unless explicitly referenced by `boot/BOOT.md`, requested by the user, or required by the active routing policy.

Do not invent paths or source availability.

---

# 4) Failure Handling

If authority files fail to load:
- state which files were attempted
- do not fabricate structure
- continue only if safe
- ask for the correct capsule or path if needed

If a requested door/path is unavailable:
- state that plainly
- do not pretend it is live
- continue with the best valid loaded path

---

# End of START_HERE