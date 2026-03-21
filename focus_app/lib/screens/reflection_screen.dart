import 'package:flutter/material.dart';
import '../models/session.dart';

class ReflectionScreen extends StatefulWidget {
  const ReflectionScreen({super.key});

  @override
  State<ReflectionScreen> createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends State<ReflectionScreen> {
  final TextEditingController _reflectionController = TextEditingController();
  bool _initialized = false;
  late Map<String, dynamic> _sessionArgs;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _sessionArgs =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  void _submitReflection() {
    // XP calculation will be handled by XPService in a future step.
    // For now navigate home and clear the stack.
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void _skipReflection() {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final sessionType =
        _initialized ? _sessionArgs['sessionType'] as SessionType : null;
    final actualMinutes =
        _initialized ? _sessionArgs['actualMinutes'] as int : 0;

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
                'Session complete — $actualMinutes min',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              if (sessionType == SessionType.generic) ...[
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
                onPressed: _submitReflection,
                child: const Text('Submit & Earn XP'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _skipReflection,
                child: const Text('Skip reflection'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
