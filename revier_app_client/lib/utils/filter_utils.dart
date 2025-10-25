import 'package:revier_app_client/core/services/logging_service.dart';

/// Utility class for filtering operations on collections
class FilterUtils {
  static final _logger = loggingService.getLogger('FilterUtils');

  /// Filter entities based on a search query and multiple field values
  ///
  /// This is a more complex search that can look through multiple fields
  static List<T> applyMultiFieldSearch<T>({
    required List<T> entities,
    required String searchQuery,
    required List<String> searchableFields,
    required dynamic Function(T entity, String field) fieldValueGetter,
    required String Function(String field, dynamic value) formatFieldValue,
  }) {
    if (searchQuery.isEmpty) {
      return List.from(entities);
    }

    final lowercaseQuery = searchQuery.toLowerCase();
    _logger.debug('Applying multi-field search with query: "$lowercaseQuery"');

    final filteredEntities = entities.where((entity) {
      for (final field in searchableFields) {
        final value = fieldValueGetter(entity, field);
        if (value != null) {
          final stringValue = formatFieldValue(field, value);
          if (stringValue.toLowerCase().contains(lowercaseQuery)) {
            return true;
          }
        }
      }
      return false;
    }).toList();

    _logger.debug(
        'Filter complete, found ${filteredEntities.length} matches out of ${entities.length}');
    return filteredEntities;
  }

  /// Apply custom filter function to a list of entities
  static List<T> applyCustomFilter<T>({
    required List<T> entities,
    required bool Function(T entity) filterFunction,
  }) {
    final filteredEntities = entities.where(filterFunction).toList();

    _logger.debug(
        'Applied custom filter, found ${filteredEntities.length} matches out of ${entities.length}');
    return filteredEntities;
  }

  /// Filter entities based on a query parameter matching a field value
  static List<T> applyFieldFilter<T>({
    required List<T> entities,
    required String fieldName,
    required dynamic fieldValue,
    required dynamic Function(T entity, String field) fieldValueGetter,
  }) {
    _logger.debug('Filtering by field $fieldName = $fieldValue');

    final filteredEntities = entities.where((entity) {
      final value = fieldValueGetter(entity, fieldName);

      // Handle null values
      if (value == null && fieldValue == null) return true;
      if (value == null || fieldValue == null) return false;

      // Handle different types
      if (value is String && fieldValue is String) {
        return value.toLowerCase() == fieldValue.toLowerCase();
      } else {
        return value == fieldValue;
      }
    }).toList();

    _logger.debug(
        'Field filter complete, found ${filteredEntities.length} matches out of ${entities.length}');
    return filteredEntities;
  }

  /// Filter entities based on a date range
  static List<T> applyDateRangeFilter<T>({
    required List<T> entities,
    required String dateField,
    DateTime? startDate,
    DateTime? endDate,
    required DateTime? Function(T entity, String field) dateFieldGetter,
  }) {
    if (startDate == null && endDate == null) {
      return entities;
    }

    _logger.debug(
        'Filtering by date range: $dateField, start: $startDate, end: $endDate');

    final filteredEntities = entities.where((entity) {
      final date = dateFieldGetter(entity, dateField);
      if (date == null) return false;

      if (startDate != null && date.isBefore(startDate)) {
        return false;
      }

      if (endDate != null) {
        // Add one day to end date to make it inclusive
        final inclusiveEndDate = endDate.add(const Duration(days: 1));
        if (date.isAfter(inclusiveEndDate)) {
          return false;
        }
      }

      return true;
    }).toList();

    _logger.debug(
        'Date range filter complete, found ${filteredEntities.length} matches out of ${entities.length}');
    return filteredEntities;
  }
}
