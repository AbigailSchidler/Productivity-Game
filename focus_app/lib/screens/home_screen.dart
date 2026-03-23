import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/app_settings.dart';
import '../models/session.dart';
import '../models/task.dart';
import '../providers/session_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/streak_provider.dart';
import '../providers/task_provider.dart';
import '../providers/unlock_provider.dart';
import '../providers/xp_provider.dart';
import '../services/focus_window_service.dart';
import '../services/mascot_service.dart';
import '../services/streak_service.dart' show kDailyStreakXpThreshold;

// Dart weekday: 7 = Sunday.
const int _sunday = 7;

const _focusWindowService = FocusWindowService();
const _mascotService = MascotService();

String _formatTime(int hour, int minute) {
  final period = hour < 12 ? 'AM' : 'PM';
  final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
  final minuteStr = minute.toString().padLeft(2, '0');
  return '$displayHour:$minuteStr $period';
}

({IconData icon, String message}) _mascotContent(MascotState state) =>
    switch (state) {
      MascotState.locked => (
          icon: Icons.lock_outline,
          message: 'we should probably focus',
        ),
      MascotState.focusing => (
          icon: Icons.self_improvement,
          message: 'in the zone — keep going',
        ),
      MascotState.completedSession => (
          icon: Icons.check_circle_outline,
          message: 'nice!! session done',
        ),
      MascotState.outsideFocusWindow => (
          icon: Icons.nights_stay_outlined,
          message: 'outside focus window',
        ),
      MascotState.streakActive => (
          icon: Icons.local_fire_department_outlined,
          message: "we're on a streak",
        ),
      MascotState.idle => (
          icon: Icons.sentiment_satisfied_outlined,
          message: 'ready when you are',
        ),
    };

