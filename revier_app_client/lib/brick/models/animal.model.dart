import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart' show Uuid;
import 'package:revier_app_client/brick/models/hunting_ground.model.dart';
import 'package:revier_app_client/brick/models/species.model.dart';
import 'package:revier_app_client/brick/models/shooting.model.dart';

@ConnectOfflineFirstWithSupabase(
    supabaseConfig: SupabaseSerializable(tableName: 'animal'),
    sqliteConfig: SqliteSerializable())
class Animal extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(unique: true, index: true)
  final String id;

  @Supabase(foreignKey: 'hunting_ground_id', ignoreTo: true)
  final HuntingGround huntingGround;
  String get huntingGroundId => huntingGround.id;

  final String name;
  final bool dead;
  final double? age;
  final double? weight;
  final String? abnormalities;
  final int? shootingPriority;
  final String? notes;

  @Supabase(foreignKey: 'shooting_id', ignoreTo: true)
  final Shooting? shooting;
  @Sqlite(ignore: true)
  String? get shootingId => shooting?.id;

  @Supabase(foreignKey: 'species_id', ignoreTo: true)
  final Species species;
  @Sqlite(ignore: true)
  String get speciesId => species.id;

  final int? customColor;

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final bool? isDeleted;

  Animal({
    String? id,
    required this.name,
    required this.dead,
    this.age,
    this.weight,
    this.abnormalities,
    this.shootingPriority,
    this.notes,
    this.shooting,
    required this.species,
    required this.huntingGround,
    this.customColor,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isDeleted,
  }) : id = id ?? const Uuid().v4();

  Animal copyWith({
    String? name,
    bool? dead,
    double? age,
    double? weight,
    String? abnormalities,
    int? shootingPriority,
    String? notes,
    Shooting? shooting,
    Species? species,
    HuntingGround? huntingGround,
    int? customColor,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool? isDeleted,
  }) {
    return Animal(
      id: id, // ID should not change
      name: name ?? this.name,
      dead: dead ?? this.dead,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      abnormalities: abnormalities ?? this.abnormalities,
      shootingPriority: shootingPriority ?? this.shootingPriority,
      notes: notes ?? this.notes,
      shooting: shooting ?? this.shooting,
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
