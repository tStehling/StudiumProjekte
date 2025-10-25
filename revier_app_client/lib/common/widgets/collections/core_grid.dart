import 'package:flutter/material.dart';
import 'package:revier_app_client/common/widgets/collections/core_collection_type.dart';
import 'core_grid_item.dart';
import 'dart:developer' as developer;

class CoreGrid extends StatelessWidget {
  final List<CoreCollectionItemType> collection;
  final int itemCount;
  final Function(CoreCollectionItemType item)? onItemTap;
  final int? crossAxisCount;
  final double? childAspectRatio;
  final EdgeInsets padding;
  final double spacing;

  const CoreGrid({
    super.key,
    required this.collection,
    this.onItemTap,
    this.crossAxisCount,
    this.childAspectRatio,
    this.padding = const EdgeInsets.all(8.0),
    this.spacing = 16.0,
  }) : itemCount = collection.length;

  void _handleItemTap(int index) {
    final item = collection[index];
    developer.log("Grid item tapped: ${item.title}");
    onItemTap?.call(item);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    // Default responsive grid configuration
    final defaultCrossAxisCount = screenWidth < 600
        ? 2
        : screenWidth < 900
            ? 3
            : 4;

    final defaultAspectRatio = screenWidth < 600
        ? 0.8
        : screenWidth < 900
            ? 0.9
            : 1.0;

    // Use provided values or defaults
    final effectiveCrossAxisCount = crossAxisCount ?? defaultCrossAxisCount;
    final effectiveAspectRatio = childAspectRatio ?? defaultAspectRatio;

    return Container(
      child: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: padding,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: effectiveCrossAxisCount,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
                childAspectRatio: effectiveAspectRatio,
              ),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                final item = collection[index];
                return CoreGridItem(
                  imagePath: item.imagePath,
                  title: item.title,
                  subtitle: item.subtitle,
                  onTapCallback: () => _handleItemTap(index),
                  gridColumns: effectiveCrossAxisCount,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
