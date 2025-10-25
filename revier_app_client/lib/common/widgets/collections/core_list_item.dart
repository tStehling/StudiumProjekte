import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'package:revier_app_client/common/widgets/collections/core_collection_image.dart';

class CoreListItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final VoidCallback? onTapCallback;
  final VoidCallback? onMoreTapCallback;
  final double? height;

  const CoreListItem({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    this.onTapCallback,
    this.onMoreTapCallback,
    this.height,
  });

  void _handleTap() {
    developer.log("CoreListItem tapped: $title");
    onTapCallback?.call();
  }

  void _handleMoreTap() {
    developer.log("More options tapped for: $title");
    onMoreTapCallback?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Calculate image size based on provided height or default
    final double itemHeight = height ?? 80.0;

    // Reduce the vertical padding to give more space for content
    final double verticalPadding = 4.0;

    return SizedBox(
      height: itemHeight,
      child: GestureDetector(
        onTap: _handleTap,
        child: Padding(
          padding:
              EdgeInsets.symmetric(vertical: verticalPadding, horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image on the left - use a fixed size based on available height
              SizedBox(
                width: itemHeight - (verticalPadding * 2),
                height: itemHeight - (verticalPadding * 2),
                child: CoreCollectionImage(
                  imagePath: imagePath,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),

              // Text section for title and description
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontSize: 16, // Slightly smaller font size
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2), // Reduce spacing
                    Flexible(
                      child: Text(
                        subtitle,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 14, // Slightly smaller font size
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),

              // More options icon
              GestureDetector(
                onTap: _handleMoreTap,
                child: Icon(
                  Icons.more_vert,
                  size: 24.0, // Slightly smaller icon
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
