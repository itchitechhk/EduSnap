import 'dart:io';
import 'dart:typed_data';

import 'package:edusnap/Models/JournalEntry.dart';
import 'package:edusnap/Pages/Add/AddPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

import 'l10n_harness.dart';

void main() {
  final permissions = _FakePermissions();
  final picker = _FakePicker();
  late PermissionHandlerPlatform previousPermissions;
  late ImagePickerPlatform previousPicker;
  late File photo;

  setUp(() {
    previousPermissions = PermissionHandlerPlatform.instance;
    previousPicker = ImagePickerPlatform.instance;
    permissions.statuses.clear();
    permissions.settingsOpens = 0;
    picker.source = null;
    photo = File('${Directory.systemTemp.path}/edusnap-photo.png')
      ..writeAsBytesSync(_png);
    picker.bytes = Uint8List.fromList(_png);
    PermissionHandlerPlatform.instance = permissions;
    ImagePickerPlatform.instance = picker;
  });

  tearDown(() {
    PermissionHandlerPlatform.instance = previousPermissions;
    ImagePickerPlatform.instance = previousPicker;
    if (photo.existsSync()) photo.deleteSync();
  });

  testWidgets('Denied camera explains and opens settings', (tester) async {
    permissions.statuses[Permission.camera] = PermissionStatus.denied;
    await _openAdd(tester);

    await tester.tap(find.text('Add photo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Camera'));
    await tester.pumpAndSettle();

    expect(find.text('Camera access is needed to take a photo.'), findsOneWidget);
    await tester.tap(find.text('Open settings'));
    await tester.pumpAndSettle();
    expect(permissions.settingsOpens, 1);
    expect(picker.source, isNull);
  });

  testWidgets('Gallery uses storage when photos is denied', (tester) async {
    permissions.statuses[Permission.photos] = PermissionStatus.denied;
    permissions.statuses[Permission.storage] = PermissionStatus.granted;
    final saved = await _openAdd(tester);

    await tester.tap(find.text('Add photo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Gallery'));
    await tester.pumpAndSettle();

    expect(picker.source, ImageSource.gallery);
    expect(find.bySemanticsLabel('Selected photo'), findsOneWidget);
    expect(find.text('Change photo'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('Leave without saving?'), findsOneWidget);
    await tester.tap(find.text('Stay'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Leaf');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(saved.value?.imageBytes, Uint8List.fromList(_png));
    expect(saved.value?.title, 'Leaf');
  });

  testWidgets('Edit shows the stored photo', (tester) async {
    await tester.pumpWidget(
      l10nApp(
        home: AddPage(
          entry: JournalEntry(
            title: 'Leaf',
            note: 'Green',
            createdAt: DateTime(2026, 11, 1),
            imageBytes: Uint8List.fromList(_png),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Change photo'), findsOneWidget);
    expect(find.bySemanticsLabel('Selected photo'), findsOneWidget);
  });
}

Future<ValueNotifier<JournalEntry?>> _openAdd(WidgetTester tester) async {
  final saved = ValueNotifier<JournalEntry?>(null);
  await tester.pumpWidget(
    l10nApp(
      home: Builder(
        builder: (context) {
          return Scaffold(
            body: TextButton(
              onPressed: () async {
                saved.value = await Navigator.of(context).push<JournalEntry>(
                  MaterialPageRoute(builder: (_) => const AddPage()),
                );
              },
              child: const Text('Open'),
            ),
          );
        },
      ),
    ),
  );
  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
  return saved;
}

class _FakePermissions extends PermissionHandlerPlatform {
  final statuses = <Permission, PermissionStatus>{};
  int settingsOpens = 0;

  PermissionStatus _status(Permission permission) {
    return statuses[permission] ?? PermissionStatus.denied;
  }

  @override
  Future<PermissionStatus> checkPermissionStatus(Permission permission) async {
    return _status(permission);
  }

  @override
  Future<Map<Permission, PermissionStatus>> requestPermissions(
    List<Permission> permissions,
  ) async {
    return {for (final permission in permissions) permission: _status(permission)};
  }

  @override
  Future<bool> openAppSettings() async {
    settingsOpens += 1;
    return true;
  }
}

class _FakePicker extends ImagePickerPlatform {
  Uint8List bytes = Uint8List(0);
  ImageSource? source;

  @override
  Future<XFile?> getImageFromSource({
    required ImageSource source,
    ImagePickerOptions options = const ImagePickerOptions(),
  }) async {
    this.source = source;
    return XFile.fromData(bytes, name: 'photo.png', mimeType: 'image/png');
  }
}

const _png = <int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49,
  0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06,
  0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44,
  0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, 0x05, 0x00, 0x01, 0x0D,
  0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42,
  0x60, 0x82,
];
