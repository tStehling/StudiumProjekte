import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brick_core/query.dart';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:revier_app_client/brick/models/country.model.dart';
import 'package:revier_app_client/brick/models/federal_state.model.dart';
import 'package:revier_app_client/brick/models/species.model.dart';
import 'package:revier_app_client/core/services/logging_service.dart';
import 'package:revier_app_client/data/model_registry.dart';
import 'package:revier_app_client/data/providers/model_registry_provider.dart';
import 'package:revier_app_client/common/model_management/field_config.dart';

/// A service for loading and caching reference data
///
/// This service helps load reference data that is used across multiple forms,
/// such as Species, Tags, WeatherConditions, etc. It caches the data to prevent
/// redundant database calls when the same reference data is needed in multiple places.
class ReferenceDataService {
  final ModelRegistry _modelRegistry;
  final Map<String, List<DropdownOption>> _optionsCache = {};
  final _log = loggingService.getLogger('ReferenceDataService');

  /// Constructor
  ReferenceDataService(this._modelRegistry);

  /// Clears all cached data
  void clearCache() {
    _log.debug('Clearing all cached data');
    _optionsCache.clear();
  }

  /// Clears cached options for a specific key pattern
  void clearOptionsCache(String keyPattern) {
    _log.debug('Clearing cached data for $keyPattern');
    _optionsCache.removeWhere((key, _) => key.startsWith(keyPattern));
  }

