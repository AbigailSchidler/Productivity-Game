# Claude Session Starter Guide
## Evidence-Based Focus Lock App

This file contains recommended prompts to use when starting Claude Code sessions.

Always begin each coding session by reloading project context.

---

# Session 0 — Context Initialization (Run Every Time)

Copy this:

Read all files inside /project-docs.

We are implementing MVP only.

Follow the architecture.md and data-model.md definitions exactly.

Do not implement future features unless requested.

Today we are working on:

<INSERT TASK HERE>

---

# Session 1 — Verify Models (Run First If Not Already Done)

Goal:
Confirm models match data-model.md exactly.

Prompt:

Read data-model.md.

Create Dart models for:

Task
Session
XPBalance
AppSettings

Include:

constructors
fromJson
toJson
copyWith

Keep models Hive-compatible later.

Do not implement future models yet.

---

# Session 2 — Build Providers

Goal:
Create app state management layer.

Prompt:

Using Provider, create:

session_provider.dart
xp_provider.dart
settings_provider.dart
task_provider.dart

Responsibilities:

SessionProvider:
active session state
start session
pause session
resume session
end session

XPProvider:
daily XP
lifetime XP
add XP
spend XP
carryover logic placeholder

SettingsProvider:
focus window settings
lock mode settings
XP settings

TaskProvider:
store reusable tasks

Follow architecture.md service/provider separation rules.

---

# Session 3 — Timer Service

Goal:
Implement session timing engine.

Prompt:

Create timer_service.dart.

Responsibilities:

start timer
pause timer
resume timer
stop timer
track elapsed time
track planned time
notify provider updates

Keep timer logic outside widgets.

Provider should consume TimerService.

---

# Session 4 — XP Service

Goal:
Implement XP calculation logic from PRD.

Prompt:

Create xp_service.dart.

Implement:

base XP calculation

Rules:

1 minute = 1 XP
reflection bonus = +5 XP
generic session multiplier = 0.85

Add function:

calculateUnlockMinutes()

Rule:

2 XP = 1 unlock minute

Keep logic reusable for future AI scoring multiplier.

---

# Session 5 — Focus Window Service

Goal:
Implement structured time enforcement logic.

Prompt:

Create focus_window_service.dart.

Responsibilities:

check if current time inside focus window
check if rest day
calculate carryover reset time
apply carryover percentage logic placeholder

Follow AppSettings model definitions.

---

# Session 6 — Wire Providers to UI

Goal:
Connect logic layer to screens.

Prompt:

Connect:

SessionProvider
XPProvider
SettingsProvider

to:

home_screen.dart
start_session_screen.dart
active_session_screen.dart
reflection_screen.dart

Ensure:

session lifecycle works end-to-end

Start session
Run timer
End session
Submit reflection
Award XP
Return to home screen

---

# Session 7 — Reflection Submission Flow

Goal:
Complete MVP reward loop.

Prompt:

Update reflection_screen.dart.

When user submits reflection:

end session
calculate XP
apply reflection bonus
update XPProvider
store session in repository placeholder

Then navigate back to home screen.

---

# Session 8 — Session History Storage

Goal:
Persist sessions locally.

Prompt:

Create session_repository.dart.

Responsibilities:

save session
load sessions
delete session (optional)
return session list

Use in-memory storage first.

Design interface so Hive can replace later.

Then connect HistoryScreen to repository.

---

# Session 9 — Settings Screen Logic

Goal:
Enable configurable focus window and lock mode.

Prompt:

Update settings_screen.dart.

Allow editing:

focus window start time
focus window end time
lock mode
generic session multiplier
reflection bonus XP

Persist settings using SettingsProvider.

---

# Session 10 — XP Carryover Logic

Goal:
Implement overnight persistence behavior.

Prompt:

Update XPProvider.

Add:

daily XP reset logic
carryover percentage rule
minimum carryover floor rule

Rules:

carryoverPercentage = 0.5
minimumNextDayXpFloor = 10

Reset happens when focus window ends.

---

# Session 11 — Unlock Minutes Calculation

Goal:
Show user reward outcome.

Prompt:

Update session_complete_screen.dart.

Display:

XP earned
unlock minutes granted
reflection bonus applied

Pull values from XPService.

---

# Session 12 — Generic vs Task Session Handling

Goal:
Support both session types cleanly.

Prompt:

Update start_session_screen.dart.

Allow:

task session
generic session

Generic sessions:

apply multiplier = 0.85

Ensure sessionType stored in Session model.

---

# Session 13 — Simulated Lock State (MVP Only)

Goal:
Represent restriction logic before OS-level locking exists.

Prompt:

Create unlock_service.dart.

Responsibilities:

track unlock minutes remaining
simulate locked state
simulate unlocked state
consume unlock minutes when used

Expose:

isUnlocked()
remainingUnlockMinutes()

Use provider integration.

---

# Session 14 — Final MVP Loop Validation

Goal:
Verify core product loop works.

Prompt:

Audit session lifecycle.

Ensure:

start session works
timer updates correctly
reflection submission works
XP calculation correct
unlock minutes correct
session saved correctly
history screen displays sessions correctly

Report missing connections.

---

# Session 15 - Figma Screenshot Mapping

Use the attached screenshot as a layout reference for HomeScreen.

Requirements:

Match the visual hierarchy and layout structure shown in the screenshot.

Specifically match:

- section order
- spacing relationships
- card grouping
- typography hierarchy
- button placement

Do not modify:

- providers
- services
- navigation logic
- business logic

Only update UI layout code.

Keep implementation Flutter-native and responsive.

---

# Session Safety Rules

Always remind Claude:

Follow PRD definitions exactly.

Do not introduce:

calendar integration
AI scoring
image validation
task bubbles
suggestion engine
timelapse capture

Those belong to later roadmap phases.

---

# When Starting Any New Session

Always begin with:

Read all files in /project-docs.

Then describe what feature you are implementing today.

This keeps Claude aligned with architecture.