import 'dart:typed_data';

import 'package:edusnap/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class JournalPhoto extends StatelessWidget {
  const JournalPhoto({
    super.key,
    required this.bytes,
    this.width = double.infinity,
    this.height = 180,
    this.showLabel = false,
  });

  final Uint8List? bytes;
  final double width;
  final double height;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final imageBytes = bytes;
    final child = imageBytes == null || imageBytes.isEmpty
        ? _placeholder(context, l10n)
        : Image.memory(
            imageBytes,
            width: width,
            height: height,
            fit: BoxFit.cover,
            gaplessPlayback: true,
            semanticLabel: l10n.photo,
            errorBuilder: (context, error, stackTrace) {
              return _placeholder(context, l10n);
            },
          );

    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        foregroundDecoration: BoxDecoration(
          border: Border.all(color: colorScheme.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        child: child,
      ),
    );
  }

  Widget _placeholder(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    final icon = Icon(
      Icons.image_outlined,
      color: colorScheme.onSurfaceVariant,
    );
    final body = Center(
      child: showLabel
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(height: 8),
                Text(
                  l10n.noPhoto,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            )
          : icon,
    );
    return ColoredBox(
      color: colorScheme.surfaceContainerHighest,
      child: showLabel
          ? body
          : Semantics(label: l10n.noPhoto, child: body),
    );
  }
}