  /// Gets reference data for a specific model type
  ///
  /// Uses the model registry directly since the sync service was redesigned
  Future<List<T>> getReferenceData<T extends OfflineFirstWithSupabaseModel>(
      WidgetRef ref) async {
    try {
      final result =
          await _modelRegistry.getWhere<T>(ref, query: const Query());

      if (result.isEmpty) {
        _log.warning('No ${T.toString()} records found!');
      }

      return result;
    } catch (e, stackTrace) {
      _log.error('Error fetching ${T.toString()}',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Gets dropdown options for a specific model type
  ///
  /// Uses cached options if available, otherwise converts reference data to options
  Future<List<DropdownOption>>
      getDropdownOptions<T extends OfflineFirstWithSupabaseModel>(
    WidgetRef ref, {
    required String valueField,
    required String labelField,
    String? cacheKey,
    String? Function(T)? labelFormatter,
    String? subtitleField,
    bool includeEmpty = false,
    String emptyLabel = '-- Select --',
    bool forceRefresh = false,
    int page = 0,
    int pageSize = 50,
  }) async {
    // Generate a cache key
    final String typeStr = T.toString();
    final key = cacheKey ?? '${typeStr}_${valueField}_$labelField';

    // Check cache first, unless force refresh is requested
    if (!forceRefresh &&
        _optionsCache.containsKey(key) &&
        _optionsCache[key]!.isNotEmpty) {
      return _optionsCache[key]!;
    }

    // Fetch data
    final entities = await getReferenceData<T>(ref);

    // Convert to options
    final options = <DropdownOption>[];

    // Add empty option if requested
    if (includeEmpty) {
      options.add(DropdownOption(value: '', label: emptyLabel));
    }

    // Convert entities to options
    int successCount = 0;
    int errorCount = 0;

    // Apply pagination
    final int startIndex = page * pageSize;
    final int endIndex = startIndex + pageSize;

    final paginatedEntities = entities.length > startIndex
        ? entities.sublist(
            startIndex, endIndex < entities.length ? endIndex : entities.length)
        : <T>[];

    for (final entity in paginatedEntities) {
      try {
        // Get the value based on field name
        final dynamic value = _getEntityFieldValue(entity, valueField);
        if (value == null) {
          errorCount++;
          continue;
        }

        String label;
        if (labelFormatter != null) {
          label = labelFormatter(entity) ?? 'Unknown';
        } else {
          final dynamic labelValue = _getEntityFieldValue(entity, labelField);
          label = labelValue?.toString() ?? 'Unknown';
        }

        String? subtitle;
        if (subtitleField != null) {
          final dynamic subtitleValue =
              _getEntityFieldValue(entity, subtitleField);
          subtitle = subtitleValue?.toString();
        }

        options.add(DropdownOption(
          value: value,
          label: label,
          subtitle: subtitle,
        ));
        successCount++;
      } catch (e, stackTrace) {
        errorCount++;
        _log.error('Error converting entity to option',
            error: e, stackTrace: stackTrace);
      }
    }

    // Ensure options are unique
    final uniqueOptions = _ensureUniqueOptions(options, typeStr);

    // Cache the options
    _optionsCache[key] = uniqueOptions;

    // Log a warning if no options were generated
    if (uniqueOptions.isEmpty) {
      _log.warning('No options generated for $typeStr!');
    }

    return uniqueOptions;
  }

  /// Helper method to ensure options have unique values
  List<DropdownOption> _ensureUniqueOptions(
    List<DropdownOption> options,
    String optionType,
  ) {
    final valueSet = <dynamic>{};
    final uniqueOptions = <DropdownOption>[];

    for (final option in options) {
      if (!valueSet.contains(option.value)) {
        valueSet.add(option.value);
        uniqueOptions.add(option);
      } else {
        _log.warning(
            'Duplicate $optionType option value found: ${option.value}');
      }
    }

    if (options.length != uniqueOptions.length) {
      _log.info(
          'Filtered ${options.length - uniqueOptions.length} duplicate $optionType options');
    }

    return uniqueOptions;
  }

  /// Convenience method to get country dropdown options
  Future<List<DropdownOption>> getCountryOptions(
    WidgetRef ref, {
    bool includeEmpty = false,
    String emptyLabel = '-- Select Country --',
    int page = 0,
    int pageSize = 50,
  }) async {
    return await getDropdownOptions<Country>(
      ref,
      valueField: 'id',
      labelField: 'name',
      includeEmpty: includeEmpty,
      emptyLabel: emptyLabel,
      page: page,
      pageSize: pageSize,
    );
  }

  /// Convenience method to get federal state dropdown options
  Future<List<DropdownOption>> getFederalStateOptions(
    WidgetRef ref, {
    bool includeEmpty = false,
    String emptyLabel = '-- Select Federal State --',
    String? countryId,
    int page = 0,
    int pageSize = 50,
  }) async {
    final options = await getDropdownOptions<FederalState>(
      ref,
      valueField: 'id',
      labelField: 'name',
      includeEmpty: includeEmpty,
      emptyLabel: emptyLabel,
      page: page,
      pageSize: pageSize,
    );

    // Filter by country if specified
    if (countryId != null && countryId.isNotEmpty) {
      final states = await getReferenceData<FederalState>(ref);
      final filteredOptions = options.where((option) {
        // Skip the empty option if present
        if (option.value == '') return true;

        // Find the corresponding state and check country
        try {
          final state = states.firstWhere((s) => s.id == option.value);
          return state.countryId == countryId;
        } catch (e) {
          return false;
        }
      }).toList();

      return filteredOptions;
    }

    return options;
  }

  /// Convenience method to get species dropdown options
  Future<List<DropdownOption>> getSpeciesOptions(
    WidgetRef ref, {
    bool includeEmpty = false,
    String emptyLabel = '-- Select Species --',
    int page = 0,
    int pageSize = 50,
  }) async {
    return await getDropdownOptions<Species>(
      ref,
      valueField: 'id',
      labelField: 'name',
      includeEmpty: includeEmpty,
      emptyLabel: emptyLabel,
      page: page,
      pageSize: pageSize,
    );
  }

  /// Helper method to get a field value from an entity using reflection
  dynamic _getEntityFieldValue(dynamic entity, String fieldName) {
    // This is a simplified approach - in a real app you might use reflection
    // or a more robust way to access fields
    try {
      final fieldParts = fieldName.split('.');
      dynamic value = entity;

      for (final part in fieldParts) {
        if (value == null) return null;

        // Use Dart's mirror capabilities or simply try/catch to access properties
        // Here we use a simple approach that works for common Brick model patterns
        if (value is Map) {
          value = value[part];
        } else {
          // Try to access the property by name
          value = _getObjectProperty(value, part);
        }
      }

      return value;
    } catch (e) {
      _log.error('Error accessing field $fieldName', error: e);
      return null;
    }
  }

  /// Helper method to get an object property by name
  dynamic _getObjectProperty(dynamic object, String propertyName) {
    // This is a simple approach that works for common properties
    // In a real app, you might use reflection or code generation
    switch (propertyName) {
      case 'id':
        return object.id;
      case 'name':
        return object.name;
      case 'title':
        return object.title;
      case 'description':
        return object.description;
      // Add other common property names as needed
      default:
        // Try to access the property dynamically
        try {
          // This is a very simplified approach and won't work in all cases
          final value = object.toJson()[propertyName];
          return value;
        } catch (e) {
          _log.error(
              'Property not found: $propertyName on ${object.runtimeType}',
              error: e);
          return null;
        }
    }
  }
}

/// Provider for the ReferenceDataService
final referenceDataServiceProvider = Provider<ReferenceDataService>((ref) {
  final modelRegistry = ref.watch(modelRegistryProvider);
  final service = ReferenceDataService(modelRegistry);
  return service;
});
