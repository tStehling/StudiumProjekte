// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Sighting> _$SightingFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Sighting(
    id: data['id'] as String?,
    species:
        data['species'] == null
            ? null
            : await SpeciesAdapter().fromSupabase(
              data['species'],
              provider: provider,
              repository: repository,
            ),
    groupType:
        data['group_type'] == null ? null : data['group_type'] as String?,
    animalCount: data['animal_count'] as int,
    animalCountPrecision:
        data['animal_count_precision'] == null
            ? null
            : data['animal_count_precision'] as int?,
    weatherCondition:
        data['weather_condition'] == null
            ? null
            : await WeatherConditionAdapter().fromSupabase(
              data['weather_condition'],
              provider: provider,
              repository: repository,
            ),
    camera:
        data['camera'] == null
            ? null
            : await CameraAdapter().fromSupabase(
              data['camera'],
              provider: provider,
              repository: repository,
            ),
    huntingGround: await HuntingGroundAdapter().fromSupabase(
      data['hunting_ground'],
      provider: provider,
      repository: repository,
    ),
    upload:
        data['upload'] == null
            ? null
            : await UploadAdapter().fromSupabase(
              data['upload'],
              provider: provider,
              repository: repository,
            ),
    latitude: data['latitude'] as double,
    longitude: data['longitude'] as double,
    sightingStart: DateTime.parse(data['sighting_start'] as String),
    sightingEnd: DateTime.parse(data['sighting_end'] as String),
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

Future<Map<String, dynamic>> _$SightingToSupabase(
  Sighting instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'species':
        instance.species != null
            ? await SpeciesAdapter().toSupabase(
              instance.species!,
              provider: provider,
              repository: repository,
            )
            : null,
    'species_id': instance.speciesId,
    'group_type': instance.groupType,
    'animal_count': instance.animalCount,
    'animal_count_precision': instance.animalCountPrecision,
    'weather_condition':
        instance.weatherCondition != null
            ? await WeatherConditionAdapter().toSupabase(
              instance.weatherCondition!,
              provider: provider,
              repository: repository,
            )
            : null,
    'weather_condition_id': instance.weatherConditionId,
    'camera':
        instance.camera != null
            ? await CameraAdapter().toSupabase(
              instance.camera!,
              provider: provider,
              repository: repository,
            )
            : null,
    'camera_id': instance.cameraId,
    'hunting_ground_id': instance.huntingGroundId,
    'upload':
        instance.upload != null
            ? await UploadAdapter().toSupabase(
              instance.upload!,
              provider: provider,
              repository: repository,
            )
            : null,
    'upload_id': instance.uploadId,
    'latitude': instance.latitude,
    'longitude': instance.longitude,
    'sighting_start': instance.sightingStart.toIso8601String(),
    'sighting_end': instance.sightingEnd.toIso8601String(),
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'is_deleted': instance.isDeleted,
  };
}

