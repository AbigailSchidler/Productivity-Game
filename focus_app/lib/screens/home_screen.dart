import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_settings.dart';
import '../providers/session_provider.dart';
import '../providers/unlock_provider.dart';
import '../providers/xp_provider.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            _UnlockStatusCard(unlock: unlock),
            const SizedBox(height: 16),
            _XpCard(dailyXp: xp.dailyXp, lifetimeXp: xp.lifetimeXp),
            const SizedBox(height: 32),
            if (session.hasActiveSession) ...[
              ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/active-session'),
                child: const Text('Resume Active Session'),
              ),
            ] else ...[
              ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/start-session'),
                child: const Text('Start Session'),
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
  const _XpStat({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value XP',
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
