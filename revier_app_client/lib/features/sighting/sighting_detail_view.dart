import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revier_app_client/brick/models/sighting.model.dart';
import 'package:revier_app_client/common/model_management/entity_detail_view.dart';
import 'package:revier_app_client/core/services/logging_service.dart';
import 'package:revier_app_client/features/sighting/sighting_form_view.dart';
import 'package:revier_app_client/features/sighting/providers/sighting_providers.dart';
import 'package:revier_app_client/common/navigation/navigation_service.dart';
import 'package:revier_app_client/common/widgets/dialogs/confirm_dialog.dart';
import 'package:revier_app_client/common/widgets/snackbars/app_snackbar.dart';

/// A detailed view for displaying sighting information that listens to provider updates.
///
/// This widget wraps the generic EntityDetailView but adds Riverpod consumer
/// functionality to refresh when the underlying data changes.
class SightingDetailView extends ConsumerStatefulWidget {
  /// The sighting to display
  final Sighting sighting;

  const SightingDetailView({
    super.key,
    required this.sighting,
  });

  @override
  ConsumerState<SightingDetailView> createState() => _SightingDetailViewState();
}

class _SightingDetailViewState extends ConsumerState<SightingDetailView> {
  late String sightingId;
  Sighting? refreshedSighting;
  final _log = loggingService.getLogger('SightingDetailView');

  @override
  void initState() {
    super.initState();
    sightingId = widget.sighting.id;
    _log.info('Initializing SightingDetailView for sighting ID: $sightingId');
    _refreshSighting();
  }

  Future<void> _refreshSighting() async {
    final modelHandler = ref.read(sightingModelHandlerProvider);
    try {
      // Fetch the latest version of this sighting
      final sighting = await modelHandler.fetchById(ref, sightingId);
      if (mounted && sighting != null) {
        setState(() {
          refreshedSighting = sighting;
        });
      }
    } catch (e) {
      _log.error('Error refreshing sighting', error: e);
    }
  }

  Future<void> _editSighting(Sighting sighting) async {
    // Navigate to the edit view
    await NavigationService.instance.navigateWithScale(
      SightingFormView(
        sighting: sighting,
        onSave: (updatedSighting) {
          // When the sighting is saved, refresh our local state
          if (mounted) {
            setState(() {
              refreshedSighting = updatedSighting;
            });
            // Also refresh the provider data
            ref.invalidate(sightingModelHandlerProvider);
          }
        },
      ),
    );

    // Double-check that we have the latest data
    _refreshSighting();
  }

  void _deleteSighting(Sighting sighting) async {
    // Show confirmation dialog
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Delete Sighting',
      message: 'Are you sure you want to delete this sighting?',
      confirmText: 'Delete',
      isDestructive: true,
    );

    if (confirmed) {
      final modelHandler = ref.read(sightingModelHandlerProvider);

      try {
        // Delete the sighting
        await modelHandler.delete(ref, sighting);

        // Navigate back after deletion
        if (mounted) {
          // Show success message
          showSuccessSnackBar(context, 'Sighting deleted successfully');
          NavigationService.instance.goBack();
        }
      } catch (e) {
        if (mounted) {
          // Show error message
          showErrorSnackBar(context, 'Error deleting sighting: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // This ensures the widget rebuilds when the provider changes
    ref.watch(sightingModelHandlerProvider);

    // Use the refreshed sighting if available, otherwise use the original
    final displaySighting = refreshedSighting ?? widget.sighting;

    // Get the model handler
    final modelHandler = ref.read(sightingModelHandlerProvider);

    return EntityDetailView<Sighting>(
      modelHandler: modelHandler,
      entity: displaySighting,
      onEdit: () => _editSighting(displaySighting),
      onDelete: () => _deleteSighting(displaySighting),
    );
  }
}
