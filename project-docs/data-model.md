# Data Model
## Project: Evidence-Based Focus Lock App

Version: 1.0
Status: MVP + Future Model Definitions

---

# 1. Modeling Goal

The data model should support:

- session-based accountability
- XP calculation
- focus window settings
- local-first persistence
- future AI evidence expansion
- future calendar/task integrations

MVP models should be simple, but the structure should leave room for later extensions.

---

# 2. Model Overview

Core MVP models:

- Task
- Session
- XPBalance
- AppSettings

Future models:

- EvidenceItem
- TaskTemplate
- CalendarEventLink
- Suggestion
- AIValidationResult

---

# 3. Task Model

## Purpose
Represents a reusable user-defined task.

Tasks are optional in MVP because generic sessions are allowed.

## Fields

- id: String
- title: String
- category: String
- defaultDurationMinutes: int
- isRecurring: bool
- isArchived: bool
- createdAt: DateTime
- updatedAt: DateTime

## Notes

Examples:
- Study
- Laundry
- Practice Viola
- Compose
- Clean Room

MVP usage:
- task sessions can reference Task
- generic sessions do not require Task

---

# 4. Session Model

## Purpose
Represents one completed or in-progress productivity session.

## Fields

- id: String
- sessionType: SessionType
- taskId: String?
- title: String
- plannedMinutes: int
- actualMinutes: int
- startTime: DateTime
- endTime: DateTime?
- reflectionText: String?
- xpEarned: int
- unlockMinutesGranted: int
- pauseCount: int
- wasCompleted: bool
- createdAt: DateTime
- updatedAt: DateTime

## SessionType enum

- task
- generic
- calendar (future)

## Notes

- title may mirror task title or be custom for generic sessions
- actualMinutes is 0 until session completes
- endTime is nullable while session is active
- reflectionText is optional but rewarded

---

# 5. XPBalance Model

## Purpose
Tracks user XP status.

## Fields

- dailyXp: int
- lifetimeXp: int
- carryoverXp: int
- lastResetDate: DateTime
- totalSpentXp: int

## Notes

dailyXp:
used for current unlock economy

lifetimeXp:
tracks all-time progress

carryoverXp:
amount preserved from previous focus window reset

---

# 6. AppSettings Model

## Purpose
Stores user-configurable app behavior.

## Fields

- focusWindowStartHour: int
- focusWindowStartMinute: int
- focusWindowEndHour: int
- focusWindowEndMinute: int
- restDays: List<int>
- lockMode: LockMode
- reflectionBonusXp: int
- xpToUnlockMinuteRatio: int
- genericSessionMultiplier: double
- carryoverPercentage: double
- minimumNextDayXpFloor: int
- warningEnabled: bool
- warningLeadMinutes: int

## LockMode enum

- light
- balanced
- strict

## Notes

restDays should use weekday numbers consistently.

Example:
- 6 = Saturday
- 7 = Sunday

---

# 7. EvidenceItem Model (Future)

## Purpose
Represents a piece of evidence attached to a session.

## Fields

- id: String
- sessionId: String
- evidenceType: EvidenceType
- localPath: String?
- textContent: String?
- createdAt: DateTime
- metadataJson: String?

## EvidenceType enum

- reflection
- image
- timelapse
- link
- note

## Notes

MVP only needs reflection embedded in Session.
This separate model becomes useful once images and multiple evidence items are supported.

---

# 8. AIValidationResult Model (Future)

## Purpose
Stores AI validation output for evidence.

## Fields

- id: String
- sessionId: String
- confidenceScore: double
- summary: String?
- feedback: String?
- validationStatus: ValidationStatus
- createdAt: DateTime

## ValidationStatus enum

- pending
- passed
- partial
- failed

## Notes

Future AI may return:
- confidence score
- structured summary
- reward hints
- feedback on weak evidence

---

# 9. TaskTemplate Model (Future)

