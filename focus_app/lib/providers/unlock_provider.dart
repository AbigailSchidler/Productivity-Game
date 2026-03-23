import 'package:flutter/foundation.dart';
import '../models/app_settings.dart';
import '../services/unlock_service.dart';

/// Exposes unlock state to the widget tree.
///
/// Owns an [UnlockService] instance. Service callbacks drive [notifyListeners]
/// so widgets rebuild through this provider — never through UnlockService
/// directly.
///
/// Wire-up in main.dart:
///   - Create after SettingsProvider so the initial lock mode can be applied.
///   - Call [setLockMode] whenever settings change.
///   - Call [grantUnlockMinutes] after a session completes.
class UnlockProvider extends ChangeNotifier {
  final UnlockService _service = UnlockService();

  // ── Getters ──────────────────────────────────────────────────────────────

  /// True while unlock access is active (earned or temporary).
  bool get isUnlocked => _service.isUnlocked;

  /// Whole minutes of earned unlock time remaining in the pool.
  int get remainingUnlockMinutes => _service.remainingUnlockMinutes;

  /// Total seconds remaining — use this for a live mm:ss countdown display.
  int get remainingSeconds => _service.remainingSeconds;

  /// The current lock mode from app settings.
  LockMode get currentLockMode => _service.currentLockMode;

  /// True when the active unlock was started as a temporary unlock.
  bool get isTemporaryUnlock => _service.isTemporaryUnlock;

  /// True when earned unlock minutes are available to activate.
  bool get hasUnlockAvailable => _service.hasUnlockAvailable;

  // ── Configuration ─────────────────────────────────────────────────────────

  /// Updates the lock mode. Call this when [SettingsProvider] changes.
  void setLockMode(LockMode mode) {
    _service.setLockMode(mode);
    notifyListeners();
  }

  // ── Earning unlock time ───────────────────────────────────────────────────

  /// Grants unlock minutes from a completed session.
  ///
  /// Call this from the session-complete flow, passing
  /// [Session.unlockMinutesGranted] computed by [XpService].
  void grantUnlockMinutes(int minutes) {
    _service.grantUnlockMinutes(minutes);
    notifyListeners();
  }

  // ── Activating unlock ─────────────────────────────────────────────────────

  /// Activates earned unlock time and starts the countdown.
  void activateUnlock() {
    _service.activateUnlock(onTick: notifyListeners);
  }

  /// Pauses the countdown and marks the device as locked.
  /// Remaining earned time is preserved.
  void deactivateUnlock() {
    _service.deactivateUnlock();
  }

  // ── Temporary unlock ──────────────────────────────────────────────────────

  /// Opens a temporary, out-of-band unlock (MVP simulation of decision #12).
  void startTemporaryUnlock() {
    _service.startTemporaryUnlock(onTick: notifyListeners);
  }

  /// Ends the temporary unlock and returns to locked state.
  void endTemporaryUnlock() {
    _service.endTemporaryUnlock();
  }

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}
