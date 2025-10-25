import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart' show SqliteProvider;
import 'package:brick_sqlite/memory_cache_provider.dart'
    show MemoryCacheProvider;
import 'package:brick_supabase/brick_supabase.dart' hide Supabase;
import 'package:revier_app_client/brick/brick.g.dart';
import 'package:revier_app_client/brick/db/schema.g.dart';
import 'package:revier_app_client/core/services/logging_service.dart';
import 'package:sqflite/sqflite.dart' show databaseFactory;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:revier_app_client/brick/models/upload.model.dart';
import 'package:revier_app_client/brick/models/hunting_ground_user_role.model.dart';
import 'package:revier_app_client/brick/models/sighting_tag.model.dart';
import 'package:brick_core/query.dart' show Query, Where;
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';

const String sqliteDbName = "revier_app_client.sqlite";
const String brickQueueDbName = "brick_offline_queue.sqlite";

/// Repository implementation for offline-first capabilities with Supabase
/// Based on the Brick documentation
class BrickRepository extends OfflineFirstWithSupabaseRepository {
  /// Singleton instance
  static BrickRepository? _instance;

  /// Connectivity instance
  final Connectivity _connectivity = Connectivity();

  /// Supabase client cache
  late SupabaseClient _supabaseClient;

  static final _log = loggingService.getLogger('BrickRepository');

  /// Private constructor
  BrickRepository._({
    required SupabaseProvider supabaseProvider,
    required super.sqliteProvider,
    required super.migrations,
    required super.offlineRequestQueue,
    super.memoryCacheProvider,
  }) : super(supabaseProvider: supabaseProvider) {
    // Cache the Supabase client for direct access
    _supabaseClient = supabaseProvider.client;
  }

  /// Factory constructor to access singleton
  factory BrickRepository() {
    if (_instance == null) {
      throw StateError(
        'BrickRepository has not been initialized. '
        'Call BrickRepository.configure() before accessing the instance.',
      );
    }
    return _instance!;
  }

  /// Configure the repository
  static Future<void> configure(
      String supabaseUrl, String supabaseAnonKey) async {
    _log.info('Configuring BrickRepository...');
    _log.info('Using Supabase URL: $supabaseUrl');

    // Create the repository if it doesn't exist
    if (_instance == null) {
      await _createRepository(supabaseUrl, supabaseAnonKey);
    }
  }

