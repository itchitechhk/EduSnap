import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

class JournalEntry {
  const JournalEntry({
    required this.title,
    required this.note,
    required this.createdAt,
    this.imageBytes,
  });

  final String title;
  final String note;
  final DateTime createdAt;
  final Uint8List? imageBytes;

  Map<String, Object?> toJson() {
    final bytes = imageBytes;
    return {
      'title': title,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
      'imageData': bytes == null ? null : base64Encode(bytes),
    };
  }

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      title: json['title'] as String,
      note: json['note'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      imageBytes: _readImageBytes(json),
    );
  }

  static Uint8List? _readImageBytes(Map<String, dynamic> json) {
    final data = json['imageData'] as String?;
    if (data != null && data.isNotEmpty) {
      return Uint8List.fromList(base64Decode(data));
    }

    // Migrate older entries that only stored a temporary file path.
    final path = (json['imagePath'] as String?)?.trim();
    if (path == null || path.isEmpty) return null;
    final file = File(path);
    if (!file.existsSync()) return null;
    return file.readAsBytesSync();
  }

  bool sameImageAs(Uint8List? other) => listEquals(imageBytes, other);
}
