// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<HuntingGroundUserRole> _$HuntingGroundUserRoleFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return HuntingGroundUserRole(
    id: data['id'] as String?,
    userId: data['user_id'] as String,
    huntingGround: await HuntingGroundAdapter().fromSupabase(
      data['hunting_ground'],
      provider: provider,
      repository: repository,
    ),
    role: data['role'] as String,
  );
}

Future<Map<String, dynamic>> _$HuntingGroundUserRoleToSupabase(
  HuntingGroundUserRole instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'hunting_ground_id': instance.huntingGroundId,
    'role': instance.role,
  };
}

Future<HuntingGroundUserRole> _$HuntingGroundUserRoleFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return HuntingGroundUserRole(
    id: data['id'] as String,
    userId: data['user_id'] as String,
    huntingGround:
        (await repository!.getAssociation<HuntingGround>(
          Query.where(
            'primaryKey',
            data['hunting_ground_HuntingGround_brick_id'] as int,
            limit1: true,
          ),
        ))!.first,
    role: data['role'] as String,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$HuntingGroundUserRoleToSqlite(
  HuntingGroundUserRole instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'user_id': instance.userId,
    'hunting_ground_HuntingGround_brick_id':
        instance.huntingGround.primaryKey ??
        await provider.upsert<HuntingGround>(
          instance.huntingGround,
          repository: repository,
        ),
    'hunting_ground_id': instance.huntingGroundId,
    'role': instance.role,
  };
}

/// Construct a [HuntingGroundUserRole]
class HuntingGroundUserRoleAdapter
    extends OfflineFirstWithSupabaseAdapter<HuntingGroundUserRole> {
  HuntingGroundUserRoleAdapter();

  @override
  final supabaseTableName = 'hunting_ground_user_role';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'userId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'user_id',
      foreignKey: 'user_id',
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
    'role': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'role',
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
    'userId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'user_id',
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
    'role': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'role',
      iterable: false,
      type: String,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    HuntingGroundUserRole instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `HuntingGroundUserRole` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'HuntingGroundUserRole';

  @override
  Future<HuntingGroundUserRole> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$HuntingGroundUserRoleFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    HuntingGroundUserRole input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$HuntingGroundUserRoleToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<HuntingGroundUserRole> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$HuntingGroundUserRoleFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    HuntingGroundUserRole input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$HuntingGroundUserRoleToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
