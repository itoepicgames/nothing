import 'package:flutter/material.dart';

import '../l10n.dart';
import '../models/scan_item.dart';
import '../services/settings_service.dart';
import '../widgets/brand_mark.dart';
import '../widgets/primary_button.dart';
import 'result_screen.dart';
import 'scanner_screen.dart';
import 'settings_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.t,
    required this.history,
    required this.hapticsEnabled,
    required this.themeMode,
    required this.language,
    required this.onAddHistory,
    required this.onDeleteHistory,
    required this.onClearHistory,
    required this.onThemeChanged,
    required this.onLanguageChanged,
    required this.onHapticsChanged,
  });

  final T t;
  final List<ScanItem> history;
  final bool hapticsEnabled;
  final AppThemeMode themeMode;
  final AppLanguage language;
  final Future<void> Function(ScanItem) onAddHistory;
  final Future<void> Function(ScanItem) onDeleteHistory;
  final Future<void> Function() onClearHistory;
  final Future<void> Function(AppThemeMode) onThemeChanged;
  final Future<void> Function(AppLanguage) onLanguageChanged;
  final Future<void> Function(bool) onHapticsChanged;

  Future<void> _scan(BuildContext context) async {
    final result = await Navigator.of(context).push<ScanItem>(
      MaterialPageRoute(
        builder: (_) => ScannerScreen(t: t, hapticsEnabled: hapticsEnabled),
      ),
    );
    if (result == null || !context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          t: t,
          item: result,
          onSave: onAddHistory,
          onScanAgain: () => _scan(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final recent = history.take(3).toList();
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    const BrandMark(),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.appName, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 2),
                          Text(t.tagline, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: t.history,
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => HistoryScreen(
                          t: t,
                          history: history,
                          onDelete: onDeleteHistory,
                          onClear: onClearHistory,
                        ),
                      )),
                      icon: const Icon(Icons.history_rounded),
                    ),
                    IconButton(
                      tooltip: t.settings,
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => SettingsScreen(
                          t: t,
                          themeMode: themeMode,
                          language: language,
                          hapticsEnabled: hapticsEnabled,
                          onThemeChanged: onThemeChanged,
                          onLanguageChanged: onLanguageChanged,
                          onHapticsChanged: onHapticsChanged,
                        ),
                      )),
                      icon: const Icon(Icons.settings_outlined),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(22, 34, 22, 0),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: [scheme.primary.withValues(alpha: .14), scheme.tertiary.withValues(alpha: .08)],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.scanQr, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      Text(t.pointCamera, style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                      const SizedBox(height: 20),
                      PrimaryButton(label: t.scanQr, icon: Icons.qr_code_scanner_rounded, onPressed: () => _scan(context)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => HistoryScreen(t: t, history: history, onDelete: onDeleteHistory, onClear: onClearHistory),
                              )),
                              icon: const Icon(Icons.history_rounded),
                              label: Text(t.history),
                              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => SettingsScreen(
                                  t: t, themeMode: themeMode, language: language, hapticsEnabled: hapticsEnabled,
                                  onThemeChanged: onThemeChanged, onLanguageChanged: onLanguageChanged, onHapticsChanged: onHapticsChanged,
                                ),
                              )),
                              icon: const Icon(Icons.settings_outlined),
                              label: Text(t.settings),
                              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(22, 28, 22, 12),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(child: Text(t.recentScans, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800))),
                    if (history.isNotEmpty)
                      TextButton.icon(
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => HistoryScreen(
                            t: t,
                            history: history,
                            onDelete: onDeleteHistory,
                            onClear: onClearHistory,
                          ),
                        )),
                        icon: const Icon(Icons.history_rounded, size: 18),
                        label: Text(t.history),
                      ),
                  ],
                ),
              ),
            ),
            if (recent.isEmpty)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                sliver: SliverToBoxAdapter(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(26),
                      child: Column(
                        children: [
                          Icon(Icons.qr_code_2_rounded, size: 42, color: scheme.primary),
                          const SizedBox(height: 12),
                          Text(t.noScans, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text(t.startScanning, textAlign: TextAlign.center, style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                sliver: SliverList.builder(
                  itemCount: recent.length,
                  itemBuilder: (context, index) {
                    final item = recent[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        child: ListTile(
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ResultScreen(t: t, item: item, onSave: onAddHistory, onScanAgain: () => _scan(context)),
                          )),
                          leading: CircleAvatar(
                            backgroundColor: scheme.primaryContainer,
                            foregroundColor: scheme.onPrimaryContainer,
                            child: const Icon(Icons.qr_code_2_rounded),
                          ),
                          title: Text(item.type, style: const TextStyle(fontWeight: FontWeight.w700)),
                          subtitle: Text(item.rawValue, maxLines: 1, overflow: TextOverflow.ellipsis),
                          trailing: const Icon(Icons.chevron_right_rounded),
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}
