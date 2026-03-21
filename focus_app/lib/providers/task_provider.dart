import 'dart:async';

import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  TaskProvider(this._repo);

  final TaskRepository _repo;
  final List<Task> _tasks = [];

  // ── Initialisation ────────────────────────────────────────────────────────

  Future<void> init() async {
    final saved = await _repo.loadAll();
    _tasks
      ..clear()
      ..addAll(saved);
    notifyListeners();
  }

  // ── Getters ───────────────────────────────────────────────────────────────

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

  // ── Mutations ─────────────────────────────────────────────────────────────

  void addTask(Task task) {
    _tasks.add(task);
    unawaited(_repo.save(task));
    notifyListeners();
  }

  void updateTask(Task updated) {
    final index = _tasks.indexWhere((t) => t.id == updated.id);
    if (index == -1) return;
    _tasks[index] = updated;
    unawaited(_repo.save(updated));
    notifyListeners();
  }

  void archiveTask(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return;
    _tasks[index] = _tasks[index].copyWith(
      isArchived: true,
      updatedAt: DateTime.now(),
    );
    unawaited(_repo.save(_tasks[index]));
    notifyListeners();
  }
}
