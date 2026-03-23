import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/session.dart';
import '../models/task.dart';
import '../providers/session_provider.dart';
import '../providers/task_provider.dart';

class StartSessionScreen extends StatefulWidget {
  const StartSessionScreen({super.key});

  @override
  State<StartSessionScreen> createState() => _StartSessionScreenState();
}

class _StartSessionScreenState extends State<StartSessionScreen> {
  SessionType _sessionType = SessionType.generic;
  final TextEditingController _titleController = TextEditingController();
  int _plannedMinutes = 25;
  Task? _selectedTask;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _selectTask(Task task) {
    setState(() {
      _selectedTask = task;
      _plannedMinutes = task.defaultDurationMinutes;
    });
  }

  void _clearTaskSelection() {
    setState(() => _selectedTask = null);
  }

  void _startSession() {
    final now = DateTime.now();

    final String title;
    final String? taskId;

    if (_sessionType == SessionType.task) {
      if (_selectedTask == null) return;
      title = _selectedTask!.title;
      taskId = _selectedTask!.id;
    } else {
      title = _titleController.text.trim().isEmpty
          ? 'Generic Session'
          : _titleController.text.trim();
      taskId = null;
    }

    final session = Session(
      id: const Uuid().v4(),
      sessionType: _sessionType,
      taskId: taskId,
      title: title,
      plannedMinutes: _plannedMinutes,
      startTime: now,
      createdAt: now,
      updatedAt: now,
    );

    context.read<SessionProvider>().startSession(session);
    Navigator.pushNamed(context, '/active-session');
  }

  @override
  Widget build(BuildContext context) {
    final activeTasks = context.watch<TaskProvider>().activeTasks;
    final canStart =
        _sessionType == SessionType.generic || _selectedTask != null;

    // When browsing the task list, an Expanded widget fills remaining space.
    // In all other states a Spacer() pushes the button to the bottom.
    final browsingTaskList =
        _sessionType == SessionType.task && _selectedTask == null;

    return Scaffold(
      appBar: AppBar(title: const Text('Start Session')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Session type toggle ──────────────────────────────────────────
            const Text('Session Type'),
            const SizedBox(height: 8),
            SegmentedButton<SessionType>(
              segments: const [
                ButtonSegment(
                  value: SessionType.generic,
                  label: Text('Generic'),
                  icon: Icon(Icons.bolt),
                ),
                ButtonSegment(
                  value: SessionType.task,
                  label: Text('Task'),
                  icon: Icon(Icons.check_box_outlined),
                ),
              ],
              selected: {_sessionType},
              onSelectionChanged: (s) =>
                  setState(() => _sessionType = s.first),
            ),
            if (_sessionType == SessionType.generic) ...[
              const SizedBox(height: 6),
              Text(
                '0.85× XP — complete a task session for full rewards',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
            const SizedBox(height: 24),

            // ── Content area (varies by state) ───────────────────────────────
            if (_sessionType == SessionType.task) ...[
              if (_selectedTask == null) ...[
                // Task list header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select a task',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/create-task'),
                      child: const Text('+ New task'),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Inline task list — expands to fill remaining space
                Expanded(
                  child: _TaskList(
                    tasks: activeTasks,
                    onSelect: _selectTask,
                  ),
                ),
              ] else ...[
                // Task selected — show summary + duration
                _SelectedTaskCard(
                  task: _selectedTask!,
                  onClear: _clearTaskSelection,
                ),
                const SizedBox(height: 24),
                _DurationRow(
                  minutes: _plannedMinutes,
                  onChanged: (v) => setState(() => _plannedMinutes = v),
                ),
                const Spacer(),
              ],
            ] else ...[
              // Generic session
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Session title (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              _DurationRow(
                minutes: _plannedMinutes,
                onChanged: (v) => setState(() => _plannedMinutes = v),
              ),
              const Spacer(),
            ],

            // ── Begin button ─────────────────────────────────────────────────
            if (!browsingTaskList) const SizedBox(height: 8),
            ElevatedButton(
              onPressed: canStart ? _startSession : null,
              child: const Text('Begin Session'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ── Private widgets ────────────────────────────────────────────────────────────

class _TaskList extends StatelessWidget {
  const _TaskList({required this.tasks, required this.onSelect});

  final List<Task> tasks;
  final void Function(Task) onSelect;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Text(
            'No tasks yet.\nTap "+ New task" to create one.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: tasks.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          title: Text(task.title),
          subtitle: Text(
            '${task.category} · ${task.defaultDurationMinutes} min'
            '${task.isRecurring ? ' · recurring' : ''}',
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => onSelect(task),
        );
      },
    );
  }
}

class _SelectedTaskCard extends StatelessWidget {
  const _SelectedTaskCard({required this.task, required this.onClear});

  final Task task;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.check_box_outlined),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimaryContainer,
                        ),
                  ),
                  Text(
                    task.category,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                        ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: onClear,
              child: const Text('Change'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DurationRow extends StatelessWidget {
  const _DurationRow({required this.minutes, required this.onChanged});

  final int minutes;
  final void Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Planned duration: $minutes min'),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: minutes.toDouble(),
                min: 5,
                max: 120,
                divisions: 23,
                label: '$minutes min',
                onChanged: (v) => onChanged(v.round()),
              ),
            ),
            Text('$minutes min'),
          ],
        ),
      ],
    );
  }
}
