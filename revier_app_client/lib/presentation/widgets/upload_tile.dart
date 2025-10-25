import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:revier_app_client/brick/models/upload.model.dart';
import 'package:revier_app_client/data/model_registry.dart';
import 'package:revier_app_client/data/providers/model_registry_provider.dart';
import 'package:revier_app_client/features/hunting_ground/providers/hunting_ground_provider.dart';

/// A widget that displays a single upload
class UploadTile extends ConsumerWidget {
  /// The upload to display
  final Upload upload;

  /// Constructor
  const UploadTile({
    super.key,
    required this.upload,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: _buildStatusIcon(context),
        title: Text('Upload ${upload.id.substring(0, 8)}...'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: ${upload.status}'),
            if (upload.latitude != null && upload.longitude != null)
              Text(
                'Location: ${upload.latitude?.toStringAsFixed(4)}, '
                '${upload.longitude?.toStringAsFixed(4)}',
              ),
            if (upload.createdAt != null)
              Text(
                'Created: ${_formatDateTime(upload.createdAt!)}',
              ),
          ],
        ),
        isThreeLine: true,
        trailing: _buildActionButton(context, ref),
        onTap: () {
          // We could navigate to an upload details screen here
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (_) => UploadDetailScreen(upload: upload),
          //   ),
          // );
        },
      ),
    );
  }

  /// Builds an icon representing the upload status
  Widget _buildStatusIcon(BuildContext context) {
    final theme = Theme.of(context);

    switch (upload.status) {
      case 'PENDING':
        return const Icon(Icons.hourglass_empty, color: Colors.orange);
      case 'UPLOADING':
        return SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: theme.colorScheme.primary,
          ),
        );
      case 'COMPLETED':
        return Icon(Icons.check_circle, color: theme.colorScheme.primary);
      case 'FAILED':
        return Icon(Icons.error, color: theme.colorScheme.error);
      default:
        return const Icon(Icons.help);
    }
  }

  /// Builds an action button based on the upload status
  Widget? _buildActionButton(BuildContext context, WidgetRef ref) {
    final registry = ref.read(modelRegistryProvider);

    if (upload.status == 'FAILED') {
      return IconButton(
        icon: const Icon(Icons.refresh),
        tooltip: 'Retry upload',
        onPressed: () {
          final updatedUpload = Upload(
            id: upload.id,
            status: 'PENDING',
            camera: upload.camera,
            huntingGround: upload.huntingGround,
            latitude: upload.latitude,
            longitude: upload.longitude,
            createdAt: upload.createdAt,
            updatedAt: DateTime.now(),
            deletedAt: null,
            isDeleted: false,
          );

          registry.update<Upload>(ref, updatedUpload);
        },
      );
    } else if (upload.status == 'PENDING' || upload.status == 'UPLOADING') {
      return IconButton(
        icon: const Icon(Icons.cancel),
        tooltip: 'Cancel upload',
        onPressed: () {
          _showCancelConfirmation(context, ref);
        },
      );
    }

    return null;
  }

  /// Shows a confirmation dialog for cancelling an upload
  void _showCancelConfirmation(BuildContext context, WidgetRef ref) {
    final registry = ref.read(modelRegistryProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Upload'),
        content: const Text('Are you sure you want to cancel this upload?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              registry.delete<Upload>(ref, upload);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  /// Formats a DateTime for display
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-'
        '${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
