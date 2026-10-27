import 'package:flutter/foundation.dart';

class HomePageController extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    // TODO: fetch home data
    await Future<void>.delayed(const Duration(milliseconds: 300));

    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
