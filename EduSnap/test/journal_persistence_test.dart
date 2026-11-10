import 'package:edusnap/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Add and delete survive a fresh app open', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(find.byType(Dismissible), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Mitosis');
    await tester.enterText(find.byType(TextFormField).at(1), 'Cells divide.');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Mitosis'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Leaf');
    await tester.enterText(find.byType(TextFormField).at(1), 'Green.');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    await tester.drag(find.text('Leaf').first, const Offset(-500, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(find.text('Leaf'), findsNothing);
    expect(find.text('Mitosis'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Mitosis'), findsOneWidget);
    expect(find.text('Cells divide.'), findsOneWidget);
    expect(find.text('Leaf'), findsNothing);
    expect(find.byType(Dismissible), findsOneWidget);
  });
}
