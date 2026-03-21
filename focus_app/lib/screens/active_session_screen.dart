import 'dart:async';
import 'package:flutter/material.dart';
import '../models/session.dart';

class ActiveSessionScreen extends StatefulWidget {
  const ActiveSessionScreen({super.key});

  @override
  State<ActiveSessionScreen> createState() => _ActiveSessionScreenState();
}

class _ActiveSessionScreenState extends State<ActiveSessionScreen> {
  late SessionType _sessionType;
  late String _title;
  late int _plannedMinutes;
  late DateTime _startTime;

  int _elapsedSeconds = 0;
  int _pauseCount = 0;
  bool _isPaused = false;
  Timer? _timer;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _sessionType = args['sessionType'] as SessionType;
      _title = args['title'] as String;
      _plannedMinutes = args['plannedMinutes'] as int;
      _startTime = DateTime.now();
      _startTimer();
      _initialized = true;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_isPaused) {
        setState(() => _elapsedSeconds++);
      }
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) _pauseCount++;
    });
  }

  void _endSession() {
    _timer?.cancel();
    final actualMinutes = (_elapsedSeconds / 60).ceil();

    Navigator.pushNamed(
      context,
      '/reflection',
      arguments: {
        'sessionType': _sessionType,
        'title': _title,
        'plannedMinutes': _plannedMinutes,
        'actualMinutes': actualMinutes,
        'startTime': _startTime,
        'pauseCount': _pauseCount,
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _elapsedDisplay {
    final minutes = _elapsedSeconds ~/ 60;
    final seconds = _elapsedSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_initialized ? _title : 'Session'),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _elapsedDisplay,
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _initialized ? 'Goal: $_plannedMinutes min' : '',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: _togglePause,
                child: Text(_isPaused ? 'Resume' : 'Pause'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: _endSession,
                child: const Text('End Session'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
