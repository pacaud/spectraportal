# Projects Registry — PKW Core (External)

PKW bundles are not code project repositories.
Software projects live outside PKW (typically as git repos) and are referenced here.

## Why this exists
- Prevents PKW lore/system files from mixing with build/deploy code
- Keeps bundles small and ChatGPT-friendly
- Lets projects evolve normally under git (branches, tags, rollbacks)

## Projects (external)

### Spectra (Framework + Portal)
- Type: UI framework, design tokens, docs portal
- Repo/path: TBD
- Includes: Spectra framework, SpectraPortal (docs + hosting surface)
- Relationship to PKW: external toolchain (not canon content)
- Notes: Export small snapshots only when needed for review/help.

### Inkpad
- Type: editor/workspace manager
- Repo/path: TBD
- Relationship to PKW: external tool (not canon content)

### Code Crunchers Technologies (CCT)
- Type: business/brand + client work
- Repo/path: TBD
- Relationship to PKW: external (business layer)

## Rules
- Do not store full project source trees inside PKW bundles by default.
- If a project snapshot is needed, export a minimal zip and label it clearly.
- PKW may contain documentation about how a project relates to PKW,
  but not the project itself.
