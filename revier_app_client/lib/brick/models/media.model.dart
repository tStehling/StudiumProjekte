import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:supabase/supabase.dart' show User;
import 'package:uuid/uuid.dart' show Uuid;

@ConnectOfflineFirstWithSupabase(
    supabaseConfig: SupabaseSerializable(tableName: 'media'),
    sqliteConfig: SqliteSerializable())
class Media extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(unique: true, index: true)
  final String id;

  final String mediaType;
  final String? remoteFilePath;
  final String? localFilePath;

  final int? timeOffset;
  final DateTime? timestampOriginal;
  final DateTime? timestamp;

  @Supabase(foreignKey: 'created_by_id', ignoreTo: true)
  final String? createdById;

  @Supabase(foreignKey: 'updated_by_id', ignoreTo: true)
  final String? updatedById;

  @Supabase(foreignKey: 'deleted_by_id', ignoreTo: true)
  final String? deletedById;

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final bool? isDeleted;

  Media({
    String? id,
    this.remoteFilePath,
    this.localFilePath,
    required this.mediaType,
    this.timeOffset,
    this.timestampOriginal,
    this.timestamp,
    this.createdById,
    this.updatedById,
    this.deletedById,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isDeleted,
  }) : id = id ?? const Uuid().v4();

  Media copyWith({
    String? remoteFilePath,
    String? localFilePath,
    String? mediaType,
    int? timeOffset,
    DateTime? timestampOriginal,
    DateTime? timestamp,
    User? createdBy,
    String? createdById,
    User? updatedBy,
    String? updatedById,
    User? deletedBy,
    String? deletedById,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool? isDeleted,
  }) {
    return Media(
      id: id, // ID should not change
      remoteFilePath: remoteFilePath ?? this.remoteFilePath,
      localFilePath: localFilePath ?? this.localFilePath,
      mediaType: mediaType ?? this.mediaType,
      timeOffset: timeOffset ?? this.timeOffset,
      timestampOriginal: timestampOriginal ?? this.timestampOriginal,
      timestamp: timestamp ?? this.timestamp,
      createdById: createdById ?? this.createdById,
      updatedById: updatedById ?? this.updatedById,
      deletedById: deletedById ?? this.deletedById,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
