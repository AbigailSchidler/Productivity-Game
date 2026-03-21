# Roadmap
## Project: Evidence-Based Focus Lock App

Version: 1.0
Status: Initial Build Plan

---

# 1. Roadmap Goal

This roadmap breaks the product into implementation phases so the MVP can be shipped quickly without overbuilding.

The priority is:
1. build the core loop
2. make the XP economy real
3. make the app demoable
4. layer in AI and integrations later

---

# 2. Phase 0 — Project Setup

## Objective
Create repo, docs, and Flutter skeleton.

## Deliverables
- Flutter project initialized
- /project-docs created
- prd.md added
- architecture.md added
- roadmap.md added
- decisions.md added
- basic folder structure created

## Done when
- app runs locally
- screens can be navigated
- Claude Code can read docs and summarize architecture

---

# 3. Phase 1 — MVP Core Loop

## Objective
Implement the session-based productivity loop.

## Features
- Home screen
- Start session screen
- Session timer
- Reflection submission
- XP calculation
- Session complete screen
- Session history
- Local storage
- Settings screen
- Focus window settings

## User flow
User starts session
→ timer runs
→ session ends
→ reflection submitted
→ XP calculated
→ unlock minutes granted
→ session saved

## Done when
- user can complete at least one full session end-to-end
- XP is awarded correctly
- history persists between app launches

---

# 4. Phase 2 — Better Reward and Lock Behavior

## Objective
Make the product loop feel more realistic and gamified.

## Features
- daily XP vs lifetime XP
- carryover XP logic
- rest day settings
- temporary unlock penalties
- lock mode settings
- generic session multiplier
- unlock scope display

## Done when
- XP economy feels coherent
- users can see how much unlock time they earned
- penalties and carryover behave correctly

---

# 5. Phase 3 — Evidence Expansion

## Objective
Add richer evidence types before true AI scoring.

## Features
- image attachment support
- multiple evidence items
- evidence preview in session history
- evidence metadata model
- basic scoring placeholders

## Done when
- user can attach images to session completion
- app can calculate higher rewards for richer evidence
- no AI required yet

---

# 6. Phase 4 — First AI Features

## Objective
Introduce meaningful AI-assisted functionality.

## Features
- reflection summarization
- structured session recap generation
- evidence quality heuristic scoring
- confidence-score placeholder returned from backend

## Suggested implementation
Flutter app
→ FastAPI backend
→ LLM/multimodal API
→ score/summary response

## Done when
- app can send session reflection to backend
- AI returns structured summary
- XP can be influenced by AI confidence

---

# 7. Phase 5 — Task System Expansion

## Objective
Support reusable task templates and better task structure.

## Features
- create/edit tasks
- task-specific prompts
- expected durations
- task categories
- reusable task templates

## Done when
- tasks are reusable
- sessions can be tied to tasks cleanly
- generic and task-based sessions both work

---

# 8. Phase 6 — Task Bubble Generator

## Objective
Let users create custom task types with AI support.

## Features
- AI-generated task outline
- suggested verification strategies
- estimated duration
- editable task template
- saved task bubble library

## Done when
- user can type a custom task idea
- AI returns a draft task structure
- user can edit and save it

---

# 9. Phase 7 — Calendar Integration

## Objective
Connect focus enforcement to real schedules.

## Features
- Google Calendar sync
- focus-required event tagging
- auto-generated sessions from calendar events
- override penalties for defying scheduled sessions

## Done when
- calendar event can produce expected session behavior
- user can ignore or classify certain event types
- session behavior respects real schedule data

---

# 10. Phase 8 — Smart Suggestion Engine

## Objective
Suggest neglected recurring tasks and scheduling opportunities.

## Features
- recurring task frequency tracking
- overdue task detection
- suggested scheduling prompts
- calendar-based open slot suggestions

## Done when
- app can detect neglected tasks
- app can suggest when to schedule them
- system stays non-intrusive

---

# 11. Phase 9 — Productive Procrastination Detection

## Objective
Detect when productive tasks are being used to avoid more important tasks.

## Features
- compare planned vs actual task distribution
- detect repeated imbalance
- prompt users when behavior suggests avoidance
- recommend task switching

## Done when
- system can flag obvious imbalance patterns
- prompts are supportive, not punitive

---

# 12. Milestones for Resume Use

## Resume Checkpoint A
Core loop working:
- session timer
- reflection
- XP
- history

## Resume Checkpoint B
Reward economy working:
- daily/lifetime XP
- carryover
- penalties
- focus window logic

## Resume Checkpoint C
AI integration working:
- reflection summarization
- confidence-based scoring

## Resume Checkpoint D
Advanced intelligence:
- task bubbles
- calendar integration
- suggestion engine

---

# 13. Guiding Rule

Do not skip ahead to later phases until the current loop works reliably.

The app should always remain demoable.