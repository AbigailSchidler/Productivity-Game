import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_settings.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _reflectionBonusController;
  late final TextEditingController _xpRatioController;
  late final TextEditingController _genericMultiplierController;

  @override
  void initState() {
    super.initState();
    final s = context.read<SettingsProvider>().settings;
    _reflectionBonusController =
        TextEditingController(text: s.reflectionBonusXp.toString());
    _xpRatioController =
        TextEditingController(text: s.xpToUnlockMinuteRatio.toString());
    _genericMultiplierController =
        TextEditingController(text: s.genericSessionMultiplier.toString());
  }

  @override
  void dispose() {
    _reflectionBonusController.dispose();
    _xpRatioController.dispose();
    _genericMultiplierController.dispose();
    super.dispose();
  }

  String _formatTime(int hour, int minute) =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  Future<void> _pickTime(
    BuildContext context, {
    required int initialHour,
    required int initialMinute,
    required void Function(int hour, int minute) onPicked,
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initialHour, minute: initialMinute),
    );
    if (picked != null) {
      onPicked(picked.hour, picked.minute);
    }
  }

  void _saveReflectionBonus(SettingsProvider sp) {
    final val = int.tryParse(_reflectionBonusController.text.trim());
    if (val != null && val >= 0) sp.updateXpSettings(reflectionBonusXp: val);
  }

  void _saveXpRatio(SettingsProvider sp) {
    final val = int.tryParse(_xpRatioController.text.trim());
    if (val != null && val > 0) sp.updateXpSettings(xpToUnlockMinuteRatio: val);
  }

  void _saveGenericMultiplier(SettingsProvider sp) {
    final val = double.tryParse(_genericMultiplierController.text.trim());
    if (val != null && val > 0 && val <= 1) {
      sp.updateXpSettings(genericSessionMultiplier: val);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<SettingsProvider>();
    final s = sp.settings;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // ── Focus window ────────────────────────────────────────────────────
          const Text(
            'Focus Window',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Start time'),
            trailing: Text(
              _formatTime(s.focusWindowStartHour, s.focusWindowStartMinute),
              style: const TextStyle(fontSize: 15),
            ),
            onTap: () => _pickTime(
              context,
              initialHour: s.focusWindowStartHour,
              initialMinute: s.focusWindowStartMinute,
              onPicked: (h, m) =>
                  sp.updateFocusWindow(startHour: h, startMinute: m),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('End time'),
            trailing: Text(
              _formatTime(s.focusWindowEndHour, s.focusWindowEndMinute),
              style: const TextStyle(fontSize: 15),
            ),
            onTap: () => _pickTime(
              context,
              initialHour: s.focusWindowEndHour,
              initialMinute: s.focusWindowEndMinute,
              onPicked: (h, m) =>
                  sp.updateFocusWindow(endHour: h, endMinute: m),
            ),
          ),
          const Divider(height: 32),
          // ── Lock mode ───────────────────────────────────────────────────────
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
            selected: {s.lockMode},
            onSelectionChanged: (selected) =>
                sp.updateLockMode(selected.first),
          ),
          const Divider(height: 32),
          // ── XP settings ─────────────────────────────────────────────────────
          const Text(
            'XP Settings',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _NumericField(
            label: 'Reflection bonus XP',
            controller: _reflectionBonusController,
            onSave: () => _saveReflectionBonus(sp),
          ),
          const SizedBox(height: 12),
          _NumericField(
            label: 'XP per unlock minute',
            controller: _xpRatioController,
            onSave: () => _saveXpRatio(sp),
          ),
          const SizedBox(height: 12),
          _NumericField(
            label: 'Generic session multiplier',
            controller: _genericMultiplierController,
            onSave: () => _saveGenericMultiplier(sp),
            decimal: true,
          ),
        ],
      ),
    );
  }
}

class _NumericField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final VoidCallback onSave;
  final bool decimal;

  const _NumericField({
    required this.label,
    required this.controller,
    required this.onSave,
    this.decimal = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: decimal
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onSubmitted: (_) => onSave(),
      onTapOutside: (_) => onSave(),
    );
  }
}
