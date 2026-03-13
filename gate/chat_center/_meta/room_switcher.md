# Room Switcher

This file defines how we switch rooms quickly and safely.

## Quick switch command
Type:
- `switch: <room>`

Rooms:
- `just_chatting`
- `work`
- `playground`
- `roleplay`
- `media`
- `finance`
- `recovery`
- `review`

## What happens on switch (standard response)
1) Confirm the room: “Switched to `<room>`.”
2) One-line purpose reminder.
3) Ask: “What are we doing in this room right now?”
4) Suggest a **Room Clear** if bleed is likely.

## Soft trigger suggestions (assistant may suggest)
- tired / overwhelmed / stuck → `recovery`
- experiments / drafts / try it → `playground`
- decisions / bundling / docs → `work`
- wrap up / what’s next → `review`
- scenes / bedtime activity → `roleplay`
- anime / games / music → `media`
- pricing / budget / money → `finance`
