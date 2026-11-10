import 'package:flutter/foundation.dart';

import '../../Utils/journal_storage.dart';

class SettingsPageController extends ChangeNotifier {
  int? _storageBytes;
  bool _isLoadingStorage = true;

  int? get storageBytes => _storageBytes;
  bool get isLoadingStorage => _isLoadingStorage;

  String get storageKbLabel {
    final bytes = _storageBytes;
    if (bytes == null) return '—';
    return formatStorageKb(bytes);
  }

  Future<void> loadStorageUsage() async {
    _isLoadingStorage = true;
    notifyListeners();
    try {
      _storageBytes = await calculateJournalStorageBytes();
    } finally {
      _isLoadingStorage = false;
      notifyListeners();
    }
  }
}
