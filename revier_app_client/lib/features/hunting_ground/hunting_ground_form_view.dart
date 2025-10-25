import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revier_app_client/brick/models/hunting_ground.model.dart';
import 'package:revier_app_client/common/model_management/entity_form_view.dart';
import 'package:revier_app_client/features/hunting_ground/hunting_ground_model_handler.dart';
import 'package:revier_app_client/features/hunting_ground/providers/hunting_ground_provider.dart';
import 'package:revier_app_client/common/navigation/navigation_service.dart';

/// A form view for creating or editing hunting grounds
class HuntingGroundFormView extends ConsumerStatefulWidget {
  /// The hunting ground to edit (null for create mode)
  final HuntingGround? initialEntity;

  /// Whether to navigate to the main screen after saving
  final bool navigateToMainAfterSave;

  /// Callback when the form is saved
  final Function(HuntingGround)? onSave;

  /// Callback when the form is cancelled
  final VoidCallback? onCancel;

  const HuntingGroundFormView({
    super.key,
    this.initialEntity,
    this.navigateToMainAfterSave = false,
    this.onSave,
    this.onCancel,
  });

  @override
  ConsumerState<HuntingGroundFormView> createState() =>
      _HuntingGroundFormViewState();
}

class _HuntingGroundFormViewState extends ConsumerState<HuntingGroundFormView> {
  late final HuntingGroundModelHandler _modelHandler;

  @override
  void initState() {
    super.initState();
    _modelHandler = HuntingGroundModelHandler();
  }

  @override
  Widget build(BuildContext context) {
    // Use either initialEntity or huntingGround (for backward compatibility)
    final entity = widget.initialEntity;

    return EntityFormView<HuntingGround>(
      modelHandler: _modelHandler,
      entity: entity,
      onSave: _handleSave,
      onCancel: widget.onCancel ?? () => NavigationService.instance.goBack(),
    );
  }

  Future<void> _handleSave(HuntingGround entity) async {
    try {
      // Save the entity
      await _modelHandler.save(ref, entity);

      // Set as selected hunting ground if needed
      if (widget.navigateToMainAfterSave) {
        ref.read(selectedHuntingGroundProvider.notifier).state = entity;
      }

      // Call onSave callback if provided
      if (widget.onSave != null) {
        widget.onSave!(entity);
      }
    } catch (e) {
      // Handle errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving hunting ground: $e')),
        );
      }
    }
  }
}