## Purpose
Represents AI-generated or user-created task workflow templates.

## Fields

- id: String
- title: String
- description: String
- suggestedDurationMinutes: int
- verificationStrategy: String
- reflectionPrompts: List<String>
- createdByAi: bool
- createdAt: DateTime
- updatedAt: DateTime

## Notes

Examples:
- Compose viola piece
- Clean desk
- Study chapter 4

This powers the future task bubble system.

---

# 10. CalendarEventLink Model (Future)

## Purpose
Associates calendar events with app sessions.

## Fields

- id: String
- externalCalendarEventId: String
- title: String
- startTime: DateTime
- endTime: DateTime
- calendarBehavior: CalendarBehavior
- linkedTaskId: String?
- createdAt: DateTime

## CalendarBehavior enum

- focusRequired
- optional
- ignore

## Notes

Used later for Google Calendar integration.

---

# 11. Suggestion Model (Future)

## Purpose
Represents suggested tasks or scheduling prompts.

## Fields

- id: String
- suggestionType: SuggestionType
- title: String
- description: String
- relatedTaskId: String?
- suggestedStartTime: DateTime?
- createdAt: DateTime
- dismissedAt: DateTime?

## SuggestionType enum

- recurringTaskReminder
- scheduleOpenSlot
- imbalanceWarning
- focusWindowAdjustment

---

# 12. Recommended Dart Enums

Use enums for:

- SessionType
- LockMode
- EvidenceType
- ValidationStatus
- CalendarBehavior
- SuggestionType

This improves readability and prevents string bugs.

---

# 13. MVP Storage Requirements

The MVP should persist:

- sessions
- tasks
- XP balance
- settings

Minimum persistence needed:
- app can be closed and reopened without losing progress
- session history remains available
- XP totals remain available
- settings remain available

---

# 14. Relationships Between Models

## Task → Session
One Task can be linked to many Sessions.

## Session → EvidenceItem
One Session can have many EvidenceItems in future versions.

## Session → AIValidationResult
One Session may have one or more validation records later.

## CalendarEventLink → Session
One calendar event may generate one session.

---

# 15. MVP Simplification Rules

For MVP:

- reflection can stay directly on Session
- no separate EvidenceItem model needed yet
- no AIValidationResult persistence needed yet
- no CalendarEventLink needed yet
- no Suggestion model needed yet

Only fully implement:
- Task
- Session
- XPBalance
- AppSettings

---

# 16. Suggested Dart Class Notes

## Task
Should be serializable for local storage.

## Session
Should support active session state and completed session state.

## XPBalance
Should be globally accessible through provider.

## AppSettings
Should load at app startup.

---

# 17. Example Session Record

Example:

id: "session_001"
sessionType: "task"
taskId: "task_study_001"
title: "Study Calculus"
plannedMinutes: 45
actualMinutes: 42
startTime: 2026-03-20T10:00:00
endTime: 2026-03-20T10:42:00
reflectionText: "Reviewed derivatives and completed 3 practice problems."
xpEarned: 47
unlockMinutesGranted: 23
pauseCount: 1
wasCompleted: true

---

# 18. Example XPBalance Record

dailyXp: 38
lifetimeXp: 420
carryoverXp: 12
lastResetDate: 2026-03-20T21:00:00
totalSpentXp: 150

---

# 19. Example AppSettings Record

focusWindowStartHour: 10
focusWindowStartMinute: 0
focusWindowEndHour: 21
focusWindowEndMinute: 0
restDays: [6, 7]
lockMode: balanced
reflectionBonusXp: 5
xpToUnlockMinuteRatio: 2
genericSessionMultiplier: 0.85
carryoverPercentage: 0.5
minimumNextDayXpFloor: 10
warningEnabled: true
warningLeadMinutes: 5

---

# 20. Rule for Future Changes

If a feature requires a new persisted concept, update this file before implementation.

This file should remain the source of truth for app data structures.