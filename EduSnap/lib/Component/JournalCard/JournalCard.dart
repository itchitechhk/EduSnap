import 'package:edusnap/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../Models/JournalEntry.dart';
import '../../Utils/journal_date.dart';
import '../JournalPhoto/JournalPhoto.dart';

class JournalCard extends StatelessWidget {
  const JournalCard({super.key, required this.entry, this.onTap});

  final JournalEntry entry;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        onTap: onTap,
        isThreeLine: true,
        leading: JournalPhoto(
          bytes: entry.imageBytes,
          width: 56,
          height: 56,
        ),
        title: Text(entry.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.note,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              l10n.createdOn(formatJournalDate(entry.createdAt)),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
