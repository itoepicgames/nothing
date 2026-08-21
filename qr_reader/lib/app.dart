import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'l10n.dart';
import 'models/scan_item.dart';
import 'screens/home_screen.dart';
import 'services/history_service.dart';
import 'services/settings_service.dart';

class ScanovaApp extends StatefulWidget {
  const ScanovaApp({
    super.key,
    required this.settings,
    required this.historyService,
    required this.initialTheme,
    required this.initialLanguage,
    required this.initialHaptics,
    required this.initialHistory,
  });

  final SettingsService settings;
  final HistoryService historyService;
  final AppThemeMode initialTheme;
  final AppLanguage initialLanguage;
  final bool initialHaptics;
  final List<ScanItem> initialHistory;

  @override
  State<ScanovaApp> createState() => _ScanovaAppState();
}

class _ScanovaAppState extends State<ScanovaApp> {
  late AppThemeMode themeMode = widget.initialTheme;
  late AppLanguage language = widget.initialLanguage;
  late bool haptics = widget.initialHaptics;
  late List<ScanItem> history = List<ScanItem>.from(widget.initialHistory);

  T get t => T(language);

  Future<void> setTheme(AppThemeMode value) async {
    setState(() => themeMode = value);
    await widget.settings.saveTheme(value);
  }

  Future<void> setLanguage(AppLanguage value) async {
    setState(() => language = value);
    await widget.settings.saveLanguage(value);
  }

  Future<void> setHaptics(bool value) async {
    setState(() => haptics = value);
    await widget.settings.saveHaptics(value);
  }

  Future<void> addHistory(ScanItem item) async {
    final existing = history.indexWhere((entry) => entry.rawValue == item.rawValue);
    final updated = List<ScanItem>.from(history);
    if (existing >= 0) updated.removeAt(existing);
    updated.insert(0, item);
    if (updated.length > 200) updated.removeRange(200, updated.length);
    setState(() => history = updated);
    await widget.historyService.save(updated);
  }

  Future<void> deleteHistory(ScanItem item) async {
    final updated = history.where((entry) => entry.id != item.id).toList();
    setState(() => history = updated);
    await widget.historyService.save(updated);
  }

  Future<void> clearHistory() async {
    setState(() => history = []);
    await widget.historyService.save([]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: t.appName,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: switch (themeMode) {
        AppThemeMode.system => ThemeMode.system,
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.dark => ThemeMode.dark,
      },
      locale: Locale(language == AppLanguage.arabic ? 'ar' : 'en'),
      builder: (context, child) => Directionality(
        textDirection: language == AppLanguage.arabic ? TextDirection.rtl : TextDirection.ltr,
        child: child ?? const SizedBox.shrink(),
      ),
      home: HomeScreen(
        t: t,
        history: history,
        hapticsEnabled: haptics,
        themeMode: themeMode,
        language: language,
        onAddHistory: addHistory,
        onDeleteHistory: deleteHistory,
        onClearHistory: clearHistory,
        onThemeChanged: setTheme,
        onLanguageChanged: setLanguage,
        onHapticsChanged: setHaptics,
      ),
    );
  }
}
