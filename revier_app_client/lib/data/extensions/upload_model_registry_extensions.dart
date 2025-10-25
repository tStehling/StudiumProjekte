import 'package:brick_core/query.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revier_app_client/brick/models/upload.model.dart';
import 'package:revier_app_client/data/model_registry.dart';

/// Extension for Upload-specific operations on ModelRegistry
extension UploadOperations on ModelRegistry {
  /// Get uploads with a specific status
  Future<List<Upload>> getUploadsByStatus(WidgetRef ref, String status) async {
    return getWhere<Upload>(ref, query: Query.where('status', status));
  }

  /// Mark an upload as complete
  Future<void> markUploadAsCompleted(WidgetRef ref, String id) async {
    final upload = await getById<Upload>(ref, id);
    if (upload != null) {
      final updatedUpload = Upload(
        id: upload.id,
        status: 'COMPLETED',
        camera: upload.camera,
        huntingGround: upload.huntingGround,
        latitude: upload.latitude,
        longitude: upload.longitude,
        createdAt: upload.createdAt,
        updatedAt: DateTime.now(),
      );
      await update<Upload>(ref, updatedUpload);
    }
  }

  /// Mark an upload as failed
  Future<void> markUploadAsFailed(WidgetRef ref, String id) async {
    final upload = await getById<Upload>(ref, id);
    if (upload != null) {
      final updatedUpload = Upload(
        id: upload.id,
        status: 'FAILED',
        camera: upload.camera,
        huntingGround: upload.huntingGround,
        latitude: upload.latitude,
        longitude: upload.longitude,
        createdAt: upload.createdAt,
        updatedAt: DateTime.now(),
      );
      await update<Upload>(ref, updatedUpload);
    }
  }

  /// Stream of uploads with a specific status
  AsyncValue<List<Upload>> watchUploadsByStatus(WidgetRef ref, String status) {
    // This is a workaround since we can't directly subscribe to a filtered stream
    // We filter the full list of uploads by status
    final allUploadsAsync = watchAll<Upload>(ref);

    return allUploadsAsync.when(
      data: (uploads) {
        final filtered = uploads.where((u) => u.status == status).toList();
        return AsyncData(filtered);
      },
      loading: () => const AsyncLoading(),
      error: (error, stackTrace) => AsyncError(error, stackTrace),
    );
  }
}
