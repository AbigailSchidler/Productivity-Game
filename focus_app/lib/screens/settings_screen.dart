import 'package:flutter/material.dart';
import '../models/app_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Placeholder state — will be replaced by SettingsProvider in a future step.
  AppSettings _settings = const AppSettings();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Focus Window',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Start: ${_settings.focusWindowStartHour.toString().padLeft(2, '0')}:'
            '${_settings.focusWindowStartMinute.toString().padLeft(2, '0')}',
          ),
          Text(
            'End: ${_settings.focusWindowEndHour.toString().padLeft(2, '0')}:'
            '${_settings.focusWindowEndMinute.toString().padLeft(2, '0')}',
          ),
          const Divider(height: 32),
          const Text(
            'Lock Mode',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SegmentedButton<LockMode>(
            segments: const [
              ButtonSegment(value: LockMode.light, label: Text('Light')),
              ButtonSegment(
                  value: LockMode.balanced, label: Text('Balanced')),
              ButtonSegment(value: LockMode.strict, label: Text('Strict')),
            ],
            selected: {_settings.lockMode},
            onSelectionChanged: (selected) => setState(
              () => _settings = _settings.copyWith(lockMode: selected.first),
            ),
          ),
          const Divider(height: 32),
          const Text(
            'XP Settings',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('Reflection bonus XP: ${_settings.reflectionBonusXp}'),
          Text(
              'XP to unlock ratio: ${_settings.xpToUnlockMinuteRatio} XP / min'),
          Text(
              'Generic session multiplier: ${_settings.genericSessionMultiplier}'),
        ],
      ),
    );
  }
}
