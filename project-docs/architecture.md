# Architecture
## Project: Evidence-Based Focus Lock App

Version: 1.0
Status: MVP Architecture

---

# 1. Architecture Goal

The architecture should support a fast MVP in Flutter while leaving room for future AI verification, calendar integration, and more advanced lock logic.

The MVP should prioritize:

- simple local-first development
- modular session logic
- easy Claude Code context ingestion
- clear upgrade path to backend + AI services later

---

# 2. Tech Stack

## Frontend
Flutter

## State Management
Provider

## Local Storage
Hive (preferred) or SharedPreferences for lightweight settings

## Backend (future)
FastAPI

## AI Layer (future)
LLM + multimodal API calls through backend

## Calendar Integration (future)
Google Calendar API

---

# 3. MVP Architecture Philosophy

Build the app as a local-first mobile app.

In MVP:
- all session logic is local
- XP logic is local
- reflection storage is local
- focus window settings are local
- app unlock state can be simulated if full OS-level lock is not yet implemented

Future versions may move validation and scoring to a backend.

---

# 4. Core Application Layers

## Presentation Layer
Flutter screens and widgets

Responsible for:
- screen rendering
- user input
- navigation
- displaying timers, XP, history, and settings

## State Layer
Provider-based app state

Responsible for:
- active session state
- XP balances
- settings state
- session history state

## Data Layer
Local storage and repositories

Responsible for:
- saving tasks
- saving sessions
- saving XP
- saving settings

## Service Layer
App logic services

Responsible for:
- timer handling
- XP calculation
- focus window logic
- unlock state calculation
- penalty handling

---

# 5. Suggested Folder Structure

lib/
  main.dart
  app.dart

  core/
    constants/
    theme/
    utils/

  models/
    task.dart
    session.dart
    xp_balance.dart
    app_settings.dart

  providers/
    session_provider.dart
    xp_provider.dart
    settings_provider.dart
    task_provider.dart

  services/
    timer_service.dart
    xp_service.dart
    focus_window_service.dart
    unlock_service.dart

  repositories/
    task_repository.dart
    session_repository.dart
    settings_repository.dart

  screens/
    home_screen.dart
    start_session_screen.dart
    active_session_screen.dart
    reflection_screen.dart
    session_complete_screen.dart
    history_screen.dart
    settings_screen.dart

  widgets/
    primary_button.dart
    task_card.dart
    xp_card.dart
    session_card.dart
    focus_window_card.dart

---

# 6. Core Data Models

## Task
Represents a reusable task template.

Fields:
- id
- title
- category
- defaultDurationMinutes
- isRecurring
- isGenericAllowed

MVP note:
Tasks may be optional at first because generic sessions are supported.

## Session
Represents one productivity session.

Fields:
- id
- sessionType (task or generic)
- taskId (nullable)
- title
- plannedMinutes
- actualMinutes
- startTime
- endTime
- reflectionText
- xpEarned
- unlockMinutesGranted
- pauseCount
- wasCompleted

## XPBalance
Tracks XP state.

Fields:
- dailyXp
- lifetimeXp
- carryoverXp
- lastResetDate

## AppSettings
Stores user preferences.

Fields:
- focusWindowStart
- focusWindowEnd
- restDays
- lockMode
- genericSessionMultiplier
- reflectionBonusXp
- xpToUnlockMinuteRatio

---

# 7. Core Services

## TimerService
Handles:
- session timer
- pause/resume
- elapsed duration
- planned vs actual duration

## XPService
Handles:
- base XP calculation
- reflection bonus
- generic session multiplier
- override penalties
- unlock minute conversion
- daily carryover logic

## FocusWindowService
Handles:
- whether current time is inside focus window
- whether today is a rest day
- when daily XP should partially reset

## UnlockService
Handles:
- current unlock eligibility
- unlock duration remaining
- temporary unlock penalties
- lock mode interpretation

---

# 8. MVP Navigation Flow

HomeScreen
→ StartSessionScreen
→ ActiveSessionScreen
→ ReflectionScreen
→ SessionCompleteScreen
→ HomeScreen

Secondary navigation:
HomeScreen → HistoryScreen
HomeScreen → SettingsScreen

---

# 9. Locking Strategy for MVP

MVP should not depend on full OS-level lock implementation.

Instead:
- simulate lock state in-app
- track which apps would be unlocked
- build the reward system first

This allows the product loop to work before deeper platform integrations.

Later versions can add:
- Android-specific lock behavior
- iOS-specific restrictions where possible
- stronger strict mode behavior

---

# 10. Persistence Strategy

Store locally:
- sessions
- tasks
- XP balances
- settings

Recommended:
Hive for structured local data

If speed matters more than structure for first prototype:
SharedPreferences can be used temporarily for settings and simple counters

---

# 11. Future Backend Responsibilities

When backend is added, move these concerns there:

- AI evidence validation
- confidence scoring
- image processing
- timelapse processing
- Google Calendar sync orchestration
- advanced suggestion engine
- productive procrastination analysis

MVP does not need backend.

---

# 12. Non-Goals for MVP

Do not build yet:
- image upload validation
- timelapse recording
- full phone lock enforcement
- Google Calendar sync
- AI task bubble generation
- automated suggestion engine
- productive procrastination detection

---

# 13. Architecture Rule for Claude Code

When implementing features:
- prefer simple modular code
- do not introduce backend dependencies in MVP
- do not add future features unless explicitly requested
- keep business logic out of UI widgets when possible