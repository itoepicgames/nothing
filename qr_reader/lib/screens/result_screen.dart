import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n.dart';
import '../models/scan_item.dart';
import '../services/qr_parser.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({
    super.key,
    required this.t,
    required this.item,
    required this.onSave,
    required this.onScanAgain,
    this.initiallySaved = false,
  });

  final T t;
  final ScanItem item;
  final Future<void> Function(ScanItem) onSave;
  final VoidCallback onScanAgain;
  final bool initiallySaved;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late bool _saved = widget.initiallySaved;
  bool _busy = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.item.rawValue));
    if (mounted) _message(widget.t.copied);
  }

  Future<void> _share() async {
    await SharePlus.instance.share(ShareParams(text: widget.item.rawValue));
  }

  Future<void> _open() async {
    final uri = Uri.tryParse(widget.item.rawValue.trim());
    if (uri == null || !QrParser.isUrl(widget.item.rawValue)) return;
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (mounted && ok) _message(widget.t.opened);
  }

  Future<void> _save() async {
    if (_busy || _saved) return;
    setState(() => _busy = true);
    await widget.onSave(widget.item);
    if (mounted) setState(() { _busy = false; _saved = true; });
  }

  void _message(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isUrl = QrParser.isUrl(widget.item.rawValue);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.t.result),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: scheme.primaryContainer,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.qr_code_2_rounded, color: scheme.onPrimaryContainer, size: 30),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(widget.item.type, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, color: scheme.onPrimaryContainer)),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  widget.item.rawValue,
                  style: theme.textTheme.bodyLarge?.copyWith(color: scheme.onPrimaryContainer, height: 1.45),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(child: _ActionTile(icon: Icons.copy_rounded, label: widget.t.copy, onTap: _copy)),
              const SizedBox(width: 10),
              Expanded(child: _ActionTile(icon: Icons.share_rounded, label: widget.t.share, onTap: _share)),
            ],
          ),
          if (isUrl) ...[
            const SizedBox(height: 10),
            SizedBox(
              height: 54,
              child: FilledButton.icon(
                onPressed: _open,
                icon: const Icon(Icons.open_in_new_rounded),
                label: Text(widget.t.open),
              ),
            ),
          ],
          const SizedBox(height: 10),
          SizedBox(
            height: 54,
            child: OutlinedButton.icon(
              onPressed: _busy ? null : _save,
              icon: Icon(_saved ? Icons.check_rounded : Icons.bookmark_add_outlined),
              label: Text(_saved ? widget.t.saved : widget.t.save),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 54,
            child: FilledButton.tonalIcon(
              onPressed: widget.onScanAgain,
              icon: const Icon(Icons.qr_code_scanner_rounded),
              label: Text(widget.t.scanAgain),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Column(
            children: [
              Icon(icon),
              const SizedBox(height: 7),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}
