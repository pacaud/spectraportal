# Naming Rules — PKW Core

These rules ensure bundles and files remain readable, sortable, and unambiguous.

## Bundle filename format (recommended)
```
pkw_<scope>__<name_optional>__v<semver>.bundle.zip
```

### Examples
- `pkw_core__v0.1.0.bundle.zip`
- `pkw_assets__v0.1.0.bundle.zip`
- `pkw_chat_center__v0.1.0.bundle.zip`
- `pkw_world__hollowverse__v0.1.0.bundle.zip`
- `pkw_world__forest_of_illusions__v0.1.0.bundle.zip`

## Versioning (SemVer-lite)
- **Patch** (x.y.z): typo fixes, text edits, no structure change
- **Minor** (x.y.0): new files, folders, or features
- **Major** (x.0.0): breaking structural changes or reroutes

## Inside-bundle conventions
- Use `_index.md` as the entry point for any folder
- Use lowercase filenames with underscores where possible
- Avoid spaces in filenames inside bundles

## Intent
Clear names reduce confusion, prevent accidental overwrites,
and make long-term maintenance easier.
