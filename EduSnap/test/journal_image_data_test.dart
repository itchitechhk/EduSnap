import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:edusnap/Models/JournalEntry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('round-trips image bytes through JSON', () {
    final bytes = Uint8List.fromList([1, 2, 3, 4]);
    final entry = JournalEntry(
      title: 'Leaf',
      note: 'Green',
      createdAt: DateTime(2026, 11, 1),
      imageBytes: bytes,
    );

    final restored = JournalEntry.fromJson(entry.toJson());
    expect(restored.imageBytes, bytes);
    expect(restored.toJson()['imagePath'], isNull);
    expect(restored.toJson()['imageData'], base64Encode(bytes));
  });

  test('migrates legacy imagePath into image bytes', () {
    final file = File('${Directory.systemTemp.path}/edusnap-legacy.png')
      ..writeAsBytesSync(const [9, 8, 7]);
    addTearDown(() {
      if (file.existsSync()) file.deleteSync();
    });

    final restored = JournalEntry.fromJson({
      'title': 'Leaf',
      'note': 'Green',
      'createdAt': '2026-11-01T00:00:00.000',
      'imagePath': file.path,
    });

    expect(restored.imageBytes, Uint8List.fromList(const [9, 8, 7]));
  });
}
