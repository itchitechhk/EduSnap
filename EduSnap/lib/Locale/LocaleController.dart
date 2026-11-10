import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends ChangeNotifier {
  static const _storageKey = 'app_locale';

  static const english = Locale('en');
  static const chinese = Locale('zh', 'TW');
  static const japanese = Locale('ja');

  static const supported = <Locale>[english, chinese, japanese];

  Locale _locale = english;

  Locale get locale => _locale;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _locale = fromCode(prefs.getString(_storageKey)) ?? english;
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, toCode(locale));
  }

  static String toCode(Locale locale) {
    return switch (locale.languageCode) {
      'zh' => 'zh_TW',
      'ja' => 'ja',
      _ => 'en',
    };
  }

  static Locale? fromCode(String? code) {
    return switch (code) {
      'zh_TW' || 'zh' => chinese,
      'ja' => japanese,
      'en' => english,
      _ => null,
    };
  }
}

class LocaleScope extends InheritedNotifier<LocaleController> {
  const LocaleScope({
    super.key,
    required LocaleController controller,
    required super.child,
  }) : super(notifier: controller);

  static LocaleController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LocaleScope>();
    assert(scope != null, 'LocaleScope not found');
    return scope!.notifier!;
  }
}
