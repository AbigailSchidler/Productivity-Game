import 'dart:async';

import 'package:flutter/foundation.dart';
import '../models/xp_balance.dart';
import '../repositories/xp_repository.dart';

/// Manages XP state: daily XP, lifetime XP, carryover.
///
/// XP calculation logic (base XP, reflection bonus, multipliers) lives in
/// XPService — this provider only holds the balance and applies mutations.
class XpProvider extends ChangeNotifier {
  XpProvider(this._repo);

  final XpRepository _repo;
  XPBalance _xpBalance = XPBalance.initial();

  // ── Initialisation ────────────────────────────────────────────────────────

  Future<void> init() async {
    _xpBalance = await _repo.load();
    notifyListeners();
  }

  // ── Getters ──────────────────────────────────────────────────────────────

  XPBalance get xpBalance => _xpBalance;
  int get dailyXp => _xpBalance.dailyXp;
  int get lifetimeXp => _xpBalance.lifetimeXp;
  int get carryoverXp => _xpBalance.carryoverXp;
  int get totalSpentXp => _xpBalance.totalSpentXp;

  // ── Mutations ─────────────────────────────────────────────────────────────

  /// Adds XP to both daily and lifetime totals.
  void addXp(int amount) {
    if (amount <= 0) return;
    _xpBalance = _xpBalance.copyWith(
      dailyXp: _xpBalance.dailyXp + amount,
      lifetimeXp: _xpBalance.lifetimeXp + amount,
    );
    _persist();
    notifyListeners();
  }

  /// Spends XP from the daily total (used for unlock-time redemption).
  /// Clamps to available daily XP — cannot spend more than is available.
  void spendXp(int amount) {
    if (amount <= 0) return;
    final spent = amount.clamp(0, _xpBalance.dailyXp);
    _xpBalance = _xpBalance.copyWith(
      dailyXp: _xpBalance.dailyXp - spent,
      totalSpentXp: _xpBalance.totalSpentXp + spent,
    );
    _persist();
    notifyListeners();
  }

  /// Placeholder for end-of-focus-window daily reset.
  ///
  /// Calculates carryover from [carryoverPercentage], then applies
  /// [minimumFloor] without exceeding what was actually earned that day.
  /// Full integration with FocusWindowService comes in the service layer.
  void resetDailyXp({
    required double carryoverPercentage,
    required int minimumFloor,
  }) {
    final raw = (_xpBalance.dailyXp * carryoverPercentage).floor();
    // Apply minimum floor, but never carry over more than was earned.
    final carryover = raw < minimumFloor
        ? minimumFloor.clamp(0, _xpBalance.dailyXp)
        : raw;
    _xpBalance = _xpBalance.copyWith(
      dailyXp: carryover,
      carryoverXp: carryover,
      lastResetDate: DateTime.now(),
    );
    _persist();
    notifyListeners();
  }

  // ── Internal ──────────────────────────────────────────────────────────────

  void _persist() {
    unawaited(_repo.save(_xpBalance));
  }
}
