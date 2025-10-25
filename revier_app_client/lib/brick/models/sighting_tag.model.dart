import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart' show Uuid;
import 'package:revier_app_client/brick/models/sighting.model.dart';
import 'package:revier_app_client/brick/models/tag.model.dart';

/// SightingTags model for offline-first capabilities
///
/// This model corresponds to the sighting_tags table in Supabase
@ConnectOfflineFirstWithSupabase(
    supabaseConfig: SupabaseSerializable(tableName: 'sighting_tag'),
    sqliteConfig: SqliteSerializable())
class SightingTag extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(unique: true, index: true)
  final String id;

  @Supabase(foreignKey: "sighting_id", ignoreTo: true)
  final Sighting sighting;
  @Sqlite(ignore: true)
  String get sightingId => sighting.id;

  @Supabase(foreignKey: 'tag_id', ignoreTo: true)
  final Tag tag;
  @Sqlite(ignore: true)
  String get tagId => tag.id;

  SightingTag({
    String? id,
    required this.sighting,
    required this.tag,
  }) : id = id ?? Uuid().v4();

  SightingTag copyWith({
    Sighting? sighting,
    Tag? tag,
    String? tagId,
  }) {
    return SightingTag(
      id: id,
      sighting: sighting ?? this.sighting,
      tag: tag ?? this.tag,
    );
  }
}
