import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart' show Uuid;

@ConnectOfflineFirstWithSupabase(
    supabaseConfig: SupabaseSerializable(tableName: 'weather_condition'),
    sqliteConfig: SqliteSerializable())
class WeatherCondition extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(unique: true, index: true)
  final String id;

  final int? windDirection;
  final double? windSpeed;
  final double? temperature;
  final double? airPressure;
  final double? precipitation;
  final String? groundConditions;
  final String? moonPhase;
  final DateTime? timestamp;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final bool? isDeleted;

  WeatherCondition({
    String? id,
    this.windDirection,
    this.windSpeed,
    this.temperature,
    this.airPressure,
    this.precipitation,
    this.groundConditions,
    this.moonPhase,
    this.timestamp,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isDeleted,
  }) : id = id ?? const Uuid().v4();

  WeatherCondition copyWith({
    int? windDirection,
    double? windSpeed,
    double? temperature,
    double? airPressure,
    double? precipitation,
    String? groundConditions,
    String? moonPhase,
    DateTime? timestamp,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool? isDeleted,
  }) {
    return WeatherCondition(
      id: id, // ID should not change
      windDirection: windDirection ?? this.windDirection,
      windSpeed: windSpeed ?? this.windSpeed,
      temperature: temperature ?? this.temperature,
      airPressure: airPressure ?? this.airPressure,
      precipitation: precipitation ?? this.precipitation,
      groundConditions: groundConditions ?? this.groundConditions,
      moonPhase: moonPhase ?? this.moonPhase,
      timestamp: timestamp ?? this.timestamp,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
