# PKW Boot (MD-first)

This is the authoritative capsule launcher.
GPTS_BOOT.md must open this file first and then follow it exactly.

## Root mode
This capsule is scope-rooted (paths like `boot/`, `chat_center/`, `core/` at zip root).
Do not assume a `docs/` prefix.

---

## Step 1 — Enter Chat Center (required)
Open:
- `chat_center/START_HERE.md`

After START_HERE loads:
- Follow it exactly.
- START_HERE is responsible for loading:
  - `chat_center/system/style.md`
  - `chat_center/system/routing_policy.md`
  - `chat_center/system/system_manifest.md` (if present)

---

## Optional references (do NOT open unless requested)
- `boot/CURRENT.md`
- `boot/REDIRECT.md`

---

# End of BOOT