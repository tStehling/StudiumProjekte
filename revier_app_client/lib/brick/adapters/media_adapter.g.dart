// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Media> _$MediaFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Media(
    id: data['id'] as String?,
    mediaType: data['media_type'] as String,
    remoteFilePath:
        data['remote_file_path'] == null
            ? null
            : data['remote_file_path'] as String?,
    localFilePath:
        data['local_file_path'] == null
            ? null
            : data['local_file_path'] as String?,
    timeOffset:
        data['time_offset'] == null ? null : data['time_offset'] as int?,
    timestampOriginal:
        data['timestamp_original'] == null
            ? null
            : data['timestamp_original'] == null
            ? null
            : DateTime.tryParse(data['timestamp_original'] as String),
    timestamp:
        data['timestamp'] == null
            ? null
            : data['timestamp'] == null
            ? null
            : DateTime.tryParse(data['timestamp'] as String),
    createdById:
        data['created_by_id'] == null ? null : data['created_by_id'] as String?,
    updatedById:
        data['updated_by_id'] == null ? null : data['updated_by_id'] as String?,
    deletedById:
        data['deleted_by_id'] == null ? null : data['deleted_by_id'] as String?,
    createdAt:
        data['created_at'] == null
            ? null
            : data['created_at'] == null
            ? null
            : DateTime.tryParse(data['created_at'] as String),
    updatedAt:
        data['updated_at'] == null
            ? null
            : data['updated_at'] == null
            ? null
            : DateTime.tryParse(data['updated_at'] as String),
    deletedAt:
        data['deleted_at'] == null
            ? null
            : data['deleted_at'] == null
            ? null
            : DateTime.tryParse(data['deleted_at'] as String),
    isDeleted: data['is_deleted'] == null ? null : data['is_deleted'] as bool?,
  );
}

Future<Map<String, dynamic>> _$MediaToSupabase(
  Media instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'media_type': instance.mediaType,
    'remote_file_path': instance.remoteFilePath,
    'local_file_path': instance.localFilePath,
    'time_offset': instance.timeOffset,
    'timestamp_original': instance.timestampOriginal?.toIso8601String(),
    'timestamp': instance.timestamp?.toIso8601String(),
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'is_deleted': instance.isDeleted,
  };
}

Future<Media> _$MediaFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Media(
    id: data['id'] as String,
    mediaType: data['media_type'] as String,
    remoteFilePath:
        data['remote_file_path'] == null
            ? null
            : data['remote_file_path'] as String?,
    localFilePath:
        data['local_file_path'] == null
            ? null
            : data['local_file_path'] as String?,
    timeOffset:
        data['time_offset'] == null ? null : data['time_offset'] as int?,
    timestampOriginal:
        data['timestamp_original'] == null
            ? null
            : data['timestamp_original'] == null
            ? null
            : DateTime.tryParse(data['timestamp_original'] as String),
    timestamp:
        data['timestamp'] == null
            ? null
            : data['timestamp'] == null
            ? null
            : DateTime.tryParse(data['timestamp'] as String),
    createdById:
        data['created_by_id'] == null ? null : data['created_by_id'] as String?,
    updatedById:
        data['updated_by_id'] == null ? null : data['updated_by_id'] as String?,
    deletedById:
        data['deleted_by_id'] == null ? null : data['deleted_by_id'] as String?,
    createdAt:
        data['created_at'] == null
            ? null
            : data['created_at'] == null
            ? null
            : DateTime.tryParse(data['created_at'] as String),
    updatedAt:
        data['updated_at'] == null
            ? null
            : data['updated_at'] == null
            ? null
            : DateTime.tryParse(data['updated_at'] as String),
    deletedAt:
        data['deleted_at'] == null
            ? null
            : data['deleted_at'] == null
            ? null
            : DateTime.tryParse(data['deleted_at'] as String),
    isDeleted: data['is_deleted'] == null ? null : data['is_deleted'] == 1,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$MediaToSqlite(
  Media instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'media_type': instance.mediaType,
    'remote_file_path': instance.remoteFilePath,
    'local_file_path': instance.localFilePath,
    'time_offset': instance.timeOffset,
    'timestamp_original': instance.timestampOriginal?.toIso8601String(),
    'timestamp': instance.timestamp?.toIso8601String(),
    'created_by_id': instance.createdById,
    'updated_by_id': instance.updatedById,
    'deleted_by_id': instance.deletedById,
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'is_deleted':
        instance.isDeleted == null ? null : (instance.isDeleted! ? 1 : 0),
  };
}

/// Construct a [Media]
class MediaAdapter extends OfflineFirstWithSupabaseAdapter<Media> {
  MediaAdapter();

  @override
  final supabaseTableName = 'media';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'mediaType': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'media_type',
    ),
    'remoteFilePath': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'remote_file_path',
    ),
    'localFilePath': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'local_file_path',
    ),
    'timeOffset': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'time_offset',
    ),
    'timestampOriginal': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'timestamp_original',
    ),
    'timestamp': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'timestamp',
    ),
    'createdById': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_by_id',
      foreignKey: 'created_by_id',
    ),
    'updatedById': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'updated_by_id',
      foreignKey: 'updated_by_id',
    ),
    'deletedById': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'deleted_by_id',
      foreignKey: 'deleted_by_id',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'updatedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'updated_at',
    ),
    'deletedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'deleted_at',
    ),
    'isDeleted': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_deleted',
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
    'mediaType': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'media_type',
      iterable: false,
      type: String,
    ),
    'remoteFilePath': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'remote_file_path',
      iterable: false,
      type: String,
    ),
    'localFilePath': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'local_file_path',
      iterable: false,
      type: String,
    ),
    'timeOffset': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'time_offset',
      iterable: false,
      type: int,
    ),
    'timestampOriginal': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'timestamp_original',
      iterable: false,
      type: DateTime,
    ),
    'timestamp': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'timestamp',
      iterable: false,
      type: DateTime,
    ),
    'createdById': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_by_id',
      iterable: false,
      type: String,
    ),
    'updatedById': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'updated_by_id',
      iterable: false,
      type: String,
    ),
    'deletedById': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'deleted_by_id',
      iterable: false,
      type: String,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: DateTime,
    ),
    'updatedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'updated_at',
      iterable: false,
      type: DateTime,
    ),
    'deletedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'deleted_at',
      iterable: false,
      type: DateTime,
    ),
    'isDeleted': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_deleted',
      iterable: false,
      type: bool,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    Media instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Media` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Media';

  @override
  Future<Media> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$MediaFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Media input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$MediaToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Media> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$MediaFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Media input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$MediaToSqlite(input, provider: provider, repository: repository);
}
