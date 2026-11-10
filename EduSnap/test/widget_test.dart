import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:edusnap/main.dart';

Future<void> _addEntry(
  WidgetTester tester, {
  required String title,
  required String note,
}) async {
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextFormField).at(0), title);
  await tester.enterText(find.byType(TextFormField).at(1), note);
  await tester.tap(find.text('Save'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('List starts empty and opens Add and Settings', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('List'), findsWidgets);
    expect(find.byType(Dismissible), findsNothing);
    expect(find.text('No entries yet.\nTap + to add one.'), findsOneWidget);

    for (final target in [
      (icon: Icons.settings, name: 'Settings', back: find.text('Back')),
      (icon: Icons.add, name: 'Add', back: find.byIcon(Icons.arrow_back)),
    ]) {
      await tester.tap(find.byIcon(target.icon));
      await tester.pumpAndSettle();
      expect(find.text(target.name), findsWidgets);

      await tester.tap(target.back);
      await tester.pumpAndSettle();
      expect(find.text('List'), findsWidgets);
    }
  });

  testWidgets('Back asks before leaving unsaved text', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Draft');
    await tester.pump();
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('Leave without saving?'), findsOneWidget);

    await tester.tap(find.text('Stay'));
    await tester.pumpAndSettle();
    expect(find.text('Draft'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Leave'));
    await tester.pumpAndSettle();

    expect(find.text('List'), findsWidgets);
    expect(find.text('Draft'), findsNothing);
  });

  testWidgets('Save returns a new entry to the list', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 750));
    expect(find.text('Title is missing'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Mitosis');
    await tester.enterText(find.byType(TextFormField).at(1), 'Cells divide.');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Mitosis'), findsOneWidget);
    expect(find.text('Cells divide.'), findsOneWidget);

    await _addEntry(tester, title: 'Photosynthesis', note: 'Light to sugar.');
    expect(
      tester.getTopLeft(find.text('Photosynthesis')).dy,
      lessThan(tester.getTopLeft(find.text('Mitosis')).dy),
    );
  });

  testWidgets('Swipe left removes a journal entry', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await _addEntry(tester, title: 'Water cycle', note: 'Rain falls.');

    await tester.drag(find.byType(Dismissible).first, const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(find.text('Delete this entry?'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Water cycle'), findsOneWidget);

    await tester.drag(find.byType(Dismissible).first, const Offset(-500, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Water cycle'), findsNothing);
  });

  testWidgets('Edit updates Detail and the list', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await _addEntry(
      tester,
      title: 'Water cycle',
      note: 'Evaporation, condensation, precipitation.',
    );

    await tester.tap(find.text('Water cycle'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Created on'),
      findsOneWidget,
    );
    expect(
      tester.getTopRight(find.textContaining('Created on')).dx,
      greaterThan(tester.getCenter(find.text('Water cycle')).dx),
    );

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    expect(find.text('Water cycle'), findsOneWidget);
    expect(
      find.text('Evaporation, condensation, precipitation.'),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('Leave without saving?'), findsNothing);
    expect(find.text('Water cycle'), findsOneWidget);

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Atoms');
    await tester.enterText(find.byType(TextFormField).at(1), 'Smallest unit.');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Atoms'), findsOneWidget);
    expect(find.text('Smallest unit.'), findsOneWidget);
    expect(find.text('Water cycle'), findsNothing);

    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();

    expect(find.text('Atoms'), findsOneWidget);
    expect(find.text('Smallest unit.'), findsOneWidget);
    expect(find.text('Water cycle'), findsNothing);
  });
}
