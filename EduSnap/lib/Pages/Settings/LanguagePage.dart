import 'package:edusnap/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../Locale/LocaleController.dart';
import '../../Locale/locale_labels.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeController = LocaleScope.of(context);
    return ListenableBuilder(
      listenable: localeController,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.language),
          ),
          body: ListView(
            children: [
              for (final locale in LocaleController.supported)
                ListTile(
                  title: Text(localeLabel(l10n, locale)),
                  trailing: localeController.locale == locale
                      ? const Icon(Icons.check)
                      : null,
                  onTap: () async {
                    await localeController.setLocale(locale);
                    if (context.mounted) Navigator.of(context).pop();
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
