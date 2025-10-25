import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart' show Uuid;
import 'package:supabase/supabase.dart' show User;
import 'package:revier_app_client/brick/models/weapon.model.dart';
import 'package:revier_app_client/brick/models/caliber.model.dart';

@ConnectOfflineFirstWithSupabase(
    supabaseConfig: SupabaseSerializable(tableName: 'shooting'),
    sqliteConfig: SqliteSerializable())
class Shooting extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(unique: true, index: true)
  final String id;

  @Supabase(foreignKey: 'shot_by_id', ignoreTo: true)
  String? shotById;

  @Supabase(foreignKey: "weapon_id", ignoreTo: true)
  final Weapon? weapon;
  @Sqlite(ignore: true)
  String? get weaponId => weapon?.id;

  @Supabase(foreignKey: 'caliber_id', ignoreTo: true)
  final Caliber? caliber;
  @Sqlite(ignore: true)
  String? get caliberId => caliber?.id;

  final double? distance;
  final String? hitLocation;
  final int? shotCount;
  final String? notes;
  final DateTime? shotAt;

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final bool? isDeleted;

  Shooting({
    String? id,
    this.shotById,
    this.weapon,
    this.caliber,
    this.distance,
    this.hitLocation,
    this.shotCount,
    this.notes,
    this.shotAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isDeleted,
  }) : id = id ?? const Uuid().v4();

  Shooting copyWith({
    User? shotBy,
    String? shotById,
    Weapon? weapon,
    String? weaponId,
    Caliber? caliber,
    String? caliberId,
    double? distance,
    String? hitLocation,
    int? shotCount,
    String? notes,
    DateTime? shotAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool? isDeleted,
  }) {
    return Shooting(
      id: id, // ID should not change
      shotById: shotById ?? this.shotById,
      weapon: weapon ?? this.weapon,
      caliber: caliber ?? this.caliber,
      distance: distance ?? this.distance,
      hitLocation: hitLocation ?? this.hitLocation,
      shotCount: shotCount ?? this.shotCount,
      notes: notes ?? this.notes,
      shotAt: shotAt ?? this.shotAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
