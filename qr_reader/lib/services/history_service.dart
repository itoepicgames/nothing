import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/scan_item.dart';

class HistoryService {
  static const _key = 'scan_history_v1';
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  Future<List<ScanItem>> load() async {
    final value = await _prefs.getString(_key);
    if (value == null || value.isEmpty) return <ScanItem>[];
    try {
      final decoded = jsonDecode(value) as List<dynamic>;
      return decoded
          .map((item) => ScanItem.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    } catch (_) {
      return <ScanItem>[];
    }
  }

  Future<void> save(List<ScanItem> items) async {
    await _prefs.setString(
      _key,
      jsonEncode(items.map((item) => item.toJson()).toList()),
    );
  }
}