  /// Helper method to create the repository instance
  static Future<void> _createRepository(
      String supabaseUrl, String supabaseAnonKey) async {
    _log.info('Creating BrickRepository instance...');

    try {
      // if dev mode delete database
      if (kDebugMode) {
        await databaseFactory.deleteDatabase(sqliteDbName);
        await databaseFactory.deleteDatabase(brickQueueDbName);
      }
      // First verify that we can connect to the Supabase instance
      await _testSupabaseConnection(supabaseUrl, supabaseAnonKey);

      final (client, queue) = OfflineFirstWithSupabaseRepository.clientQueue(
        // For Flutter, use import 'package:sqflite/sqflite.dart' show databaseFactory;
        // For unit testing (even in Flutter), use import 'package:sqflite_common_ffi/sqflite_ffi.dart' show databaseFactory;
        databaseFactory: databaseFactory,
        databasePath: brickQueueDbName,
      );

      client.onReattempt = (request, statusCode) {
        _log.info('Reattempting request: $request, status code: $statusCode');
      };

      // Create SQL provider
      final sqliteProvider = SqliteProvider(
        sqliteDbName,
        databaseFactory: databaseFactory,
        modelDictionary: sqliteModelDictionary,
        // migrationManager: migrationManager,
      );

      // Get the Supabase client
      await Supabase.initialize(
          url: supabaseUrl, anonKey: supabaseAnonKey, httpClient: client);

      // Create Supabase provider
      final supabaseProvider = SupabaseProvider(
        Supabase.instance.client,
        modelDictionary: supabaseModelDictionary,
      );

      // Create the repository instance
      _instance = BrickRepository._(
        sqliteProvider: sqliteProvider,
        supabaseProvider: supabaseProvider,
        offlineRequestQueue: queue,
        migrations: migrations,
        memoryCacheProvider: MemoryCacheProvider(),
      );

      if (kDebugMode) {
        await _instance!.reset();
      }
      _log.info('BrickRepository created successfully');
    } catch (e, stack) {
      _log.error('Error creating BrickRepository', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Initialize the repository
  @override
  Future<void> initialize() async {
    _log.info('Initializing BrickRepository...');

    try {
      // First call the parent's initialize
      await super.initialize();

      // Set up connectivity monitoring for automatic sync
      setupConnectivitySubscription();

      // Check if we can process the queue
      _log.info('Checking offline queue status...');

      _log.info('BrickRepository initialized successfully');
    } catch (e, stack) {
      _log.error('Error initializing BrickRepository',
          error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Set up connectivity monitoring to trigger sync when connection is restored
  void setupConnectivitySubscription() {
    // Subscribe to connectivity changes to sync data when online
    _connectivity.onConnectivityChanged.listen((status) async {
      if (status == ConnectivityResult.wifi ||
          status == ConnectivityResult.mobile ||
          status == ConnectivityResult.ethernet) {
        _log.info('💻 Connected to the internet, syncing data...');
        await syncAll();
      }
    });
  }

  static Future<void> _testSupabaseConnection(
      String supabaseUrl, String supabaseAnonKey) async {
    try {
      final testResponse = await http
          .get(Uri.parse('$supabaseUrl/rest/v1/?apikey=$supabaseAnonKey'));
      _log.info(
          'Supabase connection test - status code: ${testResponse.statusCode}');
      _log.info('Response headers: ${testResponse.headers}');
      if (testResponse.statusCode >= 400) {
        _log.info(
            'Warning: Supabase connection test failed with status ${testResponse.statusCode}');
        _log.info('Response body: ${testResponse.body}');
      }
    } catch (e, stack) {
      _log.error('Warning: Failed to connect to Supabase',
          error: e, stackTrace: stack);
      // Continue anyway, as we still want offline functionality
    }
  }

  /// Helper method to sync all supported models with remote data
  Future<void> syncAll() async {
    _log.info('Syncing all models with Supabase...');
    try {
      // Sync all known model types explicitly
      await syncModel<Upload>();
      await syncModel<HuntingGroundUserRole>();
      await syncModel<SightingTag>();

      // Add more model types here as they're implemented

      _log.info('Refreshed data from remote sources');
    } catch (e, stack) {
      _log.error('Error syncing with Supabase', error: e, stackTrace: stack);
    }
  }

  /// Sync a specific model type with remote data
  Future<void> syncModel<T extends OfflineFirstWithSupabaseModel>() async {
    _log.info('Syncing model ${T.toString()} with Supabase...');
    try {
      // This will get the latest data from Supabase and update local SQLite
      await get<T>();
      _log.info('Synced ${T.toString()} successfully');
    } catch (e, stack) {
      _log.error('Error syncing ${T.toString()}', error: e, stackTrace: stack);
    }
  }

  /// Get the table name for a model type
  String? getTableName<T extends OfflineFirstWithSupabaseModel>() {
    // Simple table name mapping based on model class name
    // This approach avoids reflection but requires explicit mappings
    final type = T.toString();
    final mapping = {
      'Upload': 'upload',
      'HuntingGroundsMember': 'hunting_grounds_members',
      'SightingTag': 'sighting_tags',
      // Add more mappings as needed
    };

    final tableName = mapping[type.replaceAll(RegExp(r'^.*\.'), '')];
    if (tableName == null) {
      _log.error('No table mapping found for type: $type');
    }
    return tableName;
  }

  /// Force a direct synchronization for any model bypassing the queue
  Future<void> forceSyncModel<T extends OfflineFirstWithSupabaseModel>(
      T model) async {
    _log.info('Force syncing model ${T.toString()} with Supabase directly...');
    try {
      // Get the table name
      final tableName = getTableName<T>();
      if (tableName == null) {
        _log.error('Could not determine table name for ${T.toString()}');
        return;
      }

      // Convert model to JSON for Supabase
      Map<String, dynamic> data;

      // Try to convert the model to a map using toJson
      try {
        data = (model as dynamic).toJson();

        // Check if the model exists in Supabase before updating
        final existingResponse = await _supabaseClient
            .from(tableName)
            .select()
            .eq('id', data['id'])
            .maybeSingle();

        // If it exists and hasn't changed, don't update the updated_at field
        if (existingResponse != null) {
          // Compare relevant fields to see if anything has actually changed
          // Exclude updated_at from comparison
          final existingData = Map<String, dynamic>.from(existingResponse);
          final compareData = Map<String, dynamic>.from(data);

          // Remove fields we don't want to compare
          existingData.remove('updated_at');
          compareData.remove('updated_at');

          // If the data hasn't changed, keep the original updated_at
          if (_mapsAreEqual(existingData, compareData)) {
            data['updated_at'] = existingResponse['updated_at'];
          }
        }
      } catch (e, stack) {
        _log.error('Error converting model to JSON',
            error: e, stackTrace: stack);
        return; // Early exit since we can't properly serialize
      }

      // Direct upsert using Supabase client
      final response =
          await _supabaseClient.from(tableName).upsert(data).select();

      _log.info('Direct upsert response: $response');
      _log.info('Force synced ${T.toString()} with Supabase');
    } catch (e, stack) {
      _log.error('Error force syncing ${T.toString()}',
          error: e, stackTrace: stack);
    }
  }

  // Helper method to compare maps for equality
  bool _mapsAreEqual(Map<String, dynamic> map1, Map<String, dynamic> map2) {
    if (map1.length != map2.length) return false;

    for (final key in map1.keys) {
      if (!map2.containsKey(key)) return false;

      final value1 = map1[key];
      final value2 = map2[key];

      if (value1 != value2) return false;
    }

    return true;
  }

  /// Force sync all instances of a given model type
  Future<void>
      forceSyncAllOfType<T extends OfflineFirstWithSupabaseModel>() async {
    _log.info('Force syncing all instances of ${T.toString()}...');
    try {
      // Get all local instances
      final models = await get<T>();
      _log.info('Found ${models.length} ${T.toString()} to sync');

      // Force sync each instance
      int successCount = 0;
      for (final model in models) {
        await forceSyncModel<T>(model);
        successCount++;
      }

      _log.info(
          'Successfully force synced $successCount/${models.length} ${T.toString()}');
    } catch (e, stack) {
      _log.error('Error force syncing all ${T.toString()}',
          error: e, stackTrace: stack);
    }
  }

  /// Update a field for any model using a generic approach
  Future<bool> updateField<T extends OfflineFirstWithSupabaseModel>({
    required String id,
    required Map<String, dynamic> updates,
  }) async {
    final typeName = T.toString();
    _log.info('Updating $typeName with ID: $id');
    try {
      // Get the table name
      final tableName = getTableName<T>();
      if (tableName == null) {
        _log.error('Could not determine table name for $typeName');
        return false;
      }

      // Add updated_at timestamp
      final updateData = {
        ...updates,
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Use the cached Supabase client
      await _supabaseClient.from(tableName).update(updateData).eq('id', id);

      // Force sync to update local database
      await syncModel<T>();

      _log.info('$typeName updated successfully');
      return true;
    } catch (e, stack) {
      _log.error('Error updating $typeName', error: e, stackTrace: stack);
      return false;
    }
  }

  /// Soft delete a model by ID
  Future<bool> softDelete<T extends OfflineFirstWithSupabaseModel>(
      String id) async {
    final typeName = T.toString();
    _log.info('Soft deleting $typeName with ID: $id');
    try {
      // Get the table name
      final tableName = getTableName<T>();
      if (tableName == null) {
        _log.error('Could not determine table name for $typeName');
        return false;
      }

      // First get the model to delete using standard repository method
      final models = await get<T>(
        query: Query(where: [Where.exact('id', id)]),
      );

      if (models.isEmpty) {
        _log.error('Model not found for soft deletion');
        return false;
      }

      final model = models.first;

      // IMPORTANT: Use standard delete method first to queue proper DELETE operation
      // This ensures proper sync with Supabase
      final deleteResult = await delete<T>(model);
      _log.info('Model queued for deletion: $deleteResult');

      // After queuing the DELETE, also mark the record as soft deleted
      // in case we want to restore it later or maintain an audit trail
      final now = DateTime.now().toIso8601String();

      try {
        // Direct update to Supabase for soft delete fields
        await _supabaseClient.from(tableName).update({
          'is_deleted': true,
          'deleted_at': now,
          'updated_at': now,
        }).eq('id', id);
        _log.info('Soft delete fields updated in Supabase');
      } catch (e, stack) {
        _log.error('Warning: Could not update soft delete fields',
            error: e, stackTrace: stack);
        // Continue anyway as the DELETE operation is already queued
      }

      _log.info('$typeName soft deleted successfully');
      return deleteResult;
    } catch (e, stack) {
      _log.error('Error soft deleting $typeName', error: e, stackTrace: stack);
      return false;
    }
  }
}
