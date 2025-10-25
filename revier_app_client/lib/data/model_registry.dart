import 'package:brick_core/query.dart';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revier_app_client/brick/brick_repository.dart';
import 'package:revier_app_client/data/repositories/generic_repository.dart';
import 'package:revier_app_client/presentation/state/generic_model_notifier.dart';

/// A registry for managing Brick models with Riverpod
///
/// Usage:
/// 1. Initialize the registry with a BrickRepository provider
/// 2. Register all models using [register<T>()]
/// 3. Access model data using the provided methods
///
/// Example:
/// ```dart
/// // Register models
/// modelRegistry.register<Upload>();
///
/// // Watch all models of a type
/// final uploadsAsync = modelRegistry.watchAll<Upload>(ref);
///
/// // Create a new model
/// final upload = Upload(status: 'PENDING');
/// modelRegistry.create<Upload>(ref, upload);
/// ```

class ModelRegistry {
  final ProviderBase<BrickRepository> _brickRepositoryProvider;
  final Map<Type, dynamic> _repositoryProviders = {};
  final Map<Type, dynamic> _notifierProviders = {};
  final Map<Type, GenericModelNotifier> _notifiers = {};

  /// Constructor
  ModelRegistry(this._brickRepositoryProvider);

  /// Register a model type
  void register<T extends OfflineFirstWithSupabaseModel>() {
    // Create repository provider
    final repositoryProvider = Provider<GenericRepository<T>>((ref) {
      final brickRepository = ref.watch(_brickRepositoryProvider);
      return GenericRepository<T>(brickRepository);
    });

    // Store repositories in map
    _repositoryProviders[T] = repositoryProvider;
  }

  /// Get repository provider for a model type
  Provider<GenericRepository<T>>
      getRepositoryProvider<T extends OfflineFirstWithSupabaseModel>() {
    return _repositoryProviders[T] as Provider<GenericRepository<T>>;
  }

  /// Get or create a notifier for a model type
  GenericModelNotifier<T> getNotifier<T extends OfflineFirstWithSupabaseModel>(
      WidgetRef ref) {
    if (!_notifiers.containsKey(T)) {
      final repository = ref.read(getRepositoryProvider<T>());
      _notifiers[T] = GenericModelNotifier<T>(repository);
    }
    return _notifiers[T] as GenericModelNotifier<T>;
  }
}

/// Extension methods for the ModelRegistry
extension ModelRegistryExtensions on ModelRegistry {
  /// Watch all models of a type
  AsyncValue<List<T>> watchAll<T extends OfflineFirstWithSupabaseModel>(
      WidgetRef ref) {
    final notifier = getNotifier<T>(ref);
    return notifier.state;
  }

  /// Get a specific model by ID
  Future<T?> getById<T extends OfflineFirstWithSupabaseModel>(
      WidgetRef ref, String id) async {
    final notifier = getNotifier<T>(ref);
    return notifier.getById(id);
  }

  /// Get models with a specific query
  Future<List<T>> getWhere<T extends OfflineFirstWithSupabaseModel>(
      WidgetRef ref,
      {required Query query}) async {
    final notifier = getNotifier<T>(ref);
    return notifier.getWhere(query: query);
  }

  /// Create a new model
  Future<void> create<T extends OfflineFirstWithSupabaseModel>(
      WidgetRef ref, T model) async {
    final notifier = getNotifier<T>(ref);
    await notifier.create(model);
  }

  /// Update a model
  Future<void> update<T extends OfflineFirstWithSupabaseModel>(
      WidgetRef ref, T model) async {
    final notifier = getNotifier<T>(ref);
    await notifier.updateModel(model);
  }

  /// Delete a model
  Future<void> delete<T extends OfflineFirstWithSupabaseModel>(
      WidgetRef ref, T model) async {
    final notifier = getNotifier<T>(ref);
    await notifier.delete(model);
  }

  /// Sync models with server
  Future<void> sync<T extends OfflineFirstWithSupabaseModel>(
      WidgetRef ref) async {
    final notifier = getNotifier<T>(ref);
    await notifier.syncWithServer();
  }

  /// Refresh models from local database
  Future<void> refresh<T extends OfflineFirstWithSupabaseModel>(
      WidgetRef ref) async {
    final notifier = getNotifier<T>(ref);
    await notifier.refresh();
  }
}
