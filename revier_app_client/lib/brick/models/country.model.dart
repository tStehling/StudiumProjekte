import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart' show Uuid;

@ConnectOfflineFirstWithSupabase(
    supabaseConfig: SupabaseSerializable(tableName: 'country'),
    sqliteConfig: SqliteSerializable())
class Country extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(unique: true, index: true)
  final String id;

  final String name;

  Country({
    String? id,
    required this.name,
  }) : id = id ?? const Uuid().v4();

  Country copyWith({
    String? name,
  }) {
    return Country(
      id: id, // ID should not change
      name: name ?? this.name,
    );
  }
}