String _formatCountdown(int totalSeconds) {
  final m = totalSeconds ~/ 60;
  final s = totalSeconds % 60;
  return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')} remaining';
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final xp = context.watch<XpProvider>();
    final session = context.watch<SessionProvider>();
    final unlock = context.watch<UnlockProvider>();
    final settings = context.watch<SettingsProvider>().settings;
    final streak = context.watch<StreakProvider>();
    final taskProvider = context.watch<TaskProvider>();
    final recentTasks = session
        .recentTaskIds()
        .map(taskProvider.getTaskById)
        .whereType<Task>()
        .toList();

    final mascotState = _mascotService.resolve(
      hasActiveSession: session.hasActiveSession,
      isInsideFocusWindow: _focusWindowService.isInsideFocusWindow(settings),
      isLocked: !unlock.isUnlocked,
      completedSessionToday: session.todaySessionXp > 0,
      currentStreak: streak.currentStreak,
    );

    final isSunday = DateTime.now().weekday == _sunday;
    final recap = isSunday ? session.weeklyRecap() : null;
    final topCategory = recap?.topTaskId != null
        ? taskProvider.getTaskById(recap!.topTaskId!)?.category
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              _MascotDisplay(state: mascotState),
              const SizedBox(height: 16),
              _FocusWindowCard(settings: settings, unlock: unlock),
              const SizedBox(height: 16),
              _UnlockStatusCard(unlock: unlock),
              const SizedBox(height: 16),
              _XpCard(dailyXp: xp.dailyXp, lifetimeXp: xp.lifetimeXp),
              const SizedBox(height: 16),
              _StreakCard(
                currentStreak: streak.currentStreak,
                longestStreak: streak.longestStreak,
              ),
              if (recap != null) ...[
                const SizedBox(height: 16),
                _WeeklyRecapCard(
                  recap: recap,
                  topCategory: topCategory,
                  currentStreak: streak.currentStreak,
                ),
              ],
              const SizedBox(height: 16),
              if (!session.hasActiveSession)
                _QuickStartRow(recentTasks: recentTasks),
              const SizedBox(height: 16),
              if (session.hasActiveSession) ...[
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/active-session'),
                  child: const Text('Resume Active Session'),
                ),
              ] else ...[
                OutlinedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/start-session'),
                  child: const Text('More options'),
                ),
              ],
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, '/history'),
                child: const Text('Session History'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, '/tasks'),
                child: const Text('Manage Tasks'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeeklyRecapCard extends StatelessWidget {
  const _WeeklyRecapCard({
    required this.recap,
    required this.topCategory,
    required this.currentStreak,
  });

  final WeeklyRecap recap;
  final String? topCategory;
  final int currentStreak;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final streakLabel = currentStreak == 0
        ? 'No active streak'
        : '$currentStreak ${currentStreak == 1 ? 'day' : 'days'}';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_month,
                    size: 18, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Weekly Recap',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _RecapStat(
                    label: 'Sessions',
                    value: '${recap.sessionCount}',
                  ),
                ),
                Expanded(
                  child: _RecapStat(
                    label: 'XP earned',
                    value: '${recap.totalXp}',
                  ),
                ),
                Expanded(
                  child: _RecapStat(
                    label: 'Streak',
                    value: streakLabel,
                  ),
                ),
              ],
            ),
            if (topCategory != null) ...[
              const SizedBox(height: 8),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Text(
                'Most used: $topCategory',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RecapStat extends StatelessWidget {
  const _RecapStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _QuickStartRow extends StatelessWidget {
  const _QuickStartRow({required this.recentTasks});

  final List<Task> recentTasks;

  void _startGeneric(BuildContext context) {
    final now = DateTime.now();
    context.read<SessionProvider>().startSession(Session(
          id: const Uuid().v4(),
          sessionType: SessionType.generic,
          title: 'Generic Session',
          plannedMinutes: 25,
          startTime: now,
          createdAt: now,
          updatedAt: now,
        ));
    Navigator.pushNamed(context, '/active-session');
  }

  void _startTask(BuildContext context, Task task) {
    final now = DateTime.now();
    context.read<SessionProvider>().startSession(Session(
          id: const Uuid().v4(),
          sessionType: SessionType.task,
          taskId: task.id,
          title: task.title,
          plannedMinutes: task.defaultDurationMinutes,
          startTime: now,
          createdAt: now,
          updatedAt: now,
        ));
    Navigator.pushNamed(context, '/active-session');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick start',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            ActionChip(
              avatar: const Icon(Icons.bolt, size: 16),
              label: const Text('Generic'),
              onPressed: () => _startGeneric(context),
            ),
            ...recentTasks.map(
              (task) => ActionChip(
                avatar: const Icon(Icons.check_box_outlined, size: 16),
                label: Text(task.title),
                onPressed: () => _startTask(context, task),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// TODO: replace with custom monkey artwork when assets are ready
class _MascotDisplay extends StatelessWidget {
  const _MascotDisplay({required this.state});

  final MascotState state;

  @override
  Widget build(BuildContext context) {
    final content = _mascotContent(state);
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          content.icon,
          size: 32,
          color: colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 12),
        Text(
          content.message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

class _FocusWindowCard extends StatelessWidget {
  const _FocusWindowCard({required this.settings, required this.unlock});

  final AppSettings settings;
  final UnlockProvider unlock;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isRestDay = _focusWindowService.isRestDay(settings);
    final isInWindow = _focusWindowService.isInsideFocusWindow(settings);
    final isLocked = !unlock.isUnlocked;

    final windowStart = _formatTime(
        settings.focusWindowStartHour, settings.focusWindowStartMinute);
    final windowEnd = _formatTime(
        settings.focusWindowEndHour, settings.focusWindowEndMinute);

    String statusText;
    IconData statusIcon;
    Color cardColor;
    Color contentColor;

    if (isRestDay) {
      statusText = 'Rest day — restrictions relaxed';
      statusIcon = Icons.weekend;
      cardColor = colorScheme.surfaceContainerHighest;
      contentColor = colorScheme.onSurfaceVariant;
    } else if (!isInWindow) {
      statusText = 'Outside focus window — restrictions relaxed';
      statusIcon = Icons.schedule;
      cardColor = colorScheme.surfaceContainerHighest;
      contentColor = colorScheme.onSurfaceVariant;
    } else if (isLocked) {
      statusText = 'Inside focus window — complete a session to earn access';
      statusIcon = Icons.lock_clock;
      cardColor = colorScheme.errorContainer;
      contentColor = colorScheme.onErrorContainer;
    } else {
      statusText = 'Inside focus window';
      statusIcon = Icons.radio_button_checked;
      cardColor = colorScheme.primaryContainer;
      contentColor = colorScheme.onPrimaryContainer;
    }

    return Card(
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(statusIcon, color: contentColor, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    statusText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: contentColor,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
            if (!isRestDay) ...[
              const SizedBox(height: 6),
              Text(
                'Focus window: $windowStart – $windowEnd',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: contentColor,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _UnlockStatusCard extends StatelessWidget {
  const _UnlockStatusCard({required this.unlock});

  final UnlockProvider unlock;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isUnlocked = unlock.isUnlocked;

    return Card(
      color: isUnlocked
          ? colorScheme.primaryContainer
          : colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  isUnlocked ? Icons.lock_open : Icons.lock,
                  color: isUnlocked
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  isUnlocked ? 'Unlocked' : 'Locked',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isUnlocked
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurfaceVariant,
                      ),
                ),
                const Spacer(),
                _LockModeChip(mode: unlock.currentLockMode),
              ],
            ),
            const SizedBox(height: 12),
            if (isUnlocked) ...[
              Text(
                unlock.isTemporaryUnlock
                    ? 'Temporary unlock active'
                    : _formatCountdown(unlock.remainingSeconds),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
              ),
              const SizedBox(height: 12),
              if (unlock.isTemporaryUnlock) ...[
                ElevatedButton(
                  onPressed: unlock.endTemporaryUnlock,
                  child: const Text('End Temporary Unlock'),
                ),
              ] else ...[
                OutlinedButton(
                  onPressed: unlock.deactivateUnlock,
                  child: const Text('Lock Now'),
                ),
              ],
            ] else ...[
              Text(
                unlock.hasUnlockAvailable
                    ? '${unlock.remainingUnlockMinutes} min available'
                    : 'Complete a session to earn unlock time',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
              if (unlock.hasUnlockAvailable) ...[
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: unlock.activateUnlock,
                  child: const Text('Activate Unlock'),
                ),
              ],
              const SizedBox(height: 8),
              TextButton(
                onPressed: unlock.startTemporaryUnlock,
                child: const Text('Temporary Unlock'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LockModeChip extends StatelessWidget {
  const _LockModeChip({required this.mode});

  final LockMode mode;

  String get _label => switch (mode) {
        LockMode.light => 'Light',
        LockMode.balanced => 'Balanced',
        LockMode.strict => 'Strict',
      };

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(_label),
      padding: EdgeInsets.zero,
      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard({
    required this.currentStreak,
    required this.longestStreak,
  });

  final int currentStreak;
  final int longestStreak;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _XpStat(
                    label: 'Streak',
                    value: currentStreak,
                    unit: currentStreak == 1 ? 'day' : 'days',
                  ),
                ),
                const VerticalDivider(indent: 4, endIndent: 4),
                Expanded(
                  child: _XpStat(
                    label: 'Best',
                    value: longestStreak,
                    unit: longestStreak == 1 ? 'day' : 'days',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Requires $kDailyStreakXpThreshold XP/day from sessions',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _XpCard extends StatelessWidget {
  const _XpCard({required this.dailyXp, required this.lifetimeXp});

  final int dailyXp;
  final int lifetimeXp;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: _XpStat(
                label: 'Today',
                value: dailyXp,
              ),
            ),
            const VerticalDivider(indent: 4, endIndent: 4),
            Expanded(
              child: _XpStat(
                label: 'Lifetime',
                value: lifetimeXp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _XpStat extends StatelessWidget {
  const _XpStat({required this.label, required this.value, this.unit = 'XP'});

  final String label;
  final int value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value $unit',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
