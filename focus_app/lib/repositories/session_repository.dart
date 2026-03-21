import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/session.dart';

class SessionRepository {
  static const _key = 'sessions';

  Future<List<Session>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => Session.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> save(Session session) async {
    final sessions = await loadAll();
    final index = sessions.indexWhere((s) => s.id == session.id);
    if (index >= 0) {
      sessions[index] = session;
    } else {
      sessions.add(session);
    }
    await _persist(sessions);
  }

  Future<void> delete(String id) async {
    final sessions = await loadAll();
    sessions.removeWhere((s) => s.id == id);
    await _persist(sessions);
  }

  Future<void> _persist(List<Session> sessions) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(sessions.map((s) => s.toJson()).toList()));
  }
}
