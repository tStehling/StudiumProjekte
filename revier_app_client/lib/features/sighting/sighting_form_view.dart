import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revier_app_client/common/model_management/index.dart';
import 'package:revier_app_client/common/navigation/navigation_service.dart';
import 'package:revier_app_client/brick/models/sighting.model.dart';
import 'package:revier_app_client/data/reference_data_service.dart';
import 'package:revier_app_client/features/sighting/providers/sighting_providers.dart';
import 'sighting_model_handler.dart';
import 'package:revier_app_client/localization/app_localizations.dart';

/// A form view for creating and editing Sighting entities.
class SightingFormView extends ConsumerStatefulWidget {
  /// The sighting to edit (null for create mode).
  final Sighting? sighting;

  /// Callback when the form is saved
  final Function(Sighting)? onSave;

  /// Callback when the form is cancelled
  final Function()? onCancel;

  /// Creates a sighting form view.
  ///
  /// If [sighting] is provided, this will be an edit form.
  /// If [sighting] is null, this will be a create form.
  const SightingFormView({
    super.key,
    this.sighting,
    this.onSave,
    this.onCancel,
  });

  @override
  ConsumerState<SightingFormView> createState() => _SightingFormViewState();
}

class _SightingFormViewState extends ConsumerState<SightingFormView> {
  late final SightingModelHandler _modelHandler;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Create the model handler with the reference data service
    _modelHandler = ref.read(sightingModelHandlerProvider);

    // If we're in edit mode and don't have the full entity,
    // fetch it (including relations)
    _fetchSightingIfNeeded();
  }

  Future<void> _fetchSightingIfNeeded() async {
    if (widget.sighting != null &&
        (widget.sighting!.species == null ||
            widget.sighting!.weatherCondition == null ||
            widget.sighting!.camera == null)) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Fetch the full entity with relations
        await _modelHandler.fetchById(ref, widget.sighting!.id);
        // In a real implementation, we would update our local copy here
      } catch (e) {
        // Handle error
        debugPrint('Error fetching sighting: $e');
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _handleSave(Sighting sighting) async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Save using the model handler
      final savedSighting = await _modelHandler.save(ref, sighting);

      // Refresh the model handler to ensure data is updated
      await _modelHandler.refresh(ref);

      // Call the onSave callback if provided
      if (widget.onSave != null) {
        widget.onSave!(savedSighting);
      }

      // Show a success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.sighting == null
                  ? 'Sighting created successfully'
                  : 'Sighting updated successfully',
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }

      // Navigate back to the previous screen
      NavigationService.instance.goBack();
    } catch (e) {
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
              widget.sighting == null ? l10n.newSighting : l10n.editSighting),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Get context-aware field configurations
    final fieldConfigs = _modelHandler.getFieldConfigurations(ref);

    return EntityFormView<Sighting>(
      modelHandler: _modelHandler,
      entity: widget.sighting,
      onSave: _handleSave,
      onCancel: widget.onCancel ?? () => NavigationService.instance.goBack(),
    );
  }
}
