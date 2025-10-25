import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brick_core/query.dart';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:revier_app_client/common/widgets/collections/core_collection_view.dart';
import 'package:revier_app_client/common/widgets/collections/core_collection_type.dart';
import 'package:revier_app_client/common/widgets/collections/layout_switch.dart';
import 'package:revier_app_client/common/widgets/search/core_search_bar.dart';
import 'package:revier_app_client/common/model_management/model_handler.dart';
import 'package:revier_app_client/common/model_management/model_collection_adapter.dart';
import 'package:revier_app_client/common/model_management/sort_provider.dart';
import 'package:revier_app_client/common/navigation/navigation_service.dart';
import 'package:revier_app_client/core/services/logging_service.dart';
import 'package:revier_app_client/localization/app_localizations.dart';
import 'package:revier_app_client/utils/sort_utils.dart';
import 'package:revier_app_client/utils/collection_utils.dart';
import 'package:revier_app_client/utils/filter_utils.dart';

/// A reusable view for displaying model collections using CoreCollectionView
class ModelCollectionView<T extends OfflineFirstWithSupabaseModel>
    extends ConsumerStatefulWidget {
  final ModelHandler<T> modelHandler;
  final Widget Function(BuildContext, T)? detailViewBuilder;
  final Widget Function(BuildContext)? emptyStateBuilder;
  final String Function(T)? searchFilter;
  final Query? initialQuery;
  final bool initialShowGrid;
  final bool showSearch;
  final bool autoRefresh;

  // CoreCollectionView configuration
  final int? gridColumns;
  final double? gridAspectRatio;
  final double? listItemHeight;
  final bool showDividers;
  final EdgeInsets? padding;
  final double? spacing;
  final bool showLayoutSwitch;

  // Model collection adapter configuration
  final String Function(T entity)? imagePathProvider;
  final String Function(T entity)? subtitleProvider;

  // Actions
  final Widget? floatingActionButton;
  final List<Widget>? actions;

  // Sort configuration
  final String? initialSortField;
  final bool initialSortAscending;
  final Map<String, String>? customSortFieldNames;

  // Persistence
  final String? preferenceKey;

  // External sort controller callback
  final void Function(String field, bool ascending)? onExternalSort;

  // Riverpod providers for state management
  final StateNotifierProvider<SortSettingsNotifier, SortSettings>? sortProvider;
  final StateNotifierProvider<ViewModeNotifier, bool>? viewModeProvider;
  final Provider<Map<String, String>>? sortLabelsProvider;

  const ModelCollectionView({
    super.key,
    required this.modelHandler,
    this.detailViewBuilder,
    this.emptyStateBuilder,
    this.searchFilter,
    this.initialQuery,
    this.initialShowGrid = true,
    this.showSearch = true,
    this.autoRefresh = true,
    this.showLayoutSwitch = true,

    // CoreCollectionView configuration
    this.gridColumns,
    this.gridAspectRatio,
    this.listItemHeight,
    this.showDividers = true,
    this.padding,
    this.spacing,

    // Model collection adapter configuration
    this.imagePathProvider,
    this.subtitleProvider,

    // Actions
    this.floatingActionButton,
    this.actions,

    // Sort configuration
    this.initialSortField,
    this.initialSortAscending = true,
    this.customSortFieldNames,

    // Preference key for persistent storage
    this.preferenceKey,

    // External sort controller
    this.onExternalSort,

    // Riverpod providers
    this.sortProvider,
    this.viewModeProvider,
    this.sortLabelsProvider,
  });

  @override
  ConsumerState<ModelCollectionView<T>> createState() =>
      _ModelCollectionViewState<T>();
}

