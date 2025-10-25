import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show User;
import 'package:uuid/uuid.dart' show Uuid;

@ConnectOfflineFirstWithSupabase(
    supabaseConfig: SupabaseSerializable(tableName: 'caliber'),
    sqliteConfig: SqliteSerializable())
class Caliber extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(unique: true, index: true)
  final String id;

  final String name;

  final DateTime? createdAt;
  @Supabase(foreignKey: 'created_by_id', ignoreTo: true)
  final String? createdById;

  final DateTime? updatedAt;
  @Supabase(foreignKey: 'updated_by_id', ignoreTo: true)
  final String? updatedById;

  final DateTime? deletedAt;
  final bool? isDeleted;

  Caliber({
    String? id,
    required this.name,
    this.createdById,
    this.createdAt,
    this.updatedAt,
    this.updatedById,
    this.deletedAt,
    this.isDeleted,
  }) : id = id ?? const Uuid().v4();

  Caliber copyWith({
    String? name,
    User? createdBy,
    String? createdById,
    DateTime? createdAt,
    User? updatedBy,
    String? updatedById,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool? isDeleted,
  }) {
    return Caliber(
      id: id, // ID should not change
      name: name ?? this.name,
      createdById: createdById ?? this.createdById,
      createdAt: createdAt ?? this.createdAt,
      updatedById: updatedById ?? this.updatedById,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
