# POINTERS — pacaud/spectraportal

This file is a *single-source pointer map* so an assistant can open repo files reliably via Raw URLs.

## Repo
- repo: pacaud/spectraportal
- default_branch: main

## Raw base (DRY)
RAW_BASE:
- https://raw.githubusercontent.com/pacaud/spectraportal/main/

## How to build any raw link
- raw_url = RAW_BASE + <path>

Example:
- RAW_BASE + "index.html"
- => https://raw.githubusercontent.com/pacaud/spectraportal/main/index.html

## Key entrypoints (paths)
### Site
- index: index.html
- theme: theme.css

### Docs / policy
- readme: README.md
- contributing: CONTRIBUTING.md
- security: SECURITY.md
- license: LICENSE

### Dev / config (safe public)
- env_example: .env.example
- gitignore: .gitignore

### Major folders
- framework_dir: framework/

## Assistant workflow notes
- If Kevin says “open spectra index”, open: RAW_BASE + "index.html"
- If Kevin says “open theme”, open: RAW_BASE + "theme.css"
- If a file isn’t listed here, ask for its repo-relative path (then open RAW_BASE + that path).
