import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../providers/settings_provider.dart';

/// Displays the reward summary for the most recently completed session.
///
/// Data is read from the first entry in [SessionProvider.completedSessions],
/// which is always the session just finished. [SettingsProvider] supplies
/// the reflectionBonusXp needed to split baseXp from the reflection bonus.
///
/// Navigation: always push this screen with all lower routes removed except
/// home, so the back button is not shown and "Return Home" pops to root.
class SessionCompleteScreen extends StatelessWidget {
  const SessionCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sessions = context.read<SessionProvider>().completedSessions;
    final settings = context.read<SettingsProvider>().settings;

    if (sessions.isEmpty) {
      // Safety fallback — should not normally be reached.
      return Scaffold(
        appBar: AppBar(title: const Text('Session Complete')),
        body: Center(
          child: ElevatedButton(
            onPressed: () =>
                Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false),
            child: const Text('Return Home'),
          ),
        ),
      );
    }

    final session = sessions.first;
    final reflectionBonus =
        session.reflectionText != null ? settings.reflectionBonusXp : 0;
    final baseXp = session.xpEarned - reflectionBonus;

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Session Complete'),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text(
                session.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _SummaryCard(
                baseXp: baseXp,
                reflectionBonus: reflectionBonus,
                totalXp: session.xpEarned,
                unlockMinutes: session.unlockMinutesGranted,
                plannedMinutes: session.plannedMinutes,
                actualMinutes: session.actualMinutes,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, '/', (_) => false),
                child: const Text('Return Home'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.baseXp,
    required this.reflectionBonus,
    required this.totalXp,
    required this.unlockMinutes,
    required this.plannedMinutes,
    required this.actualMinutes,
  });

  final int baseXp;
  final int reflectionBonus;
  final int totalXp;
  final int unlockMinutes;
  final int plannedMinutes;
  final int actualMinutes;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SummaryRow(label: 'Planned', value: '$plannedMinutes min'),
            const Divider(height: 24),
            _SummaryRow(label: 'Actual', value: '$actualMinutes min'),
            const Divider(height: 24),
            _SummaryRow(label: 'Base XP', value: '+$baseXp XP'),
            if (reflectionBonus > 0) ...[
              const SizedBox(height: 12),
              _SummaryRow(
                label: 'Reflection bonus',
                value: '+$reflectionBonus XP',
              ),
            ],
            const Divider(height: 24),
            _SummaryRow(
              label: 'Total XP earned',
              value: '$totalXp XP',
              bold: true,
            ),
            const Divider(height: 24),
            _SummaryRow(
              label: 'Unlock time granted',
              value: '$unlockMinutes min',
              bold: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = bold
        ? Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(fontWeight: FontWeight.bold)
        : Theme.of(context).textTheme.bodyLarge;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    );
  }
}
