# Export Rules — PKW Core

This document defines how PKW content is exported for **Gate viewing** and for
ChatGPT-compatible reading.

---

## 1) Gate is viewer-only

- The DigitalOcean droplet (Gate) is **read-only / viewer-only**.
- **No git clone/pull/build happens on DO.**
- All builds happen on a **build machine** (the machine that has the repo).
- The build machine publishes a static export to DO via `rsync` + **atomic swap**.

---

## 2) Publish only approved slices

Gate should only host the minimum “public slice” needed for routing + rules.

### Current baseline slices
- `boot/` (entry + boot documents)
- `core/` (global rules/registries)
- `chat_center/` (global hub for all companion voices)

Everything else stays private until explicitly added to the export.

---

## 3) Output layout (public URLs)

All Gate content is served under the `/boot/` prefix.

### Required files (top-level)
- `/boot/index.json`
- `/boot/BOOT.json`
- `/boot/CURRENT.json`
- `/boot/SHA256SUMS.txt`

### Required docs root
- `/boot/docs/`

### Slice roots (public)
- `/boot/docs/boot/`
- `/boot/docs/core/`
- `/boot/docs/chat_center/`

Rule: **chat_center is world-agnostic** (shared hub for all companion voices).
It must not live under `/hollowverse/` in the public export.

---

## 4) JSON capsule rule (critical)

### Rule
For every exported `.md` or `.txt` file, generate a **same-name JSON capsule**
beside it:

- `something.md` → `something.json`
- `something.txt` → `something.json`

No double extensions like `.md.json` or `.txt.json`.

### Why
Some consumers (including ChatGPT web fetch) do not reliably open raw `.md`.
They **do** reliably open JSON.

### Capsule schema (required)
Each capsule MUST include:

- `schema`: `pkw.text.v1`
- `format`: `markdown` or `text`
- `source_url`: public URL to the original file
- `sha256`: sha256 of the original content
- `bytes`: byte length of the original content
- `content`: full original file content as a string

---

## 5) CURRENT.json must be JSON-first

`/boot/CURRENT.json` MUST include:

- `docs.preferred = "json"`
- `docs.boot_json = "/boot/docs/boot/BOOT.json"`
- `docs.current_json = "/boot/docs/boot/CURRENT.json"`

And must declare the slice roots:

- `docs.core_root = "/boot/docs/core/"`
- `docs.chat_center_root = "/boot/docs/chat_center/"`

Consumers must prefer `*_json` pointers when `preferred=json`.

---

## 6) index.json is the public entry

`/boot/index.json` MUST point to:

- `current: "/boot/CURRENT.json"`
- `boot: "/boot/BOOT.json"`
- `docs_*` roots (boot/core/chat_center)

This is the “start here” map for any viewer.

---

## 7) File type allowlist (exported to Gate)

Export should include only:
- `.json`
- `.md`
- `.txt`

Everything else is excluded unless explicitly approved.

---

## 8) Deployment must be atomic

Deployment to DO must use:
- upload to a temp directory (e.g. `/var/www/.boot_incoming_<stamp>`)
- then rename/swap into `/var/www/boot`
- keep one previous backup directory (optional but recommended)

This prevents half-written exports.

---

## 9) Verification commands (required)

After publish, verify these return 200 and JSON content:

- `curl -I https://gate.hollowverse.studio/boot/CURRENT.json`
- `curl -I https://gate.hollowverse.studio/boot/docs/boot/BOOT.json`
- `curl -I https://gate.hollowverse.studio/boot/docs/core/_index.json`
- `curl -I https://gate.hollowverse.studio/boot/docs/chat_center/_index.json`

Notes:
- Directory URLs may 404 (nginx directory listing is off). Always check a file URL.
- `Cache-Control: no-store` is preferred for routing files.

---

## 10) Don’t leak private structure

Anything not included in the published slices is treated as:
- private
- non-canon for Gate viewers
- not available to ChatGPT via Gate

To publish something new, add it explicitly as a new slice in the exporter.
