import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/session_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/task_provider.dart';
import 'providers/xp_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => SessionProvider()),
        ChangeNotifierProvider(create: (_) => XpProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const FocusApp(),
    ),
  );
}
