// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<WeatherCondition> _$WeatherConditionFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return WeatherCondition(
    id: data['id'] as String?,
    windDirection:
        data['wind_direction'] == null ? null : data['wind_direction'] as int?,
    windSpeed:
        data['wind_speed'] == null ? null : data['wind_speed'] as double?,
    temperature:
        data['temperature'] == null ? null : data['temperature'] as double?,
    airPressure:
        data['air_pressure'] == null ? null : data['air_pressure'] as double?,
    precipitation:
        data['precipitation'] == null ? null : data['precipitation'] as double?,
    groundConditions:
        data['ground_conditions'] == null
            ? null
            : data['ground_conditions'] as String?,
    moonPhase:
        data['moon_phase'] == null ? null : data['moon_phase'] as String?,
    timestamp:
        data['timestamp'] == null
            ? null
            : data['timestamp'] == null
            ? null
            : DateTime.tryParse(data['timestamp'] as String),
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

Future<Map<String, dynamic>> _$WeatherConditionToSupabase(
  WeatherCondition instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'wind_direction': instance.windDirection,
    'wind_speed': instance.windSpeed,
    'temperature': instance.temperature,
    'air_pressure': instance.airPressure,
    'precipitation': instance.precipitation,
    'ground_conditions': instance.groundConditions,
    'moon_phase': instance.moonPhase,
    'timestamp': instance.timestamp?.toIso8601String(),
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'is_deleted': instance.isDeleted,
  };
}

Future<WeatherCondition> _$WeatherConditionFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return WeatherCondition(
    id: data['id'] as String,
    windDirection:
        data['wind_direction'] == null ? null : data['wind_direction'] as int?,
    windSpeed:
        data['wind_speed'] == null ? null : data['wind_speed'] as double?,
    temperature:
        data['temperature'] == null ? null : data['temperature'] as double?,
    airPressure:
        data['air_pressure'] == null ? null : data['air_pressure'] as double?,
    precipitation:
        data['precipitation'] == null ? null : data['precipitation'] as double?,
    groundConditions:
        data['ground_conditions'] == null
            ? null
            : data['ground_conditions'] as String?,
    moonPhase:
        data['moon_phase'] == null ? null : data['moon_phase'] as String?,
    timestamp:
        data['timestamp'] == null
            ? null
            : data['timestamp'] == null
            ? null
            : DateTime.tryParse(data['timestamp'] as String),
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

Future<Map<String, dynamic>> _$WeatherConditionToSqlite(
  WeatherCondition instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'wind_direction': instance.windDirection,
    'wind_speed': instance.windSpeed,
    'temperature': instance.temperature,
    'air_pressure': instance.airPressure,
    'precipitation': instance.precipitation,
    'ground_conditions': instance.groundConditions,
    'moon_phase': instance.moonPhase,
    'timestamp': instance.timestamp?.toIso8601String(),
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'is_deleted':
        instance.isDeleted == null ? null : (instance.isDeleted! ? 1 : 0),
  };
}

/// Construct a [WeatherCondition]
class WeatherConditionAdapter
    extends OfflineFirstWithSupabaseAdapter<WeatherCondition> {
  WeatherConditionAdapter();

  @override
  final supabaseTableName = 'weather_condition';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'windDirection': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'wind_direction',
    ),
    'windSpeed': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'wind_speed',
    ),
    'temperature': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'temperature',
    ),
    'airPressure': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'air_pressure',
    ),
    'precipitation': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'precipitation',
    ),
    'groundConditions': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'ground_conditions',
    ),
    'moonPhase': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'moon_phase',
    ),
    'timestamp': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'timestamp',
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
    'windDirection': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'wind_direction',
      iterable: false,
      type: int,
    ),
    'windSpeed': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'wind_speed',
      iterable: false,
      type: double,
    ),
    'temperature': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'temperature',
      iterable: false,
      type: double,
    ),
    'airPressure': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'air_pressure',
      iterable: false,
      type: double,
    ),
    'precipitation': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'precipitation',
      iterable: false,
      type: double,
    ),
    'groundConditions': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'ground_conditions',
      iterable: false,
      type: String,
    ),
    'moonPhase': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'moon_phase',
      iterable: false,
      type: String,
    ),
    'timestamp': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'timestamp',
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
    WeatherCondition instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `WeatherCondition` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'WeatherCondition';

  @override
  Future<WeatherCondition> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$WeatherConditionFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    WeatherCondition input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$WeatherConditionToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<WeatherCondition> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$WeatherConditionFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    WeatherCondition input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$WeatherConditionToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
