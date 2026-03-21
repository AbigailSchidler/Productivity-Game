import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';

class ActiveSessionScreen extends StatelessWidget {
  const ActiveSessionScreen({super.key});

  String _format(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _endSession(BuildContext context) {
    context.read<SessionProvider>().freezeForReflection();
    Navigator.pushNamed(context, '/reflection');
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<SessionProvider>();
    final session = sp.activeSession;

    // Guard: session should always be set when this screen is shown.
    if (session == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(session.title),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _format(sp.elapsed),
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                sp.isOvertime
                    ? 'Overtime (+${_format(sp.elapsed - sp.remaining)})'
                    : 'Goal: ${session.plannedMinutes} min',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: sp.isOvertime ? Colors.orange : Colors.grey,
                ),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  if (sp.isPaused) {
                    context.read<SessionProvider>().resumeSession();
                  } else {
                    context.read<SessionProvider>().pauseSession();
                  }
                },
                child: Text(sp.isPaused ? 'Resume' : 'Pause'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => _endSession(context),
                child: const Text('End Session'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
