import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart' show Uuid;

@ConnectOfflineFirstWithSupabase(
    supabaseConfig: SupabaseSerializable(tableName: 'species'),
    sqliteConfig: SqliteSerializable())
class Species extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(unique: true, index: true)
  final String id;

  final String name;
  final bool? isPest;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Species({
    String? id,
    required this.name,
    this.isPest,
    this.createdAt,
    this.updatedAt,
  }) : id = id ?? const Uuid().v4();

  Species copyWith({
    String? name,
    bool? isPest,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool? isDeleted,
  }) {
    return Species(
      id: id, // ID should not change
      name: name ?? this.name,
      isPest: isPest ?? this.isPest,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
