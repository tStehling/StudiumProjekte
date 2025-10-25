import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:revier_app_client/common/widgets/collections/core_collection_type.dart';
import 'package:revier_app_client/common/model_management/model_handler.dart';

/// Adapts model entities to CoreCollectionItemType for use with CoreCollectionView
class ModelCollectionAdapter<T extends OfflineFirstWithSupabaseModel> {
  final ModelHandler<T> modelHandler;

  /// Custom image path provider for entities (optional)
  final String Function(T entity)? imagePathProvider;

  /// Custom subtitle provider for entities (optional)
  final String Function(T entity)? subtitleProvider;

  ModelCollectionAdapter({
    required this.modelHandler,
    this.imagePathProvider,
    this.subtitleProvider,
  });

  /// Convert a single entity to a CoreCollectionItemType
  CoreCollectionItemType convertEntity(T entity) {
    return (
      imagePath: imagePathProvider?.call(entity) ?? '',
      title: modelHandler.getDisplayText(entity),
      subtitle: subtitleProvider?.call(entity) ?? _getDefaultSubtitle(entity),
    );
  }

  /// Convert a list of entities to a list of CoreCollectionItemType
  List<CoreCollectionItemType> convertEntities(List<T> entities) {
    return entities.map(convertEntity).toList();
  }

  /// Generate a default subtitle based on the entity's fields
  String _getDefaultSubtitle(T entity) {
    // Get the first couple of display fields excluding the one used for the title
    final displayFields = modelHandler.listDisplayFields.take(2).toList();
    if (displayFields.isEmpty) return '';

    final parts = <String>[];
    for (final field in displayFields) {
      final value = modelHandler.getFieldValue(entity, field);
      if (value != null) {
        final formattedValue = modelHandler.formatDisplayValue(field, value);
        if (formattedValue.isNotEmpty) {
          parts.add(formattedValue);
        }
      }
    }

    return parts.join(' • ');
  }
}
