import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revier_app_client/core/services/logging_service.dart';
import 'package:revier_app_client/localization/app_localizations.dart';
import 'package:revier_app_client/common/model_management/sort_provider.dart';

/// A widget that provides UI controls for switching between grid and list layouts,
/// and for sorting options.
///
/// This widget can be used in two ways:
/// 1. With direct callbacks (legacy mode)
/// 2. With Riverpod providers (recommended)
class LayoutSwitch extends ConsumerStatefulWidget {
  /// Legacy parameters (direct callbacks)
  /// Callback when the layout toggle is pressed
  final Function(bool)? onToggle;

  /// Whether the current layout is a grid (true) or list (false)
  final bool? isGrid;

  /// Available sort options to display in the dropdown
  final List<String>? sortOptions;

  /// The currently selected sort option label
  final String? currentSortLabel;

  /// Callback when a sort option is selected
  final Future<void> Function(int)? onSortChanged;

  /// Whether the current sort direction is ascending
  final bool? isAscending;

  /// Callback when the sort direction toggle is pressed
  final Future<void> Function()? onSortDirectionToggle;

  /// Callback for direct access to modelCollectionView.sortByField
  final void Function(String field)? onDirectSort;

  /// Riverpod integration
  final StateNotifierProvider<SortSettingsNotifier, SortSettings>? sortProvider;
  final StateNotifierProvider<ViewModeNotifier, bool>? viewModeProvider;
  final Provider<Map<String, String>>? sortLabelsProvider;

  const LayoutSwitch({
    super.key,
    // Legacy parameters
    this.onToggle,
    this.isGrid,
    this.sortOptions,
    this.currentSortLabel = 'Sort By',
    this.onSortChanged,
    this.isAscending = true,
    this.onSortDirectionToggle,
    this.onDirectSort,

    // Riverpod parameters
    this.sortProvider,
    this.viewModeProvider,
    this.sortLabelsProvider,
  }) : assert(
          (onToggle != null && isGrid != null) || (viewModeProvider != null),
          'Either provide onToggle and isGrid, or viewModeProvider',
        );

  @override
  ConsumerState<LayoutSwitch> createState() => _LayoutSwitchState();
}

class _LayoutSwitchState extends ConsumerState<LayoutSwitch> {
  // Track last selected option to prevent unnecessary updates
  String? _lastSelectedOption;

  // Track last selected index for smoother UI transitions
  int? _lastSelectedIndex;

  // Add a flag to track dropdown state
  bool _isDropdownOpen = false;

  // Logger instance for this class
  static final _logger = loggingService.getLogger('LayoutSwitch');

