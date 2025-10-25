import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brick_core/query.dart';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:revier_app_client/brick/models/country.model.dart';
import 'package:revier_app_client/brick/models/federal_state.model.dart';
import 'package:revier_app_client/brick/models/hunting_season.model.dart';
import 'package:revier_app_client/brick/models/allowed_caliber.model.dart';
import 'package:revier_app_client/brick/models/species.model.dart';
import 'package:revier_app_client/data/model_registry.dart';
import 'package:revier_app_client/data/providers/model_registry_provider.dart';
import 'package:revier_app_client/data/providers/widget_ref_provider.dart';

/// A service that ensures reference data is synchronized and available offline
class ReferenceDataSyncService {
  final ModelRegistry _modelRegistry;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Timer? _periodicSyncTimer;
  bool _initialSyncCompleted = false;

  // Track the sync status for each reference data type
  final Map<Type, bool> _syncStatus = {
    Country: false,
    FederalState: false,
    HuntingSeason: false,
    AllowedCaliber: false,
    Species: false,
  };

  ReferenceDataSyncService(this._modelRegistry) {
    // Listen for connectivity changes
    _setupConnectivityListener();

    // Set up periodic sync every 6 hours
    _setupPeriodicSync();
  }

  /// Set up a listener for connectivity changes
  void _setupConnectivityListener() {
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((results) {
      // When connectivity is restored, sync reference data
      if (results.isNotEmpty &&
          results.any((result) => result != ConnectivityResult.none)) {
        // Trigger sync - actual implementation will be done in the main app with WidgetRef
        _markForSync();
      }
    });
  }

  /// Set up periodic sync
  void _setupPeriodicSync() {
    // Sync every 6 hours
    _periodicSyncTimer =
        Timer.periodic(const Duration(hours: 6), (timer) async {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.isNotEmpty &&
          connectivityResult
              .any((result) => result != ConnectivityResult.none)) {
        // Trigger sync - actual implementation will be done in the main app with WidgetRef
        _markForSync();
      }
    });
  }

  /// Mark all data types for sync
  void _markForSync() {
    _syncStatus.updateAll((key, value) => false);
    debugPrint('ReferenceDataSyncService: All types marked for sync');
  }

  /// Check if sync is needed for a type
  bool needsSync<T>() {
    return _syncStatus[T] == false;
  }

  /// Mark a type as synced
  void markAsSynced<T>() {
    _syncStatus[T] = true;
    debugPrint('ReferenceDataSyncService: ${T.toString()} marked as synced');
  }

  /// Check if initial sync is completed
  bool get isInitialSyncCompleted => _initialSyncCompleted;

  /// Mark initial sync as completed
  void completeInitialSync() {
    _initialSyncCompleted = true;
    debugPrint('ReferenceDataSyncService: Initial sync marked as completed');
  }

  /// Get the sync status for a specific reference data type
  bool getSyncStatus<T>() {
    return _syncStatus[T] ?? false;
  }

  /// Clean up resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _periodicSyncTimer?.cancel();
  }
}

/// Provider for the reference data sync service
final referenceDataSyncServiceProvider =
    Provider<ReferenceDataSyncService>((ref) {
  final modelRegistry = ref.watch(modelRegistryProvider);
  final service = ReferenceDataSyncService(modelRegistry);

  // Automatically dispose the service when no longer needed
  ref.onDispose(() => service.dispose());

  return service;
});

/// Helper classes for safe type handling without direct casting
class RefAdapter {
  static T getValue<T>(Ref ref, Provider<T> provider) {
    return ref.read(provider);
  }

  static void syncReferenceType<T extends OfflineFirstWithSupabaseModel>(
      WidgetRef ref, ModelRegistry modelRegistry) async {
    try {
      await modelRegistry.sync<T>(ref);
    } catch (e) {
      debugPrint('Error syncing ${T.toString()}: $e');
    }
  }
}

/// Provider to initialize synchronization, must be used in a Widget context
final referenceDataSyncInitializerProvider = Provider<bool>((ref) {
  // This needs to be used with a Consumer in a widget to actually perform syncs
  return true;
});

/// Providers for each reference data type
final countriesProvider = Provider<Future<List<Country>>>((ref) {
  final modelRegistry = ref.read(modelRegistryProvider);
  final query = Query();

  // Return a future that will be executed when accessed
  return Future<List<Country>>(() async {
    // Directly use the model registry
    try {
      return await modelRegistry.getWhere<Country>(ref.read(widgetRefProvider),
          query: query);
    } catch (e) {
      debugPrint('Error fetching Country data: $e');
      return [];
    }
  });
});

final federalStatesProvider = Provider<Future<List<FederalState>>>((ref) {
  final modelRegistry = ref.read(modelRegistryProvider);
  final query = Query();

  return Future<List<FederalState>>(() async {
    try {
      return await modelRegistry
          .getWhere<FederalState>(ref.read(widgetRefProvider), query: query);
    } catch (e) {
      debugPrint('Error fetching FederalState data: $e');
      return [];
    }
  });
});

final huntingSeasonsProvider = Provider<Future<List<HuntingSeason>>>((ref) {
  final modelRegistry = ref.read(modelRegistryProvider);
  final query = Query();

  return Future<List<HuntingSeason>>(() async {
    try {
      return await modelRegistry
          .getWhere<HuntingSeason>(ref.read(widgetRefProvider), query: query);
    } catch (e) {
      debugPrint('Error fetching HuntingSeason data: $e');
      return [];
    }
  });
});

final allowedCalibersProvider = Provider<Future<List<AllowedCaliber>>>((ref) {
  final modelRegistry = ref.read(modelRegistryProvider);
  final query = Query();

  return Future<List<AllowedCaliber>>(() async {
    try {
      return await modelRegistry
          .getWhere<AllowedCaliber>(ref.read(widgetRefProvider), query: query);
    } catch (e) {
      debugPrint('Error fetching AllowedCaliber data: $e');
      return [];
    }
  });
});

final speciesProvider = Provider<Future<List<Species>>>((ref) {
  final modelRegistry = ref.read(modelRegistryProvider);
  final query = Query();

  return Future<List<Species>>(() async {
    try {
      return await modelRegistry.getWhere<Species>(ref.read(widgetRefProvider),
          query: query);
    } catch (e) {
      debugPrint('Error fetching Species data: $e');
      return [];
    }
  });
});
