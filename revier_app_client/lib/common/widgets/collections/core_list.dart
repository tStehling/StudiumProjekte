import 'package:flutter/material.dart';
import 'package:revier_app_client/common/widgets/collections/core_collection_type.dart';
import 'core_list_item.dart';
import 'dart:developer' as developer;

class CoreList extends StatelessWidget {
  final List<CoreCollectionItemType> collection;
  final int itemCount;
  final Function(CoreCollectionItemType item)? onItemTap;
  final Function(CoreCollectionItemType item)? onItemMoreTap;
  final double? itemHeight;
  final EdgeInsets padding;
  final bool showDividers;
  final double itemSpacing;

  const CoreList({
    super.key,
    required this.collection,
    this.onItemTap,
    this.onItemMoreTap,
    this.itemHeight,
    this.padding = const EdgeInsets.all(8.0),
    this.showDividers = true,
    this.itemSpacing = 4.0,
  }) : itemCount = collection.length;

  void _handleItemTap(int index) {
    final item = collection[index];
    developer.log("List item tapped: ${item.title}");
    onItemTap?.call(item);
  }

  void _handleItemMoreTap(int index) {
    final item = collection[index];
    developer.log("List item more options tapped: ${item.title}");
    onItemMoreTap?.call(item);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      // margin: const EdgeInsets.all(16.0),
      // padding: const EdgeInsets.all(12.0),
      // decoration: BoxDecoration(
      //   color: colorScheme.background,
      //   borderRadius: BorderRadius.circular(12.0),
      //   border: Border.all(
      //     color: colorScheme.outlineVariant,
      //     width: 1.0,
      //   ),
      //   boxShadow: [
      //     BoxShadow(
      //       color: colorScheme.shadow.withOpacity(0.3),
      //       blurRadius: 6,
      //       spreadRadius: 2,
      //     ),
      //   ],
      // ),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: padding,
              itemCount: itemCount,
              itemBuilder: (context, index) {
                final item = collection[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CoreListItem(
                    imagePath: item.imagePath,
                    title: item.title,
                    subtitle: item.subtitle,
                    height: itemHeight,
                    onTapCallback: () => _handleItemTap(index),
                    onMoreTapCallback: () => _handleItemMoreTap(index),
                  ),
                );
              },
              separatorBuilder: (context, index) => showDividers
                  ? Divider(
                      height: 1,
                      thickness: 1,
                      color: colorScheme.outlineVariant,
                    )
                  : const SizedBox(height: 8),
            ),
          ),
        ],
      ),
    );
  }
}