Future<Sighting> _$SightingFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Sighting(
    id: data['id'] as String,
    species:
        data['species_Species_brick_id'] == null
            ? null
            : (data['species_Species_brick_id'] > -1
                ? (await repository?.getAssociation<Species>(
                  Query.where(
                    'primaryKey',
                    data['species_Species_brick_id'] as int,
                    limit1: true,
                  ),
                ))?.first
                : null),
    groupType:
        data['group_type'] == null ? null : data['group_type'] as String?,
    animalCount: data['animal_count'] as int,
    animalCountPrecision:
        data['animal_count_precision'] == null
            ? null
            : data['animal_count_precision'] as int?,
    weatherCondition:
        data['weather_condition_WeatherCondition_brick_id'] == null
            ? null
            : (data['weather_condition_WeatherCondition_brick_id'] > -1
                ? (await repository?.getAssociation<WeatherCondition>(
                  Query.where(
                    'primaryKey',
                    data['weather_condition_WeatherCondition_brick_id'] as int,
                    limit1: true,
                  ),
                ))?.first
                : null),
    camera:
        data['camera_Camera_brick_id'] == null
            ? null
            : (data['camera_Camera_brick_id'] > -1
                ? (await repository?.getAssociation<Camera>(
                  Query.where(
                    'primaryKey',
                    data['camera_Camera_brick_id'] as int,
                    limit1: true,
                  ),
                ))?.first
                : null),
    huntingGround:
        (await repository!.getAssociation<HuntingGround>(
          Query.where(
            'primaryKey',
            data['hunting_ground_HuntingGround_brick_id'] as int,
            limit1: true,
          ),
        ))!.first,
    upload:
        data['upload_Upload_brick_id'] == null
            ? null
            : (data['upload_Upload_brick_id'] > -1
                ? (await repository.getAssociation<Upload>(
                  Query.where(
                    'primaryKey',
                    data['upload_Upload_brick_id'] as int,
                    limit1: true,
                  ),
                ))?.first
                : null),
    latitude: data['latitude'] as double,
    longitude: data['longitude'] as double,
    sightingStart: DateTime.parse(data['sighting_start'] as String),
    sightingEnd: DateTime.parse(data['sighting_end'] as String),
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

Future<Map<String, dynamic>> _$SightingToSqlite(
  Sighting instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'species_Species_brick_id':
        instance.species != null
            ? instance.species!.primaryKey ??
                await provider.upsert<Species>(
                  instance.species!,
                  repository: repository,
                )
            : null,
    'group_type': instance.groupType,
    'animal_count': instance.animalCount,
    'animal_count_precision': instance.animalCountPrecision,
    'weather_condition_WeatherCondition_brick_id':
        instance.weatherCondition != null
            ? instance.weatherCondition!.primaryKey ??
                await provider.upsert<WeatherCondition>(
                  instance.weatherCondition!,
                  repository: repository,
                )
            : null,
    'camera_Camera_brick_id':
        instance.camera != null
            ? instance.camera!.primaryKey ??
                await provider.upsert<Camera>(
                  instance.camera!,
                  repository: repository,
                )
            : null,
    'hunting_ground_HuntingGround_brick_id':
        instance.huntingGround.primaryKey ??
        await provider.upsert<HuntingGround>(
          instance.huntingGround,
          repository: repository,
        ),
    'hunting_ground_id': instance.huntingGroundId,
    'upload_Upload_brick_id':
        instance.upload != null
            ? instance.upload!.primaryKey ??
                await provider.upsert<Upload>(
                  instance.upload!,
                  repository: repository,
                )
            : null,
    'latitude': instance.latitude,
    'longitude': instance.longitude,
    'sighting_start': instance.sightingStart.toIso8601String(),
    'sighting_end': instance.sightingEnd.toIso8601String(),
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'is_deleted':
        instance.isDeleted == null ? null : (instance.isDeleted! ? 1 : 0),
  };
}

/// Construct a [Sighting]
class SightingAdapter extends OfflineFirstWithSupabaseAdapter<Sighting> {
  SightingAdapter();

  @override
  final supabaseTableName = 'sighting';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'species': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'species',
      associationType: Species,
      associationIsNullable: true,
    ),
    'speciesId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'species_id',
    ),
    'groupType': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'group_type',
    ),
    'animalCount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'animal_count',
    ),
    'animalCountPrecision': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'animal_count_precision',
    ),
    'weatherCondition': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'weather_condition',
      associationType: WeatherCondition,
      associationIsNullable: true,
    ),
    'weatherConditionId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'weather_condition_id',
    ),
    'camera': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'camera',
      associationType: Camera,
      associationIsNullable: true,
    ),
    'cameraId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'camera_id',
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
    'upload': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'upload',
      associationType: Upload,
      associationIsNullable: true,
    ),
    'uploadId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'upload_id',
    ),
    'latitude': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'latitude',
    ),
    'longitude': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'longitude',
    ),
    'sightingStart': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'sighting_start',
    ),
    'sightingEnd': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'sighting_end',
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
    'species': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'species_Species_brick_id',
      iterable: false,
      type: Species,
    ),
    'groupType': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'group_type',
      iterable: false,
      type: String,
    ),
    'animalCount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'animal_count',
      iterable: false,
      type: int,
    ),
    'animalCountPrecision': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'animal_count_precision',
      iterable: false,
      type: int,
    ),
    'weatherCondition': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'weather_condition_WeatherCondition_brick_id',
      iterable: false,
      type: WeatherCondition,
    ),
    'camera': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'camera_Camera_brick_id',
      iterable: false,
      type: Camera,
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
    'upload': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'upload_Upload_brick_id',
      iterable: false,
      type: Upload,
    ),
    'latitude': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'latitude',
      iterable: false,
      type: double,
    ),
    'longitude': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'longitude',
      iterable: false,
      type: double,
    ),
    'sightingStart': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'sighting_start',
      iterable: false,
      type: DateTime,
    ),
    'sightingEnd': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'sighting_end',
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
    Sighting instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Sighting` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Sighting';

  @override
  Future<Sighting> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$SightingFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Sighting input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$SightingToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Sighting> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$SightingFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Sighting input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$SightingToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
