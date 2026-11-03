import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:edusnap/main.dart';

void main() {
  testWidgets('List navigates to Detail, Add, and Settings', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(find.text('List'), findsWidgets);
    expect(find.text('Water cycle'), findsOneWidget);
    expect(find.text('Photosynthesis'), findsOneWidget);
    expect(find.text('2026-11-01'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Water cycle')).dy,
      lessThan(tester.getTopLeft(find.text('Photosynthesis')).dy),
    );

    await tester.tap(find.text('Water cycle'));
    await tester.pumpAndSettle();
    expect(find.text('Water cycle'), findsOneWidget);
    expect(find.text('2026-11-03'), findsOneWidget);
    expect(
      find.text('Evaporation, condensation, precipitation.'),
      findsOneWidget,
    );
    expect(
      tester.getTopRight(find.text('2026-11-03')).dx,
      greaterThan(tester.getCenter(find.text('Water cycle')).dx),
    );
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text('Fractions'), 200);
    expect(find.text('Fractions'), findsOneWidget);

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
    await tester.pump(const Duration(milliseconds: 300));
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
    await tester.pump(const Duration(milliseconds: 300));
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

    await tester.scrollUntilVisible(find.text('Mitosis'), 200);
    expect(find.text('Mitosis'), findsOneWidget);
    expect(find.text('Cells divide.'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Photosynthesis')).dy,
      lessThan(tester.getTopLeft(find.text('Mitosis')).dy),
    );
    await tester.scrollUntilVisible(find.text('Fractions'), 200);
    expect(
      tester.getTopLeft(find.text('Mitosis')).dy,
      lessThan(tester.getTopLeft(find.text('Fractions')).dy),
    );
  });

  testWidgets('Swipe left removes a journal entry', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

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
    expect(find.text('Photosynthesis'), findsOneWidget);
  });
}
