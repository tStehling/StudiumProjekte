// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<HuntingSeason> _$HuntingSeasonFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return HuntingSeason(
    id: data['id'] as String?,
    federalState: await FederalStateAdapter().fromSupabase(
      data['federal_state'],
      provider: provider,
      repository: repository,
    ),
    species: await SpeciesAdapter().fromSupabase(
      data['species'],
      provider: provider,
      repository: repository,
    ),
    startDate: DateTime.parse(data['start_date'] as String),
    endDate: DateTime.parse(data['end_date'] as String),
    animalAgeMin: data['animal_age_min'] as int,
    validFrom: DateTime.parse(data['valid_from'] as String),
    validUntil:
        data['valid_until'] == null
            ? null
            : data['valid_until'] == null
            ? null
            : DateTime.tryParse(data['valid_until'] as String),
    updatedAt:
        data['updated_at'] == null
            ? null
            : data['updated_at'] == null
            ? null
            : DateTime.tryParse(data['updated_at'] as String),
    createdAt:
        data['created_at'] == null
            ? null
            : data['created_at'] == null
            ? null
            : DateTime.tryParse(data['created_at'] as String),
  );
}

Future<Map<String, dynamic>> _$HuntingSeasonToSupabase(
  HuntingSeason instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'federal_state_id': instance.federalStateId,
    'species_id': instance.speciesId,
    'start_date': instance.startDate.toIso8601String(),
    'end_date': instance.endDate.toIso8601String(),
    'animal_age_min': instance.animalAgeMin,
    'valid_from': instance.validFrom.toIso8601String(),
    'valid_until': instance.validUntil?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
    'created_at': instance.createdAt?.toIso8601String(),
  };
}

Future<HuntingSeason> _$HuntingSeasonFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return HuntingSeason(
    id: data['id'] as String,
    federalState:
        (await repository!.getAssociation<FederalState>(
          Query.where(
            'primaryKey',
            data['federal_state_FederalState_brick_id'] as int,
            limit1: true,
          ),
        ))!.first,
    species:
        (await repository.getAssociation<Species>(
          Query.where(
            'primaryKey',
            data['species_Species_brick_id'] as int,
            limit1: true,
          ),
        ))!.first,
    startDate: DateTime.parse(data['start_date'] as String),
    endDate: DateTime.parse(data['end_date'] as String),
    animalAgeMin: data['animal_age_min'] as int,
    validFrom: DateTime.parse(data['valid_from'] as String),
    validUntil:
        data['valid_until'] == null
            ? null
            : data['valid_until'] == null
            ? null
            : DateTime.tryParse(data['valid_until'] as String),
    updatedAt:
        data['updated_at'] == null
            ? null
            : data['updated_at'] == null
            ? null
            : DateTime.tryParse(data['updated_at'] as String),
    createdAt:
        data['created_at'] == null
            ? null
            : data['created_at'] == null
            ? null
            : DateTime.tryParse(data['created_at'] as String),
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$HuntingSeasonToSqlite(
  HuntingSeason instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'federal_state_FederalState_brick_id':
        instance.federalState.primaryKey ??
        await provider.upsert<FederalState>(
          instance.federalState,
          repository: repository,
        ),
    'species_Species_brick_id':
        instance.species.primaryKey ??
        await provider.upsert<Species>(
          instance.species,
          repository: repository,
        ),
    'start_date': instance.startDate.toIso8601String(),
    'end_date': instance.endDate.toIso8601String(),
    'animal_age_min': instance.animalAgeMin,
    'valid_from': instance.validFrom.toIso8601String(),
    'valid_until': instance.validUntil?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
    'created_at': instance.createdAt?.toIso8601String(),
  };
}

/// Construct a [HuntingSeason]
class HuntingSeasonAdapter
    extends OfflineFirstWithSupabaseAdapter<HuntingSeason> {
  HuntingSeasonAdapter();

  @override
  final supabaseTableName = 'hunting_season';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
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
    'startDate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'start_date',
    ),
    'endDate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'end_date',
    ),
    'animalAgeMin': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'animal_age_min',
    ),
    'validFrom': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'valid_from',
    ),
    'validUntil': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'valid_until',
    ),
    'updatedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'updated_at',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
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
    'federalState': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'federal_state_FederalState_brick_id',
      iterable: false,
      type: FederalState,
    ),
    'species': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'species_Species_brick_id',
      iterable: false,
      type: Species,
    ),
    'startDate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'start_date',
      iterable: false,
      type: DateTime,
    ),
    'endDate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'end_date',
      iterable: false,
      type: DateTime,
    ),
    'animalAgeMin': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'animal_age_min',
      iterable: false,
      type: int,
    ),
    'validFrom': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'valid_from',
      iterable: false,
      type: DateTime,
    ),
    'validUntil': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'valid_until',
      iterable: false,
      type: DateTime,
    ),
    'updatedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'updated_at',
      iterable: false,
      type: DateTime,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: DateTime,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    HuntingSeason instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `HuntingSeason` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'HuntingSeason';

  @override
  Future<HuntingSeason> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$HuntingSeasonFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    HuntingSeason input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$HuntingSeasonToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<HuntingSeason> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$HuntingSeasonFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    HuntingSeason input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$HuntingSeasonToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
