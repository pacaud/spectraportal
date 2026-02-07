# POINTERS — SpectraPortal

default_branch: main
repo: https://github.com/pacaud/spectraportal

## How Voxia should resolve “open/display <file>”
- If you want verbatim source and the file is HTML:
  - Use `source_mirror` (GitHub raw HTML can render instead of showing literal `<html>`).
- For CSS/JS/MD:
  - `raw_url` usually works.
- If a pointer is missing:
  - Add one small entry here (don’t paste giant link lists).

## Key entrypoints

- id: landing_html
  runtime: index.html
  source_mirror: source/index.html.txt
  raw_url: https://raw.githubusercontent.com/pacaud/spectraportal/main/index.html

- id: landing_theme
  runtime: theme.css
  source_mirror: source/theme.css.txt
  raw_url: https://raw.githubusercontent.com/pacaud/spectraportal/main/theme.css

- id: readme
  runtime: README.md
  raw_url: https://raw.githubusercontent.com/pacaud/spectraportal/main/README.md

- id: contributing
  runtime: CONTRIBUTING.md
  raw_url: https://raw.githubusercontent.com/pacaud/spectraportal/main/CONTRIBUTING.md

## Notes
- `source/` is the “chat-safe mirrors” folder.
- Mirrors are verbatim copies (same content, `.txt` extension).
