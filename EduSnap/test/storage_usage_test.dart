import 'dart:convert';

import 'package:edusnap/Utils/journal_storage.dart';
import 'package:edusnap/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('counts journal JSON including embedded image data', () async {
    final json = jsonEncode([
      {
        'title': 'Leaf',
        'note': 'Green',
        'createdAt': '2026-11-01T00:00:00.000',
        'imageData': base64Encode(List<int>.filled(2048, 1)),
      },
    ]);
    SharedPreferences.setMockInitialValues({journalEntriesKey: json});

    final bytes = await calculateJournalStorageBytes();
    expect(bytes, utf8.encode(json).length);
    expect(formatStorageKb(bytes), isNot(equals('0.0')));
  });

  testWidgets('Settings shows storage usage in KB', (tester) async {
    final json = jsonEncode([
      {
        'title': 'Leaf',
        'note': 'Green',
        'createdAt': '2026-11-01T00:00:00.000',
        'imageData': base64Encode(List<int>.filled(2048, 1)),
      },
    ]);
    SharedPreferences.setMockInitialValues({journalEntriesKey: json});

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    final bytes = await tester.runAsync(calculateJournalStorageBytes);
    expect(bytes, utf8.encode(json).length);

    for (var i = 0; i < 20; i++) {
      if (find.text('${formatStorageKb(bytes!)} KB').evaluate().isNotEmpty) {
        break;
      }
      await tester.pump(const Duration(milliseconds: 20));
    }

    expect(find.text('Storage usage'), findsOneWidget);
    expect(find.text('${formatStorageKb(bytes!)} KB'), findsOneWidget);
  });
}
