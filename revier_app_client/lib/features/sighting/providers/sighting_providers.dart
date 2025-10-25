import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revier_app_client/common/model_management/sort_provider.dart';
import 'package:revier_app_client/data/reference_data_service.dart';
import 'package:revier_app_client/features/sighting/sighting_model_handler.dart';

/// Provider for the sighting model handler
final sightingModelHandlerProvider = Provider<SightingModelHandler>((ref) {
  final referenceDataService = ref.watch(referenceDataServiceProvider);
  return SightingModelHandler(referenceService: referenceDataService);
});

/// Provider for sighting sort settings.
///
/// Handles the current sort field and direction for sighting collections,
/// with persistence via SharedPreferences.
final sightingSortProvider = createSortSettingsProvider(
  defaultField: 'updatedAt',
  prefsKey: 'sighting',
);

/// Provider for sighting view mode (grid vs list).
///
/// Manages whether sightings are displayed in a grid or list view,
/// with persistence via SharedPreferences.
final sightingViewModeProvider = createViewModeProvider(
  defaultIsGrid: true,
  prefsKey: 'sighting',
);

/// Provider for sighting sort field labels.
///
/// Maps database field names to user-friendly display labels.
/// These labels will be shown in the sort dropdown.
final sightingSortLabelsProvider = Provider<Map<String, String>>((ref) {
  // Using static labels that don't require localization
  return {
    'updatedAt': 'Updated',
    'createdAt': 'Created',
    'sightingDate': 'Date',
    'speciesId': 'Species',
    // Add more sort fields as needed
  };
});
