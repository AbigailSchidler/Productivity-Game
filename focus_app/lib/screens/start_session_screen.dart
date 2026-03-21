import 'package:flutter/material.dart';
import '../models/session.dart';

class StartSessionScreen extends StatefulWidget {
  const StartSessionScreen({super.key});

  @override
  State<StartSessionScreen> createState() => _StartSessionScreenState();
}

class _StartSessionScreenState extends State<StartSessionScreen> {
  SessionType _sessionType = SessionType.generic;
  final TextEditingController _titleController = TextEditingController();
  int _plannedMinutes = 25;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _startSession() {
    final title = _titleController.text.trim().isEmpty
        ? 'Generic Session'
        : _titleController.text.trim();

    Navigator.pushNamed(
      context,
      '/active-session',
      arguments: {
        'sessionType': _sessionType,
        'title': title,
        'plannedMinutes': _plannedMinutes,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Start Session')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Session Type'),
            const SizedBox(height: 8),
            SegmentedButton<SessionType>(
              segments: const [
                ButtonSegment(
                  value: SessionType.generic,
                  label: Text('Generic'),
                ),
                ButtonSegment(
                  value: SessionType.task,
                  label: Text('Task'),
                ),
              ],
              selected: {_sessionType},
              onSelectionChanged: (selected) =>
                  setState(() => _sessionType = selected.first),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Session title (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Planned duration (minutes)'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _plannedMinutes.toDouble(),
                    min: 5,
                    max: 120,
                    divisions: 23,
                    label: '$_plannedMinutes min',
                    onChanged: (value) =>
                        setState(() => _plannedMinutes = value.round()),
                  ),
                ),
                Text('$_plannedMinutes min'),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _startSession,
              child: const Text('Begin Session'),
            ),
          ],
        ),
      ),
    );
  }
}
