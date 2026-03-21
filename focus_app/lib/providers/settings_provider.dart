import 'dart:async';

import 'package:flutter/foundation.dart';
import '../models/app_settings.dart';
import '../repositories/settings_repository.dart';

/// Manages user-configurable app settings.
///
/// Exposes the full [AppSettings] object plus grouped update methods so that
/// screens only touch the fields relevant to their concern.
class SettingsProvider extends ChangeNotifier {
  SettingsProvider(this._repo);

  final SettingsRepository _repo;
  AppSettings _settings = const AppSettings();

  // ── Initialisation ────────────────────────────────────────────────────────

  Future<void> init() async {
    _settings = await _repo.load();
    notifyListeners();
  }

  // ── Getter ────────────────────────────────────────────────────────────────

  AppSettings get settings => _settings;

  // ── Focus window ──────────────────────────────────────────────────────────

  void updateFocusWindow({
    int? startHour,
    int? startMinute,
    int? endHour,
    int? endMinute,
  }) {
    _settings = _settings.copyWith(
      focusWindowStartHour: startHour,
      focusWindowStartMinute: startMinute,
      focusWindowEndHour: endHour,
      focusWindowEndMinute: endMinute,
    );
    _persist();
    notifyListeners();
  }

  void updateRestDays(List<int> days) {
    _settings = _settings.copyWith(restDays: days);
    _persist();
    notifyListeners();
  }

  // ── Lock mode ─────────────────────────────────────────────────────────────

  void updateLockMode(LockMode mode) {
    _settings = _settings.copyWith(lockMode: mode);
    _persist();
    notifyListeners();
  }

  // ── XP settings ───────────────────────────────────────────────────────────

  void updateXpSettings({
    int? reflectionBonusXp,
    int? xpToUnlockMinuteRatio,
    double? genericSessionMultiplier,
    double? carryoverPercentage,
    int? minimumNextDayXpFloor,
  }) {
    _settings = _settings.copyWith(
      reflectionBonusXp: reflectionBonusXp,
      xpToUnlockMinuteRatio: xpToUnlockMinuteRatio,
      genericSessionMultiplier: genericSessionMultiplier,
      carryoverPercentage: carryoverPercentage,
      minimumNextDayXpFloor: minimumNextDayXpFloor,
    );
    _persist();
    notifyListeners();
  }

  // ── Warning settings ──────────────────────────────────────────────────────

  void updateWarningSettings({bool? enabled, int? leadMinutes}) {
    _settings = _settings.copyWith(
      warningEnabled: enabled,
      warningLeadMinutes: leadMinutes,
    );
    _persist();
    notifyListeners();
  }

  // ── Internal ──────────────────────────────────────────────────────────────

  void _persist() {
    unawaited(_repo.save(_settings));
  }
}
