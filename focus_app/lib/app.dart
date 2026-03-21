import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/start_session_screen.dart';
import 'screens/active_session_screen.dart';
import 'screens/reflection_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';

class FocusApp extends StatelessWidget {
  const FocusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focus App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/start-session': (_) => const StartSessionScreen(),
        '/active-session': (_) => const ActiveSessionScreen(),
        '/reflection': (_) => const ReflectionScreen(),
        '/history': (_) => const HistoryScreen(),
        '/settings': (_) => const SettingsScreen(),
      },
    );
  }
}
