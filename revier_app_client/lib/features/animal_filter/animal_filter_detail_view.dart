import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revier_app_client/brick/models/animal_filter.model.dart';
import 'package:revier_app_client/common/model_management/entity_detail_view.dart';
import 'package:revier_app_client/core/services/logging_service.dart';
import 'package:revier_app_client/features/animal_filter/animal_filter_form_view.dart';
import 'package:revier_app_client/features/animal_filter/providers/animal_filter_providers.dart';
import 'package:revier_app_client/common/navigation/navigation_service.dart';
import 'package:revier_app_client/common/widgets/dialogs/confirm_dialog.dart';
import 'package:revier_app_client/common/widgets/snackbars/app_snackbar.dart';

/// A detailed view for displaying animal filter information that listens to provider updates.
///
/// This widget wraps the generic EntityDetailView but adds Riverpod consumer
/// functionality to refresh when the underlying data changes.
class AnimalFilterDetailView extends ConsumerStatefulWidget {
  /// The animal filter to display
  final AnimalFilter animalFilter;

  const AnimalFilterDetailView({
    super.key,
    required this.animalFilter,
  });

  @override
  ConsumerState<AnimalFilterDetailView> createState() =>
      _AnimalFilterDetailViewState();
}

class _AnimalFilterDetailViewState
    extends ConsumerState<AnimalFilterDetailView> {
  late String animalFilterId;
  AnimalFilter? refreshedAnimalFilter;
  final _log = loggingService.getLogger('AnimalFilterDetailView');

  @override
  void initState() {
    super.initState();
    animalFilterId = widget.animalFilter.id;
    _log.info(
        'Initializing AnimalFilterDetailView for filter ID: $animalFilterId');
    _refreshAnimalFilter();
  }

  Future<void> _refreshAnimalFilter() async {
    final modelHandler = ref.read(animalFilterModelHandlerProvider);
    try {
      // Fetch the latest version of this animal filter
      final animalFilter = await modelHandler.fetchById(ref, animalFilterId);
      if (mounted && animalFilter != null) {
        setState(() {
          refreshedAnimalFilter = animalFilter;
        });
      }
    } catch (e) {
      _log.error('Error refreshing animal filter', error: e);
    }
  }

  Future<void> _editAnimalFilter(AnimalFilter animalFilter) async {
    // Navigate to the edit view
    await NavigationService.instance.navigateWithScale(
      AnimalFilterFormView(
        initialEntity: animalFilter,
        onSave: (updatedFilter) {
          // When the filter is saved, refresh our local state
          if (mounted) {
            setState(() {
              refreshedAnimalFilter = updatedFilter;
            });
            // Also refresh the provider data
            ref.invalidate(animalFilterModelHandlerProvider);
          }
        },
      ),
    );

    // Double-check that we have the latest data
    _refreshAnimalFilter();
  }

  void _deleteAnimalFilter(AnimalFilter animalFilter) async {
    // Show confirmation dialog
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Delete Animal Filter',
      message: 'Are you sure you want to delete ${animalFilter.name}?',
      confirmText: 'Delete',
      isDestructive: true,
    );

    if (confirmed) {
      final modelHandler = ref.read(animalFilterModelHandlerProvider);

      try {
        // Delete the animal filter
        await modelHandler.delete(ref, animalFilter);

        // Navigate back after deletion
        if (mounted) {
          // Show success message
          showSuccessSnackBar(context, 'Animal filter deleted successfully');
          NavigationService.instance.goBack();
        }
      } catch (e) {
        if (mounted) {
          // Show error message
          showErrorSnackBar(context, 'Error deleting animal filter: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // This ensures the widget rebuilds when the provider changes
    ref.watch(animalFilterModelHandlerProvider);

    // Use the refreshed animal filter if available, otherwise use the original
    final displayAnimalFilter = refreshedAnimalFilter ?? widget.animalFilter;

    // Get the model handler
    final modelHandler = ref.read(animalFilterModelHandlerProvider);

    return EntityDetailView<AnimalFilter>(
      modelHandler: modelHandler,
      entity: displayAnimalFilter,
      onEdit: () => _editAnimalFilter(displayAnimalFilter),
      onDelete: () => _deleteAnimalFilter(displayAnimalFilter),
    );
  }
}
