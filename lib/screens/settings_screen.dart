import 'package:flutter/material.dart';

import '../l10n.dart';
import '../services/settings_service.dart';
import '../widgets/brand_mark.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.t,
    required this.themeMode,
    required this.language,
    required this.hapticsEnabled,
    required this.onThemeChanged,
    required this.onLanguageChanged,
    required this.onHapticsChanged,
  });

  final T t;
  final AppThemeMode themeMode;
  final AppLanguage language;
  final bool hapticsEnabled;
  final Future<void> Function(AppThemeMode) onThemeChanged;
  final Future<void> Function(AppLanguage) onLanguageChanged;
  final Future<void> Function(bool) onHapticsChanged;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late AppThemeMode _theme = widget.themeMode;
  late AppLanguage _language = widget.language;
  late bool _haptics = widget.hapticsEnabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = T(_language);
    return Scaffold(
      appBar: AppBar(title: Text(t.settings)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        children: [
          const Center(child: BrandMark(size: 72)),
          const SizedBox(height: 12),
          Center(child: Text(t.appName, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800))),
          const SizedBox(height: 28),
          _SectionTitle(t.appearance),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.brightness_6_outlined),
                  title: Text(t.theme),
                  subtitle: Text(_themeLabel(t)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _chooseTheme(context, t),
                ),
                const Divider(height: 1, indent: 72),
                ListTile(
                  leading: const Icon(Icons.language_rounded),
                  title: Text(t.language),
                  subtitle: Text(_language == AppLanguage.arabic ? t.arabic : t.english),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _chooseLanguage(context),
                ),
                const Divider(height: 1, indent: 72),
                SwitchListTile.adaptive(
                  secondary: const Icon(Icons.vibration_rounded),
                  title: Text(t.haptics),
                  subtitle: Text(t.hapticsSubtitle),
                  value: _haptics,
                  onChanged: (value) async {
                    setState(() => _haptics = value);
                    await widget.onHapticsChanged(value);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _SectionTitle(t.about),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: Text(t.version),
                  trailing: const Text('1.0.0'),
                ),
                const Divider(height: 1, indent: 72),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: Text(t.privacy),
                  subtitle: Text(t.privacyBody),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _themeLabel(T t) => switch (_theme) {
        AppThemeMode.system => t.system,
        AppThemeMode.light => t.light,
        AppThemeMode.dark => t.dark,
      };

  Future<void> _chooseTheme(BuildContext context, T t) async {
    final selected = await showModalBottomSheet<AppThemeMode>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(value: AppThemeMode.system, groupValue: _theme, onChanged: (v) => Navigator.pop(context, v), title: Text(t.system)),
            RadioListTile(value: AppThemeMode.light, groupValue: _theme, onChanged: (v) => Navigator.pop(context, v), title: Text(t.light)),
            RadioListTile(value: AppThemeMode.dark, groupValue: _theme, onChanged: (v) => Navigator.pop(context, v), title: Text(t.dark)),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
    if (selected == null) return;
    setState(() => _theme = selected);
    await widget.onThemeChanged(selected);
  }

  Future<void> _chooseLanguage(BuildContext context) async {
    final selected = await showModalBottomSheet<AppLanguage>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(value: AppLanguage.english, groupValue: _language, onChanged: (v) => Navigator.pop(context, v), title: const Text('English')),
            RadioListTile(value: AppLanguage.arabic, groupValue: _language, onChanged: (v) => Navigator.pop(context, v), title: const Text('العربية')),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
    if (selected == null) return;
    setState(() => _language = selected);
    await widget.onLanguageChanged(selected);
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(6, 0, 6, 10),
        child: Text(title, style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800)),
      );
}
