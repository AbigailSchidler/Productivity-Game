import 'dart:async';

import '../models/app_settings.dart';

/// Manages simulated unlock state for MVP.
///
/// Pure Dart — no Flutter or Provider imports. UI updates are driven through
/// the [onTick] callback; wire this to a provider's notifyListeners so widgets
/// never depend on this class directly.
///
/// Unlock lifecycle (normal):
///   1. Session completes → [grantUnlockMinutes] adds to the pool.
///   2. User activates → [activateUnlock] starts the countdown.
///   3. Countdown reaches zero (or user calls [deactivateUnlock]) → locked.
///
/// Temporary unlock (MVP simulation of decision #12):
///   [startTemporaryUnlock] / [endTemporaryUnlock] let the UI represent a
///   brief, out-of-band unlock without consuming earned unlock time.
///   Penalty logic (XP deduction) is a future concern; the state flag is
///   surfaced here so the UI can display it.
class UnlockService {
  Timer? _timer;

  /// Remaining earned unlock time, tracked at one-second resolution.
  int _remainingSeconds = 0;

  bool _isUnlocked = false;
  bool _isTemporaryUnlock = false;
  LockMode _lockMode = LockMode.balanced;

  /// Called once per second while an unlock countdown is running.
  /// Wire to your provider's notifyListeners.
  void Function()? onTick;

  // ── Getters ──────────────────────────────────────────────────────────────

  /// True while unlock access is active (earned or temporary).
  bool get isUnlocked => _isUnlocked;

  /// Whole minutes of earned unlock time remaining in the pool.
  /// Fractional seconds are discarded — display-ready.
  int get remainingUnlockMinutes => _remainingSeconds ~/ 60;

  /// Total seconds remaining — use this for a live mm:ss countdown display.
  int get remainingSeconds => _remainingSeconds;

  /// The current lock mode from app settings.
  LockMode get currentLockMode => _lockMode;

  /// True when the active unlock was started via [startTemporaryUnlock].
  bool get isTemporaryUnlock => _isTemporaryUnlock;

  /// True when the pool has at least one full minute available.
  bool get hasUnlockAvailable => _remainingSeconds >= 60;

  // ── Configuration ─────────────────────────────────────────────────────────

  /// Updates the lock mode when settings change.
  void setLockMode(LockMode mode) {
    _lockMode = mode;
  }

  // ── Earning unlock time ───────────────────────────────────────────────────

  /// Adds [minutes] earned from a completed session to the unlock pool.
  ///
  /// Called by the session completion flow after XpService calculates
  /// [unlockMinutesGranted].
  void grantUnlockMinutes(int minutes) {
    if (minutes <= 0) return;
    _remainingSeconds += minutes * 60;
    onTick?.call();
  }

  // ── Activating unlock ─────────────────────────────────────────────────────

  /// Activates earned unlock time and starts the countdown.
  ///
  /// No-op if already unlocked, if a temporary unlock is active, or if no
  /// earned time remains. [onTick] is updated so callers can re-wire the
  /// callback without restarting.
  void activateUnlock({required void Function() onTick}) {
    if (_isUnlocked || _remainingSeconds <= 0) return;
    this.onTick = onTick;
    _isUnlocked = true;
    _isTemporaryUnlock = false;
    _startCountdown();
  }

  /// Pauses the countdown and marks the device as locked.
  ///
  /// Remaining time is preserved — the user can resume later.
  /// No-op if not currently unlocked via earned time.
  void deactivateUnlock() {
    if (!_isUnlocked || _isTemporaryUnlock) return;
    _stopCountdown();
    _isUnlocked = false;
    onTick?.call();
  }

  // ── Temporary unlock (MVP simulation) ────────────────────────────────────

  /// Opens a temporary, out-of-band unlock that does not consume earned time.
  ///
  /// The app is considered unlocked while this is active. Penalty application
  /// (XP cost, strict-mode enforcement) is a future concern; for MVP the UI
  /// simply surfaces [isTemporaryUnlock] so the user knows this is a special
  /// state.
  ///
  /// No-op if already unlocked.
  void startTemporaryUnlock({required void Function() onTick}) {
    if (_isUnlocked) return;
    this.onTick = onTick;
    _isUnlocked = true;
    _isTemporaryUnlock = true;
    // No countdown for temporary unlock — it stays open until explicitly ended.
    onTick.call();
  }

  /// Ends a temporary unlock and returns to locked state.
  ///
  /// No-op if the current unlock is not a temporary unlock.
  void endTemporaryUnlock() {
    if (!_isTemporaryUnlock) return;
    _isUnlocked = false;
    _isTemporaryUnlock = false;
    onTick?.call();
  }

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  void dispose() {
    _stopCountdown();
    onTick = null;
  }

  // ── Internal ──────────────────────────────────────────────────────────────

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
      }
      if (_remainingSeconds <= 0) {
        _stopCountdown();
        _isUnlocked = false;
      }
      onTick?.call();
    });
  }

  void _stopCountdown() {
    _timer?.cancel();
    _timer = null;
  }
}
