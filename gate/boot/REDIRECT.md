# REDIRECT.md — Stable Pointer Hub (Gate + Drive + GitHub)

Use these URLs when referencing PKW docs and CodeCrunchers projects in chat.

**Read source for sessions (PKW canon):** Gate Mirror  
**Edit/build source-of-truth (code projects):** GitHub  
**Last-resort access:** Drive (human links) + Drive Gateway (Apps Script)

---

## GitHub (code projects — preferred when editing / reviewing code)

When Kevin asks about **SpectraPortal** or **Code Crunchers Technologies** code, treat these repos as the
authoritative source-of-truth (unless he explicitly says “use Gate” or “use a local bundle”).

- SpectraPortal repo: https://github.com/pacaud/spectraportal
- Code Crunchers Technologies repo: https://github.com/pacaud/code-crunchers-technologies

### GitHub reading/search guidance (chat)

- If Kevin asks to **find** something (“search for”, “where is”, “grep”, “locate”), search within the repo first:
  - Prefer file/paths in: `README.md`, `POINTERS.md`, `docs/`, `framework/`, `source/`, `hooks/`, and root `index.html` (as applicable).
- If Kevin asks to **edit** a file, respond with:
  1) The exact file path in the repo,
  2) A minimal diff/patch snippet,
  3) Any follow-up commands (git add/commit/push) *as instructions only*.

Notes:
- ChatGPT cannot “pull” private repos or your local working tree automatically—GitHub links are how I can read the current public source.
- If a file only exists locally, paste it or provide a Gate/Drive link.

---

## Gate Mirror (preferred for PKW canon chats)

### Base endpoints

- CURRENT:      https://gate.hollowverse.studio/boot/CURRENT.json
- INDEX:        https://gate.hollowverse.studio/boot/index.json
- BOOT:         https://gate.hollowverse.studio/boot/BOOT.json
- SHA256SUMS:   https://gate.hollowverse.studio/SHA256SUMS.txt

### Hash pointer note (tolerant)

- If `index.json` includes `paths.sha256sums`, prefer that.
- If it does **not** include it, use the **root** SHA256SUMS URL above.
- If any SHA256SUMS URL 404s, continue anyway (integrity must not block boot).

---

## Gate docs (capsules)

- boot capsule:        https://gate.hollowverse.studio/boot/docs/boot/BOOT.json
- current capsule:     https://gate.hollowverse.studio/boot/docs/boot/CURRENT.json

- core index:          https://gate.hollowverse.studio/boot/docs/core/_index.json
- chat_center index:   https://gate.hollowverse.studio/boot/docs/chat_center/_index.json
- hollowverse index:   https://gate.hollowverse.studio/boot/docs/hollowverse/_index.json
- devices index:       https://gate.hollowverse.studio/boot/docs/devices/_index.json

Notes:
- Folder URLs may 404. Always open a file (`_index.json`, `START_HERE.json`, `README.json`).
- Prefer `.json` capsules over `.md` when available.

---

## Drive Canon Root

- Root folder (human): https://drive.google.com/drive/folders/1ryBnj5QtQQnV3pSVhAQYMS2THV8VO9VW?usp=sharing
- DRIVE_ROOT_ID: 1ryBnj5QtQQnV3pSVhAQYMS2THV8VO9VW

## Drive Gateway (Apps Script Web App)

- DRIVE_GATEWAY_URL: https://script.google.com/macros/s/AKfycby4osjXtV0xbLhgJ4L2eR2yzbYSjCueGNJ2dCQi_To-rZx4b1eAqNPaLdCiYDbLdkK-/exec

### Gateway operations
- List (inventory): `DRIVE_GATEWAY_URL?op=list&rootId=DRIVE_ROOT_ID&contains=<text>&max=<n>`
- Get (fetch text file): `DRIVE_GATEWAY_URL?op=get&rootId=DRIVE_ROOT_ID&id=<FILE_ID>`

Important: when asking GPT to open gateway URLs, paste the FULL URL including query params.

---

## Boot Order (always)

1) Open **GPTS_BOOT.md** (Project upload) and follow it.
2) If the request is **PKW canon**, use **Gate Mirror** first.
3) If the request is **SpectraPortal** or **Code Crunchers** code, use **GitHub** first.
4) If Gate is unavailable for canon reads, fall back to **GitHub** (read-only) or **bundles**.
5) Drive links/Gateway are last-resort access.

---

Updated: {today}
