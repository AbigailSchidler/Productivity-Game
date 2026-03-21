import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/session.dart';
import '../providers/session_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sessions = context.watch<SessionProvider>().completedSessions;

    return Scaffold(
      appBar: AppBar(title: const Text('Session History')),
      body: sessions.isEmpty
          ? const Center(
              child: Text(
                'No sessions yet.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: sessions.length,
              itemBuilder: (context, index) =>
                  _SessionCard(session: sessions[index]),
            ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final Session session;

  const _SessionCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final typeLabel =
        session.sessionType == SessionType.task ? 'Task' : 'Generic';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    session.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    typeLabel,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _Stat(label: 'Planned', value: '${session.plannedMinutes} min'),
                const SizedBox(width: 16),
                _Stat(label: 'Actual', value: '${session.actualMinutes} min'),
                const SizedBox(width: 16),
                _Stat(label: 'XP', value: '+${session.xpEarned}'),
                const SizedBox(width: 16),
                _Stat(
                    label: 'Unlock',
                    value: '${session.unlockMinutesGranted} min'),
              ],
            ),
            if (session.reflectionText != null &&
                session.reflectionText!.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Text(
                session.reflectionText!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;

  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
