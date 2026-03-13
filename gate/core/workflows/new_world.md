# Workflow: New World Bundle

Goal: add a new world without mixing it into core.

## Steps
1) Create a world folder locally (not inside core)
2) Add a world `_index.md` and a small world registry entry
3) Export as:
   - `pkw_world__<world_name>__v0.1.0.bundle.zip`
4) Register the new bundle in:
   - `core/BUNDLE_REGISTRY.md`
5) Keep shared assets out of world bundles
