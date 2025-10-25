// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<FederalState> _$FederalStateFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return FederalState(
    id: data['id'] as String?,
    name: data['name'] as String,
    country: await CountryAdapter().fromSupabase(
      data['country'],
      provider: provider,
      repository: repository,
    ),
  );
}

Future<Map<String, dynamic>> _$FederalStateToSupabase(
  FederalState instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'name': instance.name,
    'country_id': instance.countryId,
  };
}

Future<FederalState> _$FederalStateFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return FederalState(
    id: data['id'] as String,
    name: data['name'] as String,
    country:
        (await repository!.getAssociation<Country>(
          Query.where(
            'primaryKey',
            data['country_Country_brick_id'] as int,
            limit1: true,
          ),
        ))!.first,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$FederalStateToSqlite(
  FederalState instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'name': instance.name,
    'country_Country_brick_id':
        instance.country.primaryKey ??
        await provider.upsert<Country>(
          instance.country,
          repository: repository,
        ),
  };
}

/// Construct a [FederalState]
class FederalStateAdapter
    extends OfflineFirstWithSupabaseAdapter<FederalState> {
  FederalStateAdapter();

  @override
  final supabaseTableName = 'federal_state';
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
    'country': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'country',
      associationType: Country,
      associationIsNullable: false,
      foreignKey: 'country_id',
    ),
    'countryId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'country_id',
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
    'country': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'country_Country_brick_id',
      iterable: false,
      type: Country,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    FederalState instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `FederalState` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'FederalState';

  @override
  Future<FederalState> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$FederalStateFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    FederalState input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$FederalStateToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<FederalState> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$FederalStateFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    FederalState input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$FederalStateToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
