import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:revier_app_client/brick/models/hunting_ground.model.dart';
import 'package:uuid/uuid.dart' show Uuid;
import 'package:revier_app_client/brick/models/camera.model.dart';
import 'package:supabase/supabase.dart' show User;

@ConnectOfflineFirstWithSupabase(
    supabaseConfig: SupabaseSerializable(tableName: 'upload'),
    sqliteConfig: SqliteSerializable())
class Upload extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(unique: true, index: true)
  final String id;

  final String status;

  @Supabase(foreignKey: 'camera_id', ignoreTo: true)
  final Camera? camera;
  @Sqlite(ignore: true)
  String? get cameraId => camera?.id;

  @Supabase(foreignKey: 'hunting_ground_id', ignoreTo: true)
  final HuntingGround huntingGround;
  String get huntingGroundId => huntingGround.id;

  final double? latitude;
  final double? longitude;

  @Supabase(foreignKey: 'created_by_id', ignoreTo: true)
  final String? createdById;

  @Supabase(foreignKey: 'updated_by_id', ignoreTo: true)
  final String? updatedById;

  @Supabase(foreignKey: 'deleted_by_id', ignoreTo: true)
  final String? deletedById;

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final bool? isDeleted;

  Upload({
    String? id,
    required this.status,
    this.latitude,
    this.longitude,
    this.camera,
    required this.huntingGround,
    this.createdById,
    this.updatedById,
    this.deletedById,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isDeleted,
  }) : id = id ?? const Uuid().v4();

  Upload copyWith({
    String? status,
    double? latitude,
    double? longitude,
    Camera? camera,
    HuntingGround? huntingGround,
    String? createdById,
    String? updatedById,
    String? deletedById,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool? isDeleted,
  }) {
    return Upload(
      id: id, // ID should not change
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      camera: camera ?? this.camera,
      huntingGround: huntingGround ?? this.huntingGround,
      createdById: createdById ?? this.createdById,
      updatedById: updatedById ?? this.updatedById,
      deletedById: deletedById ?? this.deletedById,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
