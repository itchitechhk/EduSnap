import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

const journalEntriesKey = 'journal_entries';

/// Bytes used by saved journal JSON, including embedded image data.
Future<int> calculateJournalStorageBytes() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString(journalEntriesKey) ?? '[]';
  return utf8.encode(raw).length;
}

String formatStorageKb(int bytes) {
  return (bytes / 1024).toStringAsFixed(1);
}
