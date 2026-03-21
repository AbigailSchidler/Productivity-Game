import 'dart:async';

/// Manages the session countdown/count-up timer.
///
/// Pure Dart — no Flutter or Provider imports. All UI updates are driven
/// through the [onTick] callback, which SessionProvider wires to its own
/// notifyListeners so widgets never depend on this class directly.
class TimerService {
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  Duration _planned = Duration.zero;
  bool _isRunning = false;
  bool _isPaused = false;

  /// Called once per second while the timer is running.
  void Function()? onTick;

  // ── Getters ──────────────────────────────────────────────────────────────

  Duration get elapsed => _elapsed;
  Duration get planned => _planned;
  bool get isRunning => _isRunning;
  bool get isPaused => _isPaused;

  /// True when elapsed time has exceeded the planned duration.
  bool get isOvertime => _elapsed > _planned;

  /// Whole minutes elapsed (used when writing actualMinutes to Session).
  int get elapsedMinutes => _elapsed.inMinutes;

  /// Remaining duration. Returns Duration.zero once overtime.
  Duration get remaining =>
      _planned > _elapsed ? _planned - _elapsed : Duration.zero;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  /// Starts a fresh timer for [planned] duration.
  ///
  /// [onTick] fires once per second; pass [SessionProvider.notifyListeners]
  /// so the provider drives all UI updates.
  void start({required Duration planned, required void Function() onTick}) {
    _stop();
    _planned = planned;
    _elapsed = Duration.zero;
    _isRunning = true;
    _isPaused = false;
    this.onTick = onTick;
    _startTick();
  }

  /// Pauses the timer. Elapsed time is preserved.
  /// No-op if not running or already paused.
  void pause() {
    if (!_isRunning || _isPaused) return;
    _isPaused = true;
    _timer?.cancel();
    _timer = null;
  }

  /// Resumes a paused timer from where it left off.
  /// No-op if not running or not paused.
  void resume() {
    if (!_isRunning || !_isPaused) return;
    _isPaused = false;
    _startTick();
  }

  /// Stops the timer and resets state.
  /// Returns the final elapsed [Duration] for the caller to record.
  Duration stop() {
    final result = _elapsed;
    _stop();
    return result;
  }

  void dispose() {
    _stop();
    onTick = null;
  }

  // ── Internal ──────────────────────────────────────────────────────────────

  void _startTick() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsed += const Duration(seconds: 1);
      onTick?.call();
    });
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    _isPaused = false;
    _elapsed = Duration.zero;
  }
}
