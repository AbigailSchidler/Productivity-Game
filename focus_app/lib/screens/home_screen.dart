import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/xp_provider.dart';
import '../providers/session_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final xp = context.watch<XpProvider>();
    final session = context.watch<SessionProvider>();

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
            const SizedBox(height: 32),
            Text(
              'Daily XP: ${xp.dailyXp}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
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
          ],
        ),
      ),
    );
  }
}
