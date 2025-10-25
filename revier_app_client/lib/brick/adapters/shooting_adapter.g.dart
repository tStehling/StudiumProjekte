// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Shooting> _$ShootingFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Shooting(
    id: data['id'] as String?,
    shotById: data['shot_by_id'] == null ? null : data['shot_by_id'] as String?,
    weapon:
        data['weapon'] == null
            ? null
            : await WeaponAdapter().fromSupabase(
              data['weapon'],
              provider: provider,
              repository: repository,
            ),
    caliber:
        data['caliber'] == null
            ? null
            : await CaliberAdapter().fromSupabase(
              data['caliber'],
              provider: provider,
              repository: repository,
            ),
    distance: data['distance'] == null ? null : data['distance'] as double?,
    hitLocation:
        data['hit_location'] == null ? null : data['hit_location'] as String?,
    shotCount: data['shot_count'] == null ? null : data['shot_count'] as int?,
    notes: data['notes'] == null ? null : data['notes'] as String?,
    shotAt:
        data['shot_at'] == null
            ? null
            : data['shot_at'] == null
            ? null
            : DateTime.tryParse(data['shot_at'] as String),
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

Future<Map<String, dynamic>> _$ShootingToSupabase(
  Shooting instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'weapon_id': instance.weaponId,
    'caliber_id': instance.caliberId,
    'distance': instance.distance,
    'hit_location': instance.hitLocation,
    'shot_count': instance.shotCount,
    'notes': instance.notes,
    'shot_at': instance.shotAt?.toIso8601String(),
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'is_deleted': instance.isDeleted,
  };
}

Future<Shooting> _$ShootingFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Shooting(
    id: data['id'] as String,
    shotById: data['shot_by_id'] == null ? null : data['shot_by_id'] as String?,
    weapon:
        data['weapon_Weapon_brick_id'] == null
            ? null
            : (data['weapon_Weapon_brick_id'] > -1
                ? (await repository?.getAssociation<Weapon>(
                  Query.where(
                    'primaryKey',
                    data['weapon_Weapon_brick_id'] as int,
                    limit1: true,
                  ),
                ))?.first
                : null),
    caliber:
        data['caliber_Caliber_brick_id'] == null
            ? null
            : (data['caliber_Caliber_brick_id'] > -1
                ? (await repository?.getAssociation<Caliber>(
                  Query.where(
                    'primaryKey',
                    data['caliber_Caliber_brick_id'] as int,
                    limit1: true,
                  ),
                ))?.first
                : null),
    distance: data['distance'] == null ? null : data['distance'] as double?,
    hitLocation:
        data['hit_location'] == null ? null : data['hit_location'] as String?,
    shotCount: data['shot_count'] == null ? null : data['shot_count'] as int?,
    notes: data['notes'] == null ? null : data['notes'] as String?,
    shotAt:
        data['shot_at'] == null
            ? null
            : data['shot_at'] == null
            ? null
            : DateTime.tryParse(data['shot_at'] as String),
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

Future<Map<String, dynamic>> _$ShootingToSqlite(
  Shooting instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'shot_by_id': instance.shotById,
    'weapon_Weapon_brick_id':
        instance.weapon != null
            ? instance.weapon!.primaryKey ??
                await provider.upsert<Weapon>(
                  instance.weapon!,
                  repository: repository,
                )
            : null,
    'caliber_Caliber_brick_id':
        instance.caliber != null
            ? instance.caliber!.primaryKey ??
                await provider.upsert<Caliber>(
                  instance.caliber!,
                  repository: repository,
                )
            : null,
    'distance': instance.distance,
    'hit_location': instance.hitLocation,
    'shot_count': instance.shotCount,
    'notes': instance.notes,
    'shot_at': instance.shotAt?.toIso8601String(),
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'is_deleted':
        instance.isDeleted == null ? null : (instance.isDeleted! ? 1 : 0),
  };
}

/// Construct a [Shooting]
class ShootingAdapter extends OfflineFirstWithSupabaseAdapter<Shooting> {
  ShootingAdapter();

  @override
  final supabaseTableName = 'shooting';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'shotById': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'shot_by_id',
      foreignKey: 'shot_by_id',
    ),
    'weapon': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'weapon',
      associationType: Weapon,
      associationIsNullable: true,
      foreignKey: 'weapon_id',
    ),
    'weaponId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'weapon_id',
    ),
    'caliber': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'caliber',
      associationType: Caliber,
      associationIsNullable: true,
      foreignKey: 'caliber_id',
    ),
    'caliberId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'caliber_id',
    ),
    'distance': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'distance',
    ),
    'hitLocation': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'hit_location',
    ),
    'shotCount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'shot_count',
    ),
    'notes': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'notes',
    ),
    'shotAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'shot_at',
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
    'shotById': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'shot_by_id',
      iterable: false,
      type: String,
    ),
    'weapon': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'weapon_Weapon_brick_id',
      iterable: false,
      type: Weapon,
    ),
    'caliber': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'caliber_Caliber_brick_id',
      iterable: false,
      type: Caliber,
    ),
    'distance': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'distance',
      iterable: false,
      type: double,
    ),
    'hitLocation': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'hit_location',
      iterable: false,
      type: String,
    ),
    'shotCount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'shot_count',
      iterable: false,
      type: int,
    ),
    'notes': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'notes',
      iterable: false,
      type: String,
    ),
    'shotAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'shot_at',
      iterable: false,
      type: DateTime,
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
    Shooting instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Shooting` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Shooting';

  @override
  Future<Shooting> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ShootingFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Shooting input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ShootingToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Shooting> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ShootingFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Shooting input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ShootingToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
