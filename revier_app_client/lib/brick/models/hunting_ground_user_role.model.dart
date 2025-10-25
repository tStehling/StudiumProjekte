import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart' show Uuid;
import 'package:supabase/supabase.dart' show User;
import 'package:revier_app_client/brick/models/hunting_ground.model.dart';

/// HuntingGroundUserRoles model for offline-first capabilities
///
/// This model corresponds to the hunting_ground_user_roles table in Supabase
@ConnectOfflineFirstWithSupabase(
    supabaseConfig: SupabaseSerializable(tableName: 'hunting_ground_user_role'),
    sqliteConfig: SqliteSerializable())
class HuntingGroundUserRole extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(unique: true, index: true)
  final String id;

  @Supabase(foreignKey: 'user_id', ignoreTo: true)
  final String userId;

  @Supabase(foreignKey: 'hunting_ground_id', ignoreTo: true)
  final HuntingGround huntingGround;
  String get huntingGroundId => huntingGround.id;

  final String role;

  HuntingGroundUserRole({
    String? id,
    required this.userId,
    required this.huntingGround,
    required this.role,
  }) : id = id ?? Uuid().v4();

  /// Create a copy of this HuntingGroundUserRole with the given fields replaced
  HuntingGroundUserRole copyWith({
    String? userId,
    HuntingGround? huntingGround,
    String? role,
  }) {
    return HuntingGroundUserRole(
      id: id,
      userId: userId ?? this.userId,
      huntingGround: huntingGround ?? this.huntingGround,
      role: role ?? this.role,
    );
  }
}
