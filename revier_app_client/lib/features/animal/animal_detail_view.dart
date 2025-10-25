import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revier_app_client/brick/models/animal.model.dart';
import 'package:revier_app_client/common/model_management/entity_detail_view.dart';
import 'package:revier_app_client/core/services/logging_service.dart';
import 'package:revier_app_client/features/animal/animal_form_view.dart';
import 'package:revier_app_client/features/animal/providers/animal_providers.dart';
import 'package:revier_app_client/common/navigation/navigation_service.dart';
import 'package:revier_app_client/common/widgets/dialogs/confirm_dialog.dart';
import 'package:revier_app_client/common/widgets/snackbars/app_snackbar.dart';

/// A detailed view for displaying animal information that listens to provider updates.
///
/// This widget wraps the generic EntityDetailView but adds Riverpod consumer
/// functionality to refresh when the underlying animal data changes.
class AnimalDetailView extends ConsumerStatefulWidget {
  /// The animal to display
  final Animal animal;

  const AnimalDetailView({
    super.key,
    required this.animal,
  });

  @override
  ConsumerState<AnimalDetailView> createState() => _AnimalDetailViewState();
}

class _AnimalDetailViewState extends ConsumerState<AnimalDetailView> {
  late String animalId;
  Animal? refreshedAnimal;
  final _log = loggingService.getLogger('AnimalDetailView');

  @override
  void initState() {
    super.initState();
    animalId = widget.animal.id!;
    _log.info('Initializing AnimalDetailView for animal ID: $animalId');
    _refreshAnimal();
  }

  Future<void> _refreshAnimal() async {
    final modelHandler = ref.read(animalModelHandlerProvider);
    try {
      // Fetch the latest version of this animal
      final animal = await modelHandler.fetchById(ref, animalId);
      if (mounted && animal != null) {
        setState(() {
          refreshedAnimal = animal;
        });
      }
    } catch (e) {
      _log.error('Error refreshing animal', error: e);
    }
  }

  Future<void> _editAnimal(Animal animal) async {
    // Navigate to the edit view
    await NavigationService.instance.navigateWithScale(
      AnimalFormView(
        initialEntity: animal,
        onSave: (updatedAnimal) {
          // When the animal is saved, refresh our local state
          if (mounted) {
            setState(() {
              refreshedAnimal = updatedAnimal;
            });
            // Also refresh the provider data
            ref.invalidate(animalModelHandlerProvider);
          }
        },
      ),
    );

    // Double-check that we have the latest data
    _refreshAnimal();
  }

  void _deleteAnimal(Animal animal) async {
    // Show confirmation dialog
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Delete Animal',
      message: 'Are you sure you want to delete ${animal.name}?',
      confirmText: 'Delete',
      isDestructive: true,
    );

    if (confirmed) {
      final modelHandler = ref.read(animalModelHandlerProvider);

      try {
        // Delete the animal
        await modelHandler.delete(ref, animal);

        // Navigate back after deletion
        if (mounted) {
          // Show success message
          showSuccessSnackBar(context, 'Animal deleted successfully');
          NavigationService.instance.goBack();
        }
      } catch (e) {
        if (mounted) {
          // Show error message
          showErrorSnackBar(context, 'Error deleting animal: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // This ensures the widget rebuilds when the provider changes
    ref.watch(animalModelHandlerProvider);

    // Use the refreshed animal if available, otherwise use the original
    final displayAnimal = refreshedAnimal ?? widget.animal;

    // Get the model handler
    final modelHandler = ref.read(animalModelHandlerProvider);

    return EntityDetailView<Animal>(
      modelHandler: modelHandler,
      entity: displayAnimal,
      onEdit: () => _editAnimal(displayAnimal),
      onDelete: () => _deleteAnimal(displayAnimal),
    );
  }
}
