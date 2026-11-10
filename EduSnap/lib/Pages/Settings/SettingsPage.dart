import 'package:edusnap/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../Locale/LocaleController.dart';
import '../../Locale/locale_labels.dart';
import 'LanguagePage.dart';
import 'SettingsPageController.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final SettingsPageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SettingsPageController();
    _controller.loadStorageUsage();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeController = LocaleScope.of(context);
    return ListenableBuilder(
      listenable: Listenable.merge([_controller, localeController]),
      builder: (context, _) {
        final storageValue = _controller.isLoadingStorage
            ? l10n.emptyValue
            : l10n.storageUsageValue(_controller.storageKbLabel);
        final storageTrailing = Text(
          storageValue,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        );
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.settings,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 32),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.language),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          localeLabel(l10n, localeController.locale),
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const LanguagePage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.storageUsage),
                    trailing: storageTrailing,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.back),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
