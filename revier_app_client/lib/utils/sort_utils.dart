import 'package:shared_preferences/shared_preferences.dart';
import 'package:revier_app_client/core/services/logging_service.dart';

/// Sort options configuration for collections
class SortOption {
  final String field;
  final String label;

  const SortOption(this.field, this.label);
}

/// Utility class for sort-related operations
class SortUtils {
  static final _logger = loggingService.getLogger('SortUtils');

  // Common keys for persistent storage
  static const String sortFieldKeySuffix = '_sortField';
  static const String sortAscendingKeySuffix = '_sortAscending';
  static const String isGridKeySuffix = '_isGrid';

  // Global maps to store pending sort operations across widget rebuilds
  static final Map<String, String> globalPendingSortFields = {};
  static final Map<String, bool> globalPendingSortDirections = {};

  /// Create sort options from field names and labels
  static List<SortOption> createSortOptions(Map<String, String> fieldLabels) {
    return fieldLabels.entries
        .map((entry) => SortOption(entry.key, entry.value))
        .toList();
  }

  /// Capitalize a field name for display
  static String capitalizeField(String field) {
    if (field.isEmpty) return '';

    // Handle special cases
    if (field == 'updatedAt') return 'Updated';
    if (field == 'createdAt') return 'Created';

    // Convert camelCase to Title Case
    final result = field.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => ' ${match.group(0)}',
    );

    return result.substring(0, 1).toUpperCase() + result.substring(1);
  }

  /// Load sort preferences from SharedPreferences
  static Future<Map<String, dynamic>> loadSortPreferences({
    required String? preferenceKey,
    required String defaultField,
    required List<SortOption> sortOptions,
  }) async {
    if (preferenceKey == null) {
      _logger.info(
          'No preference key provided, using initial values: $defaultField');
      return {
        'field': defaultField,
        'ascending': true,
      };
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final sortFieldKey = '$preferenceKey$sortFieldKeySuffix';
      final sortAscendingKey = '$preferenceKey$sortAscendingKeySuffix';

      _logger.debug(
          'Looking for saved preferences with keys: $sortFieldKey, $sortAscendingKey');

      final savedSortField = prefs.getString(sortFieldKey);
      final savedSortAscending = prefs.getBool(sortAscendingKey);

      _logger.debug(
          'Retrieved preferences: sortField=$savedSortField, sortAscending=$savedSortAscending');

      String effectiveField = defaultField;
      bool effectiveAscending = true;

      // Check if we have valid saved preferences
      if (savedSortField != null) {
        // Verify the saved field exists in our sort options
        final isValidField =
            sortOptions.any((option) => option.field == savedSortField);

        if (isValidField) {
          effectiveField = savedSortField;
          _logger.debug('Using saved sort field: $effectiveField');
        } else {
          _logger.warning(
              'Saved sort field $savedSortField is not valid, using default');
        }
      }

      // Set sort direction if saved
      if (savedSortAscending != null) {
        effectiveAscending = savedSortAscending;
        _logger.debug('Using saved sort direction: $effectiveAscending');
      }

      _logger.info(
          'Loaded sort preferences: field=$effectiveField, ascending=$effectiveAscending');

      return {
        'field': effectiveField,
        'ascending': effectiveAscending,
      };
    } catch (e) {
      _logger.error('Failed to load sort preferences', error: e);
      return {
        'field': defaultField,
        'ascending': true,
      };
    }
  }

  /// Save sort preferences to SharedPreferences
  static Future<void> saveSortPreferences({
    required String? preferenceKey,
    required String? sortField,
    required bool sortAscending,
  }) async {
    if (preferenceKey == null || sortField == null) {
      _logger.debug(
          'Not saving preferences: preferenceKey=$preferenceKey, sortField=$sortField');
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final sortFieldKey = '$preferenceKey$sortFieldKeySuffix';
      final sortAscendingKey = '$preferenceKey$sortAscendingKeySuffix';

      await prefs.setString(sortFieldKey, sortField);
      await prefs.setBool(sortAscendingKey, sortAscending);

      _logger.info(
          'Saved sort preferences: field=$sortField, ascending=$sortAscending');
    } catch (e) {
      _logger.error('Failed to save sort preferences', error: e);
    }
  }

  /// Save grid/list view preference
  static Future<void> saveViewModeSetting({
    required String? preferenceKey,
    required bool isGrid,
  }) async {
    if (preferenceKey == null) {
      _logger.debug('No preference key provided, skipping save');
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final viewModeKey = '$preferenceKey$isGridKeySuffix';
      await prefs.setBool(viewModeKey, isGrid);
      _logger.debug('Saved grid preference: $isGrid');
    } catch (e) {
      _logger.error('Error saving grid preference', error: e);
    }
  }

  /// Load grid/list view preference
  static Future<bool> loadViewModeSetting({
    required String? preferenceKey,
    required bool defaultIsGrid,
  }) async {
    if (preferenceKey == null) {
      return defaultIsGrid;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final viewModeKey = '$preferenceKey$isGridKeySuffix';
      final savedIsGrid = prefs.getBool(viewModeKey);

      return savedIsGrid ?? defaultIsGrid;
    } catch (e) {
      _logger.error('Error loading grid preference', error: e);
      return defaultIsGrid;
    }
  }
}
