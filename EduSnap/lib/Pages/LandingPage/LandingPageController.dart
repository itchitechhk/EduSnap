import 'package:flutter/foundation.dart';

class LandingPageController extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> onGetStarted() async {
    _isLoading = true;
    notifyListeners();

    // TODO: navigate or bootstrap app flow
    await Future<void>.delayed(const Duration(milliseconds: 300));

    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
