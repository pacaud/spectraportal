# Workflow: Exporting (Step-by-step)

Use this as the practical checklist when exporting a bundle.

## Workspace note
- In ChatGPT's sandbox, uploaded files appear under: `/mnt/data/`.
- Do not assume the user's machine paths match the sandbox.
- If you need user-machine paths, ask for them or read the project's docs (e.g., `POINTERS.md`).

## Steps
1) Run the preflight checklist: [`../RESTRAINTS.md`](../RESTRAINTS.md)
2) Confirm you are exporting **one bundle**
3) Confirm there is a top-level `_index.md`
4) Check size target (< ~400MB active)
5) Avoid nested zips (max 1 legacy sub-zip)
6) Export to a versioned `*.bundle.zip`
7) Download and sanity-check the zip
8) Upload to chat for the session
9) If this is a new bundle, register it in:
   - [`../BUNDLE_REGISTRY.md`](../BUNDLE_REGISTRY.md)

## Authority
For the rules/policy, see:
- [`../EXPORT_RULES.md`](../EXPORT_RULES.md)
- [`../CONSTRAINTS.md`](../CONSTRAINTS.md)
