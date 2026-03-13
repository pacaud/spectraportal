# RESTRAINTS — Export Preflight

This is the **fast checklist** to run before exporting any `*.bundle.zip`.
Its job is to catch mistakes that cause upload failures or slow sessions.

## Workspace note
- In ChatGPT, uploaded files live under: `/mnt/data/`.
- Do not assume user-machine paths match the sandbox.

## 1) Nested zip rule (must pass)
Inside the bundle folder you are exporting:
- Preferred: **0** `*.zip` files
- Allowed only by explicit exception: **1** legacy sub-zip

If nested zips are found:
- **Stop** and flatten the structure (unzip, move contents out, then delete the inner zip).
- Re-export the bundle once the folder tree contains only normal files/folders.

Quick checks (run from the bundle folder you plan to zip):

**Linux/macOS**
- List nested zips: `find . -type f -name "*.zip" -print`

**Windows PowerShell**
- List nested zips: `Get-ChildItem -Recurse -Filter *.zip | Select-Object FullName`

Pass condition:
- The command prints **nothing**, or prints **exactly one** legacy zip you intentionally allowed.

## 2) Size budget rule (should pass)
- Hard limit: **512 MB**
- Design target: **≤ ~400 MB** (80% budget)

Quick checks (after exporting the zip):

**Linux/macOS**
- `ls -lh your.bundle.zip`
- or `du -h your.bundle.zip`

**Windows PowerShell**
- `(Get-Item .\your.bundle.zip).Length / 1MB`

If you are over the 80% budget:
- Move heavy assets into the Assets bundle.
- Split the export (export one bundle only).
- Remove duplicates.

## 3) One compression boundary
If you need to work inside something daily, export it as a **top-level bundle**.
Avoid zip-inside-zip workflows.

## 4) Optional automation (local)
A small preflight script may be used locally to:
- fail if nested zips > allowed
- warn if zip size > 80% budget
