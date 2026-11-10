import 'package:edusnap/Pages/HomePage/HomePage.dart';
import 'package:edusnap/Pages/LandingPage/LandingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n_harness.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('zh_TW shows Traditional Chinese UI', (tester) async {
    await tester.pumpWidget(
      l10nApp(
        locale: const Locale('zh', 'TW'),
        home: const LandingPage(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('EduSnap'), findsOneWidget);
    expect(find.text('拍攝。學習。記住。'), findsOneWidget);
    expect(find.text('開始使用'), findsOneWidget);

    await tester.pumpWidget(
      l10nApp(
        locale: const Locale('zh', 'TW'),
        home: const HomePage(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('清單'), findsWidgets);
    expect(find.text('設定'), findsNothing);
    expect(find.byTooltip('設定'), findsOneWidget);
    expect(find.byTooltip('新增'), findsOneWidget);
  });
}
