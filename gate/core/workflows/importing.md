# Workflow: Importing (Bundle → ChatGPT workspace)

Goal: safely open and use an uploaded `*.bundle.zip` inside the ChatGPT sandbox.

## Workspace rule (important)
- In ChatGPT, uploaded files live under: `/mnt/data/`.
- This is a temporary sandbox path.
- Do not assume these paths exist on the user's machines.

## Steps
1) Locate the uploaded zip in `/mnt/data/` (list files before acting)
2) Unzip into a clearly named folder:
   - Example: `/mnt/data/<bundle_name>_unzip/`
3) Verify the bundle is sane:
   - a top-level `_index.md` exists (or a clear hub)
   - links point to real files (no broken paths)
4) Navigate using the bundle’s `START_HERE.md` (shortcuts only) → hub/index → content
5) Resume from `chat_center/logs/_index.md` (if applicable)

## If the user needs to import locally
- Prefer relative instructions ("run from repo root") instead of hard-coded absolute paths.
- If absolute paths matter, ask the user for their local paths.
- If a repo is involved, read `POINTERS.md` first.
