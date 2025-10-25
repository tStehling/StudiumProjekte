// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<SightingTag> _$SightingTagFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return SightingTag(
    id: data['id'] as String?,
    sighting: await SightingAdapter().fromSupabase(
      data['sighting'],
      provider: provider,
      repository: repository,
    ),
    tag: await TagAdapter().fromSupabase(
      data['tag'],
      provider: provider,
      repository: repository,
    ),
  );
}

Future<Map<String, dynamic>> _$SightingTagToSupabase(
  SightingTag instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'sighting_id': instance.sightingId,
    'tag_id': instance.tagId,
  };
}

Future<SightingTag> _$SightingTagFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return SightingTag(
    id: data['id'] as String,
    sighting:
        (await repository!.getAssociation<Sighting>(
          Query.where(
            'primaryKey',
            data['sighting_Sighting_brick_id'] as int,
            limit1: true,
          ),
        ))!.first,
    tag:
        (await repository.getAssociation<Tag>(
          Query.where(
            'primaryKey',
            data['tag_Tag_brick_id'] as int,
            limit1: true,
          ),
        ))!.first,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$SightingTagToSqlite(
  SightingTag instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'sighting_Sighting_brick_id':
        instance.sighting.primaryKey ??
        await provider.upsert<Sighting>(
          instance.sighting,
          repository: repository,
        ),
    'tag_Tag_brick_id':
        instance.tag.primaryKey ??
        await provider.upsert<Tag>(instance.tag, repository: repository),
  };
}

/// Construct a [SightingTag]
class SightingTagAdapter extends OfflineFirstWithSupabaseAdapter<SightingTag> {
  SightingTagAdapter();

  @override
  final supabaseTableName = 'sighting_tag';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'sighting': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'sighting',
      associationType: Sighting,
      associationIsNullable: false,
      foreignKey: 'sighting_id',
    ),
    'sightingId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'sighting_id',
    ),
    'tag': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'tag',
      associationType: Tag,
      associationIsNullable: false,
      foreignKey: 'tag_id',
    ),
    'tagId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tag_id',
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
    'sighting': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'sighting_Sighting_brick_id',
      iterable: false,
      type: Sighting,
    ),
    'tag': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'tag_Tag_brick_id',
      iterable: false,
      type: Tag,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    SightingTag instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `SightingTag` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'SightingTag';

  @override
  Future<SightingTag> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$SightingTagFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    SightingTag input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$SightingTagToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<SightingTag> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$SightingTagFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    SightingTag input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$SightingTagToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
