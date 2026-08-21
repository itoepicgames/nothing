import 'package:flutter/material.dart';

import 'app.dart';
import 'services/history_service.dart';
import 'services/settings_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settings = SettingsService();
  final history = HistoryService();
  final theme = await settings.loadTheme();
  final language = await settings.loadLanguage();
  final haptics = await settings.loadHaptics();
  final items = await history.load();

  runApp(
    ScanovaApp(
      settings: settings,
      historyService: history,
      initialTheme: theme,
      initialLanguage: language,
      initialHaptics: haptics,
      initialHistory: items,
    ),
  );
}
