import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revier_app_client/common/model_management/sort_provider.dart';
import 'package:revier_app_client/data/reference_data_service.dart';
import 'package:revier_app_client/features/animal/animal_model_handler.dart';

/// Provider for the animal model handler
final animalModelHandlerProvider = Provider<AnimalModelHandler>((ref) {
  final referenceDataService = ref.watch(referenceDataServiceProvider);
  return AnimalModelHandler(referenceDataService);
});

/// Provider for animal sort settings.
///
/// Handles the current sort field and direction for animal collections,
/// with persistence via SharedPreferences.
final animalSortProvider = createSortSettingsProvider(
  defaultField: 'updatedAt',
  prefsKey: 'animal',
);

/// Provider for animal view mode (grid vs list).
///
/// Manages whether animals are displayed in a grid or list view,
/// with persistence via SharedPreferences.
final animalViewModeProvider = createViewModeProvider(
  defaultIsGrid: true,
  prefsKey: 'animal',
);

/// Provider for animal sort field labels.
///
/// Maps database field names to user-friendly display labels.
/// These labels will be shown in the sort dropdown.
final animalSortLabelsProvider = Provider<Map<String, String>>((ref) {
  // Using static labels that don't require localization
  return {
    'updatedAt': 'Updated',
    'createdAt': 'Created',
    'name': 'Name',
    // Add more sort fields as needed
  };
});
