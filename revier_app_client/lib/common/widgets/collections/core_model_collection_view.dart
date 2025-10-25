import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:revier_app_client/common/widgets/collections/core_collection_type.dart';
import 'package:revier_app_client/common/widgets/collections/core_collection_view.dart';
import 'package:revier_app_client/data/providers/model_registry_provider.dart';
import 'dart:developer' as developer;
import 'package:revier_app_client/localization/app_localizations.dart';
import 'package:revier_app_client/core/services/logging_service.dart';

/// A generic collection view that can display any Brick model type
///
/// This widget handles fetching data from the model registry and displaying it
/// using the CoreCollectionView. It requires a mapping function to convert
/// the model objects to CoreCollectionItemType objects.
class CoreModelCollectionView<T extends OfflineFirstWithSupabaseModel>
    extends ConsumerStatefulWidget {
  /// Function to map model objects to CoreCollectionItemType objects
  final CoreCollectionItemType Function(T model) itemBuilder;

  /// Callback when an item is selected
  final Function(CoreCollectionItemType item)? onItemSelected;

  /// Callback when more options are requested for an item
  final Function(CoreCollectionItemType item)? onItemMoreOptions;

  /// Grid configuration
  final int? gridColumns;
  final double? gridAspectRatio;

  /// List configuration
  final double? listItemHeight;
  final bool showDividers;

  /// Common configuration
  final EdgeInsets? padding;
  final double? spacing;
  final bool initialShowGrid;

  /// Empty state widget
  final Widget? emptyStateWidget;

  /// Error state widget builder
  final Widget Function(BuildContext context, Object error,
      StackTrace? stackTrace, VoidCallback onRetry)? errorBuilder;

  /// Default empty collection
  final List<CoreCollectionItemType> defaultCollection;

  /// Constructor
  const CoreModelCollectionView({
    super.key,
    required this.itemBuilder,
    this.onItemSelected,
    this.onItemMoreOptions,
    this.gridColumns,
    this.gridAspectRatio,
    this.listItemHeight,
    this.showDividers = true,
    this.padding,
    this.spacing,
    this.initialShowGrid = true,
    this.emptyStateWidget,
    this.errorBuilder,
    this.defaultCollection = const [],
  });

  @override
  ConsumerState<CoreModelCollectionView<T>> createState() =>
      _CoreModelCollectionViewState<T>();
}

class _CoreModelCollectionViewState<T extends OfflineFirstWithSupabaseModel>
    extends ConsumerState<CoreModelCollectionView<T>> {
  static final _logger = loggingService.getLogger('CoreModelCollectionView');
  bool _isDisposed = false;

  void _log(String message, {Object? error, StackTrace? stackTrace}) {
    // Only log in debug mode
    if (!kReleaseMode && !_isDisposed) {
      if (error != null) {
        _logger.error(message, error: error, stackTrace: stackTrace);
      } else {
        _logger.debug(message);
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> _safeRefresh(dynamic notifier) async {
    if (_isDisposed) return;

    try {
      await notifier.refresh();
    } catch (e, stackTrace) {
      _log('Error refreshing data', error: e, stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    _log("CoreModelCollectionView<${T.toString()}> - Building widget");

    // Get the model registry
    final registry = ref.watch(modelRegistryProvider);
    final l10n = AppLocalizations.of(context);

    if (registry == null) {
      _log("CoreModelCollectionView - Model Registry is null");
      return Center(
        child: Text(
            l10n?.modelRegistryNotAvailable ?? 'Model Registry not available'),
      );
    }

    // Get the notifier for the model type
    final notifier = registry.getNotifier<T>(ref);
    _log("CoreModelCollectionView - Got notifier for ${T.toString()}");

    final modelState = notifier.state;
    _log("CoreModelCollectionView - Model state: ${modelState.runtimeType}");

    // Force a refresh if we're in loading state
    if (modelState is AsyncLoading) {
      _log("CoreModelCollectionView - In loading state, triggering refresh");
      // Use a microtask to avoid triggering during build, but handle errors safely
      Future.microtask(() {
        if (!_isDisposed) {
          _safeRefresh(notifier);
        }
      });
    }

    return modelState.when(
      data: (models) {
        _log(
            "CoreModelCollectionView - Data state with ${models.length} models");

        // Map models to collection items
        final collectionItems = models.map(widget.itemBuilder).toList();

        // Show empty state if no items
        if (collectionItems.isEmpty && widget.emptyStateWidget != null) {
          _log("CoreModelCollectionView - No items, showing empty state");
          return widget.emptyStateWidget!;
        }

        _log(
            "CoreModelCollectionView - Returning CoreCollectionView with ${collectionItems.length} items");
        return CoreCollectionView(
          collection: collectionItems.isEmpty
              ? widget.defaultCollection
              : collectionItems,
          onItemSelected: widget.onItemSelected,
          onItemMoreOptions: widget.onItemMoreOptions,
          // Grid configuration
          gridColumns: widget.gridColumns,
          gridAspectRatio: widget.gridAspectRatio,
          // List configuration
          listItemHeight: widget.listItemHeight,
          showDividers: widget.showDividers,
          // Common configuration
          padding: widget.padding,
          spacing: widget.spacing,
          initialShowGrid: widget.initialShowGrid,
        );
      },
      loading: () {
        _log("CoreModelCollectionView - In loading callback");

        // Check if we have cached data
        final cachedData = modelState.valueOrNull;
        if (cachedData != null && cachedData.isNotEmpty) {
          _log(
              "CoreModelCollectionView - Have cached data (${cachedData.length} items), using it while loading");

          // Map models to collection items
          final collectionItems = cachedData.map(widget.itemBuilder).toList();

          return Stack(
            children: [
              CoreCollectionView(
                collection: collectionItems,
                onItemSelected: widget.onItemSelected,
                onItemMoreOptions: widget.onItemMoreOptions,
                gridColumns: widget.gridColumns,
                gridAspectRatio: widget.gridAspectRatio,
                listItemHeight: widget.listItemHeight,
                showDividers: widget.showDividers,
                padding: widget.padding,
                spacing: widget.spacing,
                initialShowGrid: widget.initialShowGrid,
              ),
              const Positioned(
                top: 10,
                right: 10,
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      error: (error, stackTrace) {
        _log("CoreModelCollectionView - Error state: $error",
            error: error, stackTrace: stackTrace);

        if (widget.errorBuilder != null) {
          return widget.errorBuilder!(
            context,
            error,
            stackTrace,
            () => _safeRefresh(notifier),
          );
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('${l10n.errorLoadData ?? "Error loading data:"} $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _safeRefresh(notifier),
                child: Text(l10n.retry ?? 'Retry'),
              ),
            ],
          ),
        );
      },
    );
  }
}
