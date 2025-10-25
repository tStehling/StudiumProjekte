import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'package:revier_app_client/common/widgets/collections/core_collection_image.dart';

class CoreGridItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final VoidCallback? onTapCallback;
  final int gridColumns;

  const CoreGridItem({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    this.onTapCallback,
    this.gridColumns = 2,
  });

  void _handleTap() {
    developer.log("CoreGridItem tapped: $title");
    onTapCallback?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final size = MediaQuery.of(context).size;

    // Calculate relative size based on grid columns
    // The more columns, the smaller each item should be
    final double relativeFactor =
        1.0 - (0.1 * gridColumns); // Adjust size based on columns

    return GestureDetector(
      onTap: _handleTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: CoreCollectionImage(
                imagePath: imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurface,
              fontSize:
                  14 * relativeFactor, // Adjust text size based on grid columns
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subtitle,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.primary,
              fontSize:
                  12 * relativeFactor, // Adjust text size based on grid columns
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
