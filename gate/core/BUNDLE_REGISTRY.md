# Bundle Registry — PKW Core

This file lists all bundles recognized by PKW Core.
Only bundles listed here are considered canonical.

## Bundle types

### Core
- Scope: global / globe layer
- Purpose: routing, constraints, registries, conventions
- Example: `pkw_core__v0.1.0.bundle.zip`

### World
- Scope: place / setting
- Purpose: world maps, lore, locations, flora/fauna, local systems
- Examples:
  - `pkw_world__hollowverse__v0.1.0.bundle.zip`
  - `pkw_world__forest_of_illusions__v0.1.0.bundle.zip`

### Assets
- Scope: shared resources
- Purpose: images, icons, ribbons, audio, fonts
- Example: `pkw_assets__v0.1.0.bundle.zip`

### Chat Center
- Scope: global system
- Purpose: conversation rooms, logs, voice modes, meta settings
- Example: `pkw_chat_center__v0.1.0.bundle.zip`

## Registration rules
- A bundle becomes canon only after being listed here.
- Bundles may reference each other, but should not duplicate content.
- Worlds should reference assets, not embed large shared files.

## Status
At initial creation, only the **PKW Core bundle** is guaranteed to exist.
Other bundles are registered as they are created.
