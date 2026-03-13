# routing_policy.md — Lane Switching + Sources (Chat Center System)

This file defines **where information should come from** (capsules vs GitHub),
and how we switch lanes safely.

It is loaded **after** `boot/BOOT.md` and `boot/CURRENT.*`,
as part of the Chat Center system layer.

---

## Inputs

### 1) boot/REDIRECT.md (preferred)
If `boot/REDIRECT.md` exists in the active capsule, it is the first source for:
- project repo URLs
- lane defaults
- allowed scopes

### 2) chat_center/system/system_manifest.md (always)
This defines global chat behavior (speaker tags, modes, safety rails).

If routing conflicts with system rules, **system rules win**.

---

## Lanes

### Lane A — Capsule Canon (PKW canon / bundles / docs)
Use the **active capsule ZIP** as source-of-truth for:
- world / lore / vault / indices
- chat_center docs and rooms
- bundle manifests

Rules:
- Respect ROOT_MODE (DOCS_MODE vs SCOPE_MODE).
- Do not guess paths that don’t exist.
- Do not scan the entire capsule; open only what’s needed.

### Lane B — Code Projects (Repo-first)
Use GitHub (or other repo targets declared in REDIRECT) for:
- SpectraPortal
- Code Crunchers Technologies
- other engineering repos

Rules:
- Prefer repo targets in `boot/REDIRECT.md`.
- If REDIRECT is missing, fall back to known defaults (if provided in system files).
- No Gate access is assumed unless a connector/API is explicitly available.

When proposing edits:
1) Provide exact file path(s)
2) Provide minimal diff/patch
3) Provide terminal commands as instructions only

---

## Lane switching rules (simple)

Switch to **Lane B** when the user asks for:
- code edits, CSS/JS changes, repo refactors
- “check my repo”, “update the framework”, “make a patch”
- anything that clearly lives in Spectra/CCT repositories

Otherwise stay in **Lane A**.

If unclear:
- Ask one small clarifying question **or**
- Default to Lane A and request the needed repo link/path.

---

## Boot-time loading behavior

After `CURRENT` and Chat Center Hub load:
1) Read `boot/REDIRECT.md` if present (non-blocking)
2) Read `chat_center/system/system_manifest.md` (non-blocking)
3) Read this file `chat_center/system/routing_policy.md` (non-blocking)

If any are missing:
- continue without blocking
- report what was missing in `boot status` if asked

---

Updated: 2026-03-01
