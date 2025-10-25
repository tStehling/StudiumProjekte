// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Upload> _$UploadFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Upload(
    id: data['id'] as String?,
    status: data['status'] as String,
    camera:
        data['camera'] == null
            ? null
            : await CameraAdapter().fromSupabase(
              data['camera'],
              provider: provider,
              repository: repository,
            ),
    huntingGround: await HuntingGroundAdapter().fromSupabase(
      data['hunting_ground'],
      provider: provider,
      repository: repository,
    ),
    latitude: data['latitude'] == null ? null : data['latitude'] as double?,
    longitude: data['longitude'] == null ? null : data['longitude'] as double?,
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

Future<Map<String, dynamic>> _$UploadToSupabase(
  Upload instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'status': instance.status,
    'camera_id': instance.cameraId,
    'hunting_ground_id': instance.huntingGroundId,
    'latitude': instance.latitude,
    'longitude': instance.longitude,
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'is_deleted': instance.isDeleted,
  };
}

Future<Upload> _$UploadFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Upload(
    id: data['id'] as String,
    status: data['status'] as String,
    camera:
        data['camera_Camera_brick_id'] == null
            ? null
            : (data['camera_Camera_brick_id'] > -1
                ? (await repository?.getAssociation<Camera>(
                  Query.where(
                    'primaryKey',
                    data['camera_Camera_brick_id'] as int,
                    limit1: true,
                  ),
                ))?.first
                : null),
    huntingGround:
        (await repository!.getAssociation<HuntingGround>(
          Query.where(
            'primaryKey',
            data['hunting_ground_HuntingGround_brick_id'] as int,
            limit1: true,
          ),
        ))!.first,
    latitude: data['latitude'] == null ? null : data['latitude'] as double?,
    longitude: data['longitude'] == null ? null : data['longitude'] as double?,
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

Future<Map<String, dynamic>> _$UploadToSqlite(
  Upload instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'status': instance.status,
    'camera_Camera_brick_id':
        instance.camera != null
            ? instance.camera!.primaryKey ??
                await provider.upsert<Camera>(
                  instance.camera!,
                  repository: repository,
                )
            : null,
    'hunting_ground_HuntingGround_brick_id':
        instance.huntingGround.primaryKey ??
        await provider.upsert<HuntingGround>(
          instance.huntingGround,
          repository: repository,
        ),
    'hunting_ground_id': instance.huntingGroundId,
    'latitude': instance.latitude,
    'longitude': instance.longitude,
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

/// Construct a [Upload]
class UploadAdapter extends OfflineFirstWithSupabaseAdapter<Upload> {
  UploadAdapter();

  @override
  final supabaseTableName = 'upload';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'status': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'status',
    ),
    'camera': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'camera',
      associationType: Camera,
      associationIsNullable: true,
      foreignKey: 'camera_id',
    ),
    'cameraId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'camera_id',
    ),
    'huntingGround': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'hunting_ground',
      associationType: HuntingGround,
      associationIsNullable: false,
      foreignKey: 'hunting_ground_id',
    ),
    'huntingGroundId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'hunting_ground_id',
    ),
    'latitude': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'latitude',
    ),
    'longitude': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'longitude',
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
    'status': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'status',
      iterable: false,
      type: String,
    ),
    'camera': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'camera_Camera_brick_id',
      iterable: false,
      type: Camera,
    ),
    'huntingGround': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'hunting_ground_HuntingGround_brick_id',
      iterable: false,
      type: HuntingGround,
    ),
    'huntingGroundId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'hunting_ground_id',
      iterable: false,
      type: String,
    ),
    'latitude': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'latitude',
      iterable: false,
      type: double,
    ),
    'longitude': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'longitude',
      iterable: false,
      type: double,
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
    Upload instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Upload` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Upload';

  @override
  Future<Upload> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$UploadFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Upload input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$UploadToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Upload> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$UploadFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Upload input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$UploadToSqlite(input, provider: provider, repository: repository);
}
