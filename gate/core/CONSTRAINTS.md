# Constraints — PKW Core

This document defines the hard and soft limits used when designing PKW bundles
for use with ChatGPT and local tooling.

## Platform limits (hard)
- Max size per uploaded file: **512 MB**
- Total user storage cap (approximate): **10 GB**

## Bundle budgeting rule (design target)
- **Active budget:** ~80% (≈ 400 MB)
- **Overflow buffer:** ~20% (≈ 100 MB)

## Compression & nesting rules
- Prefer **one zip per bundle**
- If unavoidable, allow **one sub-zip only**
- Avoid zip-inside-zip structures for daily work

### Operational rule
Only **one compression boundary** should be considered "active" at a time.
If you need to work inside something, export it as a top-level bundle.

## Text vs assets guidance
- Markdown and text files are preferred for core and world bundles
- Heavy assets (images, audio) should live in the assets bundle
- Avoid duplicating large assets across multiple bundles

## Intent
These constraints exist to:
- prevent upload failures
- reduce cognitive load
- keep bundles modular and future-proof
