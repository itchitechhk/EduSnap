import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/JournalEntry.dart';
import '../../Utils/journal_storage.dart';

class HomePageController extends ChangeNotifier {

  bool _isLoading = false;
  final List<JournalEntry> entries = [];

  bool get isLoading => _isLoading;

  Future<void> add(JournalEntry entry) async {
    entries.add(entry);
    _sortByTitle();
    notifyListeners();
    await _save();
  }

  Future<void> remove(JournalEntry entry) async {
    entries.remove(entry);
    notifyListeners();
    await _save();
  }

  Future<void> update(JournalEntry current, JournalEntry updated) async {
    final index = entries.indexOf(current);
    if (index < 0) return;
    entries[index] = updated;
    _sortByTitle();
    notifyListeners();
    await _save();
  }

  void _sortByTitle() {
    entries.sort(
      (a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()),
    );
  }

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(journalEntriesKey);
    entries
      ..clear()
      ..addAll(raw == null ? const [] : _decode(raw));
    _sortByTitle();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      journalEntriesKey,
      jsonEncode(entries.map((entry) => entry.toJson()).toList()),
    );
  }

  List<JournalEntry> _decode(String raw) {
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map(
          (item) => JournalEntry.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }
}
