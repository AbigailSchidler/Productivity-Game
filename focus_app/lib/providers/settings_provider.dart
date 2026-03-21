import 'package:flutter/foundation.dart';
import '../models/app_settings.dart';

/// Manages user-configurable app settings.
///
/// Exposes the full [AppSettings] object plus grouped update methods so that
/// screens only touch the fields relevant to their concern.
class SettingsProvider extends ChangeNotifier {
  AppSettings _settings = const AppSettings();

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
    notifyListeners();
  }

  void updateRestDays(List<int> days) {
    _settings = _settings.copyWith(restDays: days);
    notifyListeners();
  }

  // ── Lock mode ─────────────────────────────────────────────────────────────

  void updateLockMode(LockMode mode) {
    _settings = _settings.copyWith(lockMode: mode);
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
    notifyListeners();
  }

  // ── Warning settings ──────────────────────────────────────────────────────

  void updateWarningSettings({bool? enabled, int? leadMinutes}) {
    _settings = _settings.copyWith(
      warningEnabled: enabled,
      warningLeadMinutes: leadMinutes,
    );
    notifyListeners();
  }

  // ── Bulk replace ──────────────────────────────────────────────────────────

  /// Replaces the entire settings object at once.
  /// Used when loading persisted settings from the repository.
  void loadSettings(AppSettings loaded) {
    _settings = loaded;
    notifyListeners();
  }
}
