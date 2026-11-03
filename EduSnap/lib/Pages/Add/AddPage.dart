import 'package:flutter/material.dart';

import '../../Models/JournalEntry.dart';
import 'AddPageController.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  late final AddPageController _controller;
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AddPageController();
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

  bool get _hasUnsavedData =>
      _titleController.text.trim().isNotEmpty ||
      _noteController.text.trim().isNotEmpty;

  Future<bool> _confirmLeave() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          content: const Text('Leave without saving?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Stay'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Leave'),
            ),
          ],
        );
      },
    );
    return leave ?? false;
  }

  void _save() {
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
                  'Title is missing',
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
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              title: const Text('Add'),
            ),
            body: SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _noteController,
                    decoration: const InputDecoration(labelText: 'Note'),
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _save,
                    child: const Text('Save'),
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