class _ModelCollectionViewState<T extends OfflineFirstWithSupabaseModel>
    extends ConsumerState<ModelCollectionView<T>> with RouteAware {
  late ModelCollectionAdapter<T> _adapter;
  List<T> _entities = [];
  List<T> _filteredEntities = [];
  String _searchQuery = '';
  bool _isLoading = true;
  String? _errorMessage;
  late final ClassNameLogger _log;
  RouteObserver<ModalRoute>? _routeObserver;

  // Sorting state
  String? _sortField;
  bool _sortAscending = true;
  late List<SortOption> _sortOptions;

  // Simplify: remove redundant flags for sort tracking
  bool _isActivelySorting = false;

  @override
  void initState() {
    super.initState();
    _log = loggingService.getLogger('ModelCollectionView<${T.toString()}>');
    _log.info('Initializing ModelCollectionView<${T.toString()}>');

    // Initialize adapter for entity conversion
    _adapter = ModelCollectionAdapter<T>(
      modelHandler: widget.modelHandler,
      imagePathProvider: widget.imagePathProvider,
      subtitleProvider: widget.subtitleProvider,
    );

    // Initialize sort options
    _initSortOptions();

    // Set initial sort values (will be overridden if preferences exist)
    _sortField = widget.initialSortField ??
        (_sortOptions.isNotEmpty ? _sortOptions.first.field : null);
    _sortAscending = widget.initialSortAscending;

    // Load saved preferences and data asynchronously
    _initialize();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Set up Riverpod listeners if providers are available
    if (widget.sortProvider != null) {
      // Initial sync from Riverpod to local state
      final sortSettings = ref.read(widget.sortProvider!);
      if (sortSettings.field != _sortField ||
          sortSettings.ascending != _sortAscending) {
        _log.info(
            'Syncing from Riverpod sort provider: ${sortSettings.field}, ${sortSettings.ascending}');
        _sortField = sortSettings.field;
        _sortAscending = sortSettings.ascending;
        _applySorting();
      }
    }

    // Register with the RouteObserver to get notifications when this route is active
    _routeObserver = NavigationService.instance.routeObserver;
    if (_routeObserver != null) {
      _routeObserver!.subscribe(this, ModalRoute.of(context)!);
    }

    // Only do auto-refresh if we're not in the middle of sorting
    if (widget.autoRefresh && !_isActivelySorting) {
      _refreshData();
    }
  }

  @override
  void didPopNext() {
    // This is called when the route on top of this one is popped off the navigator
    if (_isActivelySorting) {
      return;
    }

    // Only refresh data, explicitly avoiding preference loading
    _refreshData();
  }

  @override
  void dispose() {
    // Unsubscribe from the RouteObserver when disposing
    if (_routeObserver != null) {
      _routeObserver!.unsubscribe(this);
    }
    super.dispose();
  }

  Future<void> _initialize() async {
    try {
      // Load saved sort preferences first, but only if not actively sorting
      if (!_isActivelySorting && widget.sortProvider == null) {
        await _loadSortPreferences();
      }

      // Then load data
      await _loadData();

      // After data is loaded, ensure sorting is applied
      if (mounted) {
        setState(() {
          _applySorting();
          _applySearchFilter();
        });
      }
    } catch (e) {
      _log.error('Error during initialization', error: e);
    }
  }

  void _initSortOptions() {
    // If Riverpod provider is available, use its labels
    if (widget.sortLabelsProvider != null) {
      final sortLabels = ref.read(widget.sortLabelsProvider!);
      _sortOptions = SortUtils.createSortOptions(sortLabels);
      return;
    }

    // Start with createdAt and updatedAt if they exist in the model
    _sortOptions = [
      const SortOption('updatedAt', 'Recently Updated'),
      const SortOption('createdAt', 'Date Created'),
    ];

    // Add name/title field if it exists in the model
    if (widget.modelHandler.fieldConfigurations.containsKey('name')) {
      _sortOptions.add(const SortOption('name', 'Name'));
    } else if (widget.modelHandler.fieldConfigurations.containsKey('title')) {
      _sortOptions.add(const SortOption('title', 'Title'));
    }

    // Add other display fields from the model handler
    for (final field in widget.modelHandler.listDisplayFields) {
      // Skip fields we've already added
      if (field == 'name' ||
          field == 'title' ||
          field == 'createdAt' ||
          field == 'updatedAt') {
        continue;
      }

      // Get the field label from field configurations or use field name
      final fieldConfig = widget.modelHandler.fieldConfigurations[field];
      final label = fieldConfig?.label ?? SortUtils.capitalizeField(field);

      // Add to sort options
      _sortOptions.add(SortOption(field, label));
    }
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      List<T> results;
      if (widget.initialQuery != null) {
        results = await widget.modelHandler
            .fetchWhere(ref, query: widget.initialQuery!);
      } else {
        results = await widget.modelHandler.fetchAll(ref);
      }

      if (!mounted) return;

      setState(() {
        _entities = results;
        _applySorting();
        _applySearchFilter();
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      if (!mounted) return;

      _log.severe('Failed to load data', error: e, stackTrace: stackTrace);

      setState(() {
        _errorMessage = 'Failed to load data: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    try {
      // Refresh data from repository
      await widget.modelHandler.refresh(ref);
      await _loadData();
    } catch (e, stackTrace) {
      if (!mounted) return;

      _log.severe('Failed to refresh data', error: e, stackTrace: stackTrace);

      setState(() {
        _errorMessage = 'Failed to refresh data: ${e.toString()}';
      });
    }
  }

  void _applySorting() {
    if (_sortField == null || _entities.isEmpty) {
      return;
    }

    _entities = CollectionUtils.applySorting<T>(
      entities: _entities,
      sortField: _sortField,
      ascending: _sortAscending,
      defaultField: 'updatedAt',
    );

    // Make sure filtered entities are updated after sorting
    _applySearchFilter();
  }

  void _applySearchFilter() {
    if (_searchQuery.isEmpty) {
      // Clone the entities list to ensure it's a new reference
      _filteredEntities = List<T>.from(_entities);
      return;
    }

    if (widget.searchFilter != null) {
      _filteredEntities = CollectionUtils.applySearchFilter<T>(
        entities: _entities,
        searchQuery: _searchQuery,
        searchFunction: widget.searchFilter!,
      );
    } else {
      _filteredEntities = FilterUtils.applyMultiFieldSearch<T>(
        entities: _entities,
        searchQuery: _searchQuery,
        searchableFields: widget.modelHandler.searchableFields,
        fieldValueGetter: (entity, field) =>
            widget.modelHandler.getFieldValue(entity, field),
        formatFieldValue: (field, value) =>
            widget.modelHandler.formatDisplayValue(field, value),
      );
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _applySearchFilter();
    });
  }

  Future<void> _changeSortField(String field) async {
    _isActivelySorting = true;

    try {
      final bool isSameField = _sortField == field;

      // Update state variables
      if (isSameField) {
        _sortAscending = !_sortAscending;
      } else {
        _sortField = field;
        _sortAscending = true;
      }

      // Apply sorting to the data
      _applySorting();
      _applySearchFilter();

      // Update UI immediately
      if (mounted) {
        setState(() {});
      }

      // Save preferences in the background
      await _saveSortPreferences();

      // Store in SortUtils global map for persistence
      SortUtils.globalPendingSortFields[widget.preferenceKey ?? T.toString()] =
          _sortField!;
      SortUtils.globalPendingSortDirections[
          widget.preferenceKey ?? T.toString()] = _sortAscending;
    } catch (e) {
      _log.error('Error during sort field change', error: e);
    } finally {
      _isActivelySorting = false;
    }
  }

  // Toggle sort direction with immediate update
  Future<void> _toggleSortDirection() async {
    // Use null-aware assignment
    _sortField ??= _sortOptions.isNotEmpty ? _sortOptions.first.field : null;

    if (_sortField != null) {
      // Update the state variable
      _sortAscending = !_sortAscending;

      // Apply sorting to the data
      _applySorting();
      _applySearchFilter();

      // Update UI immediately
      if (mounted) {
        setState(() {});
      }

      // Save the updated preferences in the background
      await _saveSortPreferences();
    }
  }

  // Get the current sort option label
  String getCurrentSortOptionLabel() {
    if (_sortField == null) {
      return 'Sort By';
    }

    // Find the matching sort option
    for (var option in _sortOptions) {
      if (option.field == _sortField) {
        // Return exact label from sort options to ensure matching
        return option.label;
      }
    }

    // If no match is found in _sortOptions, provide a fallback
    return SortUtils.capitalizeField(_sortField!);
  }

  // Handle when an item is selected
  void _handleItemSelected(CoreCollectionItemType item) {
    // Find the entity from the collection that matches this item
    final selectedEntity = _filteredEntities.firstWhere(
      (entity) => widget.modelHandler.getDisplayText(entity) == item.title,
      orElse: () => _filteredEntities.first,
    );

    // Navigate to the detail view if provided
    if (widget.detailViewBuilder != null) {
      NavigationService.instance.navigateWithScale(
        widget.detailViewBuilder!(context, selectedEntity),
      );
    }
  }

  Widget _buildEmptyState() {
    if (widget.emptyStateBuilder != null) {
      return widget.emptyStateBuilder!(context);
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.inbox,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No ${widget.modelHandler.modelTitle} Found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text(
            'Add some items to get started',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Check if grid view is being shown
  bool _isShowingGrid() {
    // Use riverpod if available
    if (widget.viewModeProvider != null) {
      return ref.read(widget.viewModeProvider!);
    }

    // Use SortUtils to load view mode - handle as a separate operation since it's async
    if (widget.preferenceKey != null) {
      // Kick off async loading but return current default
      SortUtils.loadViewModeSetting(
        preferenceKey: widget.preferenceKey,
        defaultIsGrid: widget.initialShowGrid,
      ).then((value) {
        if (mounted && value != _isShowingGrid()) {
          setState(() {});
        }
      }).catchError((e) {
        _log.error('Error loading grid preference', error: e);
      });
    }

    // Default to initial value if no preferences
    return widget.initialShowGrid;
  }

  // Save grid view preference
  Future<void> _setShowGrid(bool isGrid) async {
    // Use Riverpod if available
    if (widget.viewModeProvider != null) {
      ref.read(widget.viewModeProvider!.notifier).setViewMode(isGrid);
      return;
    }

    // Use SortUtils to save view mode
    if (widget.preferenceKey != null) {
      try {
        await SortUtils.saveViewModeSetting(
          preferenceKey: widget.preferenceKey,
          isGrid: isGrid,
        );
      } catch (e) {
        _log.error('Error saving grid preference', error: e);
      }
    }

    // Update UI
    if (mounted) {
      setState(() {});
    }
  }

  // Get map of sort fields to display names
  Map<String, String> _getSortFieldMap() {
    final Map<String, String> result = {};

    // Use sort labels provider if available
    if (widget.sortLabelsProvider != null) {
      result.addAll(ref.read(widget.sortLabelsProvider!));
      return result;
    }

    // Otherwise build from sort options
    for (var option in _sortOptions) {
      result[option.field] = option.label;
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Watch providers if available
    final sortSettings =
        widget.sortProvider != null ? ref.watch(widget.sortProvider!) : null;
    final isGrid = widget.viewModeProvider != null
        ? ref.watch(widget.viewModeProvider!)
        : _isShowingGrid();

    // If Riverpod is being used, synchronize the local state
    if (sortSettings != null &&
        (sortSettings.field != _sortField ||
            sortSettings.ascending != _sortAscending)) {
      // Schedule a microtask to avoid changing state during build
      Future.microtask(() {
        if (mounted) {
          setState(() {
            _sortField = sortSettings.field;
            _sortAscending = sortSettings.ascending;
            _applySorting();
          });
        }
      });
    }

    // Check if we have any pending sort operations to apply
    String stateKey = widget.preferenceKey ?? T.toString();
    if (SortUtils.globalPendingSortFields.containsKey(stateKey) && mounted) {
      // Schedule for after the build
      Future.microtask(() {
        if (mounted) {
          final field = SortUtils.globalPendingSortFields[stateKey]!;
          final ascending =
              SortUtils.globalPendingSortDirections[stateKey] ?? true;

          // If using Riverpod providers, update them directly
          if (widget.sortProvider != null) {
            ref
                .read(widget.sortProvider!.notifier)
                .setSortField(field, direction: ascending);
          } else {
            // Otherwise use the traditional approach
            setState(() {
              _sortField = field;
              _sortAscending = ascending;
              _applySorting();
              _saveSortPreferences();
            });
          }

          // Clear the pending sort
          SortUtils.globalPendingSortFields.remove(stateKey);
          SortUtils.globalPendingSortDirections.remove(stateKey);
        }
      });
    }

    // Prepare sort field name mapping for menu
    final sortFieldMap = _getSortFieldMap();

    // Collection view content
    Widget content;

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (_errorMessage != null) {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshData,
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    } else if (_filteredEntities.isEmpty) {
      content = _buildEmptyState();
    } else {
      // Use the adapter to convert our entities to CoreCollectionItemType objects
      final collection = _adapter.convertEntities(_filteredEntities);

      // Use CoreCollectionView with our sort configuration
      content = Column(
        children: [
          // Search bar if enabled and not using Riverpod (when using Riverpod, we'll add it at the root level)
          if (widget.showSearch && widget.sortProvider == null)
            CoreSearchBar(
              onSearchChanged: _onSearchChanged,
              searchHint: '${l10n.search} ${widget.modelHandler.modelTitle}',
            ),

          // Main content
          Expanded(
            child: CoreCollectionView(
              key: ValueKey<String>(
                  'core_collection_${isGrid ? 'grid' : 'list'}_${widget.preferenceKey ?? ''}'),
              collection: collection,
              onItemSelected: _handleItemSelected,
              gridColumns: widget.gridColumns,
              gridAspectRatio: widget.gridAspectRatio,
              listItemHeight: widget.listItemHeight,
              showDividers: widget.showDividers,
              padding: widget.padding,
              spacing: widget.spacing,
              initialShowGrid: isGrid,
              // Don't show sort options and controls when using Riverpod providers
              sortOptions:
                  widget.sortProvider == null && widget.showLayoutSwitch
                      ? sortFieldMap.values.toList()
                      : null,
              currentSortLabel:
                  widget.sortProvider == null && _sortField != null
                      ? sortFieldMap[_sortField]
                      : null,
              onSortChanged: widget.sortProvider == null &&
                      widget.showLayoutSwitch
                  ? (index) async {
                      // Find the field key for this index
                      final field = sortFieldMap.entries.elementAt(index).key;
                      await _changeSortField(field);
                    }
                  : null,
              isAscending: _sortAscending,
              onSortDirectionToggle:
                  widget.sortProvider == null && widget.showLayoutSwitch
                      ? _toggleSortDirection
                      : null,
            ),
          ),
        ],
      );
    }

    // Add Riverpod-based search and layout controls if applicable
    if (widget.sortProvider != null && widget.viewModeProvider != null) {
      content = Column(
        children: [
          // Search bar
          if (widget.showSearch)
            CoreSearchBar(
              onSearchChanged: _onSearchChanged,
              searchHint: '${l10n.search} ${widget.modelHandler.modelTitle}',
            ),

          // Layout switch with Riverpod integration
          if (widget.showLayoutSwitch)
            LayoutSwitch(
              sortProvider: widget.sortProvider,
              viewModeProvider: widget.viewModeProvider,
              sortLabelsProvider: widget.sortLabelsProvider,
            ),

          // Content
          Expanded(child: content),
        ],
      );
    }

    // If no floating action button is provided, just return the content
    if (widget.floatingActionButton == null) {
      return content;
    }

    // Wrap content in a Scaffold if a floating action button is provided
    return Scaffold(
      body: content,
      floatingActionButton: widget.floatingActionButton,
    );
  }

  /// Load sort preferences from SharedPreferences
  Future<void> _loadSortPreferences() async {
    try {
      // Use SortUtils to load sort preferences
      final preferences = await SortUtils.loadSortPreferences(
        preferenceKey: widget.preferenceKey,
        defaultField: widget.initialSortField ?? 'updatedAt',
        sortOptions: _sortOptions,
      );

      _sortField = preferences['field'] as String;
      _sortAscending = preferences['ascending'] as bool;
    } catch (e) {
      _log.error('Failed to load sort preferences', error: e);
      // Fall back to initial values already set in initState
    }
  }

  /// Save sort preferences to SharedPreferences
  Future<void> _saveSortPreferences() async {
    // Use SortUtils to save sort preferences
    await SortUtils.saveSortPreferences(
      preferenceKey: widget.preferenceKey,
      sortField: _sortField,
      sortAscending: _sortAscending,
    );
  }

  /// Public method to sort by a specific field - can be called directly from UI
  void sortByField(String field, {bool? direction}) {
    // Apply sort immediately if we can
    if (mounted && !_isLoading) {
      _changeSortField(field);
    }

    // Notify external sort controller if provided
    if (widget.onExternalSort != null) {
      widget.onExternalSort!(field, direction ?? _sortAscending);
    }
  }
}
