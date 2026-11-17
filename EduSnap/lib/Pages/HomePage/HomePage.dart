import 'package:edusnap/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../Component/JournalCard/JournalCard.dart';
import '../../Duo/DuoLayoutController.dart';
import '../../Models/JournalEntry.dart';
import '../Add/AddPage.dart';
import '../Detail/DetailPage.dart';
import '../Settings/SettingsPage.dart';
import 'HomePageController.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomePageController _controller;
  JournalEntry? _selected;

  @override
  void initState() {
    super.initState();
    _controller = HomePageController();
    _controller.load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _open(Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  Future<bool> _confirmDelete() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          content: Text(l10n.deleteThisEntry),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );
    return confirmed ?? false;
  }

  Future<void> _openAdd() async {
    final entry = await Navigator.of(context).push<JournalEntry>(
      MaterialPageRoute(builder: (_) => const AddPage()),
    );
    if (entry != null) {
      await _controller.add(entry);
      if (mounted) setState(() => _selected = entry);
    }
  }

  Future<void> _openDetail(JournalEntry entry) async {
    final duo = DuoScope.maybeOf(context);
    if (duo?.useFullScreenLayout ?? false) {
      setState(() => _selected = entry);
      return;
    }

    final updated = await Navigator.of(context).push<JournalEntry>(
      MaterialPageRoute(builder: (_) => DetailPage(entry: entry)),
    );
    if (updated != null) await _controller.update(entry, updated);
  }

  Future<void> _onEmbeddedUpdated(
    JournalEntry previous,
    JournalEntry updated,
  ) async {
    await _controller.update(previous, updated);
    if (mounted) setState(() => _selected = updated);
  }

  Widget _listBody(AppLocalizations l10n) {
    if (_controller.entries.isEmpty) {
      return Center(
        child: Text(
          l10n.emptyListHint,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _controller.entries.length,
      itemBuilder: (context, index) {
        final entry = _controller.entries[index];
        final colorScheme = Theme.of(context).colorScheme;
        final current = _resolvedSelection();
        final selected = identical(current, entry) ||
            (current != null &&
                current.createdAt == entry.createdAt &&
                current.title == entry.title);
        return Dismissible(
          key: ValueKey('${entry.createdAt.toIso8601String()}_${entry.title}'),
          direction: DismissDirection.endToStart,
          background: ColoredBox(
            color: colorScheme.error,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Icon(
                  Icons.delete,
                  color: colorScheme.onError,
                ),
              ),
            ),
          ),
          confirmDismiss: (_) => _confirmDelete(),
          onDismissed: (_) async {
            if (_selected == entry) {
              setState(() => _selected = null);
            }
            await _controller.remove(entry);
          },
          child: Material(
            color: selected
                ? colorScheme.primary.withValues(alpha: 0.12)
                : colorScheme.surface.withValues(alpha: 0),
            child: JournalCard(
              entry: entry,
              onTap: () => _openDetail(entry),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final duo = DuoScope.maybeOf(context);
    final fullScreen = duo?.useFullScreenLayout ?? false;

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final selected = _resolvedSelection();

        final listPane = Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => _open(const SettingsPage()),
              icon: const Icon(Icons.settings),
              tooltip: l10n.settings,
            ),
            title: Text(l10n.list),
            actions: [
              IconButton(
                onPressed: _openAdd,
                icon: const Icon(Icons.add),
                tooltip: l10n.add,
              ),
            ],
          ),
          body: SafeArea(child: _listBody(l10n)),
        );

        // Avoid dual-pane during fold animations when width collapses.
        return LayoutBuilder(
          builder: (context, constraints) {
            final canSplit = fullScreen && constraints.maxWidth >= 640;
            if (!canSplit) return listPane;

            return Row(
              children: [
                SizedBox(
                  width: (constraints.maxWidth * 0.42).clamp(280.0, 420.0),
                  child: listPane,
                ),
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
                Expanded(
                  child: selected == null
                      ? Scaffold(
                          body: Center(
                            child: Text(
                              l10n.emptyListHint,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ),
                        )
                      : DetailPage(
                          key: ValueKey(
                            '${selected.createdAt.toIso8601String()}_${selected.title}',
                          ),
                          entry: selected,
                          embedded: true,
                          onEntryUpdated: (updated) =>
                              _onEmbeddedUpdated(selected, updated),
                          onClose: () => setState(() => _selected = null),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  JournalEntry? _resolvedSelection() {
    final selected = _selected;
    if (selected == null) return null;
    for (final entry in _controller.entries) {
      if (identical(entry, selected) ||
          (entry.createdAt == selected.createdAt &&
              entry.title == selected.title)) {
        return entry;
      }
    }
    return null;
  }
}
