import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revier_app_client/brick/models/upload.model.dart';
import 'package:revier_app_client/common/model_management/entity_detail_view.dart';
import 'package:revier_app_client/common/model_management/model_handler.dart';
import 'package:revier_app_client/core/services/logging_service.dart';
import 'package:revier_app_client/features/upload/upload_model_handler.dart';
import 'package:revier_app_client/common/navigation/navigation_service.dart';
import 'package:revier_app_client/common/widgets/dialogs/confirm_dialog.dart';
import 'package:revier_app_client/common/widgets/snackbars/app_snackbar.dart';

/// Provider for the upload model handler
final uploadModelHandlerProvider =
    Provider<UploadModelHandler>((ref) => UploadModelHandler());

/// A detailed view for displaying upload information that listens to provider updates.
///
/// This widget wraps the generic EntityDetailView but adds Riverpod consumer
/// functionality to refresh when the underlying upload data changes.
class UploadDetailView extends ConsumerStatefulWidget {
  /// The upload ID to display
  final String? uploadId;

  /// The upload to display
  final Upload? upload;

  /// Custom title for the view
  final String? title;

  /// Create a new UploadDetailView
  ///
  /// Either [uploadId] or [upload] must be provided.
  /// If both are provided, [upload] will be used initially but the ID will be used for refreshing.
  const UploadDetailView({
    super.key,
    this.uploadId,
    this.upload,
    this.title,
  }) : assert(uploadId != null || upload != null,
            'Either uploadId or upload must be provided');

  @override
  ConsumerState<UploadDetailView> createState() => _UploadDetailViewState();
}

class _UploadDetailViewState extends ConsumerState<UploadDetailView> {
  late String? uploadId;
  Upload? refreshedUpload;
  final _log = loggingService.getLogger('UploadDetailView');

  @override
  void initState() {
    super.initState();
    uploadId = widget.upload?.id ?? widget.uploadId;
    _log.info('Initializing UploadDetailView for upload ID: $uploadId');
    _refreshUpload();
  }

  Future<void> _refreshUpload() async {
    if (uploadId == null) {
      _log.warning('Cannot refresh - no upload ID');
      return;
    }

    final modelHandler = ref.read(uploadModelHandlerProvider);
    try {
      // Fetch the latest version of this upload
      final upload = await modelHandler.fetchById(ref, uploadId!);
      if (mounted && upload != null) {
        setState(() {
          refreshedUpload = upload;
        });
      }
    } catch (e) {
      _log.error('Error refreshing upload', error: e);
    }
  }

  Future<void> _editUpload(Upload upload) async {
    // Show error message since uploads might not be directly editable
    showInfoSnackBar(context, 'Editing uploads is not supported');

    // In the future, you might add navigation to an edit form
    // For now, we'll just refresh the data
    _refreshUpload();
  }

  void _deleteUpload(Upload upload) async {
    // Show confirmation dialog
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Delete Upload',
      message: 'Are you sure you want to delete this upload?',
      confirmText: 'Delete',
      isDestructive: true,
    );

    if (confirmed) {
      final modelHandler = ref.read(uploadModelHandlerProvider);

      try {
        // Delete the upload
        await modelHandler.delete(ref, upload);

        // Navigate back after deletion
        if (mounted) {
          // Show success message
          showSuccessSnackBar(context, 'Upload deleted successfully');
          NavigationService.instance.goBack();
        }
      } catch (e) {
        if (mounted) {
          // Show error message
          showErrorSnackBar(context, 'Error deleting upload: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // This ensures the widget rebuilds when the provider changes
    ref.watch(uploadModelHandlerProvider);

    // Get the initial upload (either passed in directly or refreshed)
    final initialUpload = widget.upload;

    // Use the refreshed upload if available, otherwise use the initial
    final displayUpload = refreshedUpload ?? initialUpload;

    // If we don't have an upload to display yet, show a loading indicator
    if (displayUpload == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? 'Upload Details'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Get the model handler
    final modelHandler = ref.read(uploadModelHandlerProvider);

    return EntityDetailView<Upload>(
      modelHandler: modelHandler,
      entity: displayUpload,
      onEdit: () => _editUpload(displayUpload),
      onDelete: () => _deleteUpload(displayUpload),
    );
  }
}
