import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revier_app_client/brick/models/animal_filter.model.dart';
import 'package:revier_app_client/common/model_management/entity_form_view.dart';
import 'package:revier_app_client/features/animal_filter/animal_filter_model_handler.dart';
import 'package:revier_app_client/common/navigation/navigation_service.dart';

/// A form view for creating or editing hunting grounds
class AnimalFilterFormView extends ConsumerStatefulWidget {
  /// The hunting ground to edit (null for create mode)
  final AnimalFilter? initialEntity;

  /// Whether to navigate to the main screen after saving
  final bool navigateToMainAfterSave;

  /// Callback when the form is saved
  final Function(AnimalFilter)? onSave;

  /// Callback when the form is cancelled
  final VoidCallback? onCancel;

  const AnimalFilterFormView({
    super.key,
    this.initialEntity,
    this.navigateToMainAfterSave = true,
    this.onSave,
    this.onCancel,
  });

  @override
  ConsumerState<AnimalFilterFormView> createState() =>
      _AnimalFilterFormViewState();
}

class _AnimalFilterFormViewState extends ConsumerState<AnimalFilterFormView> {
  late final AnimalFilterModelHandler _modelHandler;

  @override
  void initState() {
    super.initState();
    _modelHandler = AnimalFilterModelHandler();
  }

  @override
  Widget build(BuildContext context) {
    // Use either initialEntity or huntingGround (for backward compatibility)
    final entity = widget.initialEntity;

    return EntityFormView<AnimalFilter>(
      modelHandler: _modelHandler,
      entity: entity,
      onSave: _handleSave,
      onCancel: widget.onCancel ?? () => NavigationService.instance.goBack(),
    );
  }

  Future<void> _handleSave(AnimalFilter entity) async {
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
        // Just navigate back, the detail view will handle refreshing
        NavigationService.instance.goBack();
      }
    } catch (e) {
      // Handle errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving animal filter: $e')),
        );
      }
    }
  }
}
