import 'package:flutter/foundation.dart';

import '../../Models/JournalEntry.dart';

class HomePageController extends ChangeNotifier {
  bool _isLoading = false;

  final List<JournalEntry> entries = [
    JournalEntry(
      title: 'Photosynthesis',
      note: 'Plants turn light into sugar.',
      createdAt: DateTime(2026, 11, 1),
    ),
    JournalEntry(
      title: 'Fractions',
      note: 'A half plus a quarter is three quarters.',
      createdAt: DateTime(2026, 11, 2),
    ),
    JournalEntry(
      title: 'Water cycle',
      note: 'Evaporation, condensation, precipitation.',
      createdAt: DateTime(2026, 11, 3),
    ),
  ];

  bool get isLoading => _isLoading;

  void add(JournalEntry entry) {
    entries.add(entry);
    _sortByTitle();
    notifyListeners();
  }

  void remove(JournalEntry entry) {
    entries.remove(entry);
    notifyListeners();
  }

  void update(JournalEntry current, JournalEntry updated) {
    final index = entries.indexOf(current);
    if (index < 0) return;
    entries[index] = updated;
    _sortByTitle();
    notifyListeners();
  }

  void _sortByTitle() {
    entries.sort(
      (a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()),
    );
  }

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    // TODO: fetch home data
    await Future<void>.delayed(const Duration(milliseconds: 300));

    _sortByTitle();
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
