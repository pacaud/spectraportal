# routing_policy.md — Lane Switching + Sources (Chat Center System)

This file defines **where information should come from** (capsules vs code sources),
and how lanes should be selected without breaking the boot chain.

It is loaded by `chat_center/START_HERE.md` after:
- `boot/BOOT.md`
- `chat_center/system/style.md`
- `chat_center/system/system_manifest.md` (if present)

It does **not** require `boot/CURRENT.md`.
It may use `boot/REDIRECT.md` only when source resolution or project routing needs it.

---

## Authority order

Use routing authority in this order:

1) `boot/BOOT.md`
2) `chat_center/START_HERE.md`
3) `chat_center/system/system_manifest.md` (if present)
4) this file: `chat_center/system/routing_policy.md`
5) `boot/REDIRECT.md` only when needed for repo targets, pointers, or lane-specific source selection
6) `boot/CURRENT.md` only when requested or when the user explicitly needs active-bundle/session context

If routing conflicts with higher authority files, the higher authority file wins.

---

## Inputs

### 1) Chat Center system files (default)
Use Chat Center system files as the default routing surface for:
- session type detection
- speaker / mode constraints
- safe lane selection

### 2) boot/REDIRECT.md (conditional)
Open `boot/REDIRECT.md` only when needed for:
- project repo URLs
- stable external pointers
- lane-specific source targets
- cases where the user is asking about a code project and the target source must be resolved

If `boot/REDIRECT.md` is missing, continue conservatively.
Do not invent repo access, routes, or connectors.

### 3) boot/CURRENT.md (context-only)
Open `boot/CURRENT.md` only when the user asks for:
- current bundle/session state
- active upload set
- current focus / current room / current locks
- another question that explicitly depends on current session context

Do not treat `CURRENT` as mandatory boot input.

---

## Lanes

### Lane A — Capsule / Gate Canon
Use the loaded Gate / capsule docs as source-of-truth for:
- chat_center docs and rooms
- PKW canon / lore / vault / indices
- bundle manifests
- core docs when the question is documentation or structure oriented

Rules:
- Respect root-relative paths from `boot/BOOT.md`
- Do not guess paths that do not exist
- Do not scan broadly when a direct file is enough
- Stay in this lane by default unless the request clearly points to code/repo work

### Lane B — Code Projects / Repo-Oriented Work
Use repo-targeted sources or repo-oriented guidance for:
- SpectraPortal
- Code Crunchers Technologies
- framework edits
- code patches, refactors, CSS/JS/file edits
- repo structure questions

Rules:
- Prefer repo targets from `boot/REDIRECT.md` when that file is opened and available
- If `REDIRECT` is not opened or is unavailable, state that the repo target is unresolved and continue with the best valid guidance
- Do not claim direct repo access unless a real connector/action exists
- When proposing edits, provide:
  1) exact file path(s)
  2) a minimal diff/patch
  3) commands only as instructions

---

## Lane switching rules

Switch to **Lane B** when the user asks for:
- code edits
- CSS / JS / framework changes
- repo refactors
- file patches
- “check my repo”, “update the framework”, “make a patch”
- anything that clearly belongs to SpectraPortal, Code Crunchers Technologies, or another engineering repo

Otherwise stay in **Lane A**.

If unclear:
- ask one small clarifying question, or
- default to Lane A and request the exact repo/path only if the task actually needs it

---

## Boot-time behavior

When loaded from `chat_center/START_HERE.md`:
1) use the boot chain already in effect
2) apply routing from this file
3) open `boot/REDIRECT.md` only if source resolution is needed
4) open `boot/CURRENT.md` only if the user requests current-session context or the task explicitly depends on it

Missing optional files must not block progress.
If an optional file is not opened or is unavailable:
- state that plainly when relevant
- continue with the best valid path

---

Updated: 2026-03-13