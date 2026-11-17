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
    _controller.load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  TextStyle? _trailingStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );
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
        final versionValue = _controller.isLoadingPackageInfo
            ? l10n.emptyValue
            : (_controller.version ?? l10n.emptyValue);
        final buildValue = _controller.isLoadingPackageInfo
            ? l10n.emptyValue
            : (_controller.buildNumber ?? l10n.emptyValue);
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
                          style: _trailingStyle(context),
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
                    trailing: Text(
                      storageValue,
                      style: _trailingStyle(context),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.appVersion),
                    trailing: Text(
                      versionValue,
                      style: _trailingStyle(context),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.buildNumber),
                    trailing: Text(
                      buildValue,
                      style: _trailingStyle(context),
                    ),
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
