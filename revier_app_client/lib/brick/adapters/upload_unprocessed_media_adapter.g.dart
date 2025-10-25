// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<UploadUnprocessedMedia> _$UploadUnprocessedMediaFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return UploadUnprocessedMedia(
    id: data['id'] as String?,
    upload: await UploadAdapter().fromSupabase(
      data['upload'],
      provider: provider,
      repository: repository,
    ),
    media: await MediaAdapter().fromSupabase(
      data['media'],
      provider: provider,
      repository: repository,
    ),
  );
}

Future<Map<String, dynamic>> _$UploadUnprocessedMediaToSupabase(
  UploadUnprocessedMedia instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'upload_id': instance.uploadId,
    'media_id': instance.mediaId,
  };
}

Future<UploadUnprocessedMedia> _$UploadUnprocessedMediaFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return UploadUnprocessedMedia(
    id: data['id'] as String,
    upload:
        (await repository!.getAssociation<Upload>(
          Query.where(
            'primaryKey',
            data['upload_Upload_brick_id'] as int,
            limit1: true,
          ),
        ))!.first,
    media:
        (await repository.getAssociation<Media>(
          Query.where(
            'primaryKey',
            data['media_Media_brick_id'] as int,
            limit1: true,
          ),
        ))!.first,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$UploadUnprocessedMediaToSqlite(
  UploadUnprocessedMedia instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'upload_Upload_brick_id':
        instance.upload.primaryKey ??
        await provider.upsert<Upload>(instance.upload, repository: repository),
    'media_Media_brick_id':
        instance.media.primaryKey ??
        await provider.upsert<Media>(instance.media, repository: repository),
  };
}

/// Construct a [UploadUnprocessedMedia]
class UploadUnprocessedMediaAdapter
    extends OfflineFirstWithSupabaseAdapter<UploadUnprocessedMedia> {
  UploadUnprocessedMediaAdapter();

  @override
  final supabaseTableName = 'upload_unprocessed_media';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'upload': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'upload',
      associationType: Upload,
      associationIsNullable: false,
      foreignKey: 'upload_id',
    ),
    'uploadId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'upload_id',
    ),
    'media': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'media',
      associationType: Media,
      associationIsNullable: false,
      foreignKey: 'media_id',
    ),
    'mediaId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'media_id',
    ),
  };
  @override
  final ignoreDuplicates = false;
  @override
  final uniqueFields = {'id'};
  @override
  final Map<String, RuntimeSqliteColumnDefinition> fieldsToSqliteColumns = {
    'primaryKey': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: '_brick_id',
      iterable: false,
      type: int,
    ),
    'id': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'id',
      iterable: false,
      type: String,
    ),
    'upload': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'upload_Upload_brick_id',
      iterable: false,
      type: Upload,
    ),
    'media': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'media_Media_brick_id',
      iterable: false,
      type: Media,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    UploadUnprocessedMedia instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `UploadUnprocessedMedia` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'UploadUnprocessedMedia';

  @override
  Future<UploadUnprocessedMedia> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$UploadUnprocessedMediaFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    UploadUnprocessedMedia input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$UploadUnprocessedMediaToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<UploadUnprocessedMedia> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$UploadUnprocessedMediaFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    UploadUnprocessedMedia input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$UploadUnprocessedMediaToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
