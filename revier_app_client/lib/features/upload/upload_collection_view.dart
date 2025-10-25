import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revier_app_client/brick/models/upload.model.dart';
import 'package:revier_app_client/common/model_management/hunting_ground_filtered_model_view.dart';
import 'package:revier_app_client/core/services/logging_service.dart';
import 'package:revier_app_client/features/upload/upload_model_handler.dart';
import 'package:revier_app_client/features/upload/upload_detail_view.dart';
import 'package:revier_app_client/common/navigation/navigation_service.dart';
import 'package:revier_app_client/common/model_management/sort_provider.dart';
import 'package:intl/intl.dart';

/// Providers for upload view state
final uploadSortProvider =
    StateNotifierProvider<SortSettingsNotifier, SortSettings>((ref) {
  return SortSettingsNotifier(
    defaultField: 'createdAt',
    prefsKey: 'upload',
  );
});

final uploadViewModeProvider =
    StateNotifierProvider<ViewModeNotifier, bool>((ref) {
  return ViewModeNotifier(
    defaultIsGrid: true,
    prefsKey: 'upload',
  );
});

final uploadSortLabelsProvider = Provider<Map<String, String>>((ref) => {
      'createdAt': 'Date Created',
      'updatedAt': 'Date Updated',
      'status': 'Status',
    });

/// A collection view for displaying a list of uploads
class UploadCollectionView extends ConsumerWidget {
  static final _log = loggingService.getLogger('UploadCollectionView');

  /// Filter for upload status
  final String? statusFilter;

  /// Maximum number of uploads to display
  final int? maxItems;

  /// Whether to show the collection title
  final bool showTitle;

  /// Create a new UploadCollectionView
  const UploadCollectionView({
    super.key,
    this.statusFilter,
    this.maxItems,
    this.showTitle = true,
  });

  String _getUploadSubtitle(Upload upload) {
    final parts = <String>[];

    if (upload.camera != null) {
      parts.add(upload.camera!.name);
    }

    if (upload.createdAt != null) {
      parts.add(DateFormat('yyyy-MM-dd').format(upload.createdAt!));
    }

    if (parts.isEmpty) {
      return 'No details available';
    }

    return parts.join(' • ');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _log.info('Building UploadCollectionView');

    // Get the model handler
    final modelHandler = ref.watch(uploadModelHandlerProvider);

    return HuntingGroundFilteredModelView<Upload>(
      modelHandler: modelHandler,
      detailViewBuilder: (context, upload) => UploadDetailView(
        upload: upload,
      ),

      // Use our Riverpod providers for sorting and view mode
      sortProvider: uploadSortProvider,
      viewModeProvider: uploadViewModeProvider,
      sortLabelsProvider: uploadSortLabelsProvider,

      // Subtitle provider
      subtitleProvider: _getUploadSubtitle,

      // Enable layout switch and search
      showLayoutSwitch: true,
      showSearch: true,

      // Customize appearance
      gridColumns: 2,
      gridAspectRatio: 1.5,

      // Filter by camera's hunting ground ID
      huntingGroundIdField: 'huntingGroundId',

      // Enable persistent preferences
      preferenceKey: 'upload_collection',
    );
  }
}
