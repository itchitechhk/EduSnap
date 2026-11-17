import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../Utils/journal_storage.dart';

class SettingsPageController extends ChangeNotifier {
  int? _storageBytes;
  bool _isLoadingStorage = true;
  String? _version;
  String? _buildNumber;
  bool _isLoadingPackageInfo = true;

  int? get storageBytes => _storageBytes;
  bool get isLoadingStorage => _isLoadingStorage;
  String? get version => _version;
  String? get buildNumber => _buildNumber;
  bool get isLoadingPackageInfo => _isLoadingPackageInfo;

  String get storageKbLabel {
    final bytes = _storageBytes;
    if (bytes == null) return '—';
    return formatStorageKb(bytes);
  }

  Future<void> load() async {
    await Future.wait([
      loadStorageUsage(),
      loadPackageInfo(),
    ]);
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

  Future<void> loadPackageInfo() async {
    _isLoadingPackageInfo = true;
    notifyListeners();
    try {
      final info = await PackageInfo.fromPlatform();
      _version = info.version;
      _buildNumber = info.buildNumber;
    } catch (_) {
      _version = null;
      _buildNumber = null;
    } finally {
      _isLoadingPackageInfo = false;
      notifyListeners();
    }
  }
}
