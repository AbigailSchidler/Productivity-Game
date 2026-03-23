import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/streak_record.dart';

class StreakRepository {
  static const _key = 'streak_record';

  Future<StreakRecord> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return StreakRecord.initial();
    return StreakRecord.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> save(StreakRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(record.toJson()));
  }
}
