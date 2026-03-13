# REDIRECT.md — Stable Pointer Hub (Gate + external source status)

Use this file to resolve **preferred sources**, **source status**, and **fallback order** for PKW docs and project questions.

This file is **optional at boot**.
Open it only when source resolution, project targeting, or external pointer selection is needed.

---

## Purpose

Use this file to answer questions like:
- which source should be treated as preferred for this task?
- which sources are currently active vs inactive?
- where should repo-oriented work point once external sources are re-enabled?
- what is the fallback order if an external source is unavailable?

This file does **not** grant access by itself.
Do not assume any connector, repo read capability, or external fetch capability unless it exists in the live tool surface.

---

## Source status

### 1) Loaded Gate surface / active capsule docs
Status: **ACTIVE**

Prefer the currently loaded Gate surface or active capsule docs for:
- PKW canon
- chat_center docs and rooms
- core docs
- bundle structure and internal documentation
- current live routing authority

If no live mirror/base URL is formally locked yet:
- use the currently mounted/readable Gate surface first
- avoid hard-coding public hostnames into routing language
- treat hostnames and mirror endpoints as deployment details, not routing authority

### 2) GitHub repo targets
Status: **INACTIVE / not hooked up**

Do **not** treat GitHub as an active routing source until it is actually connected and verified in the current environment.

GitHub may still be the intended future source-of-truth for repo-oriented work, but while inactive:
- do not route to GitHub by default
- do not imply repo search/read access
- do not present repo URLs as if they are currently usable workflow endpoints
- if repo guidance is still useful, provide path-level guidance only when the needed structure is already known from the live surface or user-provided files

### 3) Drive / Drive Gateway
Status: **INACTIVE / not hooked up**

Do **not** treat Drive as an active fallback until it is actually connected and verified.

While inactive:
- do not route to it by default
- do not print stale folder IDs or gateway URLs as if they are ready to use
- treat Drive wiring as an integration/deployment detail, not a routing dependency

---

## External source placeholders

These are placeholders for future activation, not current routing promises.

### GitHub placeholders
- `SPECTRAPORTAL_REPO_URL`: UNSET
- `CCT_REPO_URL`: UNSET

When GitHub is re-enabled:
- add the approved repo URLs here
- mark GitHub as ACTIVE only after the environment can actually use it
- keep repo access wording truthful to the real tool surface

### Gate endpoint placeholders
Only use concrete endpoint URLs after a real Gate base URL or mirror host is officially locked.
Until then, keep endpoint references symbolic or local to the mounted/readable surface.

- `GATE_BASE_URL`: UNSET
- `GATE_BOOT_POINTER`: `boot/BOOT.*`
- `GATE_CURRENT_POINTER`: `boot/CURRENT.*`
- `GATE_INDEX_POINTER`: `boot/index.*`
- `GATE_SHA256_POINTER`: `SHA256SUMS.txt`

Rules:
- do not hard-code a public hostname until it is formally adopted
- prefer exact file pointers over folder URLs
- prefer the active mirror format (`.json`, `.md`, or other) that the live surface actually uses
- integrity pointers must not block boot or safe progress
- if external access is unavailable, do not pretend any endpoint was opened

### Drive placeholders
- `DRIVE_ROOT_ID`: UNSET
- `DRIVE_GATEWAY_URL`: UNSET

When Drive is re-enabled:
- add the current live root ID and gateway URL here
- mark Drive as ACTIVE only after verification

---

## Selection rules

Use these rules when deciding which source to point to:

1) For PKW canon or Chat Center structure questions, prefer the loaded Gate surface or active capsule docs
2) Do not use GitHub unless it has been explicitly re-enabled and verified
3) Do not use Drive unless it has been explicitly re-enabled and verified
4) If an inactive source would normally be preferred, say that it is inactive and continue with the best valid Gate-local path
5) Do not use a public Gate hostname as authority until that hostname is officially adopted

---

## Repo-oriented work while GitHub is inactive

If the user asks for SpectraPortal, Code Crunchers Technologies, or other repo-style work while GitHub is inactive:
- use Gate/local docs if they contain the needed structure
- ask for pasted file text or an accessible local/Gate path when exact code content is required
- provide minimal patch suggestions only when the target file/path is known
- do not imply that a repo was searched or opened

---

## Boot order reference

At session start, follow the actual boot chain:
1) `GPTS_BOOT.md`
2) `boot/BOOT.md`
3) `chat_center/START_HERE.md`
4) Chat Center authority files required by `START_HERE`

Open `REDIRECT.md` only when needed for source selection or project routing.

---

Updated: 2026-03-13