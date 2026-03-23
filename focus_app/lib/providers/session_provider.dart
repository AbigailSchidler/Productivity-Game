import 'dart:async';

import 'package:flutter/foundation.dart';
import '../models/session.dart';
import '../repositories/session_repository.dart';
import '../services/timer_service.dart';

/// Manages active session state and session history.
///
/// Owns a [TimerService] instance. Timer ticks drive [notifyListeners] so
/// widgets displaying elapsed time rebuild through this provider — never
/// through TimerService directly.
class SessionProvider extends ChangeNotifier {
  SessionProvider(this._repo);

  final SessionRepository _repo;
  final TimerService _timer = TimerService();

  Session? _activeSession;
  bool _isPaused = false;
  final List<Session> _completedSessions = [];

  // ── Initialisation ────────────────────────────────────────────────────────

  Future<void> init() async {
    final saved = await _repo.loadAll();
    _completedSessions
      ..clear()
      ..addAll(saved);
    notifyListeners();
  }

  // ── Session state ─────────────────────────────────────────────────────────

  Session? get activeSession => _activeSession;
  bool get hasActiveSession => _activeSession != null;
  bool get isPaused => _isPaused;
  List<Session> get completedSessions => List.unmodifiable(_completedSessions);

  /// Sum of [Session.xpEarned] for all *completed* sessions today.
  ///
  /// Uses [Session.endTime] to identify today's sessions. This reflects only
  /// XP earned from sessions — it excludes carryover, spending, and penalties
  /// held in [XPBalance].
  int get todaySessionXp {
    final now = DateTime.now();
    return _completedSessions
        .where((s) =>
            s.wasCompleted &&
            s.endTime != null &&
            s.endTime!.year == now.year &&
            s.endTime!.month == now.month &&
            s.endTime!.day == now.day)
        .fold(0, (sum, s) => sum + s.xpEarned);
  }

  /// Returns the IDs of recently used tasks, deduplicated, most recent first.
  ///
  /// Only task sessions (non-null taskId) contribute. Generic sessions are
  /// ignored. The caller is responsible for resolving IDs to Task objects.
  List<String> recentTaskIds({int limit = 3}) {
    final seen = <String>{};
    final result = <String>[];
    for (final s in _completedSessions) {
      if (s.taskId != null && seen.add(s.taskId!)) {
        result.add(s.taskId!);
        if (result.length >= limit) break;
      }
    }
    return result;
  }

  // ── Timer state (forwarded from TimerService) ─────────────────────────────

  Duration get elapsed => _timer.elapsed;
  Duration get remaining => _timer.remaining;
  bool get isOvertime => _timer.isOvertime;

  // ── Session lifecycle ─────────────────────────────────────────────────────

  /// Starts a new session and its timer.
  void startSession(Session session) {
    _activeSession = session;
    _isPaused = false;
    _timer.start(
      planned: Duration(minutes: session.plannedMinutes),
      onTick: notifyListeners,
    );
    notifyListeners();
  }

  /// Pauses the timer and records a pause against the session.
  /// No-op if there is no active session or it is already paused.
  void pauseSession() {
    if (_activeSession == null || _isPaused) return;
    _isPaused = true;
    _timer.pause();
    _activeSession = _activeSession!.copyWith(
      pauseCount: _activeSession!.pauseCount + 1,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  /// Resumes the timer after a pause.
  /// No-op if there is no active session or it is not paused.
  void resumeSession() {
    if (_activeSession == null || !_isPaused) return;
    _isPaused = false;
    _timer.resume();
    notifyListeners();
  }

  /// Finalises the session as completed and moves it to history.
  ///
  /// [actualMinutes] is read from the timer — the caller does not supply it.
  /// [xpEarned] and [unlockMinutesGranted] are calculated by XPService and
  /// passed in; the provider only stores them.
  void completeSession({
    required int xpEarned,
    required int unlockMinutesGranted,
    String? reflectionText,
  }) {
    if (_activeSession == null) return;
    final actualMinutes = _timer.elapsedMinutes;
    _timer.stop();
    final completed = _activeSession!.copyWith(
      actualMinutes: actualMinutes,
      endTime: DateTime.now(),
      reflectionText: reflectionText,
      xpEarned: xpEarned,
      unlockMinutesGranted: unlockMinutesGranted,
      wasCompleted: true,
      updatedAt: DateTime.now(),
    );
    _completedSessions.insert(0, completed);
    _activeSession = null;
    _isPaused = false;
    unawaited(_repo.save(completed));
    notifyListeners();
  }

  /// Freezes the timer when the user taps "End Session" and moves to
  /// reflection. Does not increment pauseCount — this is not a mid-session
  /// pause. Elapsed time is preserved so [completeSession] can read it.
  void freezeForReflection() {
    if (_activeSession == null) return;
    _timer.pause();
    // Do not touch _isPaused — that flag tracks user-initiated pauses only.
    notifyListeners();
  }

  /// Ends the session without marking it complete, then moves it to history.
  void abandonSession() {
    if (_activeSession == null) return;
    final actualMinutes = _timer.elapsedMinutes;
    _timer.stop();
    final abandoned = _activeSession!.copyWith(
      actualMinutes: actualMinutes,
      endTime: DateTime.now(),
      wasCompleted: false,
      updatedAt: DateTime.now(),
    );
    _completedSessions.insert(0, abandoned);
    _activeSession = null;
    _isPaused = false;
    unawaited(_repo.save(abandoned));
    notifyListeners();
  }

  @override
  void dispose() {
    _timer.dispose();
    super.dispose();
  }
}
