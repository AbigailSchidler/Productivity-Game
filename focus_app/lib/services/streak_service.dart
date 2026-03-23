import '../models/app_settings.dart';
import '../models/streak_record.dart';

/// Minimum XP that must be earned from completed sessions in a single day
/// for that day to count toward the streak.
///
/// Uses raw session XP only — carryover, spending, and penalties are excluded.
const int kDailyStreakXpThreshold = 30;

/// Calculates streak updates and reset checks.
///
/// Streak semantics:
/// - A streak counts consecutive *focus days* (non-rest days) on which the
///   user earned at least [kDailyStreakXpThreshold] XP from completed sessions.
/// - Rest days are transparent: they do not break the streak and are not
///   counted as missed days.
/// - The streak resets to 0 if one or more focus days pass without meeting
///   the threshold.
///
/// Pure Dart — no Flutter or Provider imports.
class StreakService {
  const StreakService();

  /// Updates the streak record after a session is completed.
  ///
  /// [dailySessionXp] must be the sum of [Session.xpEarned] for all
  /// *completed* sessions today — not the daily XP balance, which may
  /// include carryover or spending.
  ///
  /// The streak only advances when [dailySessionXp] meets or exceeds
  /// [kDailyStreakXpThreshold]. While below the threshold this is a no-op,
  /// so a later session on the same day that pushes the total over the
  /// threshold will still correctly qualify.
  ///
  /// [lastSessionDate] is only written when the threshold is met, so
  /// [checkForReset] can correctly detect days where the threshold was never
  /// reached.
  StreakRecord recordSession(
    StreakRecord record,
    AppSettings settings, {
    required int dailySessionXp,
    DateTime? now,
  }) {
    // Below threshold: no change — let later sessions on the same day retry.
    if (dailySessionXp < kDailyStreakXpThreshold) return record;

    final today = _dateOnly(now ?? DateTime.now());

    if (record.lastSessionDate == null) {
      return _withStreak(record, 1, today);
    }

    final lastDate = _dateOnly(record.lastSessionDate!);

    // Threshold already met today — streak was already counted.
    if (_isSameDay(lastDate, today)) return record;

    final missed = _focusDaysBetween(lastDate, today, settings.restDays);
    final newStreak = missed == 0 ? record.currentStreak + 1 : 1;
    return _withStreak(record, newStreak, today);
  }

  /// Resets the current streak to 0 if one or more focus days have passed
  /// since the last recorded session.
  ///
  /// Call this on app start so stale streaks are corrected before the user
  /// sees the home screen.
  StreakRecord checkForReset(
    StreakRecord record,
    AppSettings settings, {
    DateTime? now,
  }) {
    if (record.lastSessionDate == null || record.currentStreak == 0) {
      return record;
    }

    final today = _dateOnly(now ?? DateTime.now());
    final lastDate = _dateOnly(record.lastSessionDate!);

    if (_isSameDay(lastDate, today)) return record;

    final missed = _focusDaysBetween(lastDate, today, settings.restDays);
    if (missed > 0) {
      return record.copyWith(currentStreak: 0);
    }
    return record;
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  StreakRecord _withStreak(StreakRecord record, int streak, DateTime date) {
    return StreakRecord(
      currentStreak: streak,
      longestStreak: streak > record.longestStreak ? streak : record.longestStreak,
      lastSessionDate: date,
    );
  }

  /// Counts focus days (non-rest days) strictly between [start] and [end],
  /// exclusive on both sides.
  int _focusDaysBetween(DateTime start, DateTime end, List<int> restDays) {
    int count = 0;
    DateTime cursor = start.add(const Duration(days: 1));
    while (cursor.isBefore(end)) {
      if (!restDays.contains(cursor.weekday)) count++;
      cursor = cursor.add(const Duration(days: 1));
    }
    return count;
  }

  DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
