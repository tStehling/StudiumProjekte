// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Animal> _$AnimalFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Animal(
    id: data['id'] as String?,
    huntingGround: await HuntingGroundAdapter().fromSupabase(
      data['hunting_ground'],
      provider: provider,
      repository: repository,
    ),
    name: data['name'] as String,
    dead: data['dead'] as bool,
    age: data['age'] == null ? null : data['age'] as double?,
    weight: data['weight'] == null ? null : data['weight'] as double?,
    abnormalities:
        data['abnormalities'] == null ? null : data['abnormalities'] as String?,
    shootingPriority:
        data['shooting_priority'] == null
            ? null
            : data['shooting_priority'] as int?,
    notes: data['notes'] == null ? null : data['notes'] as String?,
    shooting:
        data['shooting'] == null
            ? null
            : await ShootingAdapter().fromSupabase(
              data['shooting'],
              provider: provider,
              repository: repository,
            ),
    species: await SpeciesAdapter().fromSupabase(
      data['species'],
      provider: provider,
      repository: repository,
    ),
    customColor:
        data['custom_color'] == null ? null : data['custom_color'] as int?,
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

Future<Map<String, dynamic>> _$AnimalToSupabase(
  Animal instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'hunting_ground_id': instance.huntingGroundId,
    'name': instance.name,
    'dead': instance.dead,
    'age': instance.age,
    'weight': instance.weight,
    'abnormalities': instance.abnormalities,
    'shooting_priority': instance.shootingPriority,
    'notes': instance.notes,
    'shooting_id': instance.shootingId,
    'species_id': instance.speciesId,
    'custom_color': instance.customColor,
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'is_deleted': instance.isDeleted,
  };
}

Future<Animal> _$AnimalFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Animal(
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
    dead: data['dead'] == 1,
    age: data['age'] == null ? null : data['age'] as double?,
    weight: data['weight'] == null ? null : data['weight'] as double?,
    abnormalities:
        data['abnormalities'] == null ? null : data['abnormalities'] as String?,
    shootingPriority:
        data['shooting_priority'] == null
            ? null
            : data['shooting_priority'] as int?,
    notes: data['notes'] == null ? null : data['notes'] as String?,
    shooting:
        data['shooting_Shooting_brick_id'] == null
            ? null
            : (data['shooting_Shooting_brick_id'] > -1
                ? (await repository.getAssociation<Shooting>(
                  Query.where(
                    'primaryKey',
                    data['shooting_Shooting_brick_id'] as int,
                    limit1: true,
                  ),
                ))?.first
                : null),
    species:
        (await repository.getAssociation<Species>(
          Query.where(
            'primaryKey',
            data['species_Species_brick_id'] as int,
            limit1: true,
          ),
        ))!.first,
    customColor:
        data['custom_color'] == null ? null : data['custom_color'] as int?,
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

Future<Map<String, dynamic>> _$AnimalToSqlite(
  Animal instance, {
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
    'dead': instance.dead ? 1 : 0,
    'age': instance.age,
    'weight': instance.weight,
    'abnormalities': instance.abnormalities,
    'shooting_priority': instance.shootingPriority,
    'notes': instance.notes,
    'shooting_Shooting_brick_id':
        instance.shooting != null
            ? instance.shooting!.primaryKey ??
                await provider.upsert<Shooting>(
                  instance.shooting!,
                  repository: repository,
                )
            : null,
    'species_Species_brick_id':
        instance.species.primaryKey ??
        await provider.upsert<Species>(
          instance.species,
          repository: repository,
        ),
    'custom_color': instance.customColor,
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'is_deleted':
        instance.isDeleted == null ? null : (instance.isDeleted! ? 1 : 0),
  };
}

/// Construct a [Animal]
class AnimalAdapter extends OfflineFirstWithSupabaseAdapter<Animal> {
  AnimalAdapter();

  @override
  final supabaseTableName = 'animal';
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
    'dead': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'dead',
    ),
    'age': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'age',
    ),
    'weight': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'weight',
    ),
    'abnormalities': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'abnormalities',
    ),
    'shootingPriority': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'shooting_priority',
    ),
    'notes': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'notes',
    ),
    'shooting': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'shooting',
      associationType: Shooting,
      associationIsNullable: true,
      foreignKey: 'shooting_id',
    ),
    'shootingId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'shooting_id',
    ),
    'species': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'species',
      associationType: Species,
      associationIsNullable: false,
      foreignKey: 'species_id',
    ),
    'speciesId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'species_id',
    ),
    'customColor': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'custom_color',
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
    'dead': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'dead',
      iterable: false,
      type: bool,
    ),
    'age': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'age',
      iterable: false,
      type: double,
    ),
    'weight': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'weight',
      iterable: false,
      type: double,
    ),
    'abnormalities': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'abnormalities',
      iterable: false,
      type: String,
    ),
    'shootingPriority': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'shooting_priority',
      iterable: false,
      type: int,
    ),
    'notes': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'notes',
      iterable: false,
      type: String,
    ),
    'shooting': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'shooting_Shooting_brick_id',
      iterable: false,
      type: Shooting,
    ),
    'species': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'species_Species_brick_id',
      iterable: false,
      type: Species,
    ),
    'customColor': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'custom_color',
      iterable: false,
      type: int,
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
    Animal instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Animal` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Animal';

  @override
  Future<Animal> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$AnimalFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Animal input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$AnimalToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Animal> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$AnimalFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Animal input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$AnimalToSqlite(input, provider: provider, repository: repository);
}
