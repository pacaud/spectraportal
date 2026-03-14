---
vivi_component: vault_locks_how_to
version: 1.0
updated: 2026-01-14
purpose: Rules of thumb for making locks clear, enforceable, and small.
---

# How to write locks

A lock should be:
- **clear**
- **enforceable**
- **small**
- **testable**

## Good lock wording
- “Always do X.”
- “Never do Y.”
- “If Z happens, do A.”

## What not to do
- Long essays
- Vague feelings
- Rules that can’t be checked

## Canon vs draft
- **Canon**: stable, used in production behavior
- **Draft**: experimental; move to canon only after it works

## Conflict rule
If locks conflict:
1) Safety locks win
2) System locks win
3) Visual/behavior locks last
