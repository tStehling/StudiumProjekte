import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart' show Uuid;
import 'package:revier_app_client/brick/models/country.model.dart';

@ConnectOfflineFirstWithSupabase(
    supabaseConfig: SupabaseSerializable(tableName: 'federal_state'),
    sqliteConfig: SqliteSerializable())
class FederalState extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(unique: true, index: true)
  final String id;

  final String name;

  @Supabase(foreignKey: 'country_id', ignoreTo: true)
  final Country country;
  @Sqlite(ignore: true)
  String get countryId => country.id;

  FederalState({
    String? id,
    required this.name,
    required this.country,
  }) : id = id ?? const Uuid().v4();

  FederalState copyWith({
    String? name,
    Country? country,
  }) {
    return FederalState(
      id: id, // ID should not change
      name: name ?? this.name,
      country: country ?? this.country,
    );
  }
}
