import 'package:edusnap/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

String localeLabel(AppLocalizations l10n, Locale locale) {
  return switch (locale.languageCode) {
    'zh' => l10n.chinese,
    'ja' => l10n.japanese,
    _ => l10n.english,
  };
}
