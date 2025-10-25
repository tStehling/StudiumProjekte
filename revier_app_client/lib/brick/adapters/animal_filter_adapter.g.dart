// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<AnimalFilter> _$AnimalFilterFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return AnimalFilter(
    id: data['id'] as String?,
    name: data['name'] as String,
    huntingGround: await HuntingGroundAdapter().fromSupabase(
      data['hunting_ground'],
      provider: provider,
      repository: repository,
    ),
    animalCount: data['animal_count'] as int,
    animalCountType: data['animal_count_type'] as String,
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

Future<Map<String, dynamic>> _$AnimalFilterToSupabase(
  AnimalFilter instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'name': instance.name,
    'hunting_ground_id': instance.huntingGroundId,
    'animal_count': instance.animalCount,
    'animal_count_type': instance.animalCountType,
    'species_id': instance.speciesId,
    'custom_color': instance.customColor,
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'is_deleted': instance.isDeleted,
  };
}

Future<AnimalFilter> _$AnimalFilterFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return AnimalFilter(
    id: data['id'] as String,
    name: data['name'] as String,
    huntingGround:
        (await repository!.getAssociation<HuntingGround>(
          Query.where(
            'primaryKey',
            data['hunting_ground_HuntingGround_brick_id'] as int,
            limit1: true,
          ),
        ))!.first,
    animalCount: data['animal_count'] as int,
    animalCountType: data['animal_count_type'] as String,
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

Future<Map<String, dynamic>> _$AnimalFilterToSqlite(
  AnimalFilter instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'name': instance.name,
    'hunting_ground_HuntingGround_brick_id':
        instance.huntingGround.primaryKey ??
        await provider.upsert<HuntingGround>(
          instance.huntingGround,
          repository: repository,
        ),
    'hunting_ground_id': instance.huntingGroundId,
    'animal_count': instance.animalCount,
    'animal_count_type': instance.animalCountType,
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

/// Construct a [AnimalFilter]
class AnimalFilterAdapter
    extends OfflineFirstWithSupabaseAdapter<AnimalFilter> {
  AnimalFilterAdapter();

  @override
  final supabaseTableName = 'animal_filter';
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
    'animalCount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'animal_count',
    ),
    'animalCountType': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'animal_count_type',
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
    'name': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'name',
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
    'animalCount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'animal_count',
      iterable: false,
      type: int,
    ),
    'animalCountType': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'animal_count_type',
      iterable: false,
      type: String,
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
    AnimalFilter instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `AnimalFilter` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'AnimalFilter';

  @override
  Future<AnimalFilter> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$AnimalFilterFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    AnimalFilter input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$AnimalFilterToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<AnimalFilter> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$AnimalFilterFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    AnimalFilter input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$AnimalFilterToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
