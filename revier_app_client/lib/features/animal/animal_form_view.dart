import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revier_app_client/brick/models/animal.model.dart';
import 'package:revier_app_client/common/model_management/entity_form_view.dart';
import 'package:revier_app_client/features/animal/animal_model_handler.dart';
import 'package:revier_app_client/common/navigation/navigation_service.dart';

/// A form view for creating or editing hunting grounds
class AnimalFormView extends ConsumerStatefulWidget {
  /// The hunting ground to edit (null for create mode)
  final Animal? initialEntity;

  /// Whether to navigate to the main screen after saving
  final bool navigateToMainAfterSave;

  /// Callback when the form is saved
  final Function(Animal)? onSave;

  /// Callback when the form is cancelled
  final VoidCallback? onCancel;

  const AnimalFormView({
    super.key,
    this.initialEntity,
    this.navigateToMainAfterSave = true,
    this.onSave,
    this.onCancel,
  });

  @override
  ConsumerState<AnimalFormView> createState() => _AnimalFormViewState();
}

class _AnimalFormViewState extends ConsumerState<AnimalFormView> {
  late final AnimalModelHandler _modelHandler;

  @override
  void initState() {
    super.initState();
    _modelHandler = AnimalModelHandler();
  }

  @override
  Widget build(BuildContext context) {
    // Use either initialEntity or huntingGround (for backward compatibility)
    final entity = widget.initialEntity;

    return EntityFormView<Animal>(
      modelHandler: _modelHandler,
      entity: entity,
      onSave: _handleSave,
      onCancel: widget.onCancel ?? () => NavigationService.instance.goBack(),
    );
  }

  Future<void> _handleSave(Animal entity) async {
    try {
      // Save the entity
      final updatedEntity = await _modelHandler.save(ref, entity);

      // Refresh the model data to ensure the list is updated
      await _modelHandler.refresh(ref);

      // Call onSave callback if provided
      if (widget.onSave != null) {
        widget.onSave!(updatedEntity);
      }

      if (widget.navigateToMainAfterSave && mounted) {
        NavigationService.instance.goBack();
      }
    } catch (e) {
      // Handle errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving animal: $e')),
        );
      }
    }
  }
}
