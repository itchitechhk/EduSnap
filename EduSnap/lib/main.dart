import 'package:edusnap/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'Duo/DuoLayoutController.dart';
import 'Locale/LocaleController.dart';
import 'Pages/HomePage/HomePage.dart';
import 'Theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _localeController = LocaleController();
  final _duoController = DuoLayoutController();

  @override
  void initState() {
    super.initState();
    _localeController.load();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _duoController.start();
    });
  }

  @override
  void dispose() {
    _duoController.dispose();
    _localeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LocaleScope(
      controller: _localeController,
      child: DuoScope(
        controller: _duoController,
        child: ListenableBuilder(
          listenable: Listenable.merge([_localeController, _duoController]),
          builder: (context, _) {
            return MaterialApp(
              navigatorKey: _duoController.navigatorKey,
              onGenerateTitle: (context) =>
                  AppLocalizations.of(context)!.appName,
              debugShowCheckedModeBanner: false,
              locale: _localeController.locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: buildAppTheme(),
              home: const HomePage(),
            );
          },
        ),
      ),
    );
  }
}
