import 'package:flutter/material.dart';

import '../l10n.dart';
import '../models/scan_item.dart';
import 'result_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({
    super.key,
    required this.t,
    required this.history,
    required this.onDelete,
    required this.onClear,
  });

  final T t;
  final List<ScanItem> history;
  final Future<void> Function(ScanItem) onDelete;
  final Future<void> Function() onClear;

  Future<void> _confirmClear(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.clearHistoryQuestion),
        content: Text(t.clearHistoryBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(t.cancel)),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(t.confirm)),
        ],
      ),
    );
    if (confirmed == true) await onClear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.history),
        actions: [
          if (history.isNotEmpty)
            IconButton(
              tooltip: t.clearAll,
              onPressed: () => _confirmClear(context),
              icon: const Icon(Icons.delete_sweep_outlined),
            ),
        ],
      ),
      body: history.isEmpty
          ? Center(child: Text(t.noScans, style: theme.textTheme.titleMedium))
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
              itemCount: history.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = history[index];
                return Dismissible(
                  key: ValueKey(item.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: AlignmentDirectional.centerEnd,
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Icon(Icons.delete_outline, color: theme.colorScheme.onErrorContainer),
                  ),
                  onDismissed: (_) => onDelete(item),
                  child: Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.secondaryContainer,
                        foregroundColor: theme.colorScheme.onSecondaryContainer,
                        child: const Icon(Icons.qr_code_2_rounded),
                      ),
                      title: Text(item.type, style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('${_format(item.createdAt)}\n${item.rawValue}', maxLines: 2, overflow: TextOverflow.ellipsis),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => ResultScreen(
                          t: t,
                          item: item,
                          onSave: (_) async {},
                          initiallySaved: true,
                          onScanAgain: () => Navigator.of(context).pop(),
                        ),
                      )),
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _format(DateTime value) {
    final local = value.toLocal();
    final mm = local.month.toString().padLeft(2, '0');
    final dd = local.day.toString().padLeft(2, '0');
    final hh = local.hour.toString().padLeft(2, '0');
    final min = local.minute.toString().padLeft(2, '0');
    return '${local.year}-$mm-$dd  $hh:$min';
  }
}
