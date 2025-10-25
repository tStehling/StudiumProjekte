import 'dart:developer' as developer;

import 'package:flutter/material.dart';

class CoreCollectionImage extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;

  const CoreCollectionImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: colorScheme.surfaceContainerLowest,
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        imagePath,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          developer.log("Error loading image: $error");
          return Container(
            width: width,
            height: height,
            color: colorScheme.surfaceContainerHighest,
            child: Icon(
              Icons.image_not_supported,
              color: colorScheme.onSurfaceVariant,
              size: (width ?? 100) * 0.4,
            ),
          );
        },
      ),
    );
  }
}
