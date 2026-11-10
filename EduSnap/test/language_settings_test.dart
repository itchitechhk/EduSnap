import 'package:edusnap/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Language page switches UI and survives relaunch', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(find.text('List'), findsWidgets);

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);

    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Chinese'));
    await tester.pumpAndSettle();

    expect(find.text('設定'), findsOneWidget);
    expect(find.text('語言'), findsOneWidget);
    expect(find.text('中文'), findsOneWidget);

    await tester.tap(find.text('返回'));
    await tester.pumpAndSettle();
    expect(find.text('清單'), findsWidgets);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(find.text('清單'), findsWidgets);
    expect(find.byTooltip('設定'), findsOneWidget);
    expect(find.text('List'), findsNothing);
  });

  testWidgets('Japanese page updates chrome', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Japanese'));
    await tester.pumpAndSettle();

    expect(find.text('設定'), findsOneWidget);
    expect(find.text('言語'), findsOneWidget);
    expect(find.text('日本語'), findsOneWidget);

    await tester.tap(find.text('戻る'));
    await tester.pumpAndSettle();
    expect(find.text('一覧'), findsOneWidget);
  });
}
