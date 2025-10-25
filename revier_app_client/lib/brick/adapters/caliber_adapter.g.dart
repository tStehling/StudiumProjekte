// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Caliber> _$CaliberFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Caliber(
    id: data['id'] as String?,
    name: data['name'] as String,
    createdAt:
        data['created_at'] == null
            ? null
            : data['created_at'] == null
            ? null
            : DateTime.tryParse(data['created_at'] as String),
    createdById:
        data['created_by_id'] == null ? null : data['created_by_id'] as String?,
    updatedAt:
        data['updated_at'] == null
            ? null
            : data['updated_at'] == null
            ? null
            : DateTime.tryParse(data['updated_at'] as String),
    updatedById:
        data['updated_by_id'] == null ? null : data['updated_by_id'] as String?,
    deletedAt:
        data['deleted_at'] == null
            ? null
            : data['deleted_at'] == null
            ? null
            : DateTime.tryParse(data['deleted_at'] as String),
    isDeleted: data['is_deleted'] == null ? null : data['is_deleted'] as bool?,
  );
}

Future<Map<String, dynamic>> _$CaliberToSupabase(
  Caliber instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'name': instance.name,
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'is_deleted': instance.isDeleted,
  };
}

Future<Caliber> _$CaliberFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Caliber(
    id: data['id'] as String,
    name: data['name'] as String,
    createdAt:
        data['created_at'] == null
            ? null
            : data['created_at'] == null
            ? null
            : DateTime.tryParse(data['created_at'] as String),
    createdById:
        data['created_by_id'] == null ? null : data['created_by_id'] as String?,
    updatedAt:
        data['updated_at'] == null
            ? null
            : data['updated_at'] == null
            ? null
            : DateTime.tryParse(data['updated_at'] as String),
    updatedById:
        data['updated_by_id'] == null ? null : data['updated_by_id'] as String?,
    deletedAt:
        data['deleted_at'] == null
            ? null
            : data['deleted_at'] == null
            ? null
            : DateTime.tryParse(data['deleted_at'] as String),
    isDeleted: data['is_deleted'] == null ? null : data['is_deleted'] == 1,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$CaliberToSqlite(
  Caliber instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'name': instance.name,
    'created_at': instance.createdAt?.toIso8601String(),
    'created_by_id': instance.createdById,
    'updated_at': instance.updatedAt?.toIso8601String(),
    'updated_by_id': instance.updatedById,
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'is_deleted':
        instance.isDeleted == null ? null : (instance.isDeleted! ? 1 : 0),
  };
}

/// Construct a [Caliber]
class CaliberAdapter extends OfflineFirstWithSupabaseAdapter<Caliber> {
  CaliberAdapter();

  @override
  final supabaseTableName = 'caliber';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'name': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'name',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'createdById': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_by_id',
      foreignKey: 'created_by_id',
    ),
    'updatedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'updated_at',
    ),
    'updatedById': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'updated_by_id',
      foreignKey: 'updated_by_id',
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
    'name': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'name',
      iterable: false,
      type: String,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: DateTime,
    ),
    'createdById': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_by_id',
      iterable: false,
      type: String,
    ),
    'updatedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'updated_at',
      iterable: false,
      type: DateTime,
    ),
    'updatedById': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'updated_by_id',
      iterable: false,
      type: String,
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
    Caliber instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Caliber` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Caliber';

  @override
  Future<Caliber> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$CaliberFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Caliber input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$CaliberToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Caliber> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$CaliberFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Caliber input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$CaliberToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
