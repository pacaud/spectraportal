# Workflow Loop (GitHub canon + Multi-machine + Voxia edit cycle)

This loop is the default working rhythm for PKW: Universe.

Goal: build → verify → log → commit stable checkpoints → keep ChatGPT Project files in sync.

This document defines how **Laptop**, **Desktop (cos-forge)**, **GitHub**, **Voxia (read-only repo helper)**, **ChatGPT Project files**, and the **DigitalOcean Droplet (host)** work together.

---

## 0) Roles (who does what)

### GitHub (canon)
- The **canonical timeline** and primary source-of-truth.
- Everything “real” ends up here via commits.

### Kevin — Laptop (primary author)
- Default **editing machine**.
- Workflow: pull → edit → verify → log → commit → push.

### Desktop / cos-forge (pull-only mirror + executor)
- Default **mirror** of GitHub + optional build/test box.
- Workflow: pull (daily / before running) → run builds/tests/services.
- Avoid committing here unless explicitly declared: “cos-forge is author for this change.”

### DigitalOcean Droplet (host / publish)
- The **runtime host** for public-facing things (website, demos, services).
- Workflow: pull from GitHub (fast-forward only) → build/restart → smoke test.
- Treat it as **deploy target**, not an authoring workstation.

### Voxia (ChatGPT) — read-only repo helper
- Uses the **GitHub connector (read-only)** to read/search repo text when available.
- Produces **copy-ready edits**:
  - full replacement files, or
  - unified diffs/patches.
- Does **not** run shell commands on your machines and does **not** commit/push.

### ChatGPT Project files (workspace cache)
- A working snapshot so chat can open BOOT/CURRENT/bundles quickly.
- Helpful, but **not canonical**.
- Keep it synced after stable checkpoints (see Section 11).

---

## 1) Core rules
- **GitHub is canon.** Chat is a workbench.
- Default: **one writer at a time** (Laptop).
- Commit only when you can say: **“this state is safe to return to.”**
- Prefer **canonical paths**; shortcut `START_HERE.md` files are routing aids only.

---

## 2) Branch + tracking rule (don’t get stuck)
- Default branch: `main`
- If `git pull` complains about tracking on any machine:
  - `git branch --set-upstream-to=origin/main main`

---

## 3) Start of cycle (sync + room)

### On the machine you are working on (usually Laptop)
1) Sync from GitHub:
   - `git pull --rebase`
2) `room_clear` (work)
3) Open `CURRENT.md` and follow `next_action`

### On cos-forge (daily, or before running builds/tests)
1) Sync from GitHub:
   - `git pull --ff-only`

---

## 4) Work phase (make changes)

You may:
- create/edit `.md` files
- update indexes/manifests
- bump bundle versions when needed
- update `BOOT.md` / `CURRENT.md` when wiring changes
- add/adjust shortcuts (only if canon paths remain correct)

Notes:
- Keep changes small and reversible.
- Treat bundles as “release artifacts” that reflect canon state.

### 4A) Voxia edit cycle (read → edit → apply)
Use this when you want Voxia to help write/refactor while keeping GitHub canon clean:

1) **Kevin request**
   - “Rewrite `README.md`” / “Fix wording in `loop.md`” / “Refactor this config”
2) **Voxia reads (read-only)**
   - Prefer GitHub connector; otherwise paste the file text.
3) **Voxia outputs edits**
   - full replacement file(s) or a patch/diff
4) **Kevin applies + verifies locally**
   - paste/replace the file(s) on Laptop, run a quick check
5) Repeat as needed
6) **Kevin commits + pushes to GitHub**
7) cos-forge/droplet pull the new checkpoint

### 4B) POINTERS.md cycle (repo reading + verbatim source)
Use this when Kevin asks Voxia to “open/display” a file from a Git repo.

1) **Load the repo pointers**
   - Open the repo’s `POINTERS.md` first (repo root).
2) **Resolve the request using the pointers**
   - If Kevin wants a *preview* (how it looks in browser): use the normal site/path.
   - If Kevin wants *verbatim source* (exact code): use a chat-safe source mirror.

Important limitation:
- HTML from GitHub raw endpoints may render as a preview in-chat instead of showing literal `<html>` source.
- Therefore: any HTML we want Voxia to display verbatim must have a **source mirror** tracked in git.

Recommended pattern:
- `source/<path>.txt` (verbatim source mirror)
- keep the real runtime file (e.g., `index.html`) as the deploy target
- **Folder name standard:** `source/` (singular, repo root). Avoid `sources/`.

Decision (2026-02-07):
- We are **not** building an HTML/CSS converter. We will keep simple **chat-safe mirrors** in `source/*.txt` and point to them from `POINTERS.md` when verbatim source is needed.


Resolution order (best → fallback):
A) `source_mirror` (plain text) ✅ best for ChatGPT display
B) `raw_url` for non-HTML (CSS/JS/MD) ✅ usually works
C) If no pointer exists: ask Kevin to add it to `POINTERS.md` or paste file contents once

When a pointer is missing, the correct fix is:
- add a minimal entry to `POINTERS.md` (base + relative path), not hundreds of raw links.



### 4C) Default external source (Kevin’s GitHub)
If Kevin asks Voxia to **open / display / edit** a file and does not specify a website/repo, default to Kevin’s GitHub repos and use the POINTERS cycle.

