import 'dart:typed_data';

import 'package:edusnap/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Models/JournalEntry.dart';
import 'AddPageController.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key, this.entry});

  final JournalEntry? entry;

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  late final AddPageController _controller;
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  Uint8List? _imageBytes;
  bool _picking = false;

  @override
  void initState() {
    super.initState();
    _controller = AddPageController();
    final entry = widget.entry;
    if (entry != null) {
      _titleController.text = entry.title;
      _noteController.text = entry.note;
      _imageBytes = entry.imageBytes;
    }
    _titleController.addListener(_onFieldChanged);
    _noteController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _titleController.removeListener(_onFieldChanged);
    _noteController.removeListener(_onFieldChanged);
    _titleController.dispose();
    _noteController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    setState(() {});
  }

  bool get _hasUnsavedData {
    final title = _titleController.text.trim();
    final note = _noteController.text.trim();
    final imageBytes = _imageBytes;
    final entry = widget.entry;
    if (entry == null) {
      return title.isNotEmpty || note.isNotEmpty || imageBytes != null;
    }
    return title != entry.title ||
        note != entry.note ||
        !entry.sameImageAs(imageBytes);
  }

  Future<bool> _confirmLeave() async {
    final l10n = AppLocalizations.of(context)!;
    final leave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          content: Text(l10n.leaveWithoutSaving),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.stay),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l10n.leave),
            ),
          ],
        );
      },
    );
    return leave ?? false;
  }

  Future<void> _pickPhoto() async {
    if (_picking) return;
    _picking = true;
    try {
      final l10n = AppLocalizations.of(context)!;
      final source = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (sheetContext) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: Text(l10n.gallery),
                  onTap: () => Navigator.pop(sheetContext, ImageSource.gallery),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera_outlined),
                  title: Text(l10n.camera),
                  onTap: () => Navigator.pop(sheetContext, ImageSource.camera),
                ),
              ],
            ),
          );
        },
      );
      if (source == null || !mounted) return;

      final allowed = await _allow(source);
      if (!allowed || !mounted) return;

      final XFile? file;
      try {
        file = await ImagePicker().pickImage(
          source: source,
          maxWidth: 1600,
          imageQuality: 85,
        );
      } catch (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.couldNotOpenPhotoPicker)),
        );
        return;
      }
      if (file == null || !mounted) return;
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      setState(() => _imageBytes = Uint8List.fromList(bytes));
    } finally {
      _picking = false;
    }
  }

  Future<bool> _allow(ImageSource source) async {
    // Android 12 and below only grants storage; photos is denied with no dialog.
    final permissions = source == ImageSource.camera
        ? <Permission>[Permission.camera]
        : <Permission>[
            Permission.photos,
            if (defaultTargetPlatform == TargetPlatform.android)
              Permission.storage,
          ];
    for (final permission in permissions) {
      if (await _grant(permission)) return true;
    }
    if (mounted) await _explainDenied(source);
    return false;
  }

  Future<bool> _grant(Permission permission) async {
    var status = await permission.status;
    if (status.isGranted || status.isLimited) return true;
    if (status.isPermanentlyDenied || status.isRestricted) return false;
    status = await permission.request();
    return status.isGranted || status.isLimited;
  }

  Future<void> _explainDenied(ImageSource source) async {
    final l10n = AppLocalizations.of(context)!;
    final open = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          content: Text(
            source == ImageSource.camera
                ? l10n.cameraAccessNeeded
                : l10n.photoLibraryAccessNeeded,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.notNow),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l10n.openSettings),
            ),
          ],
        );
      },
    );
    if (open ?? false) await openAppSettings();
  }

  void _save() {
    final l10n = AppLocalizations.of(context)!;
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      final colorScheme = Theme.of(context).colorScheme;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: colorScheme.error,
            content: Row(
              children: [
                Icon(Icons.error_outline, color: colorScheme.onError),
                const SizedBox(width: 12),
                Text(
                  l10n.titleMissing,
                  style: TextStyle(color: colorScheme.onError),
                ),
              ],
            ),
          ),
        );
      return;
    }

    Navigator.pop(
      context,
      JournalEntry(
        title: title,
        note: _noteController.text.trim(),
        createdAt: widget.entry?.createdAt ?? DateTime.now(),
        imageBytes: _imageBytes,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final imageBytes = _imageBytes;
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return PopScope(
          canPop: !_hasUnsavedData,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            final leave = await _confirmLeave();
            if (leave && context.mounted) Navigator.pop(context);
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(widget.entry == null ? l10n.add : l10n.edit),
            ),
            body: SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: l10n.title),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _noteController,
                    decoration: InputDecoration(labelText: l10n.note),
                    textInputAction: TextInputAction.done,
                  ),
                  if (imageBytes != null) ...[
                    const SizedBox(height: 16),
                    Semantics(
                      label: l10n.selectedPhoto,
                      image: true,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          imageBytes,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          gaplessPlayback: true,
                          excludeFromSemantics: true,
                          errorBuilder: (context, error, stackTrace) {
                            return SizedBox(
                              height: 180,
                              child: Center(child: Text(l10n.noPhoto)),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: _pickPhoto,
                    child: Text(
                      imageBytes == null ? l10n.addPhoto : l10n.changePhoto,
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _save,
                    child: Text(l10n.save),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
