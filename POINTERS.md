# POINTERS — SpectraPortal

repo: https://github.com/pacaud/spectraportal
default_branch: main

## Resolver rules (Voxia)
- HTML: prefer `source_mirror` for verbatim display
- CSS: raw is fine, mirror is also fine
- If you want me to display text in chat: paste the `raw_mirror_url`

## Entrypoints

- id: landing_html
  runtime: index.html
  source_mirror: source/index.html.txt
  raw_url: https://raw.githubusercontent.com/pacaud/spectraportal/main/index.html
  raw_mirror_url: https://raw.githubusercontent.com/pacaud/spectraportal/main/source/index.html.txt

- id: landing_theme
  runtime: theme.css
  source_mirror: source/theme.css.txt
  raw_url: https://raw.githubusercontent.com/pacaud/spectraportal/main/theme.css
  raw_mirror_url: https://raw.githubusercontent.com/pacaud/spectraportal/main/source/theme.css.txt

## Meta

- id: pointers
  runtime: POINTERS.md
  raw_url: https://raw.githubusercontent.com/pacaud/spectraportal/main/POINTERS.md

- id: readme
  runtime: README.md
  raw_url: https://raw.githubusercontent.com/pacaud/spectraportal/main/README.md

