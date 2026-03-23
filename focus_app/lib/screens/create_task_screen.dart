import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

/// Form screen for creating a new [Task].
///
/// Calls [TaskProvider.addTask] on save, then pops. No editing logic —
/// tasks are immutable in MVP once created (archive to remove).
class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  int _durationMinutes = 25;
  bool _isRecurring = false;
  TaskDifficulty _difficulty = TaskDifficulty.normal;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final now = DateTime.now();
    final task = Task(
      id: const Uuid().v4(),
      title: title,
      category: _categoryController.text.trim().isEmpty
          ? 'General'
          : _categoryController.text.trim(),
      defaultDurationMinutes: _durationMinutes,
      isRecurring: _isRecurring,
      difficulty: _difficulty,
      createdAt: now,
      updatedAt: now,
    );

    context.read<TaskProvider>().addTask(task);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Task')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task title',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Category (optional)',
                hintText: 'e.g. Study, Chores, Creative',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 24),
            Text('Default duration: $_durationMinutes min'),
            Slider(
              value: _durationMinutes.toDouble(),
              min: 5,
              max: 120,
              divisions: 23,
              label: '$_durationMinutes min',
              onChanged: (v) => setState(() => _durationMinutes = v.round()),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Recurring task'),
              subtitle: const Text('Shows as a reusable option each day'),
              value: _isRecurring,
              onChanged: (v) => setState(() => _isRecurring = v),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 16),
            const Text('How hard is this task for you to do?'),
            const SizedBox(height: 8),
            _DifficultyPicker(
              selected: _difficulty,
              onChanged: (d) => setState(() => _difficulty = d),
            ),
            const SizedBox(height: 4),
            Text(
              '${_difficulty.multiplierLabel} XP multiplier',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _titleController.text.trim().isEmpty ? null : _save,
              child: const Text('Save Task'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _DifficultyPicker extends StatelessWidget {
  const _DifficultyPicker({
    required this.selected,
    required this.onChanged,
  });

  final TaskDifficulty selected;
  final void Function(TaskDifficulty) onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: TaskDifficulty.values.map((d) {
        return ChoiceChip(
          label: Text(d.label),
          selected: selected == d,
          onSelected: (_) => onChanged(d),
        );
      }).toList(),
    );
  }
}
