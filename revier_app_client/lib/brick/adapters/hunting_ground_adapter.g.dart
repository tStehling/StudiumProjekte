// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<HuntingGround> _$HuntingGroundFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return HuntingGround(
    id: data['id'] as String?,
    name: data['name'] as String,
    federalState: await FederalStateAdapter().fromSupabase(
      data['federal_state'],
      provider: provider,
      repository: repository,
    ),
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

Future<Map<String, dynamic>> _$HuntingGroundToSupabase(
  HuntingGround instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'name': instance.name,
    'federal_state_id': instance.federalStateId,
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'is_deleted': instance.isDeleted,
  };
}

Future<HuntingGround> _$HuntingGroundFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return HuntingGround(
    id: data['id'] as String,
    name: data['name'] as String,
    federalState:
        (await repository!.getAssociation<FederalState>(
          Query.where(
            'primaryKey',
            data['federal_state_FederalState_brick_id'] as int,
            limit1: true,
          ),
        ))!.first,
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

Future<Map<String, dynamic>> _$HuntingGroundToSqlite(
  HuntingGround instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'name': instance.name,
    'federal_state_FederalState_brick_id':
        instance.federalState.primaryKey ??
        await provider.upsert<FederalState>(
          instance.federalState,
          repository: repository,
        ),
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'is_deleted':
        instance.isDeleted == null ? null : (instance.isDeleted! ? 1 : 0),
  };
}

/// Construct a [HuntingGround]
class HuntingGroundAdapter
    extends OfflineFirstWithSupabaseAdapter<HuntingGround> {
  HuntingGroundAdapter();

  @override
  final supabaseTableName = 'hunting_ground';
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
    'federalState': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'federal_state',
      associationType: FederalState,
      associationIsNullable: false,
      foreignKey: 'federal_state_id',
    ),
    'federalStateId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'federal_state_id',
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
    'name': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'name',
      iterable: false,
      type: String,
    ),
    'federalState': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'federal_state_FederalState_brick_id',
      iterable: false,
      type: FederalState,
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
    HuntingGround instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `HuntingGround` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'HuntingGround';

  @override
  Future<HuntingGround> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$HuntingGroundFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    HuntingGround input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$HuntingGroundToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<HuntingGround> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$HuntingGroundFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    HuntingGround input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$HuntingGroundToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
