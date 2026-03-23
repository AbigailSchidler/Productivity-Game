import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/session_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/streak_provider.dart';
import 'providers/task_provider.dart';
import 'providers/unlock_provider.dart';
import 'providers/xp_provider.dart';
import 'repositories/session_repository.dart';
import 'repositories/settings_repository.dart';
import 'repositories/streak_repository.dart';
import 'repositories/task_repository.dart';
import 'repositories/xp_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sessionProvider = SessionProvider(SessionRepository());
  final settingsProvider = SettingsProvider(SettingsRepository());
  final taskProvider = TaskProvider(TaskRepository());
  final xpProvider = XpProvider(XpRepository());
  final streakProvider = StreakProvider(StreakRepository());

  await Future.wait([
    sessionProvider.init(),
    settingsProvider.init(),
    taskProvider.init(),
    xpProvider.init(),
  ]);

  await streakProvider.init(settingsProvider.settings);

  // Seed initial lock mode from persisted settings.
  final unlockProvider = UnlockProvider()
    ..setLockMode(settingsProvider.settings.lockMode);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: taskProvider),
        ChangeNotifierProvider.value(value: sessionProvider),
        ChangeNotifierProvider.value(value: xpProvider),
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider.value(value: unlockProvider),
        ChangeNotifierProvider.value(value: streakProvider),
      ],
      child: const FocusApp(),
    ),
  );
}
