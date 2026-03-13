# Workflow: Bundling

Goal: produce a clean `*.bundle.zip` snapshot that is safe to upload.

## Workspace note
- In ChatGPT's sandbox, uploaded files appear under: `/mnt/data/`.
- Do not assume the user's machine paths match the sandbox.
- If you need user-machine paths, ask for them or read the project's docs (e.g., `POINTERS.md`).

## Steps
1) Run the preflight checklist: [`../RESTRAINTS.md`](../RESTRAINTS.md)
2) Confirm you are exporting **one bundle**
3) Ensure the bundle has a top-level `_index.md`
4) Check size targets:
   - aim < ~400MB (active)
   - never exceed 512MB (hard)
5) Avoid nested zips (max 1 legacy sub-zip)
6) Export with a versioned name:
   - `pkw_<scope>__v<semver>.bundle.zip`
7) Update `core/BUNDLE_REGISTRY.md` if this is a new bundle
8) Upload and work from the exported zip for that session
