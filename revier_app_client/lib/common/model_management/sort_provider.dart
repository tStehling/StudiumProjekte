import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:revier_app_client/core/services/logging_service.dart';

/// Represents the current sort settings with a field and direction.
class SortSettings {
  /// The field to sort by
  final String field;

  /// Whether to sort in ascending order
  final bool ascending;

  const SortSettings({
    required this.field,
    this.ascending = true,
  });

  /// Creates a copy of this SortSettings with optional new values.
  SortSettings copyWith({
    String? field,
    bool? ascending,
  }) {
    return SortSettings(
      field: field ?? this.field,
      ascending: ascending ?? this.ascending,
    );
  }

  /// Gets the display label for the current sort field.
  String getLabel(Map<String, String> labels) {
    return labels[field] ?? field;
  }
}

/// A Riverpod state notifier that manages sort settings.
class SortSettingsNotifier extends StateNotifier<SortSettings> {
  final String _prefsKey;
  final String _prefsDirectionKey;
  final String defaultField;
  final logger = loggingService.getLogger('SortSettingsNotifier');

  SortSettingsNotifier({
    required this.defaultField,
    required String prefsKey,
  })  : _prefsKey = '${prefsKey}_sort_field',
        _prefsDirectionKey = '${prefsKey}_sort_direction',
        super(SortSettings(field: defaultField)) {
    _loadPreferences();
  }

  /// Loads sort preferences from SharedPreferences.
  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedField = prefs.getString(_prefsKey);
      final savedAscending = prefs.getBool(_prefsDirectionKey);

      if (savedField != null) {
        state = SortSettings(
          field: savedField,
          ascending: savedAscending ?? true,
        );
        logger.info(
            'Loaded sort preferences: field=$savedField, ascending=$savedAscending');
      }
    } catch (e) {
      logger.error('Error loading sort preferences: $e');
    }
  }

  /// Saves current sort preferences to SharedPreferences.
  Future<void> _savePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, state.field);
      await prefs.setBool(_prefsDirectionKey, state.ascending);
      logger.info(
          'Saved sort preferences: field=${state.field}, ascending=${state.ascending}');
    } catch (e) {
      logger.error('Error saving sort preferences: $e');
    }
  }

  /// Sets the sort field and optionally the direction.
  Future<void> setSortField(String field, {bool? direction}) async {
    if (field == state.field && direction == null) {
      logger.info('Sort field unchanged: $field');
      return;
    }

    logger.info(
        'Setting sort field: $field, direction: ${direction ?? state.ascending}');
    state = state.copyWith(
      field: field,
      ascending: direction ?? state.ascending,
    );
    await _savePreferences();
  }

  /// Toggles the sort direction.
  Future<void> toggleDirection() async {
    logger.info(
        'Toggling sort direction from ${state.ascending} to ${!state.ascending}');
    state = state.copyWith(ascending: !state.ascending);
    await _savePreferences();
  }
}

/// A Riverpod state notifier that manages view mode (grid or list).
class ViewModeNotifier extends StateNotifier<bool> {
  final String _prefsKey;
  final bool defaultIsGrid;
  final logger = loggingService.getLogger('ViewModeNotifier');

  ViewModeNotifier({
    required this.defaultIsGrid,
    required String prefsKey,
  })  : _prefsKey = '${prefsKey}_view_mode',
        super(defaultIsGrid) {
    _loadPreferences();
  }

  /// Loads view mode preference from SharedPreferences.
  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedIsGrid = prefs.getBool(_prefsKey);

      if (savedIsGrid != null) {
        state = savedIsGrid;
        logger.info('Loaded view mode preference: isGrid=$savedIsGrid');
      }
    } catch (e) {
      logger.error('Error loading view mode preference: $e');
    }
  }

  /// Saves current view mode to SharedPreferences.
  Future<void> _savePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefsKey, state);
      logger.info('Saved view mode preference: isGrid=$state');
    } catch (e) {
      logger.error('Error saving view mode preference: $e');
    }
  }

  /// Toggles between grid and list view.
  Future<void> toggleViewMode() async {
    logger.info('Toggling view mode from $state to ${!state}');
    state = !state;
    await _savePreferences();
  }

  /// Sets the view mode explicitly.
  Future<void> setViewMode(bool isGrid) async {
    print('===== VIEW_MODE_NOTIFIER DEBUG =====');
    print('Current state: $state');
    print('Setting to: $isGrid');

    // Force refresh the UI regardless of whether the state appears to be the same
    // This ensures the view mode change is applied even in case of stale state
    logger.info('Setting view mode: isGrid=$isGrid');

    // Force a state change by toggling twice if the requested state matches current state
    if (state == isGrid) {
      print('Forcing state change cycle');
      state = !isGrid; // First toggle to the opposite
      // Small delay to ensure state updates properly
      await Future.delayed(const Duration(milliseconds: 50));
    }

    // Set to the requested state
    state = isGrid;
    print('New state set: $state');

    await _savePreferences();
    print('Preferences saved');
    print('===== VIEW_MODE_NOTIFIER COMPLETED =====');
  }
}

/// Creates a provider for sort settings.
///
/// Example usage:
/// ```dart
/// final animalSortProvider = StateNotifierProvider<SortSettingsNotifier, SortSettings>((ref) {
///   return SortSettingsNotifier(
///     defaultField: 'updatedAt',
///     prefsKey: 'animal',
///   );
/// });
/// ```
StateNotifierProvider<SortSettingsNotifier, SortSettings>
    createSortSettingsProvider({
  required String defaultField,
  required String prefsKey,
}) {
  return StateNotifierProvider<SortSettingsNotifier, SortSettings>((ref) {
    return SortSettingsNotifier(
      defaultField: defaultField,
      prefsKey: prefsKey,
    );
  });
}

/// Creates a provider for view mode.
///
/// Example usage:
/// ```dart
/// final animalViewModeProvider = StateNotifierProvider<ViewModeNotifier, bool>((ref) {
///   return ViewModeNotifier(
///     defaultIsGrid: true,
///     prefsKey: 'animal',
///   );
/// });
/// ```
StateNotifierProvider<ViewModeNotifier, bool> createViewModeProvider({
  required bool defaultIsGrid,
  required String prefsKey,
}) {
  return StateNotifierProvider<ViewModeNotifier, bool>((ref) {
    return ViewModeNotifier(
      defaultIsGrid: defaultIsGrid,
      prefsKey: prefsKey,
    );
  });
}

/// Common sort field labels that can be used across different models
final Map<String, String> commonSortLabels = {
  'updatedAt': 'Recently Updated',
  'createdAt': 'Date Created',
  'name': 'Name',
  'title': 'Title',
};
