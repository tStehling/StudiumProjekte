import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revier_app_client/common/model_management/hunting_ground_filtered_model_view.dart';
import 'package:revier_app_client/core/services/logging_service.dart';
import 'package:revier_app_client/brick/models/animal.model.dart';
import 'package:revier_app_client/features/animal/animal_detail_view.dart';
import 'package:revier_app_client/features/animal/providers/animal_providers.dart';

/// Animal collection view.
///
/// Displays a collection of animals for the selected hunting ground.
///
class AnimalCollectionView extends ConsumerStatefulWidget {
  const AnimalCollectionView({super.key});

  @override
  ConsumerState<AnimalCollectionView> createState() =>
      _AnimalCollectionViewState();
}

class _AnimalCollectionViewState extends ConsumerState<AnimalCollectionView> {
  static const _defaultImagePath = 'assets/images/deerFace.png';
  static final _log = loggingService.getLogger('AnimalCollectionView');

  // Map of species names to image paths
  static const Map<String, String> _speciesImageMap = {
    'deer': 'assets/images/deerFace.png',
    'boar': 'assets/images/boarFace.png',
  };

  String _getAnimalImagePath(Animal animal) {
    _log.debug('Getting image path for animal: ${animal.name}');

    try {
      if (animal.species?.name == null) {
        _log.debug('Animal has no species name, using default image');
        return _defaultImagePath;
      }

      final speciesName = animal.species!.name.toLowerCase();

      // Check each key in the map to see if the species name contains it
      for (final entry in _speciesImageMap.entries) {
        if (speciesName.contains(entry.key)) {
          _log.debug('Found matching species image for: ${entry.key}');
          return entry.value;
        }
      }

      _log.debug('No matching species image found, using default');
      return _defaultImagePath;
    } catch (e) {
      _log.warning('Error getting animal image path', error: e);
      return _defaultImagePath;
    }
  }

  String _getAnimalSubtitle(Animal animal) {
    try {
      final parts = <String>[];

      if (animal.species != null) {
        parts.add(animal.species!.name);
      }

      if (animal.age != null) {
        parts.add('${animal.age} years');
      }

      if (animal.weight != null) {
        parts.add('${animal.weight} kg');
      }

      if (parts.isEmpty) {
        return 'No details available';
      }

      return parts.join(' • ');
    } catch (e) {
      _log.warning('Error generating animal subtitle', error: e);
      return 'No details available';
    }
  }

  @override
  Widget build(BuildContext context) {
    final log = loggingService.getLogger('AnimalCollectionView');
    log.info('Building AnimalCollectionView');

    // Get the model handler directly in build
    final modelHandler = ref.watch(animalModelHandlerProvider);

    return HuntingGroundFilteredModelView<Animal>(
      modelHandler: modelHandler,
      detailViewBuilder: (context, animal) => AnimalDetailView(
        animal: animal,
      ),

      // Use our Riverpod providers for sorting and view mode
      sortProvider: animalSortProvider,
      viewModeProvider: animalViewModeProvider,
      sortLabelsProvider: animalSortLabelsProvider,

      imagePathProvider: _getAnimalImagePath,
      subtitleProvider: _getAnimalSubtitle,
      // Enable layout switch and search in HuntingGroundFilteredModelView
      showLayoutSwitch: true,
      showSearch: true,

      // Customize the appearance
      gridColumns: 2,
      gridAspectRatio: 1.5,

      // Use hunting ground ID as the filtering field
      huntingGroundIdField: 'huntingGroundId',

      // Enable persistent preferences
      preferenceKey: 'animal_collection',
    );
  }
}
