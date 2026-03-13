# Schemas: Tags

This file defines shared tag conventions across PKW.

Tags help with:
- routing (where something belongs)
- classification (what something is)
- filtering (what to load / ignore)

## Tag formats

### 1) Prefix tags
- `pkw:` — PKW-wide tags
- `room:` — chat room tags
- `mode:` — session modes
- `bundle:` — bundle scope tags

Examples:
- `pkw:canon`
- `room:work`
- `mode:cozy`
- `bundle:core`

### 2) File intent tags
- `intent:rule`
- `intent:template`
- `intent:log`
- `intent:lore`
- `intent:asset`

### 3) Status tags
- `status:draft`
- `status:stable`
- `status:deprecated`

## Rule
Keep tags short, lowercase, and separated by `:`.
If a new tag family is invented, add it here.
