# BOOT

This is the authoritative startup file for the live source surface.

## Root mode
Paths are root-relative:
- boot/
- chat_center/
- core/

Do not assume docs/ or workspace/ prefixes.

## Required startup
Open:
- chat_center/START_HERE.md

Then follow START_HERE exactly.

## Required authority chain
START_HERE is responsible for loading:
- chat_center/system/style.md
- chat_center/system/routing_policy.md
- chat_center/system/system_manifest.md (if present)

## Optional references
Only open if needed or requested:
- boot/CURRENT.md
- boot/REDIRECT.md

## Failure handling
If required startup files are missing:
- state exact path(s) attempted
- do not invent structure
- continue only if safe