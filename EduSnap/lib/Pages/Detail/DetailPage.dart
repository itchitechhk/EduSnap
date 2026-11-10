import 'package:flutter/material.dart';

import '../../Models/JournalEntry.dart';
import '../Add/AddPage.dart';
import 'DetailPageController.dart';

String _formatDate(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.entry});

  final JournalEntry entry;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late final DetailPageController _controller;
  late JournalEntry _entry;

  @override
  void initState() {
    super.initState();
    _controller = DetailPageController();
    _entry = widget.entry;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _edit() async {
    final updated = await Navigator.of(context).push<JournalEntry>(
      MaterialPageRoute(builder: (_) => AddPage(entry: _entry)),
    );
    if (!mounted || updated == null) return;
    setState(() => _entry = updated);
  }

  void _close() => Navigator.of(context).pop(_entry);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            _close();
          },
          child: Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(_formatDate(_entry.createdAt)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _entry.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(_entry.note),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: _edit,
                      child: const Text('Edit'),
                    ),
                    TextButton(
                      onPressed: _close,
                      child: const Text('Back'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
