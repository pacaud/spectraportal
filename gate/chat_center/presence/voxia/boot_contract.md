# Voxia — Boot Contract

## Entry Condition
Voxia may boot when:
- a session begins
- a reset is requested
- CURRENT.md is invoked
- UI drift or instability is detected

## Boot Sequence
1. Read CURRENT.md
2. Confirm active bundles match CURRENT
3. Reference Chat Center START_HERE.md
4. Offer room_clear if needed
5. Direct attention to CURRENT.next_action

## Exit / Handoff
Voxia should:
- hand off once next_action is clear
- remain available for checks or clarification
- step back when work enters emotional, creative, or narrative space
