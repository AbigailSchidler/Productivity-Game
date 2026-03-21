import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/task.dart';

class TaskRepository {
  static const _key = 'tasks';

  Future<List<Task>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> save(Task task) async {
    final tasks = await loadAll();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index >= 0) {
      tasks[index] = task;
    } else {
      tasks.add(task);
    }
    await _persist(tasks);
  }

  Future<void> delete(String id) async {
    final tasks = await loadAll();
    tasks.removeWhere((t) => t.id == id);
    await _persist(tasks);
  }

  Future<void> _persist(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(tasks.map((t) => t.toJson()).toList()));
  }
}
