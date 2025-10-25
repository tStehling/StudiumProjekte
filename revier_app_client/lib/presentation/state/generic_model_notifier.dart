import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_core/query.dart';
import 'package:revier_app_client/data/repositories/generic_repository.dart';

/// A generic notifier for managing Brick models
class GenericModelNotifier<T extends OfflineFirstWithSupabaseModel> {
  final GenericRepository<T> _repository;
  StreamSubscription<List<T>>? _subscription;
  AsyncValue<List<T>> state = const AsyncValue.loading();

  /// Constructor
  GenericModelNotifier(this._repository) {
    dev.log('Creating GenericModelNotifier for ${T.toString()}');
    // Set up initial data
    _initialize();
  }

  /// Initialize the notifier
  Future<void> _initialize() async {
    try {
      dev.log('Initializing GenericModelNotifier for ${T.toString()}');

      // Set up a subscription to the models stream for reactivity
      _listenToModels();

      // Get initial data
      dev.log('Fetching initial data for ${T.toString()}');
      final initialModels = await _repository.getAll();
      dev.log('Received ${initialModels.length} ${T.toString()} models');

      state = AsyncValue.data(initialModels);
      dev.log('State updated to data for ${T.toString()}');
    } catch (error, stackTrace) {
      dev.log('Error initializing ${T.toString()}: $error',
          error: error, stackTrace: stackTrace);
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Sets up a subscription to the models stream
  void _listenToModels() {
    dev.log('Setting up subscription for ${T.toString()}');
    _subscription?.cancel();
    _subscription = _repository.watch().listen((models) {
      // Update state when new models arrive
      dev.log(
          'Stream update: received ${models.length} ${T.toString()} models');
      state = AsyncValue.data(models);
    }, onError: (error, stackTrace) {
      dev.log('Stream error for ${T.toString()}: $error',
          error: error, stackTrace: stackTrace);
      state = AsyncValue.error(error, stackTrace);
    });
  }

  /// Dispose resources
  void dispose() {
    dev.log('Disposing GenericModelNotifier for ${T.toString()}');
    _subscription?.cancel();
    _subscription = null;
  }

  /// Refreshes the list of models
  Future<void> refresh() async {
    dev.log('Refreshing ${T.toString()} models');
    state = const AsyncValue.loading();

    try {
      final models = await _repository.getAll();
      dev.log('Refresh complete: got ${models.length} ${T.toString()} models');
      state = AsyncValue.data(models);
    } catch (error, stackTrace) {
      dev.log('Error refreshing ${T.toString()}: $error',
          error: error, stackTrace: stackTrace);
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Creates a new model
  Future<void> create(T model) async {
    dev.log('Creating ${T.toString()} model');
    await _repository.upsert(model);
    dev.log('${T.toString()} model created');
    // State will be updated via the stream subscription
  }

  /// Updates an existing model
  Future<void> updateModel(T model) async {
    dev.log('Updating ${T.toString()} model');
    await _repository.upsert(model);
    dev.log('${T.toString()} model updated');
    // State will be updated via the stream subscription
  }

  /// Deletes a model
  Future<void> delete(T model) async {
    dev.log('Deleting ${T.toString()} model');
    await _repository.delete(model);
    dev.log('${T.toString()} model deleted');
    // State will be updated via the stream subscription
  }

  /// Forces synchronization with the server
  Future<void> syncWithServer() async {
    dev.log('Syncing ${T.toString()} models with server');
    await _repository.sync();
    dev.log('Server sync completed for ${T.toString()}');
    await refresh();
  }

  /// Gets models with a specific query
  Future<List<T>> getWhere({required Query query}) async {
    dev.log('Querying ${T.toString()} models with: ${query.toString()}');
    final result = await _repository.getWhere(query: query);
    dev.log('Query returned ${result.length} ${T.toString()} models');
    return result;
  }

  /// Gets a specific model by ID
  Future<T?> getById(String id) async {
    dev.log('Getting ${T.toString()} by ID: $id');
    final result = await _repository.getById(id);
    dev.log('GetById result: ${result != null ? 'found' : 'not found'}');
    return result;
  }
}
