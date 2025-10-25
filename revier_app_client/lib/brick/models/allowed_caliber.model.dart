import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:revier_app_client/brick/models/federal_state.model.dart';
import 'package:uuid/uuid.dart' show Uuid;
import 'package:revier_app_client/brick/models/species.model.dart';
import 'package:revier_app_client/brick/models/caliber.model.dart';

@ConnectOfflineFirstWithSupabase(
    supabaseConfig: SupabaseSerializable(tableName: 'allowed_caliber'),
    sqliteConfig: SqliteSerializable())
class AllowedCaliber extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(unique: true, index: true)
  final String id;

  final DateTime validFrom;
  final DateTime? validUntil;

  @Supabase(foreignKey: 'species_id', ignoreTo: true)
  final Species species;
  @Sqlite(ignore: true)
  String get speciesId => species.id;

  @Supabase(foreignKey: 'caliber_id', ignoreTo: true)
  final Caliber caliber;
  @Sqlite(ignore: true)
  String get caliberId => caliber.id;

  @Supabase(foreignKey: 'federal_state_id', ignoreTo: true)
  final FederalState federalState;
  @Sqlite(ignore: true)
  String get federalStateId => federalState.id;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  AllowedCaliber({
    String? id,
    required this.validFrom,
    this.validUntil,
    required this.species,
    required this.caliber,
    required this.federalState,
    this.createdAt,
    this.updatedAt,
  }) : id = id ?? const Uuid().v4();

  AllowedCaliber copyWith({
    Species? species,
    String? speciesId,
    Caliber? caliber,
    FederalState? federalState,
    DateTime? validFrom,
    DateTime? validUntil,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool? isDeleted,
  }) {
    return AllowedCaliber(
      id: id,
      species: species ?? this.species,
      caliber: caliber ?? this.caliber,
      federalState: federalState ?? this.federalState,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil ?? this.validUntil,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
