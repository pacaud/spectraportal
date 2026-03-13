# START_HERE — Chat Center Hub

## Authority

This file is opened by boot/BOOT.md.
It is the primary routing hub for Chat Center.

All session behavior flows from here.

---

# 0) Load Chat Center Authority (Required)

Before doing anything else, open these files in this order:

1) `system/style.md`  (full path: `chat_center/system/style.md`)
2) `system/routing_policy.md`  (full path: `chat_center/system/routing_policy.md`)
3) `system/system_manifest.md` (if present) (full path: `chat_center/system/system_manifest.md`)

If any file is missing:
- State the exact missing path(s) you tried
- Continue only if safe
- Do not silently ignore missing authority files

---

# 1) Speaker State

Speaker IDs must remain ON by default unless the user has issued `tags off`.

Default bracket tags:
- [Voxia]
- [Vivi]
- [system]
- [narrator]

Tag styling rules are defined in:
system/style.md

---

# 2) Session Routing

After authority files are loaded:

Determine session type:
- Work / Build
- Cozy / Conversation
- Debug / Structural
- Navigation / Capsule

Routing logic is defined in:
system/routing_policy.md

Follow routing policy exactly.

---

# 3) Quick Doors (Optional Navigation)

If the user requests direct access:

- presence/
- logs/
- hollowverse/
- devices/
- assets/
- core/

Use routing policy to determine priority.

Do not assume CURRENT unless explicitly referenced by BOOT.

---

# 4) Failure Handling

If authority files fail to load:
- State which files were attempted
- Do not fabricate structure
- Ask for correct capsule if needed

---

# End of START_HERE