  /// Log a message only in debug mode
  void _log(String message) {
    if (!kReleaseMode) {
      _logger.debug(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    // Determine if we're using Riverpod or legacy mode
    final bool useRiverpod =
        widget.sortProvider != null && widget.sortLabelsProvider != null;

    // Variables for UI rendering
    bool effectiveIsGrid;
    String effectiveSortLabel;
    bool effectiveIsAscending;
    List<String> effectiveSortOptions = [];
    Map<String, String> sortFieldMap = {};

    // Set up variables based on the mode
    if (useRiverpod) {
      // Riverpod mode
      final sortSettings = ref.watch(widget.sortProvider!);
      effectiveIsAscending = sortSettings.ascending;

      // Get sort labels and options
      sortFieldMap = ref.watch(widget.sortLabelsProvider!);
      effectiveSortOptions = sortFieldMap.values.toList();
      effectiveSortLabel = sortSettings.getLabel(sortFieldMap);

      // Get grid mode if provider is available
      effectiveIsGrid = widget.viewModeProvider != null
          ? ref.watch(widget.viewModeProvider!)
          : (widget.isGrid ?? true);
    } else {
      // Legacy mode
      effectiveIsGrid = widget.isGrid ?? true;
      effectiveIsAscending = widget.isAscending ?? true;
      effectiveSortLabel =
          widget.currentSortLabel ?? (l10n.sortBy ?? 'Sort By');
      if (widget.sortOptions != null) {
        effectiveSortOptions = widget.sortOptions!;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Sort controls
          Row(
            children: [
              // Sort dropdown menu
              _buildSortDropdown(
                context,
                colorScheme,
                textTheme,
                l10n,
                effectiveSortLabel,
                effectiveSortOptions,
                sortFieldMap,
                useRiverpod,
              ),

              // Sort direction toggle button
              if (_shouldShowSortDirectionToggle(
                  effectiveSortLabel, effectiveSortOptions, l10n))
                _buildSortDirectionToggle(
                    context, colorScheme, l10n, effectiveIsAscending),
            ],
          ),

          // Button switch between grid and list
          _buildLayoutToggle(
              context, colorScheme, textTheme, l10n, effectiveIsGrid),
        ],
      ),
    );
  }

  bool _shouldShowSortDirectionToggle(
      String label, List<String> options, AppLocalizations? l10n) {
    final sortBy = l10n?.sortBy ?? 'Sort By';

    if (widget.sortProvider != null && widget.sortLabelsProvider != null) {
      // Riverpod mode - always show if we have sort options
      return true;
    } else {
      // Legacy mode
      return widget.onSortDirectionToggle != null &&
          label != sortBy &&
          options.isNotEmpty;
    }
  }

  Widget _buildSortDirectionToggle(BuildContext context,
      ColorScheme colorScheme, AppLocalizations? l10n, bool isAscending) {
    _log("Building sort direction toggle, isAscending: $isAscending");

    final String ascendingTooltip = l10n?.sortAscending ?? 'Sort Ascending';
    final String descendingTooltip = l10n?.sortDescending ?? 'Sort Descending';

    return Semantics(
      label: isAscending ? ascendingTooltip : descendingTooltip,
      button: true,
      child: IconButton(
        icon: Icon(
          isAscending ? Icons.arrow_upward : Icons.arrow_downward,
          size: 20,
          color: colorScheme.primary,
        ),
        tooltip: isAscending ? ascendingTooltip : descendingTooltip,
        onPressed: () => _handleSortDirectionToggle(),
        padding: const EdgeInsets.all(8.0),
        constraints: const BoxConstraints(),
      ),
    );
  }

  Widget _buildSortDropdown(
      BuildContext context,
      ColorScheme colorScheme,
      TextTheme textTheme,
      AppLocalizations? l10n,
      String displayLabel,
      List<String> sortOptions,
      Map<String, String> sortFieldMap,
      bool useRiverpod) {
    try {
      final String sortByText = l10n?.sortBy ?? 'Sort By';
      final String noOptionsText =
          l10n?.noSortOptionsAvailable ?? 'No sort options available';
      final String sortOptionsTooltip = l10n?.sortOptions ?? 'Sort options';

      // If no sort options are provided, show a simple text
      if (sortOptions.isEmpty) {
        return Text(
          displayLabel.isNotEmpty ? displayLabel : sortByText,
          style: textTheme.titleSmall?.copyWith(
            color: colorScheme.onSurface,
          ),
        );
      }

      // Log current state for debugging
      _logger.debug("Current sort label: '$displayLabel'");
      _logger.debug("Available options: ${sortOptions.join(', ')}");

      // Check if we've manually selected an option before
      if (_lastSelectedOption != null) {
        _logger
            .debug("Last manually selected option was: $_lastSelectedOption");
      }

      return Semantics(
        label: sortOptionsTooltip,
        child: PopupMenuButton<int>(
          onSelected: (int index) async {
            _logger.debug("PopupMenuButton selected index: $index");
            await _handleSortSelection(
                index, sortOptions, sortFieldMap, useRiverpod);
          },
          onCanceled: () {
            setState(() {
              _isDropdownOpen = false;
            });
          },
          onOpened: () {
            setState(() {
              _isDropdownOpen = true;
            });
          },
          // Use initialValue to pre-select the current option
          initialValue: _findCurrentSortIndex(displayLabel, sortOptions),
          itemBuilder: (_) => _buildSortMenuItems(
              displayLabel, noOptionsText, sortOptions, useRiverpod),
          tooltip: sortOptionsTooltip,
          position: PopupMenuPosition.under,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.primary.withAlpha(128)),
              borderRadius: BorderRadius.circular(4.0),
              color: _isDropdownOpen
                  ? colorScheme.primaryContainer.withOpacity(0.2)
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.sort,
                  size: 18,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  displayLabel,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  _isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  size: 20,
                  color: colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      _logger.error("Error building sort dropdown", error: e);
      // Return a minimal fallback
      return Text(
        l10n?.sortBy ?? 'Sort By',
        style: textTheme.titleSmall,
      );
    }
  }

  Widget _buildLayoutToggle(BuildContext context, ColorScheme colorScheme,
      TextTheme textTheme, AppLocalizations? l10n, bool isGrid) {
    try {
      final String listViewText = l10n?.listView ?? 'List View';
      final String gridViewText = l10n?.gridView ?? 'Grid View';

      return Semantics(
        button: true,
        label: isGrid ? listViewText : gridViewText,
        child: InkWell(
          onTap: () => _handleViewModeToggle(!isGrid),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isGrid ? Icons.list : Icons.grid_view,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  isGrid ? listViewText : gridViewText,
                  style: textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      _logger.error("Error building layout toggle", error: e);
      // Return minimal fallback
      return IconButton(
        icon: Icon(isGrid ? Icons.list : Icons.grid_view),
        onPressed: () => _handleViewModeToggle(!isGrid),
      );
    }
  }

  List<PopupMenuItem<int>> _buildSortMenuItems(String currentLabel,
      String noOptionsText, List<String> sortOptions, bool useRiverpod) {
    try {
      return List.generate(
        sortOptions.length,
        (index) {
          final option = sortOptions[index];

          // Compare trimmed strings for more accurate matching
          final isSelected = option.trim() == currentLabel.trim();

          _logger.debug("Menu item: '$option', isSelected: $isSelected");

          return PopupMenuItem<int>(
            value: index,
            // Add custom onTap handler for direct sort
            onTap: !useRiverpod && widget.onDirectSort != null
                ? () {
                    _logger.debug("*** DIRECT SORT: '$option' ***");

                    // Save locally for display
                    _lastSelectedOption = option;
                    _lastSelectedIndex = index;

                    // Call direct sort immediately
                    widget.onDirectSort!(option);
                  }
                : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  option,
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (isSelected) const Icon(Icons.check, size: 18),
              ],
            ),
          );
        },
      );
    } catch (e) {
      _logger.error("Error building sort menu items", error: e);
      return [
        PopupMenuItem<int>(
          value: -1,
          child: Text(noOptionsText),
        )
      ];
    }
  }

  Future<void> _handleSortSelection(int index, List<String> sortOptions,
      Map<String, String> sortFieldMap, bool useRiverpod) async {
    _logger.fine("Sort option selected at index $index");

    // First close dropdown regardless of what happens next
    setState(() {
      _isDropdownOpen = false;
    });

    // Validate the selected option
    if (index < 0 || index >= sortOptions.length) {
      _logger.warning("Invalid sort index: $index");
      return;
    }

    // Get the selected option
    final selectedOption = sortOptions[index];
    _logger.debug("Selected option: '$selectedOption'");

    // Save as last selected option and index - do this early to maintain state
    _lastSelectedOption = selectedOption;
    _lastSelectedIndex = index;

    // Update UI immediately to show selection
    if (mounted) {
      setState(() {});
    }

    // Handle the sort change based on mode
    if (useRiverpod && widget.sortProvider != null) {
      // Find the field key for the selected option label
      final fieldKey = sortFieldMap.entries
          .firstWhere((entry) => entry.value == selectedOption,
              orElse: () => MapEntry('', ''))
          .key;

      if (fieldKey.isNotEmpty) {
        await ref.read(widget.sortProvider!.notifier).setSortField(fieldKey);
      }
    } else if (widget.onSortChanged != null) {
      // Legacy mode
      _logger.debug("Calling legacy onSortChanged with index $index");
      try {
        await widget.onSortChanged!(index);
        _logger.debug("Sort change completed successfully");
      } catch (e) {
        _logger.error("Error in sort change callback", error: e);
      }
    }

    _logger.fine("Sort selection complete for index $index");
  }

  void _handleViewModeToggle(bool newIsGrid) {
    _logger.debug(
        "View mode toggle pressed, current: ${widget.isGrid}, new: $newIsGrid");

    if (widget.viewModeProvider != null) {
      // Riverpod mode
      ref.read(widget.viewModeProvider!.notifier).setViewMode(newIsGrid);
    } else if (widget.onToggle != null) {
      // Legacy mode
      widget.onToggle!(newIsGrid);
    }
  }

  Future<void> _handleSortDirectionToggle() async {
    if (widget.sortProvider != null) {
      // Riverpod mode
      await ref.read(widget.sortProvider!.notifier).toggleDirection();
    } else if (widget.onSortDirectionToggle != null) {
      // Legacy mode
      await widget.onSortDirectionToggle!();
    }
  }

  /// Find the index of the current sort option
  int? _findCurrentSortIndex(String displayLabel, List<String> sortOptions) {
    if (sortOptions.isEmpty) {
      return null;
    }

    // If we have a last selected index stored, prefer that for stability
    if (_lastSelectedIndex != null &&
        _lastSelectedOption != null &&
        _lastSelectedIndex! < sortOptions.length) {
      _logger.debug(
          "Using last selected index: $_lastSelectedIndex ('${sortOptions[_lastSelectedIndex!]}')");
      return _lastSelectedIndex;
    }

    // Try a few different matching strategies

    // 1. First try exact match
    for (int i = 0; i < sortOptions.length; i++) {
      if (sortOptions[i] == displayLabel) {
        _logger.debug("Found exact match for '$displayLabel' at index $i");
        return i;
      }
    }

    // 2. Try trimmed match
    for (int i = 0; i < sortOptions.length; i++) {
      if (sortOptions[i].trim() == displayLabel.trim()) {
        _logger.debug("Found trimmed match for '$displayLabel' at index $i");
        return i;
      }
    }

    // 3. Special case for "Name" option which seems to have issues
    if (displayLabel.contains("Name")) {
      for (int i = 0; i < sortOptions.length; i++) {
        if (sortOptions[i].contains("Name")) {
          _logger.debug("Found special 'Name' match at index $i");
          return i;
        }
      }
    }

    // 4. If we had a last manually selected option, try to match that
    if (_lastSelectedOption != null) {
      for (int i = 0; i < sortOptions.length; i++) {
        if (sortOptions[i] == _lastSelectedOption) {
          _logger.debug(
              "Using last selected option '$_lastSelectedOption' at index $i");
          return i;
        }
      }
    }

    _logger.debug("No match found for '$displayLabel'");
    return null;
  }
}
