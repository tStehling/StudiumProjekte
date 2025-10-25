// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<AllowedCaliber> _$AllowedCaliberFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return AllowedCaliber(
    id: data['id'] as String?,
    validFrom: DateTime.parse(data['valid_from'] as String),
    validUntil:
        data['valid_until'] == null
            ? null
            : data['valid_until'] == null
            ? null
            : DateTime.tryParse(data['valid_until'] as String),
    species: await SpeciesAdapter().fromSupabase(
      data['species'],
      provider: provider,
      repository: repository,
    ),
    caliber: await CaliberAdapter().fromSupabase(
      data['caliber'],
      provider: provider,
      repository: repository,
    ),
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
  );
}

Future<Map<String, dynamic>> _$AllowedCaliberToSupabase(
  AllowedCaliber instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'valid_from': instance.validFrom.toIso8601String(),
    'valid_until': instance.validUntil?.toIso8601String(),
    'species_id': instance.speciesId,
    'caliber_id': instance.caliberId,
    'federal_state_id': instance.federalStateId,
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
  };
}

Future<AllowedCaliber> _$AllowedCaliberFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return AllowedCaliber(
    id: data['id'] as String,
    validFrom: DateTime.parse(data['valid_from'] as String),
    validUntil:
        data['valid_until'] == null
            ? null
            : data['valid_until'] == null
            ? null
            : DateTime.tryParse(data['valid_until'] as String),
    species:
        (await repository!.getAssociation<Species>(
          Query.where(
            'primaryKey',
            data['species_Species_brick_id'] as int,
            limit1: true,
          ),
        ))!.first,
    caliber:
        (await repository.getAssociation<Caliber>(
          Query.where(
            'primaryKey',
            data['caliber_Caliber_brick_id'] as int,
            limit1: true,
          ),
        ))!.first,
    federalState:
        (await repository.getAssociation<FederalState>(
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
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$AllowedCaliberToSqlite(
  AllowedCaliber instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'valid_from': instance.validFrom.toIso8601String(),
    'valid_until': instance.validUntil?.toIso8601String(),
    'species_Species_brick_id':
        instance.species.primaryKey ??
        await provider.upsert<Species>(
          instance.species,
          repository: repository,
        ),
    'caliber_Caliber_brick_id':
        instance.caliber.primaryKey ??
        await provider.upsert<Caliber>(
          instance.caliber,
          repository: repository,
        ),
    'federal_state_FederalState_brick_id':
        instance.federalState.primaryKey ??
        await provider.upsert<FederalState>(
          instance.federalState,
          repository: repository,
        ),
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
  };
}

/// Construct a [AllowedCaliber]
class AllowedCaliberAdapter
    extends OfflineFirstWithSupabaseAdapter<AllowedCaliber> {
  AllowedCaliberAdapter();

  @override
  final supabaseTableName = 'allowed_caliber';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'validFrom': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'valid_from',
    ),
    'validUntil': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'valid_until',
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
    'caliber': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'caliber',
      associationType: Caliber,
      associationIsNullable: false,
      foreignKey: 'caliber_id',
    ),
    'caliberId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'caliber_id',
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
    'species': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'species_Species_brick_id',
      iterable: false,
      type: Species,
    ),
    'caliber': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'caliber_Caliber_brick_id',
      iterable: false,
      type: Caliber,
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
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    AllowedCaliber instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `AllowedCaliber` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'AllowedCaliber';

  @override
  Future<AllowedCaliber> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$AllowedCaliberFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    AllowedCaliber input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$AllowedCaliberToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<AllowedCaliber> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$AllowedCaliberFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    AllowedCaliber input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$AllowedCaliberToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
