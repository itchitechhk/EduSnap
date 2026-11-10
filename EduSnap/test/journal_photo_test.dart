import 'dart:typed_data';

import 'package:edusnap/Component/JournalCard/JournalCard.dart';
import 'package:edusnap/Models/JournalEntry.dart';
import 'package:edusnap/Pages/Detail/DetailPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'l10n_harness.dart';

void main() {
  final photoBytes = Uint8List.fromList(_png);

  testWidgets('Card and detail show a photo or a placeholder', (tester) async {
    final empty = JournalEntry(
      title: 'Leaf',
      note: 'Green',
      createdAt: DateTime(2026, 11, 1),
    );
    await tester.pumpWidget(
      l10nApp(home: Scaffold(body: JournalCard(entry: empty))),
    );
    expect(find.byIcon(Icons.image_outlined), findsOneWidget);
    expect(find.byType(Image), findsNothing);

    final withPhoto = JournalEntry(
      title: 'Leaf',
      note: 'Green',
      createdAt: DateTime(2026, 11, 1),
      imageBytes: photoBytes,
    );
    await tester.pumpWidget(
      l10nApp(home: Scaffold(body: JournalCard(entry: withPhoto))),
    );
    await tester.pump();
    expect(find.byType(Image), findsOneWidget);
    expect(
      tester.getCenter(find.byType(Image)).dx,
      lessThan(tester.getCenter(find.text('Leaf')).dx),
    );

    await tester.pumpWidget(
      l10nApp(home: DetailPage(key: UniqueKey(), entry: empty)),
    );
    expect(find.text('No photo'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Leaf')).dy,
      lessThan(tester.getTopLeft(find.text('No photo')).dy),
    );
    expect(
      tester.getTopLeft(find.text('No photo')).dy,
      lessThan(tester.getTopLeft(find.text('Green')).dy),
    );

    await tester.pumpWidget(
      l10nApp(home: DetailPage(key: UniqueKey(), entry: withPhoto)),
    );
    await tester.pump();
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('No photo'), findsNothing);
    expect(find.text('Green'), findsOneWidget);
  });

  testWidgets('Stored image data still shows without a file', (tester) async {
    await tester.pumpWidget(
      l10nApp(
        home: DetailPage(
          entry: JournalEntry(
            title: 'Leaf',
            note: 'Green',
            createdAt: DateTime(2026, 11, 1),
            imageBytes: photoBytes,
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('No photo'), findsNothing);
  });
}

const _png = <int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49,
  0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06,
  0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44,
  0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, 0x05, 0x00, 0x01, 0x0D,
  0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42,
  0x60, 0x82,
];
