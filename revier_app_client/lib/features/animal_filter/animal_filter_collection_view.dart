import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revier_app_client/brick/models/animal_filter.model.dart';
import 'package:revier_app_client/common/model_management/hunting_ground_filtered_model_view.dart';
import 'package:revier_app_client/common/navigation/navigation_service.dart';
import 'package:revier_app_client/common/widgets/buttons/extended_floating_action_button.dart';
import 'package:revier_app_client/core/services/logging_service.dart';
import 'package:revier_app_client/features/animal/animal_form_view.dart';
import 'package:revier_app_client/features/animal_filter/animal_filter_detail_view.dart';
import 'package:revier_app_client/features/animal_filter/animal_filter_form_view.dart';
import 'package:revier_app_client/features/animal_filter/providers/animal_filter_providers.dart';

/// A collection view for displaying and managing animal filters
class AnimalFilterCollectionView extends ConsumerStatefulWidget {
  const AnimalFilterCollectionView({super.key});

  @override
  ConsumerState<AnimalFilterCollectionView> createState() =>
      _AnimalFilterCollectionViewState();
}

class _AnimalFilterCollectionViewState
    extends ConsumerState<AnimalFilterCollectionView> {
  static final _log = loggingService.getLogger('AnimalFilterCollectionView');
  static const _defaultImagePath = 'assets/images/3deer.png';

  String _getAnimalFilterSubtitle(AnimalFilter animalFilter) {
    try {
      final parts = <String>[];

      if (animalFilter.speciesId != null) {
        parts.add('Species: ${animalFilter.speciesId}');
      }

      if (animalFilter.animalCount != null) {
        parts.add('Count: ${animalFilter.animalCount}');
      }

      if (parts.isEmpty) {
        return 'No details available';
      }

      return parts.join(' • ');
    } catch (e) {
      _log.warning('Error generating animal filter subtitle', error: e);
      return 'No details available';
    }
  }

  @override
  Widget build(BuildContext context) {
    _log.info('Building AnimalFilterCollectionView');

    // Get the animal filter model handler from the provider
    final modelHandler = ref.watch(animalFilterModelHandlerProvider);

    return HuntingGroundFilteredModelView<AnimalFilter>(
      modelHandler: modelHandler,
      detailViewBuilder: (context, animalFilter) =>
          AnimalFilterDetailView(animalFilter: animalFilter),

      // Use our Riverpod providers for sorting and view mode
      sortProvider: animalFilterSortProvider,
      viewModeProvider: animalFilterViewModeProvider,
      sortLabelsProvider: animalFilterSortLabelsProvider,

      // Add other properties
      imagePathProvider: (animalFilter) => _defaultImagePath,
      subtitleProvider: _getAnimalFilterSubtitle,

      // Enable layout switch and search
      showLayoutSwitch: true,
      showSearch: true,

      // Customize the appearance
      gridColumns: 2,
      gridAspectRatio: 1.5,

      // Use hunting ground ID as the filtering field
      huntingGroundIdField: 'huntingGroundId',

      // Enable persistent preferences
      preferenceKey: 'animal_filter_collection',

      floatingActionButton: ExtendedFloatingActionButton(
        alignment: Alignment.bottomRight,
        type: ButtonType.add,
        isFlyoutMode: true,
        flyoutButtons: [
          FlyoutButtonItem(
            assetPath: 'assets/images/1deer.png',
            onPressed: () => NavigationService.instance.navigateWithScale(
              const AnimalFormView(),
            ),
            flyoutDirection: FlyoutDirection.left,
          ),
          FlyoutButtonItem(
            assetPath: 'assets/images/3deer.png',
            onPressed: () => NavigationService.instance.navigateWithScale(
              const AnimalFilterFormView(),
            ),
            flyoutDirection: FlyoutDirection.up,
          ),
        ],
      ),
    );
  }
}
