import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/xp_provider.dart';
import '../services/xp_service.dart';

class ReflectionScreen extends StatefulWidget {
  const ReflectionScreen({super.key});

  @override
  State<ReflectionScreen> createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends State<ReflectionScreen> {
  final TextEditingController _reflectionController = TextEditingController();
  static const _xpService = XpService();

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  /// Calculates XP, awards it, completes the session, then returns home.
  void _finish(BuildContext context, {required bool hasReflection}) {
    final sp = context.read<SessionProvider>();
    final session = sp.activeSession;
    if (session == null) return;

    final settings = context.read<SettingsProvider>().settings;
    final text = _reflectionController.text.trim();

    final calc = _xpService.calculateSessionXp(
      actualMinutes: sp.elapsed.inMinutes,
      sessionType: session.sessionType,
      hasReflection: hasReflection,
      reflectionBonusXp: settings.reflectionBonusXp,
      genericSessionMultiplier: settings.genericSessionMultiplier,
    );

    final unlockMinutes = _xpService.calculateUnlockMinutes(
      xpEarned: calc.totalXp,
      xpToUnlockMinuteRatio: settings.xpToUnlockMinuteRatio,
    );

    context.read<XpProvider>().addXp(calc.totalXp);
    sp.completeSession(
      xpEarned: calc.totalXp,
      unlockMinutesGranted: unlockMinutes,
      reflectionText: (hasReflection && text.isNotEmpty) ? text : null,
    );

    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<SessionProvider>();
    final session = sp.activeSession;
    final elapsedMinutes = sp.elapsed.inMinutes;

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Session Reflection'),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Session complete — $elapsedMinutes min',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              if (session != null &&
                  session.sessionType.name == 'generic') ...[
                const SizedBox(height: 8),
                const Text(
                  'Generic session (0.85× XP multiplier)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
              const SizedBox(height: 32),
              const Text(
                'What did you work on? (+5 XP bonus)',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _reflectionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Describe what you accomplished...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () =>
                    _finish(context, hasReflection: true),
                child: const Text('Submit & Earn XP'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () =>
                    _finish(context, hasReflection: false),
                child: const Text('Skip reflection'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
