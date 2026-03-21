import '../models/app_settings.dart';

/// Result of a daily XP reset calculation.
///
/// Separates the computed carryover amount from the decision of whether a
/// reset is due, so callers can inspect both independently.
class DailyResetResult {
  /// The XP amount that carries over to the next day.
  final int carryoverXp;

  const DailyResetResult({required this.carryoverXp});
}

/// Determines focus window state and calculates daily XP carryover.
///
/// Pure Dart — no Flutter or Provider imports. All inputs are passed per call
/// so the same instance can be shared without any reset.
///
/// Focus window semantics:
/// - The window is the interval [startHour:startMinute, endHour:endMinute).
/// - Overnight windows (end < start, e.g. 22:00–06:00) are supported.
/// - Rest days use [DateTime.weekday] values (1 = Monday … 7 = Sunday),
///   matching Dart's convention. AppSettings stores 6 = Saturday, 7 = Sunday
///   by default, which aligns with this convention.
class FocusWindowService {
  const FocusWindowService();

  // ── Focus window ────────────────────────────────────────────────────────────

  /// Returns true if [now] falls within the focus window defined by [settings].
  ///
  /// Comparison is done in total minutes since midnight so that overnight
  /// windows (end < start) are handled correctly.
  bool isInsideFocusWindow(AppSettings settings, {DateTime? now}) {
    final current = now ?? DateTime.now();
    final currentMinutes = current.hour * 60 + current.minute;
    final startMinutes =
        settings.focusWindowStartHour * 60 + settings.focusWindowStartMinute;
    final endMinutes =
        settings.focusWindowEndHour * 60 + settings.focusWindowEndMinute;

    if (startMinutes <= endMinutes) {
      // Normal window: e.g. 10:00–21:00
      return currentMinutes >= startMinutes && currentMinutes < endMinutes;
    } else {
      // Overnight window: e.g. 22:00–06:00
      return currentMinutes >= startMinutes || currentMinutes < endMinutes;
    }
  }

  /// Returns true if [now]'s weekday is listed in [settings.restDays].
  ///
  /// Uses [DateTime.weekday] (1 = Monday … 7 = Sunday).
  bool isRestDay(AppSettings settings, {DateTime? now}) {
    final current = now ?? DateTime.now();
    return settings.restDays.contains(current.weekday);
  }

  // ── Reset detection ─────────────────────────────────────────────────────────

  /// Returns true if a daily XP reset is due.
  ///
  /// A reset is due when the focus window has ended since [lastResetDate] —
  /// i.e. the focus window end time has passed on a day after the last reset,
  /// or it has passed today and [lastResetDate] is still from a previous cycle.
  ///
  /// Specifically: if [now] is at or past the window end time AND
  /// [lastResetDate] precedes the most recent window-end boundary.
  bool isDailyResetDue(
    AppSettings settings, {
    required DateTime lastResetDate,
    DateTime? now,
  }) {
    final current = now ?? DateTime.now();
    final lastResetBoundary = _mostRecentWindowEnd(settings, reference: current);
    return lastResetDate.isBefore(lastResetBoundary);
  }

  // ── Carryover calculation ───────────────────────────────────────────────────

  /// Calculates the XP amount that carries over after a daily reset.
  ///
  /// Rule (from data-model.md / AppSettings):
  /// - raw carryover = floor(dailyXp × carryoverPercentage)
  /// - if raw < minimumNextDayXpFloor, use the floor instead
  /// - the carryover can never exceed dailyXp (cannot manufacture XP)
  DailyResetResult calculateCarryover({
    required int dailyXp,
    required double carryoverPercentage,
    required int minimumNextDayXpFloor,
  }) {
    if (dailyXp <= 0) {
      return const DailyResetResult(carryoverXp: 0);
    }

    final raw = (dailyXp * carryoverPercentage).floor();
    final withFloor =
        raw < minimumNextDayXpFloor ? minimumNextDayXpFloor : raw;

    // Never carry over more than was actually earned.
    final carryover = withFloor.clamp(0, dailyXp);

    return DailyResetResult(carryoverXp: carryover);
  }

  // ── Internal helpers ────────────────────────────────────────────────────────

  /// Returns the most recent DateTime at which the focus window ended,
  /// relative to [reference].
  ///
  /// If the window end time has already passed today, that is the boundary.
  /// Otherwise the boundary is yesterday at the end time.
  DateTime _mostRecentWindowEnd(AppSettings settings,
      {required DateTime reference}) {
    final endHour = settings.focusWindowEndHour;
    final endMinute = settings.focusWindowEndMinute;

    final todayEnd = DateTime(
      reference.year,
      reference.month,
      reference.day,
      endHour,
      endMinute,
    );

    if (!reference.isBefore(todayEnd)) {
      return todayEnd;
    }

    // End time hasn't arrived today — the last boundary was yesterday.
    final yesterday = reference.subtract(const Duration(days: 1));
    return DateTime(
      yesterday.year,
      yesterday.month,
      yesterday.day,
      endHour,
      endMinute,
    );
  }
}
