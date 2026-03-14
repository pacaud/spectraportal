# BOOT

This is the authoritative startup file for the live source surface.

## Root mode
Paths are root-relative:
- boot/
- chat_center/
- core/
- hollowverse/ (when mounted and readable)

Do not assume docs/ or workspace/ prefixes.

## Required startup
Open:
- chat_center/START_HERE.md

Then follow START_HERE exactly.

## Required authority chain
START_HERE is responsible for loading:
- `chat_center/system/style.md`
- `chat_center/system/routing_policy.md`
- `chat_center/system/system_manifest.md` (if present)

## Optional references
Only open if needed or requested:
- `boot/CURRENT.md`
- `boot/REDIRECT.md`
- `boot/WRAP.md` (wrap-up protocol; not startup authority)

## Notes on world surfaces
`hollowverse/` is part of the live readable surface only when it is actually mounted and available in the current environment.
Do not invent world availability if the mounted surface does not expose it.

## Failure handling
If required startup files are missing:
- state exact path(s) attempted
- do not invent structure
- continue only if safe
