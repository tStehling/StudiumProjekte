import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart' show Uuid;
import 'package:revier_app_client/brick/models/upload.model.dart';
import 'package:revier_app_client/brick/models/media.model.dart';

@ConnectOfflineFirstWithSupabase(
    supabaseConfig: SupabaseSerializable(tableName: 'upload_media'),
    sqliteConfig: SqliteSerializable())
class UploadMedia extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(unique: true, index: true)
  final String id;

  @Supabase(foreignKey: 'upload_id', ignoreTo: true)
  final Upload upload;
  @Sqlite(ignore: true)
  String get uploadId => upload.id;

  @Supabase(foreignKey: 'media_id', ignoreTo: true)
  final Media media;
  @Sqlite(ignore: true)
  String get mediaId => media.id;

  UploadMedia({
    String? id,
    required this.upload,
    required this.media,
  }) : id = id ?? const Uuid().v4();

  // Create a copy of this upload media with modified fields
  UploadMedia copyWith({
    Upload? upload,
    Media? media,
  }) {
    return UploadMedia(
      id: id, // ID should not change
      upload: upload ?? this.upload,
      media: media ?? this.media,
    );
  }
}
