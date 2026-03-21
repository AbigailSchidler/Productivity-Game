# Product Requirements Document
## Project: Evidence-Based Focus Lock App

Version: 1.0
Status: MVP Spec Locked
Owner: Abigail Schidler

---

# 1. Product Vision

This app helps users stay focused by restricting access to distracting apps (or optionally the entire phone) until they provide evidence of completing productive tasks.

Instead of relying on timers alone, the system verifies real-world effort using reflection, images, and later timelapse evidence, and rewards users with controlled access to distractions through an XP-based unlock system.

The app encourages structured productivity windows, intentional session-based work, and balanced task allocation.

XP can only be earned through intentional sessions.

---

# 2. Core Principles

The system is based on:

session-based accountability
evidence-based validation
adaptive reward economy
structured focus windows
configurable strictness levels

XP is never granted passively.

---

# 3. Target Users

Primary users:

students
creators (musicians, programmers, writers)
people with flexible schedules
users struggling with distraction loops

---

# 4. Core Problem

Existing productivity apps:

block distractions temporarily
assume work happened
lack verification
fail to detect productive procrastination
lack structured session enforcement

This app solves that by making evidence the unlock mechanism.

---

# 5. Core User Loop

User starts session
→ lock activates
→ work occurs
→ evidence submitted
→ AI evaluates evidence quality
→ XP awarded
→ distraction apps unlock for earned duration
→ repeat during focus window

XP cannot be earned outside sessions.

---

# 6. Focus Window System

Users define a daily focus window.

Example:

10:00 AM – 9:00 PM

During focus window:

XP required for distraction app unlock
session participation encouraged
temporary unlocks allowed with penalty

Outside focus window:

phone unrestricted
sessions optional
XP optional

Users may customize the window.

---

# 7. Lock Modes

Users select strictness level.

Balanced Mode (default):

selected apps locked
calls allowed
messages allowed

Strict Mode:

entire phone locked except emergency access

Light Mode:

only selected apps locked

Mode selectable in settings.

---

# 8. Session Types

Two session types exist.

Task Session

linked to defined task
supports structured verification

Generic Session

freeform productivity session
requires reflection evidence
earns reduced XP multiplier

generic_session_multiplier = 0.85

---

# 9. Evidence Types

Evidence increases XP.

Tier 1 (MVP):

reflection text

Tier 2 (future):

images

Tier 3 (future):

timelapse recording

Tier 4 (future):

multimodal AI verification

More evidence increases XP.

---

# 10. Evidence Submission Timing

Evidence submitted after session ends.

Future versions may support mid-session verification.

---

# 11. AI Verification Model (Future)

AI evaluates:

evidence validity
task relevance
evidence completeness
effort quality

Outputs:

confidence_score (0–1)

XP multiplied by confidence_score.

---

# 12. XP Economy

XP represents distraction unlock currency.

Base rule:

1 minute session = 1 XP

Reflection bonus:

+5 XP

Example conversion:

2 XP = 1 minute distraction unlock

XP determines:

unlock duration
unlock scope
override penalties

---

# 13. Unlock Scope Tiers

XP quality determines unlock level.

Low XP:

messaging access

Medium XP:

selected distraction apps

High XP:

extended distraction access

Very high XP:

temporary full phone unlock (optional mode)

---

# 14. Temporary Unlock Exceptions

Users may temporarily unlock phone for:

calls
messages
urgent tasks

Repeated temporary unlock usage causes XP deficit penalty.

Example:

3 pauses = -5 XP

---

# 15. Lock Warning System

Before lock activates:

user receives warning notification

Example:

Lock starting soon

Ignoring warnings repeatedly results in XP penalty.

---

# 16. Session Duration Model

Sessions run within focus window.

Users may:

start sessions
pause sessions
resume sessions
run multiple sessions per day

XP earned only after session completion.

---

# 17. Daily XP Model

Two XP types exist.

Daily XP

used for distraction unlocks

Lifetime XP

used for long-term progress tracking

Daily XP partially resets after focus window ends.

Example carryover rule:

50% unused XP carries into next day

---

# 18. Lifetime XP Model

Lifetime XP never resets.

Used for:

levels
progress tracking
future feature unlocks

---

# 19. Rest Day System

Users may define rest days.

Example:

Saturday
Sunday

Rest days apply:

reduced XP penalties
weaker lock strictness
longer unlock windows

Locks remain active but softened.

---

# 20. XP Carryover Floor

Minimum daily carryover exists.

Example:

minimum_next_day_xp = 10

Prevents motivation loss after low-productivity days.

---

# 21. XP Expiration Model (Future)

Carryover XP may decay gradually.

Example:

10% decay per unused day

Not included in MVP.

---

# 22. Session-Only XP Rule

XP can only be earned through sessions.

Not allowed:

retroactive reflections
manual XP entry
passive tracking

---

# 23. Productive Procrastination Detection (Future)

System compares:

planned sessions
actual sessions

Example:

viola practiced repeatedly
study avoided repeatedly

Prompt example:

Are you avoiding another task?

---

# 24. Task System (Future)

Users define reusable tasks.

Example:

study
laundry
practice viola
compose

Each task includes:

expected duration
verification strategy
reflection prompts

---

# 25. AI Task Bubble Generator (Future)

User enters:

Compose viola piece

AI generates:

steps
verification suggestions
reflection prompts
estimated duration

User edits template.

Reusable later.

---

# 26. Google Calendar Integration (Future)

Calendar events generate expected sessions.

Example:

Physics lecture

System behavior:

auto-lock distraction apps
monitor compliance
apply override penalties

User may tag events:

focus-required
optional
ignore

---

# 27. Suggested Task Engine (Future)

System detects missing recurring tasks.

Example:

Laundry overdue

System suggests:

Schedule laundry session?

Future version suggests calendar slot.

---

# 28. Privacy Model

Reflection stored locally.

Images stored locally first.

Timelapse stored locally first.

Cloud processing optional in future versions.

User may delete evidence anytime.

---

# 29. MVP Scope

Includes:

session start
session timer
reflection evidence
XP reward system
focus window scheduling
app-level locking
temporary unlock override
session repetition
history tracking

Excludes:

image verification
timelapse verification
calendar integration
task suggestion engine
task bubble generator
AI scoring model
productive procrastination detection

---

# 30. MVP Success Criteria

User can:

start session
complete session
submit reflection
earn XP
unlock distraction apps
repeat sessions daily
view session history

MVP considered successful if loop functions reliably.