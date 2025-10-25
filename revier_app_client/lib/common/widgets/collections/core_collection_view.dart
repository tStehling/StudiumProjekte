import 'package:flutter/material.dart';
import 'package:revier_app_client/common/widgets/collections/core_collection_type.dart';
import 'package:revier_app_client/common/widgets/collections/layout_switch.dart';
import '/common/widgets/collections/core_grid.dart';
import '/common/widgets/collections/core_list.dart';
import 'dart:developer' as developer;

class CoreCollectionView extends StatefulWidget {
  final List<CoreCollectionItemType> collection;
  final Function(CoreCollectionItemType item)? onItemSelected;
  final Function(CoreCollectionItemType item)? onItemMoreOptions;

  // Grid configuration
  final int? gridColumns;
  final double? gridAspectRatio;

  // List configuration
  final double? listItemHeight;
  final bool showDividers;

  // Common configuration
  final EdgeInsets? padding;
  final double? spacing;
  final bool initialShowGrid;

  // Sorting configuration
  final List<String>? sortOptions;
  final String? currentSortLabel;
  final Future<void> Function(int)? onSortChanged;
  final bool isAscending;
  final Future<void> Function()? onSortDirectionToggle;

  // Direct sorting - bypasses async chain
  final void Function(String field)? onDirectSort;

  const CoreCollectionView({
    super.key,
    required this.collection,
    this.onItemSelected,
    this.onItemMoreOptions,
    this.gridColumns,
    this.gridAspectRatio,
    this.listItemHeight,
    this.showDividers = true,
    this.padding,
    this.spacing,
    this.initialShowGrid = true,
    this.sortOptions,
    this.currentSortLabel,
    this.onSortChanged,
    this.isAscending = true,
    this.onSortDirectionToggle,
    this.onDirectSort,
  });

  @override
  State<CoreCollectionView> createState() => _CoreCollectionViewState();
}

class _CoreCollectionViewState extends State<CoreCollectionView> {
  late bool _showGrid;
  late int _selectedSortIndex;

  @override
  void initState() {
    super.initState();
    _showGrid = widget.initialShowGrid;
    _selectedSortIndex =
        widget.sortOptions?.indexOf(widget.currentSortLabel ?? '') ?? 0;

    // Log sort options for debugging
    if (widget.sortOptions != null) {
      developer.log(
          'CoreCollectionView initialized with sort options: ${widget.sortOptions!.join(', ')}');
      developer.log('Current sort label: ${widget.currentSortLabel ?? 'none'}');
    }
  }

  void _toggleView(bool isGrid) {
    setState(() {
      _showGrid = isGrid;
    });
  }

  void _handleItemSelected(CoreCollectionItemType item) {
    developer.log("Item selected: ${item.title}");
    widget.onItemSelected?.call(item);
  }

  void _handleItemMoreOptions(CoreCollectionItemType item) {
    developer.log("Item more options: ${item.title}");
    widget.onItemMoreOptions?.call(item);
  }

  Future<void> _handleSortChanged(int index) async {
    developer.log("CoreCollectionView: Sort option selected, index=$index");

    // Log current sort options for debugging
    if (widget.sortOptions != null) {
      developer
          .log("Available sort options: ${widget.sortOptions!.join(', ')}");
      developer.log(
          "Current sort label before change: '${widget.currentSortLabel}'");
    }

    if (widget.onSortChanged != null) {
      try {
        // Store the selected index before async operation
        final selectedIndex = index;

        // Log what we're about to request
        if (widget.sortOptions != null &&
            selectedIndex >= 0 &&
            selectedIndex < widget.sortOptions!.length) {
          developer.log(
              "About to request sort by: '${widget.sortOptions![selectedIndex]}'");
        }

        // Call parent callback first and await its completion
        developer.log("Calling parent onSortChanged...");
        await widget.onSortChanged!(index);
        developer.log("Parent onSortChanged completed");

        // Log the current sort label after parent callback
        developer.log(
            "Current sort label after parent callback: '${widget.currentSortLabel}'");

        // Only update UI after parent callback completes successfully
        if (mounted) {
          setState(() {
            _selectedSortIndex = selectedIndex;
            developer.log("Updated _selectedSortIndex to: $selectedIndex");
          });
        }
      } catch (e) {
        developer.log("Error during sort change: $e");
        // Revert UI if there was an error
        if (mounted) {
          setState(() {});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectivePadding = widget.padding ?? const EdgeInsets.all(8.0);
    final effectiveSpacing = widget.spacing ?? 16.0;

    // Debug log current state
    if (widget.sortOptions != null) {
      developer.log(
          'CoreCollectionView: Building with sort options: ${widget.sortOptions!.join(', ')}');
      developer.log(
          'CoreCollectionView: Current sort label: "${widget.currentSortLabel ?? 'none'}"');
      developer.log(
          'CoreCollectionView: isAscending: ${widget.isAscending}, has toggle callback: ${widget.onSortDirectionToggle != null}');

      // Log if direct sort is available
      developer.log(
          'CoreCollectionView: Direct sort available: ${widget.onDirectSort != null}');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Only show the LayoutSwitch when sortOptions is provided
        if (widget.sortOptions != null)
          LayoutSwitch(
            onToggle: _toggleView,
            isGrid: _showGrid,
            sortOptions: widget.sortOptions,
            currentSortLabel: widget.currentSortLabel ?? 'Sort By',
            onSortChanged: _handleSortChanged,
            isAscending: widget.isAscending,
            onSortDirectionToggle: widget.onSortDirectionToggle,
            onDirectSort: widget.onDirectSort,
          ),
        if (widget.sortOptions != null) const SizedBox(height: 16),
        Expanded(
          child: _showGrid
              ? CoreGrid(
                  collection: widget.collection,
                  onItemTap: _handleItemSelected,
                  crossAxisCount: widget.gridColumns,
                  childAspectRatio: widget.gridAspectRatio,
                  padding: effectivePadding,
                  spacing: effectiveSpacing,
                )
              : CoreList(
                  collection: widget.collection,
                  onItemTap: _handleItemSelected,
                  onItemMoreTap: _handleItemMoreOptions,
                  itemHeight: widget.listItemHeight,
                  padding: effectivePadding,
                  showDividers: widget.showDividers,
                  itemSpacing: effectiveSpacing /
                      2, // Use half the spacing for list items
                ),
        ),
      ],
    );
  }
}
