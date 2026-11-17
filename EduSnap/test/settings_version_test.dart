import 'package:edusnap/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    PackageInfo.setMockInitialValues(
      appName: 'edusnap',
      packageName: 'com.edusnap.edusnap',
      version: '1.1.0',
      buildNumber: '2',
      buildSignature: '',
    );
  });

  testWidgets('Settings shows version and build number', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    expect(find.text('Version'), findsOneWidget);
    expect(find.text('1.1.0'), findsOneWidget);
    expect(find.text('Build'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
  });
}
