import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brick_core/query.dart';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:revier_app_client/common/model_management/model_collection_view.dart';
import 'package:revier_app_client/common/model_management/model_handler.dart';
import 'package:revier_app_client/common/model_management/sort_provider.dart';
import 'package:revier_app_client/core/services/logging_service.dart';
import 'package:revier_app_client/features/hunting_ground/providers/hunting_ground_provider.dart';
import 'package:revier_app_client/localization/app_localizations.dart';

/// A specialized version of ModelCollectionView that automatically filters models
/// by the currently selected hunting ground.
///
/// This component observes the selectedHuntingGroundProvider and only displays
/// models that belong to the selected hunting ground. It also provides an empty
/// state when no hunting ground is selected.
class HuntingGroundFilteredModelView<T extends OfflineFirstWithSupabaseModel>
    extends ConsumerWidget {
  /// Handler for the model type
  final ModelHandler<T> modelHandler;

  /// Field name that contains the hunting ground ID in the model
  final String huntingGroundIdField;

  /// Builder for detail views when an item is tapped
  final Widget Function(BuildContext, T)? detailViewBuilder;

  /// Custom image path provider for items
  final String Function(T)? imagePathProvider;

  /// Custom subtitle provider for items
  final String Function(T)? subtitleProvider;

  /// Custom empty state builder (when data is empty but hunting ground is selected)
  final Widget Function(BuildContext)? emptyStateBuilder;

  /// Custom no hunting ground selected message
  final Widget Function(BuildContext)? noHuntingGroundSelectedBuilder;

  /// Additional query to combine with the hunting ground filter
  final Query? additionalQuery;

  /// CoreCollectionView configuration
  final int? gridColumns;
  final double? gridAspectRatio;
  final double? listItemHeight;
  final bool showDividers;
  final EdgeInsets? padding;
  final double? spacing;
  final bool showSearch;
  final bool showLayoutSwitch;

  /// Riverpod sort and view mode providers
  final StateNotifierProvider<SortSettingsNotifier, SortSettings>? sortProvider;
  final StateNotifierProvider<ViewModeNotifier, bool>? viewModeProvider;
  final Provider<Map<String, String>>? sortLabelsProvider;

  /// Actions
  final Widget? floatingActionButton;
  final List<Widget>? actions;

  /// Additional parameters
  final bool autoRefresh;
  final String? preferenceKey;

  const HuntingGroundFilteredModelView({
    super.key,
    required this.modelHandler,
    this.huntingGroundIdField = 'huntingGroundId',
    this.detailViewBuilder,
    this.imagePathProvider,
    this.subtitleProvider,
    this.emptyStateBuilder,
    this.noHuntingGroundSelectedBuilder,
    this.additionalQuery,
    this.gridColumns,
    this.gridAspectRatio,
    this.listItemHeight,
    this.showDividers = true,
    this.padding,
    this.spacing,
    this.showSearch = true,
    this.showLayoutSwitch = true,
    this.sortProvider,
    this.viewModeProvider,
    this.sortLabelsProvider,
    this.floatingActionButton,
    this.actions,
    this.autoRefresh = true,
    this.preferenceKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final log = loggingService
        .getLogger('HuntingGroundFilteredModelView<${T.toString()}>');

    log.info(
        'Building HuntingGroundFilteredModelView for ${modelHandler.modelTitle}');
    final selectedHuntingGround = ref.watch(selectedHuntingGroundProvider);
    log.info('Selected hunting ground: ${selectedHuntingGround?.id ?? 'none'}');

    // Get sort settings and view mode if providers are supplied
    final sortSettings = sortProvider != null ? ref.watch(sortProvider!) : null;
    final isGrid =
        viewModeProvider != null ? ref.watch(viewModeProvider!) : true;

    log.info(
        'Sort settings: ${sortSettings?.field}, ascending: ${sortSettings?.ascending}');
    log.info('View mode: ${isGrid ? "grid" : "list"}');

    // Create a query to filter by hunting ground ID
    Query? query;
    if (selectedHuntingGround != null) {
      log.info(
          'Creating query for huntingGroundId: ${selectedHuntingGround.id}');
      log.info('Using field: $huntingGroundIdField');

      // Basic hunting ground filter
      final huntingGroundFilter =
          Where.exact(huntingGroundIdField, selectedHuntingGround.id);

      if (additionalQuery != null && additionalQuery!.where != null) {
        // Combine both queries
        log.info('Combining hunting ground filter with additional query');

        // Create a new query with all conditions
        final combinedWhereConditions = <WhereCondition>[huntingGroundFilter];
        combinedWhereConditions.addAll(additionalQuery!.where!);

        query = Query(where: combinedWhereConditions);

        log.info(
            'Combined query created with ${combinedWhereConditions.length} conditions: ' +
                combinedWhereConditions.map((w) => w.toString()).join(', '));
      } else {
        // Just use hunting ground filter
        query = Query(where: [huntingGroundFilter]);
        log.info('Using only hunting ground filter: $huntingGroundFilter');
      }
    } else {
      log.info('No hunting ground selected, no query created');
    }

    // Default no hunting ground selected message
    final noHuntingGroundWidget = noHuntingGroundSelectedBuilder != null
        ? noHuntingGroundSelectedBuilder!(context)
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.orange),
                const SizedBox(height: 16),
                Text(
                  l10n.noHGSelected,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.selectHGFirst,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );

    log.info(
        'Creating ModelCollectionView with query: ${query != null ? 'yes' : 'no'}');

    // Function to handle external sort requests from Riverpod
    void handleExternalSort(String field, bool ascending) {
      if (sortProvider != null) {
        log.info('Handling external sort: field=$field, ascending=$ascending');
        ref
            .read(sortProvider!.notifier)
            .setSortField(field, direction: ascending);
      }
    }

    return ModelCollectionView<T>(
      key: ValueKey('${selectedHuntingGround?.id}-${modelHandler.modelTitle}'),
      modelHandler: modelHandler,
      detailViewBuilder: detailViewBuilder,
      imagePathProvider: imagePathProvider,
      subtitleProvider: subtitleProvider,
      initialQuery: query,
      emptyStateBuilder: selectedHuntingGround == null
          ? (BuildContext ctx) => noHuntingGroundWidget
          : emptyStateBuilder,

      // CoreCollectionView configuration
      gridColumns: gridColumns,
      gridAspectRatio: gridAspectRatio,
      listItemHeight: listItemHeight,
      showDividers: showDividers,
      padding: padding,
      spacing: spacing,
      initialShowGrid: viewModeProvider != null ? isGrid : true,
      showSearch: showSearch,
      showLayoutSwitch: showLayoutSwitch,

      // Only show the floating action button if hunting ground is selected
      floatingActionButton:
          selectedHuntingGround == null ? null : floatingActionButton,
      actions: actions,

      // Pass sorting configuration
      initialSortField: sortSettings?.field ?? 'updatedAt',
      initialSortAscending: sortSettings?.ascending ?? false,

      // Additional parameters
      autoRefresh: autoRefresh,
      preferenceKey: preferenceKey != null
          ? '${preferenceKey}_${selectedHuntingGround?.id}'
          : null,

      // Use Riverpod providers if available
      sortProvider: sortProvider,
      viewModeProvider: viewModeProvider,
      sortLabelsProvider: sortLabelsProvider,
      onExternalSort: handleExternalSort,
    );
  }
}
