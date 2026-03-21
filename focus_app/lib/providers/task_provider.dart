import 'package:flutter/foundation.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  List<Task> get activeTasks =>
      _tasks.where((t) => !t.isArchived).toList();

  Task? getTaskById(String id) {
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task updated) {
    final index = _tasks.indexWhere((t) => t.id == updated.id);
    if (index == -1) return;
    _tasks[index] = updated;
    notifyListeners();
  }

  void archiveTask(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return;
    _tasks[index] = _tasks[index].copyWith(
      isArchived: true,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }
}
