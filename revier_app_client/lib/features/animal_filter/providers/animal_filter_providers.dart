import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revier_app_client/common/model_management/sort_provider.dart';
import 'package:revier_app_client/data/reference_data_service.dart';
import 'package:revier_app_client/features/animal_filter/animal_filter_model_handler.dart';

/// Provider for the animal filter model handler
final animalFilterModelHandlerProvider =
    Provider<AnimalFilterModelHandler>((ref) {
  final referenceDataService = ref.watch(referenceDataServiceProvider);
  return AnimalFilterModelHandler(referenceDataService);
});

/// Provider for animal filter sort settings.
///
/// Handles the current sort field and direction for animal filter collections,
/// with persistence via SharedPreferences.
final animalFilterSortProvider = createSortSettingsProvider(
  defaultField: 'updatedAt',
  prefsKey: 'animal_filter',
);

/// Provider for animal filter view mode (grid vs list).
///
/// Manages whether animal filters are displayed in a grid or list view,
/// with persistence via SharedPreferences.
final animalFilterViewModeProvider = createViewModeProvider(
  defaultIsGrid: true,
  prefsKey: 'animal_filter',
);

/// Provider for animal filter sort field labels.
///
/// Maps database field names to user-friendly display labels.
/// These labels will be shown in the sort dropdown.
final animalFilterSortLabelsProvider = Provider<Map<String, String>>((ref) {
  // Using static labels that don't require localization
  return {
    'updatedAt': 'Updated',
    'createdAt': 'Created',
    'animalCount': 'Count',
    'speciesId': 'Species',
    // Add more sort fields as needed
  };
});
