# Design System
## Evidence-Based Focus Lock App

Version: 1.0
Status: MVP Visual Language

---

# 1. Design Philosophy

The UI should visually reinforce the behavioral loop:

lock → focus → evidence → reward → unlock

The interface should feel:

calm
intentional
structured
rewarding
not distracting

Avoid overly playful or gamified aesthetics.

This is a focus tool, not a habit toy.

---

# 2. Color Roles

Use semantic colors instead of decorative colors.

## Primary

Used for:

primary buttons
navigation highlights
active controls

Example:

deep blue

---

## Success

Used for:

XP earned
unlock minutes granted
completed sessions
positive streak signals

Example:

green

---

## Warning

Used for:

locked state
focus window active
restricted access

Example:

amber or orange

---

## Surface

Used for:

cards
containers
panels

Example:

light gray or neutral white

---

## Background

Used for:

screen background

Example:

off-white or soft neutral

---

# 3. Status Color Language

Status colors should communicate behavior state clearly.

Locked:

muted gray or warning tone

Earning XP:

amber

Unlocked:

green

Rest day:

soft blue

Outside focus window:

neutral gray

---

# 4. Typography Scale

Use a simple 4-level hierarchy.

## Headline

Used for:

screen titles
major state indicators

Example:

Locked
Unlocked
Focus Window Active

Font size:

24–28

Weight:

bold

---

## Section Title

Used for:

Today Summary
Recent Tasks
Session History

Font size:

18–20

Weight:

semi-bold

---

## Body Text

Used for:

descriptions
task names
session info

Font size:

14–16

Weight:

regular

---

## Caption Text

Used for:

timestamps
metadata
XP labels

Font size:

12–13

Weight:

medium

Color:

muted gray

---

# 5. Spacing System

Use consistent spacing multiples.

Base unit:

8px

Allowed spacing:

8
16
24
32
48

Example usage:

card padding = 16
section spacing = 24
screen margin = 24

Avoid arbitrary spacing values.

---

# 6. Layout Structure Rules

Screens should follow this structure:

SafeArea
→ scrollable container
→ vertical section stack

Example:

HomeScreen layout:

Focus status
Today summary
Quick start tasks
Recent sessions

Each section separated by 24 spacing.

---

# 7. Card Design

Cards represent structured information blocks.

Use cards for:

sessions
tasks
XP summaries
history entries

Card styling:

rounded corners
light elevation
consistent padding

Recommended:

border radius = 12
elevation = 2

Important cards:

elevation = 4

---

# 8. Button Hierarchy

Use only three button types.

## Primary Button

Used for:

Start Session
Submit Reflection
Save Settings

Color:

primary color

---

## Secondary Button

Used for:

Cancel
Back
Edit

Color:

neutral outline or surface variant

---

## Status Button

Used for:

Unlock
Resume Session

Color depends on state:

success
warning

---

# 9. Icon Usage

Icons should reinforce structure.

Use icons for:

lock state
calendar history
streak
XP
tasks
settings

Recommended mapping:

lock = locked state
check_circle = completed session
calendar_today = history
bolt = XP
flame = streak
settings = settings

Avoid decorative-only icons.

---

# 10. Section Pattern

Each screen section follows:

Section Title
→ card container
→ structured content

Example:

Today Summary
→ XP card
→ unlock minutes
→ streak length

---

# 11. Focus Window Indicator

Focus window status must always be visible on HomeScreen.

Display:

inside focus window
outside focus window
rest day

Visual example:

badge or status bar at top of screen

---

# 12. Unlock State Indicator

Unlock state should always be visible.

Display:

locked
unlocked
unlock minutes remaining

Recommended placement:

top section of HomeScreen

---

# 13. Task Card Pattern

Each task card displays:

task title
planned duration
difficulty level

Optional:

icon
category label

Tap behavior:

starts session immediately

---

# 14. Session History Pattern

Session history entries display:

title
session type
actual duration
XP earned
unlock minutes granted

Optional:

reflection preview

Group entries by date.

---

# 15. Calendar View Pattern

Calendar should indicate:

days with sessions
selected day
sessions for selected day

Highlight session days with subtle markers.

Avoid analytics overlays in MVP.

---

# 16. XP Display Rules

XP should always appear:

clearly
consistently
near reward-related UI

Display:

daily XP
lifetime XP
session-earned XP

XP earned should appear immediately after session completion.

---

# 17. Streak Display Rules

Streak display should:

appear on HomeScreen
feel motivational
not dominate layout

Recommended:

small flame icon + number

Example:

🔥 4-day streak

---

# 18. Accessibility Rules

Ensure:

minimum touch target = 44px
sufficient contrast
readable font sizes

Avoid:

light gray text on white backgrounds

---

# 19. Animation Guidelines (Future)

Animations should reinforce feedback loops.

Examples:

XP increment animation
unlock transition animation
session completion confirmation

Avoid decorative motion.

---

# 20. Dark Mode (Future)

Not required for MVP.

Design system should remain compatible with later dark mode support.

Use semantic colors to enable this later.

---

# 21. Visual Consistency Rule

Every screen must follow:

same spacing scale
same typography hierarchy
same card styling
same color roles

Avoid introducing new visual patterns unless added here.