/// Visual state of the mascot displayed on HomeScreen.
///
/// Priority order (highest to lowest) when [MascotService.resolve] evaluates:
///   1. focusing             — active session is running
///   2. completedSession     — at least one session finished today
///   3. locked               — inside focus window and device is locked
///   4. outsideFocusWindow   — outside the scheduled focus window
///   5. streakActive         — streak is greater than zero
///   6. idle                 — default fallback
enum MascotState {
  locked,
  focusing,
  completedSession,
  outsideFocusWindow,
  streakActive,
  idle;

  /// Placeholder emoji displayed until real mascot assets are added.
  String get emoji => switch (this) {
        locked => '🙈',
        focusing => '🐒💭',
        completedSession => '🐒✨',
        outsideFocusWindow => '🐒🎧',
        streakActive => '🐒🔥',
        idle => '🐒',
      };

  /// Short motivational label shown beside the emoji.
  String get label => switch (this) {
        locked => 'Earn your unlock',
        focusing => 'In the zone',
        completedSession => 'Session done!',
        outsideFocusWindow => 'Time to recharge',
        streakActive => 'Keep the streak going',
        idle => 'Ready when you are',
      };
}

/// Determines which [MascotState] to display given current app state.
///
/// Pure Dart — no Flutter or Provider imports.
/// All inputs are passed per call so the same instance can be shared.
class MascotService {
  const MascotService();

  /// Resolves the current mascot state from the provided inputs.
  ///
  /// [completedSessionToday] should be true when [SessionProvider.todaySessionXp]
  /// is greater than zero — meaning at least one session was completed today.
  MascotState resolve({
    required bool hasActiveSession,
    required bool isInsideFocusWindow,
    required bool isLocked,
    required bool completedSessionToday,
    required int currentStreak,
  }) {
    if (hasActiveSession) return MascotState.focusing;
    if (completedSessionToday) return MascotState.completedSession;
    if (isInsideFocusWindow && isLocked) return MascotState.locked;
    if (!isInsideFocusWindow) return MascotState.outsideFocusWindow;
    if (currentStreak > 0) return MascotState.streakActive;
    return MascotState.idle;
  }
}
