import 'dart:async';

import 'package:flutter/foundation.dart';
import '../models/app_settings.dart';
import '../models/streak_record.dart';
import '../repositories/streak_repository.dart';
import '../services/streak_service.dart';

/// Manages streak state: current streak, longest streak, last session date.
///
/// Business logic lives in [StreakService] — this provider only holds the
/// record and applies mutations.
class StreakProvider extends ChangeNotifier {
  StreakProvider(this._repo) : _service = const StreakService();

  final StreakRepository _repo;
  final StreakService _service;
  StreakRecord _record = StreakRecord.initial();

  // ── Initialisation ────────────────────────────────────────────────────────

  /// Loads persisted record and resets streak if focus days were missed.
  Future<void> init(AppSettings settings) async {
    _record = await _repo.load();
    final checked = _service.checkForReset(_record, settings);
    if (checked.currentStreak != _record.currentStreak) {
      _record = checked;
      unawaited(_repo.save(_record));
    }
    notifyListeners();
  }

  // ── Getters ───────────────────────────────────────────────────────────────

  int get currentStreak => _record.currentStreak;
  int get longestStreak => _record.longestStreak;

  // ── Mutations ─────────────────────────────────────────────────────────────

  /// Records a completed session and updates the streak.
  ///
  /// [dailySessionXp] must be the total XP earned from completed sessions
  /// today (use [SessionProvider.todaySessionXp]). The streak only advances
  /// when this meets [kDailyStreakXpThreshold].
  ///
  /// Call this immediately after [SessionProvider.completeSession].
  void recordSession(AppSettings settings, {required int dailySessionXp}) {
    _record = _service.recordSession(_record, settings,
        dailySessionXp: dailySessionXp);
    unawaited(_repo.save(_record));
    notifyListeners();
  }
}
