import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:revier_app_client/brick/models/hunting_ground.model.dart';
import 'package:uuid/uuid.dart' show Uuid;

@ConnectOfflineFirstWithSupabase(
    supabaseConfig: SupabaseSerializable(tableName: 'camera'),
    sqliteConfig: SqliteSerializable())
class Camera extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(unique: true, index: true)
  final String id;

  @Supabase(foreignKey: 'hunting_ground_id', ignoreTo: true)
  final HuntingGround huntingGround;
  String get huntingGroundId => huntingGround.id;

  final String name;

  final double latitude;
  final double longitude;

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final bool? isDeleted;

  Camera({
    String? id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.huntingGround,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isDeleted,
  }) : id = id ?? const Uuid().v4();

  Camera copyWith({
    String? name,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool? isDeleted,
    HuntingGround? huntingGround,
  }) {
    return Camera(
      id: id, // ID should not change
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      huntingGround: huntingGround ?? this.huntingGround,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
