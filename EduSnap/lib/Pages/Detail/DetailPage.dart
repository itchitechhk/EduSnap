import 'package:edusnap/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../Component/JournalPhoto/JournalPhoto.dart';
import '../../Duo/DuoLayoutController.dart';
import '../../Models/JournalEntry.dart';
import '../../Utils/journal_date.dart';
import '../Add/AddPage.dart';
import 'DetailPageController.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({
    super.key,
    required this.entry,
    this.embedded = false,
    this.onEntryUpdated,
    this.onClose,
  });

  final JournalEntry entry;
  final bool embedded;
  final ValueChanged<JournalEntry>? onEntryUpdated;
  final VoidCallback? onClose;

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
  void didUpdateWidget(covariant DetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entry != widget.entry) {
      _entry = widget.entry;
    }
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
    widget.onEntryUpdated?.call(updated);
  }

  void _close() {
    if (widget.embedded) {
      widget.onClose?.call();
      return;
    }
    Navigator.of(context).pop(_entry);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final duo = DuoScope.maybeOf(context);
    final hideFlutterBack = duo?.isSideBackActive ?? false;

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return PopScope(
          canPop: widget.embedded,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            _close();
          },
          child: Scaffold(
            appBar: widget.embedded
                ? AppBar(
                    automaticallyImplyLeading: false,
                    title: Text(_entry.title),
                    actions: [
                      if (!hideFlutterBack)
                        IconButton(
                          onPressed: _close,
                          icon: const Icon(Icons.close),
                          tooltip: l10n.back,
                        ),
                    ],
                  )
                : null,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        l10n.createdOn(formatJournalDate(_entry.createdAt)),
                      ),
                    ),
                    if (!widget.embedded) ...[
                      const SizedBox(height: 8),
                      Text(
                        _entry.title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                    const SizedBox(height: 16),
                    JournalPhoto(bytes: _entry.imageBytes, showLabel: true),
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
                      child: Text(l10n.edit),
                    ),
                    if (!widget.embedded && !hideFlutterBack)
                      TextButton(
                        onPressed: _close,
                        child: Text(l10n.back),
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
