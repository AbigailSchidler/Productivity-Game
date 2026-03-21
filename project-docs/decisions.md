# Decisions
## Project: Evidence-Based Focus Lock App

Version: 1.0
Status: Active Decisions Log

---

# Product Decisions

## 1. XP is session-only
Users can only earn XP by intentionally starting and completing sessions.

Reason:
Prevents retroactive productivity claims and strengthens accountability.

---

## 2. Reflection is optional but rewarded
Reflection is not mandatory, but it increases XP.

Reason:
Encourages evidence submission without adding too much friction.

---

## 3. More evidence = more reward
Evidence quality and quantity should increase rewards.

Reason:
Supports future AI validation model and motivates richer proof.

---

## 4. Generic sessions are allowed
Users can start either:
- task-based sessions
- generic productivity sessions

Reason:
Keeps the app flexible and lowers friction for users who do not want to define everything upfront.

---

## 5. Generic sessions earn less XP
Generic sessions use a reduced XP multiplier.

Current rule:
generic_session_multiplier = 0.85

Reason:
Encourages structured task use without forcing it.

---

## 6. Users choose lock strictness
Lock mode is configurable.

Modes:
- Light Mode
- Balanced Mode
- Strict Mode

Reason:
Different users need different levels of restriction.

---

## 7. Focus windows are configurable
Users choose their own daily focus window.

Reason:
Schedules vary; system must be adaptable.

---

## 8. Outside focus window, restrictions relax
Phone usage is unrestricted outside the focus window.

Reason:
Prevents burnout and makes the app sustainable.

---

## 9. XP partially carries over
Unused daily XP partially carries into the next day.

Example rule:
50% unused XP carries over

Reason:
Supports consistency without punishing low-productivity days too harshly.

---

## 10. Lifetime XP never resets
Lifetime XP is permanent.

Reason:
Supports long-term progress and future gamification.

---

## 11. Rest days are user-defined
Users may mark specific days as lower-strictness days.

Reason:
Supports realistic weekly rhythms and long-term retention.

---

## 12. Temporary unlocks are allowed but penalized
Users may briefly unlock for calls, texts, or urgent needs.

Reason:
App must remain usable in real life, but loopholes should have a cost.

---

## 13. MVP is local-first
The first version should run locally without backend dependency.

Reason:
Faster iteration and easier prototyping.

---

## 14. AI is not required for MVP
AI verification, image validation, and summarization come later.

Reason:
The core loop must be proven before advanced features are added.

---

## 15. App-level locking comes before full phone locking
MVP should prioritize selected-app restrictions over full-device lock enforcement.

Reason:
Full phone lock is much harder platform-wise and not required to validate product loop.

---

## 16. Privacy should be local-first
Evidence should be stored locally first whenever possible.

Reason:
This app handles potentially sensitive personal evidence.

---

# Technical Decisions

## 17. Frontend framework
Flutter

Reason:
Fastest path to a cross-platform prototype.

---

## 18. State management
Provider

Reason:
Simple, readable, and sufficient for MVP complexity.

---

## 19. Local storage
Hive preferred

Reason:
Good fit for structured local data models.

---

## 20. Future backend
FastAPI

Reason:
Good fit for AI orchestration and future integrations.

---

## 21. Business logic should not live primarily in widgets
Use services/providers for session, XP, and settings logic.

Reason:
Improves maintainability and Claude Code consistency.

---

# Scope Decisions

## 22. Do not build future intelligence features in MVP
Not MVP:
- image verification
- timelapse verification
- task bubble generator
- Google Calendar sync
- task suggestion engine
- productive procrastination detection

Reason:
Scope control.

---

## 23. MVP success = functioning user loop
Success means:
- user can start session
- complete session
- submit reflection
- earn XP
- view history
- repeat process reliably

Reason:
Core loop matters more than feature count.

---

# Update Rule

When a major product or engineering decision changes, add it here before implementation changes are made.