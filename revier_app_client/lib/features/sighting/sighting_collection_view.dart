import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revier_app_client/brick/models/sighting.model.dart';
import 'package:revier_app_client/common/model_management/hunting_ground_filtered_model_view.dart';
import 'package:revier_app_client/core/services/logging_service.dart';
import 'package:revier_app_client/features/sighting/providers/sighting_providers.dart';
import 'package:revier_app_client/features/sighting/sighting_detail_view.dart';

/// Sighting collection view.
///
/// Displays a collection of sightings for the selected hunting ground.
///
class SightingCollectionView extends ConsumerStatefulWidget {
  const SightingCollectionView({super.key});

  @override
  ConsumerState<SightingCollectionView> createState() =>
      _SightingCollectionViewState();
}

class _SightingCollectionViewState
    extends ConsumerState<SightingCollectionView> {
  static final _log = loggingService.getLogger('SightingCollectionView');
  static const _defaultImagePath = 'assets/images/3deer.png';

  String _getSightingSubtitle(Sighting sighting) {
    try {
      final parts = <String>[];

      if (sighting.species != null) {
        parts.add(sighting.species?.name ?? 'Unknown Species');
      }

      if (sighting.sightingStart != null) {
        // Format the date in a readable format (e.g., "Jan 12, 2023 - 2:30 PM")
        final date = sighting.sightingStart;
        final formattedDate =
            '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
        parts.add(formattedDate);
      }

      if (sighting.animalCount > 0) {
        parts.add('Count: ${sighting.animalCount}');
      }

      if (parts.isEmpty) {
        return 'No details available';
      }

      return parts.join(' • ');
    } catch (e) {
      _log.warning('Error generating sighting subtitle', error: e);
      return 'No details available';
    }
  }

  String _getSightingImagePath(Sighting sighting) {
    try {
      // You could implement logic to get a different image based on species
      // For now, just return the default image
      return _defaultImagePath;
    } catch (e) {
      _log.warning('Error getting sighting image path', error: e);
      return _defaultImagePath;
    }
  }

  @override
  Widget build(BuildContext context) {
    _log.info('Building SightingCollectionView');

    // Get the model handler directly in build
    final modelHandler = ref.watch(sightingModelHandlerProvider);

    return HuntingGroundFilteredModelView<Sighting>(
      modelHandler: modelHandler,
      detailViewBuilder: (context, sighting) => SightingDetailView(
        sighting: sighting,
      ),

      // Use our Riverpod providers for sorting and view mode
      sortProvider: sightingSortProvider,
      viewModeProvider: sightingViewModeProvider,
      sortLabelsProvider: sightingSortLabelsProvider,
      imagePathProvider: _getSightingImagePath,
      subtitleProvider: _getSightingSubtitle,

      // Enable layout switch and search in HuntingGroundFilteredModelView
      showLayoutSwitch: true,
      showSearch: true,

      // Customize the appearance
      gridColumns: 2,
      gridAspectRatio: 1.5,

      // Use hunting ground ID as the filtering field
      huntingGroundIdField: 'huntingGroundId',

      // Enable persistent preferences
      preferenceKey: 'sighting_collection',
    );
  }
}