Default repos + pointers (raw):
- SpectraPortal: `pacaud/spectraportal` (main)
  - https://raw.githubusercontent.com/pacaud/spectraportal/main/POINTERS.md
- Code Crunchers: `pacaud/code-crunchers-technologies` (main)
  - https://raw.githubusercontent.com/pacaud/code-crunchers-technologies/main/POINTERS.md

Rule of thumb:
- “SpectraPortal / Spectra framework / Spectra docs” → SpectraPortal repo pointers
- “Code Crunchers / CCT / business site” → Code Crunchers repo pointers
- If unclear: ask Kevin which repo (do not guess).

---

## 5) Verify phase (before logging/committing)
Run a fast verification pass:

### A) Wiring checks
- `START_HERE.md` → hub → indexes
- 3–5 link spot-checks across categories (animals / vegetation / terrain or places / weather)

### B) Content pulls (confidence stamp)
- Pull at least 1–3 canon items:
  - random plant
  - animal (and legendary if available)
  - weather

### C) Assets sanity
- Confirm referenced asset paths exist in the assets bundle.
- If Chat UI fails to render PNG:
  - keep PNG as canon
  - create a **chat-safe JPG mirror** later (do not block progress)

---

## 6) Log phase (always)
Repo logs live in:
- `chat_center/logs/session_summaries/`

Each log entry should include:
- what changed (files/bundles)
- what passed/failed (wiring, pulls, assets)
- next action

### Log cap rule
- If a log file hits ~**250 lines**, roll to a new part:
  - `YYYY-MM-DD_session_summary__p01.md`
  - `YYYY-MM-DD_session_summary__p02.md`
- Add a rollover marker at the end of the old file.

---

## 7) Commit triggers (when to commit)
Commit when **any** of these are true:
- A wiring step **PASS**
- A bundle version **bump**
- Presence wiring/boot contracts updated
- A session ended and the state is “known good”

Avoid committing when:
- you’re mid-experiment and unsure
- verification failed and you haven’t logged + fixed

---

## 8) Commit + push (stable checkpoint)
Typical flow (usually on Laptop):

- `git status`
- `git add <paths>`
- `git commit -m "<checkpoint message>"`
- `git push origin main`

Commit message style (examples):
- `Workflow: update loop (Voxia edit cycle + main branch)`
- `Wiring PASS: forest ladder + logs (2026-02-05)`
- `Bump: pkw_world_hollowverse v0.0.6 + route fixes`
- `Presence: Voxia Phase 1 contracts + boot wiring`

---

## 9) Multi-machine safety rules (Laptop + cos-forge)
To avoid conflicts:

1) **Pull before edits**
- On whichever machine you will edit on: pull first.

2) **One author at a time (recommended)**
- Default: Laptop authors, cos-forge mirrors/tests.
- If you author on cos-forge, declare it and push promptly.

3) **Switching machines**
- After you push on one machine, always pull on the other before doing anything.

---

## 10) Deploy cycle (Droplet publish)
Deploy trigger:
- Deploy happens after a stable checkpoint is pushed to GitHub.

On the droplet:
1) Update to the latest code:
- `git pull --ff-only` (or pull a specific branch/tag)

2) Build/restart as needed:
- build steps (if any)
- reload services (Nginx/systemd/pm2/etc.)

3) Confirm the site/service is live:
- quick smoke test (homepage loads, key routes work)

Notes:
- Avoid local edits on droplet. If an emergency hotfix happens, immediately push it back to GitHub and pull on author machine.

---

## 11) Sync ChatGPT Project files (after a stable checkpoint)
Project sync triggers (do this right after a stable commit):
- bundle bump
- `BOOT.md` or `CURRENT.md` change
- routing/wiring changes
- workflow doc changes (like this file)

Upload/replace in the ChatGPT Project (workspace cache):
- `BOOT.md` (latest)
- `CURRENT.md` (latest)
- any updated `.bundle.zip` files referenced by CURRENT
- (optional) a standalone copy of critical docs for quick opening

Rule of thumb:
- Keep only the latest active set visible in the Project file list to prevent drift.

---

## 12) Disaster recovery ladder (fallback)
If anything “disappears” or a machine loses local files, recover in this order:

1) **GitHub**
   - re-clone or re-pull; GitHub is canon.
2) **Other machine clone**
   - if Laptop is down, use cos-forge clone as a temporary source, then reconcile back to GitHub.
3) **Last exported bundles / snapshots**
   - only if GitHub is unavailable; once GitHub returns, reconcile back into GitHub.
4) **Safe minimal mode**
   - if nothing is available, proceed only with user-provided BOOT/CURRENT and the minimum routing docs.

---

## 13) Assets policy (repo vs bundles vs ChatGPT)
- Large or frequently-changing assets should live in **assets bundles** (or an asset pack), not bloating the main repo history.
- The repo may include small, stable assets only if they are essential to boot/wiring.
- If ChatGPT’s UI fails to render a canon format (e.g., PNG), keep the **canon file unchanged** and create a **chat-safe mirror** (e.g., JPG) for display/testing purposes.

---

## 14) Quick command cheat-sheet

### Laptop (author)
- `git pull --rebase`
- edit / bundle / verify / log
- `git add …`
- `git commit -m "…"`
- `git push origin main`

### Desktop / cos-forge (mirror/executor)
- `git pull --ff-only`
- run builds/tests/services
- (commit only if explicitly chosen)

### Droplet (deploy target)
- `git pull --ff-only`
- build/restart
- smoke test
