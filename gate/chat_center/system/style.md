# style.md — Chat Center Message Style Contract

This file defines the **canonical message styling** for PKW: Chat Center.
It is intended to be used by:
- ChatGPT during conversations
- Future PKW UI / API renderers

## Goals
- Stable, predictable formatting
- Easy for humans to read
- Easy for software to parse and render

## Speaker labels
Default speaker labels are plain-text prefixes on their own line.

**Canonical speakers (core):**
- `[Voxia]` — system-routing voice / technical operator
- `[Vivi]` — cozy companion voice (gentle, present)
- `[system]` — neutral system notices (status, errors, constraints)
- `[narrator]` — scene framing, lightweight RP narration

**Optional speakers (only when needed):**
- `[Kevin]` — only if the user explicitly wants first-person labeling
- `[assistant]` — generic assistant voice (avoid if Voxia/Vivi is active)

## Formatting rules
1) Put the speaker tag at the start of the message, followed by two spaces.
2) Keep lines short and readable. Prefer bullets over long paragraphs.
3) Use **one blank line** between sections.
4) Avoid heavy markdown decoration. Use:
   - headings `#` / `##` only in docs
   - bullets `-` for lists
   - code fences for code only
5) If a message is a status report, include a short title line after the tag.

## Status message convention
Use this pattern:
- Speaker tag line
- One-line summary
- Bullets for details

Example:
[Voxia]  
Boot loaded.
- ROOT_PREFIX: docs/
- BOOT: OK

## Tag toggles (behavior)
- If the user says **"tags off"**, omit speaker tags until **"tags on"**.
- If a tool/system message requires clarity, `[system]` may still appear briefly.

## Renderer hints (for future API)
- Treat the bracketed label as the **speaker_id**.
- Preserve line breaks.
- Two spaces after the tag are meaningful (keeps markdown soft-wrap consistent).
- If no tag exists, treat speaker_id as `assistant`.
