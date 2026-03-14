# Cottage Wiring Map (Starter)

[status]
wired: true
scope: starter_rooms
updated: 2026-01-23

[rooms]
- sitting_room
- kitchenette
- hallway
- bedroom_nook
- study_nook
- deck

[connections]
sitting_room:
  - kitchenette
  - hallway
hallway:
  - sitting_room
  - bedroom_nook
  - study_nook
  - deck
kitchenette:
  - sitting_room
bedroom_nook:
  - hallway
study_nook:
  - hallway
deck:
  - hallway

[notes]
- This is intentionally light wiring.
- No automation, no locks, no heavy systems.
- Room links in each folder’s _index.md should point “Up” to ../_index.md (now present).
