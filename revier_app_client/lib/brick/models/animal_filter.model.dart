import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart' show Uuid;
import 'package:revier_app_client/brick/models/hunting_ground.model.dart';
import 'package:revier_app_client/brick/models/species.model.dart';

@ConnectOfflineFirstWithSupabase(
    supabaseConfig: SupabaseSerializable(tableName: 'animal_filter'),
    sqliteConfig: SqliteSerializable())
class AnimalFilter extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(unique: true, index: true)
  final String id;

  final String name;

  @Supabase(foreignKey: 'hunting_ground_id', ignoreTo: true)
  final HuntingGround huntingGround;
  String get huntingGroundId => huntingGround.id;

  final int animalCount;
  final String animalCountType;

  @Supabase(foreignKey: 'species_id', ignoreTo: true)
  final Species species;
  @Sqlite(ignore: true)
  String get speciesId => species.id;

  final int? customColor;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final bool? isDeleted;

  AnimalFilter({
    String? id,
    required this.name,
    required this.animalCount,
    required this.animalCountType,
    required this.species,
    required this.huntingGround,
    this.customColor,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isDeleted,
  }) : id = id ?? const Uuid().v4();

  AnimalFilter copyWith({
    String? name,
    int? animalCount,
    String? animalCountType,
    Species? species,
    HuntingGround? huntingGround,
    int? customColor,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool? isDeleted,
  }) {
    return AnimalFilter(
      id: id, // ID should not change
      name: name ?? this.name,
      animalCount: animalCount ?? this.animalCount,
      animalCountType: animalCountType ?? this.animalCountType,
      species: species ?? this.species,
      huntingGround: huntingGround ?? this.huntingGround,
      customColor: customColor ?? this.customColor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
