import 'package:edusnap/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'Locale/LocaleController.dart';
import 'Pages/HomePage/HomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _localeController = LocaleController();

  @override
  void initState() {
    super.initState();
    _localeController.load();
  }

  @override
  void dispose() {
    _localeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LocaleScope(
      controller: _localeController,
      child: ListenableBuilder(
        listenable: _localeController,
        builder: (context, _) {
          return MaterialApp(
            onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
            debugShowCheckedModeBanner: false,
            locale: _localeController.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
