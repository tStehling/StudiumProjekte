// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Camera> _$CameraFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Camera(
    id: data['id'] as String?,
    huntingGround: await HuntingGroundAdapter().fromSupabase(
      data['hunting_ground'],
      provider: provider,
      repository: repository,
    ),
    name: data['name'] as String,
    latitude: data['latitude'] as double,
    longitude: data['longitude'] as double,
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

Future<Map<String, dynamic>> _$CameraToSupabase(
  Camera instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'hunting_ground_id': instance.huntingGroundId,
    'name': instance.name,
    'latitude': instance.latitude,
    'longitude': instance.longitude,
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'is_deleted': instance.isDeleted,
  };
}

Future<Camera> _$CameraFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Camera(
    id: data['id'] as String,
    huntingGround:
        (await repository!.getAssociation<HuntingGround>(
          Query.where(
            'primaryKey',
            data['hunting_ground_HuntingGround_brick_id'] as int,
            limit1: true,
          ),
        ))!.first,
    name: data['name'] as String,
    latitude: data['latitude'] as double,
    longitude: data['longitude'] as double,
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

Future<Map<String, dynamic>> _$CameraToSqlite(
  Camera instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'hunting_ground_HuntingGround_brick_id':
        instance.huntingGround.primaryKey ??
        await provider.upsert<HuntingGround>(
          instance.huntingGround,
          repository: repository,
        ),
    'hunting_ground_id': instance.huntingGroundId,
    'name': instance.name,
    'latitude': instance.latitude,
    'longitude': instance.longitude,
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'is_deleted':
        instance.isDeleted == null ? null : (instance.isDeleted! ? 1 : 0),
  };
}

/// Construct a [Camera]
class CameraAdapter extends OfflineFirstWithSupabaseAdapter<Camera> {
  CameraAdapter();

  @override
  final supabaseTableName = 'camera';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
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
    'name': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'name',
    ),
    'latitude': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'latitude',
    ),
    'longitude': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'longitude',
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
    'name': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'name',
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
    Camera instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Camera` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Camera';

  @override
  Future<Camera> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$CameraFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Camera input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$CameraToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Camera> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$CameraFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Camera input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$CameraToSqlite(input, provider: provider, repository: repository);
}
