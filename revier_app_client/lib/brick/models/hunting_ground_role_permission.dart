import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart' show Uuid;

/// HuntingGroundUserRoles model for offline-first capabilities
///
/// This model corresponds to the hunting_ground_user_roles table in Supabase
@ConnectOfflineFirstWithSupabase(
    supabaseConfig:
        SupabaseSerializable(tableName: 'hunting_ground_role_permission'),
    sqliteConfig: SqliteSerializable())
class HuntingGroundRolePermission extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(unique: true, index: true)
  final String id;

  final String role;
  final String permission;

  HuntingGroundRolePermission({
    String? id,
    required this.role,
    required this.permission,
  }) : id = id ?? Uuid().v4();

  /// Create a copy of this HuntingGroundRolePermission with the given fields replaced
  HuntingGroundRolePermission copyWith({
    String? role,
    String? permission,
  }) {
    return HuntingGroundRolePermission(
      id: id,
      role: role ?? this.role,
      permission: permission ?? this.permission,
    );
  }
}
