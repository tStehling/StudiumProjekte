import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:revier_app_client/brick/models/federal_state.model.dart';
import 'package:uuid/uuid.dart' show Uuid;
import 'package:revier_app_client/brick/models/species.model.dart';

@ConnectOfflineFirstWithSupabase(
    supabaseConfig: SupabaseSerializable(tableName: 'hunting_season'),
    sqliteConfig: SqliteSerializable())
class HuntingSeason extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(unique: true, index: true)
  final String id;

  @Supabase(foreignKey: 'federal_state_id', ignoreTo: true)
  final FederalState federalState;
  @Sqlite(ignore: true)
  String get federalStateId => federalState.id;

  @Supabase(foreignKey: 'species_id', ignoreTo: true)
  final Species species;
  @Sqlite(ignore: true)
  String get speciesId => species.id;

  final DateTime startDate;
  final DateTime endDate;

  final int animalAgeMin;

  final DateTime validFrom;
  final DateTime? validUntil;

  final DateTime? updatedAt;
  final DateTime? createdAt;

  HuntingSeason({
    String? id,
    required this.federalState,
    required this.species,
    required this.startDate,
    required this.endDate,
    required this.animalAgeMin,
    required this.validFrom,
    this.validUntil,
    this.createdAt,
    this.updatedAt,
  }) : id = id ?? const Uuid().v4();

  HuntingSeason copyWith({
    FederalState? federalState,
    Species? species,
    DateTime? startDate,
    DateTime? endDate,
    int? animalAgeMin,
    DateTime? validFrom,
    DateTime? validUntil,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HuntingSeason(
      id: id,
      federalState: federalState ?? this.federalState,
      species: species ?? this.species,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      animalAgeMin: animalAgeMin ?? this.animalAgeMin,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil ?? this.validUntil,
    );
  }
}
