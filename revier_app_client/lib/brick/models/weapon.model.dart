import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart' show Uuid;
import 'package:revier_app_client/brick/models/caliber.model.dart';
import 'package:supabase/supabase.dart' show User;

@ConnectOfflineFirstWithSupabase(
    supabaseConfig: SupabaseSerializable(tableName: 'weapon'),
    sqliteConfig: SqliteSerializable())
class Weapon extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(unique: true, index: true)
  final String id;

  final String name;

  @Supabase(foreignKey: 'user_id', ignoreTo: true)
  String? userId;

  @Supabase(foreignKey: 'default_caliber_id', ignoreTo: true)
  final Caliber? defaultCaliber;
  @Sqlite(ignore: true)
  String? get defaultCaliberId => defaultCaliber?.id;

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final bool? isDeleted;

  Weapon({
    String? id,
    required this.name,
    this.userId,
    this.defaultCaliber,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isDeleted,
  }) : id = id ?? const Uuid().v4();

  Weapon copyWith({
    String? name,
    User? user,
    String? userId,
    Caliber? defaultCaliber,
    String? defaultCaliberId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool? isDeleted,
  }) {
    return Weapon(
      id: id, // ID should not change
      name: name ?? this.name,
      userId: userId ?? this.userId,
      defaultCaliber: defaultCaliber ?? this.defaultCaliber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
