import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:revier_app_client/common/widgets/collections/core_collection_type.dart';
import 'package:revier_app_client/core/services/logging_service.dart';

/// Utility class for collection related operations
class CollectionUtils {
  static final _logger = loggingService.getLogger('CollectionUtils');

  /// Filter entities based on a search query using a search function
  static List<T> applySearchFilter<T>({
    required List<T> entities,
    required String searchQuery,
    required String Function(T) searchFunction,
  }) {
    if (searchQuery.isEmpty) {
      return List.from(entities);
    }

    final lowercaseQuery = searchQuery.toLowerCase();
    final filteredEntities = entities.where((entity) {
      final searchText = searchFunction(entity).toLowerCase();
      return searchText.contains(lowercaseQuery);
    }).toList();

    _logger.debug(
        'Applied search filter "$lowercaseQuery", found ${filteredEntities.length} matches');
    return filteredEntities;
  }

  /// Sort a list of entities by a specific field and direction
  /// This method works with any type but has special handling for OfflineFirstWithSupabaseModel
  static List<T> applySorting<T>({
    required List<T> entities,
    required String? sortField,
    required bool ascending,
    String defaultField = 'updatedAt',
  }) {
    if (entities.isEmpty) {
      return entities;
    }

    final effectiveSortField = sortField ?? defaultField;
    _logger.debug(
        'Sorting ${entities.length} entities by $effectiveSortField (${ascending ? 'ascending' : 'descending'})');

    final sortedEntities = List<T>.from(entities);

    try {
      sortedEntities.sort((a, b) {
        // Handle OfflineFirstWithSupabaseModel types for common fields
        if (a is OfflineFirstWithSupabaseModel &&
            b is OfflineFirstWithSupabaseModel) {
          // Handle timestamp fields commonly found in these models
          if (effectiveSortField == 'updatedAt') {
            final aTime = (a as dynamic).updatedAt;
            final bTime = (b as dynamic).updatedAt;

            if (aTime == null && bTime == null) return 0;
            if (aTime == null) return ascending ? -1 : 1;
            if (bTime == null) return ascending ? 1 : -1;

            return ascending ? aTime.compareTo(bTime) : bTime.compareTo(aTime);
          }

          if (effectiveSortField == 'createdAt') {
            final aTime = (a as dynamic).createdAt;
            final bTime = (b as dynamic).createdAt;

            if (aTime == null && bTime == null) return 0;
            if (aTime == null) return ascending ? -1 : 1;
            if (bTime == null) return ascending ? 1 : -1;

            return ascending ? aTime.compareTo(bTime) : bTime.compareTo(aTime);
          }
        }

        // For other fields, use dynamic access
        dynamic aValue = _getFieldValue(a, effectiveSortField);
        dynamic bValue = _getFieldValue(b, effectiveSortField);

        // Handle null values
        if (aValue == null && bValue == null) return 0;
        if (aValue == null) return ascending ? -1 : 1;
        if (bValue == null) return ascending ? 1 : -1;

        // Handle different data types
        if (aValue is num && bValue is num) {
          return ascending
              ? aValue.compareTo(bValue)
              : bValue.compareTo(aValue);
        } else if (aValue is String && bValue is String) {
          return ascending
              ? aValue.compareTo(bValue)
              : bValue.compareTo(aValue);
        } else if (aValue is bool && bValue is bool) {
          return ascending
              ? aValue.toString().compareTo(bValue.toString())
              : bValue.toString().compareTo(aValue.toString());
        } else if (aValue is DateTime && bValue is DateTime) {
          return ascending
              ? aValue.compareTo(bValue)
              : bValue.compareTo(aValue);
        } else {
          // Convert to strings for comparison as a fallback
          return ascending
              ? aValue.toString().compareTo(bValue.toString())
              : bValue.toString().compareTo(aValue.toString());
        }
      });

      _logger.debug('Sorting completed successfully');
      return sortedEntities;
    } catch (e) {
      _logger.error('Error sorting entities', error: e);
      return entities; // Return original list on error
    }
  }

  /// Helper method to safely access field value via dynamic
  static dynamic _getFieldValue(dynamic entity, String fieldName) {
    try {
      // Use dynamic to access properties at runtime
      if (fieldName == 'name') {
        return entity.name;
      } else if (fieldName == 'title') {
        return entity.title;
      } else if (fieldName == 'updatedAt') {
        return entity.updatedAt;
      } else if (fieldName == 'createdAt') {
        return entity.createdAt;
      }

      // Try to access via getter dynamically
      try {
        return entity[fieldName] ?? entity.$fieldName;
      } catch (_) {
        // Ignore dynamic access errors
      }

      // Try to access via reflection (simplified)
      try {
        if (entity is OfflineFirstWithSupabaseModel) {
          final map = (entity as dynamic).toJson();
          if (map is Map && map.containsKey(fieldName)) {
            return map[fieldName];
          }
        }
      } catch (_) {
        // Ignore toJson errors
      }

      return null;
    } catch (e) {
      _logger.warning('Error accessing field "$fieldName": $e');
      return null;
    }
  }

  /// Convert model entities to CoreCollectionItemType objects for display
  static List<CoreCollectionItemType> convertToCoreCollectionItems<T>({
    required List<T> entities,
    required String Function(T) titleProvider,
    String Function(T)? subtitleProvider,
    String Function(T)? imagePathProvider,
  }) {
    return entities.map((entity) {
      final title = titleProvider(entity);
      final subtitle = subtitleProvider?.call(entity) ?? '';
      final imagePath = imagePathProvider?.call(entity) ?? '';

      return (
        imagePath: imagePath,
        title: title,
        subtitle: subtitle,
      );
    }).toList();
  }
}
