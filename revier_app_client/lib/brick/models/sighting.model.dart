import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:revier_app_client/brick/models/hunting_ground.model.dart';
import 'package:uuid/uuid.dart' show Uuid;
import 'package:revier_app_client/brick/models/species.model.dart';
import 'package:revier_app_client/brick/models/weather_condition.model.dart';
import 'package:revier_app_client/brick/models/camera.model.dart';
import 'package:revier_app_client/brick/models/upload.model.dart';

@ConnectOfflineFirstWithSupabase(
    supabaseConfig: SupabaseSerializable(tableName: 'sighting'),
    sqliteConfig: SqliteSerializable())
class Sighting extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(unique: true, index: true)
  final String id;

  // @Supabase(foreignKey: 'species_id', ignoreTo: true)
  final Species? species;
  @Sqlite(ignore: true)
  String? get speciesId => species?.id;

  final String? groupType;
  final int animalCount;
  final int? animalCountPrecision;

  // @Supabase(foreignKey: 'weather_condition_id', ignoreTo: true)
  final WeatherCondition? weatherCondition;
  @Sqlite(ignore: true)
  String? get weatherConditionId => weatherCondition?.id;

  // @Supabase(foreignKey: 'camera_id', ignoreTo: true)
  final Camera? camera;
  @Sqlite(ignore: true)
  String? get cameraId => camera?.id;

  @Supabase(foreignKey: 'hunting_ground_id', ignoreTo: true)
  final HuntingGround huntingGround;
  String get huntingGroundId => huntingGround.id;

  // @Supabase(foreignKey: 'upload_id', ignoreTo: true)
  final Upload? upload;
  @Sqlite(ignore: true)
  String? get uploadId => upload?.id;

  final double latitude;
  final double longitude;
  final DateTime sightingStart;
  final DateTime sightingEnd;

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final bool? isDeleted;

  Sighting({
    String? id,
    this.species,
    this.groupType,
    required this.animalCount,
    this.animalCountPrecision,
    this.weatherCondition,
    this.camera,
    required this.huntingGround,
    this.upload,
    required this.latitude,
    required this.longitude,
    required this.sightingStart,
    required this.sightingEnd,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isDeleted,
  }) : id = id ?? const Uuid().v4();

  Sighting copyWith({
    Species? species,
    String? groupType,
    int? animalCount,
    int? animalCountPrecision,
    WeatherCondition? weatherCondition,
    Camera? camera,
    Upload? upload,
    HuntingGround? huntingGround,
    double? latitude,
    double? longitude,
    DateTime? sightingStart,
    DateTime? sightingEnd,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool? isDeleted,
  }) {
    return Sighting(
      id: id, // ID should not change
      species: species ?? this.species,
      groupType: groupType ?? this.groupType,
      animalCount: animalCount ?? this.animalCount,
      animalCountPrecision: animalCountPrecision ?? this.animalCountPrecision,
      weatherCondition: weatherCondition ?? this.weatherCondition,
      camera: camera ?? this.camera,
      huntingGround: huntingGround ?? this.huntingGround,
      upload: upload ?? this.upload,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      sightingStart: sightingStart ?? this.sightingStart,
      sightingEnd: sightingEnd ?? this.sightingEnd,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
