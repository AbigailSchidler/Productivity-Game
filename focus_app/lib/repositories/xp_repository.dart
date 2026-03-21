import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/xp_balance.dart';

class XpRepository {
  static const _key = 'xp_balance';

  Future<XPBalance> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return XPBalance.initial();
    return XPBalance.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> save(XPBalance balance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(balance.toJson()));
  }
}
