import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

/// Displays all active (non-archived) tasks and allows archiving them.
///
/// Navigation entry point for task management. Tapping a task navigates
/// back with the selected [Task] as a pop result — used by
/// [StartSessionScreen] when the user picks a task.
class TaskListScreen extends StatelessWidget {
  /// Whether the screen is being shown as a picker (returns a [Task] on tap)
  /// or as a standalone management view (tap does nothing special).
  final bool isPicker;

  const TaskListScreen({super.key, this.isPicker = false});

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final tasks = taskProvider.activeTasks;

    return Scaffold(
      appBar: AppBar(
        title: Text(isPicker ? 'Choose a Task' : 'Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'New task',
            onPressed: () => Navigator.pushNamed(context, '/create-task'),
          ),
        ],
      ),
      body: tasks.isEmpty
          ? _EmptyState(isPicker: isPicker)
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: tasks.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final task = tasks[index];
                return _TaskTile(
                  task: task,
                  isPicker: isPicker,
                  onArchive: () =>
                      context.read<TaskProvider>().archiveTask(task.id),
                );
              },
            ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.task,
    required this.isPicker,
    required this.onArchive,
  });

  final Task task;
  final bool isPicker;
  final VoidCallback onArchive;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.title),
      subtitle: Text(
        '${task.category} · ${task.defaultDurationMinutes} min'
        '${task.isRecurring ? ' · recurring' : ''}',
      ),
      trailing: isPicker
          ? const Icon(Icons.chevron_right)
          : IconButton(
              icon: const Icon(Icons.archive_outlined),
              tooltip: 'Archive',
              onPressed: () => _confirmArchive(context),
            ),
      onTap: isPicker ? () => Navigator.pop(context, task) : null,
    );
  }

  Future<void> _confirmArchive(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Archive task?'),
        content: Text('"${task.title}" will be hidden from your task list.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Archive'),
          ),
        ],
      ),
    );
    if (confirmed == true) onArchive();
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isPicker});

  final bool isPicker;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isPicker
                ? 'No tasks yet.'
                : 'No tasks yet.\nTap + to create one.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          if (isPicker) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/create-task'),
              child: const Text('Create Task'),
            ),
          ],
        ],
      ),
    );
  }
}
