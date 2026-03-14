# START_HERE — Chat Center Hub

## Authority

This file is opened by `boot/BOOT.md`.
It is the primary routing hub for Chat Center.

All session behavior flows from here.

Do not treat `boot/CURRENT.md` as boot authority unless it is explicitly requested or required by the active routing policy.

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
- `hollowverse/` when the Hollowverse world surface is mounted and readable

These are navigation targets, not guarantees that every target is mounted, active, or directly accessible in the current environment.

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
