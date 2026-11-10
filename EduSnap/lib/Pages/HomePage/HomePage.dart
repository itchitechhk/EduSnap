import 'package:flutter/material.dart';

import '../../Component/JournalCard/JournalCard.dart';
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          content: const Text('Delete this entry?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Delete'),
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
    if (entry != null) _controller.add(entry);
  }

  Future<void> _openDetail(JournalEntry entry) async {
    final updated = await Navigator.of(context).push<JournalEntry>(
      MaterialPageRoute(builder: (_) => DetailPage(entry: entry)),
    );
    if (updated != null) _controller.update(entry, updated);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => _open(const SettingsPage()),
              icon: const Icon(Icons.settings),
              tooltip: 'Settings',
            ),
            title: const Text('List'),
            actions: [
              IconButton(
                onPressed: _openAdd,
                icon: const Icon(Icons.add),
                tooltip: 'Add',
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Text(
                  'List',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _controller.entries.length,
                    itemBuilder: (context, index) {
                      final entry = _controller.entries[index];
                      final colorScheme = Theme.of(context).colorScheme;
                      return Dismissible(
                        key: ValueKey(entry),
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
                        onDismissed: (_) => _controller.remove(entry),
                        child: JournalCard(
                          entry: entry,
                          onTap: () => _openDetail(entry),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
