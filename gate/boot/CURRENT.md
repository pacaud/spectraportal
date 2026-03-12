# CURRENT — Active PKW Upload Set

## Active bundles (uploaded now)
- Core: `pkw_core_v0.2.12.bundle.zip`
- Chat Center: `pkw_chat_center_v0.2.3.bundle.zip`
- Assets: `pkw_assets_v0.0.2.bundle.zip` (only if needed)
- Devices: `pkw_hollowverse_devices_v0.0.5.bundle.zip` (sanitized specs + index)
- World: `pkw_world_hollowverse__v0.0.59.bundle.zip`

---

## Chat Center hub (start here)
- Open: `chat_center/START_HERE.md`

## Chat Center doors (fallbacks)
- `chat_center/UNIVERSE_DOORS.md`
- `chat_center/_index.md`

## System rules (load during boot — not a room)
- `chat_center/system/system_manifest.md`

---

## Device hub
- Open: `devices/_index.md`

## Device bundle contents
- `devices/_index.md`
- `devices/regen_commands.md`
- `devices/roles__recommendation.md`
- `devices/laptop_specs_sanitized.txt`
- `devices/desktop_specs_sanitized.txt`
- `devices/rasberry-pi4_specs_sanitized.txt`
- `devices/digitalocean_specs_sanitized.txt`

(Optional future files — keep names stable)
- `devices/vivi_node_specs_sanitized.txt`

---

## Presence locks (canon)
- Voxia appearance lock: `chat_center/presence/voxia/appearance_lock.md`
  - If generating Voxia visuals, follow the lock (purple/indigo hair, no ribbons, no Vivi drift).

---

## Session focus (right now)
- room: work
- mode: wrap
- focus_now: stabilize SpectraPortal deploy loop + log it (laptop → GitHub → cos-forge → droplet)

---

## Status (today)
- Droplet (`cos-world-current`) serves static site from: `/srv/spectraportal`
- cos-forge deploy source currently: `/opt/spectraportal-src` (NOTE: **not a git repo** yet)
- rsync deploy verified via `stat` + `curl -I` (Last-Modified matches deployed files)

---

## Decisions (locked)
- GitHub is the canonical timeline/source-of-truth.
- Laptop is primary author.
- cos-forge is build + deploy executor (pull + build + push to droplet).
- DigitalOcean droplet is host/deploy target (no manual edits in `/srv/spectraportal`).
- Use **targeted deploy** paths (avoid syncing dev junk):
  - site: `index.html`, `theme.css`, `assets/`
  - CDN: `framework/dist/` → `/framework/cdn/v0.1/`
  - docs/demos: `framework/docs/`, `framework/demos/`

---

## Required fix (blocking)
- Make cos-forge source a real git checkout:
  - Recommended: replace `/opt/spectraportal-src` with a Git clone (or clone to `/opt/spectraportal-repo` and build from there).
  - Until this is done, “pull latest from GitHub” cannot happen on cos-forge.

---

## next_action
1) On cos-forge: create a proper git checkout (clone) for SpectraPortal.
2) Lock a single `post/deploy` command:
   - pull `--ff-only` → build → deploy (site + CDN) → verify (stat + curl)
3) Append this session summary into Chat Center logs and bump/export bundles when stable.
   - Before exporting: run `core/RESTRAINTS.md` (nested zips + size budget).

---

## Rule
Conversation is draft.
If it matters, write it into files, commit to GitHub, and (if needed) export/bump bundles.
