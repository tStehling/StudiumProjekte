// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_core/query.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_sqlite/db.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_sqlite/brick_sqlite.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_supabase/brick_supabase.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:uuid/uuid.dart' show Uuid;
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:revier_app_client/brick/models/hunting_ground.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:revier_app_client/brick/models/species.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:revier_app_client/brick/models/shooting.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:revier_app_client/brick/models/federal_state.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:revier_app_client/brick/models/caliber.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:supabase/supabase.dart' show User;
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:supabase_flutter/supabase_flutter.dart' show User;
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:revier_app_client/brick/models/country.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:revier_app_client/brick/models/weapon.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:revier_app_client/brick/models/upload.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:revier_app_client/brick/models/media.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:revier_app_client/brick/models/weather_condition.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:revier_app_client/brick/models/camera.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:revier_app_client/brick/models/sighting.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:revier_app_client/brick/models/tag.model.dart';// GENERATED CODE DO NOT EDIT
// ignore: unused_import
import 'dart:convert';
import 'package:brick_sqlite/brick_sqlite.dart' show SqliteModel, SqliteAdapter, SqliteModelDictionary, RuntimeSqliteColumnDefinition, SqliteProvider;
import 'package:brick_supabase/brick_supabase.dart' show SupabaseProvider, SupabaseModel, SupabaseAdapter, SupabaseModelDictionary;
// ignore: unused_import, unused_shown_name
import 'package:brick_offline_first/brick_offline_first.dart' show RuntimeOfflineFirstDefinition;
// ignore: unused_import, unused_shown_name
import 'package:sqflite_common/sqlite_api.dart' show DatabaseExecutor;

import '../brick/models/weather_condition.model.dart';
import '../brick/models/animal.model.dart';
import '../brick/models/hunting_ground.model.dart';
import '../brick/models/weapon.model.dart';
import '../brick/models/allowed_caliber.model.dart';
import '../brick/models/camera.model.dart';
import '../brick/models/country.model.dart';
import '../brick/models/species.model.dart';
import '../brick/models/tag.model.dart';
import '../brick/models/caliber.model.dart';
import '../brick/models/hunting_season.model.dart';
import '../brick/models/federal_state.model.dart';
import '../brick/models/shooting.model.dart';
import '../brick/models/upload_unprocessed_media.model.dart';
import '../brick/models/media.model.dart';
import '../brick/models/hunting_ground_user_role.model.dart';
import '../brick/models/sighting.model.dart';
import '../brick/models/upload.model.dart';
import '../brick/models/sighting_tag.model.dart';
import '../brick/models/animal_filter.model.dart';
import '../brick/models/upload_media.model.dart';

part 'adapters/weather_condition_adapter.g.dart';
part 'adapters/animal_adapter.g.dart';
part 'adapters/hunting_ground_adapter.g.dart';
part 'adapters/weapon_adapter.g.dart';
part 'adapters/allowed_caliber_adapter.g.dart';
part 'adapters/camera_adapter.g.dart';
part 'adapters/country_adapter.g.dart';
part 'adapters/species_adapter.g.dart';
part 'adapters/tag_adapter.g.dart';
part 'adapters/caliber_adapter.g.dart';
part 'adapters/hunting_season_adapter.g.dart';
part 'adapters/federal_state_adapter.g.dart';
part 'adapters/shooting_adapter.g.dart';
part 'adapters/upload_unprocessed_media_adapter.g.dart';
part 'adapters/media_adapter.g.dart';
part 'adapters/hunting_ground_user_role_adapter.g.dart';
part 'adapters/sighting_adapter.g.dart';
part 'adapters/upload_adapter.g.dart';
part 'adapters/sighting_tag_adapter.g.dart';
part 'adapters/animal_filter_adapter.g.dart';
part 'adapters/upload_media_adapter.g.dart';

/// Supabase mappings should only be used when initializing a [SupabaseProvider]
final Map<Type, SupabaseAdapter<SupabaseModel>> supabaseMappings = {
  WeatherCondition: WeatherConditionAdapter(),
  Animal: AnimalAdapter(),
  HuntingGround: HuntingGroundAdapter(),
  Weapon: WeaponAdapter(),
  AllowedCaliber: AllowedCaliberAdapter(),
  Camera: CameraAdapter(),
  Country: CountryAdapter(),
  Species: SpeciesAdapter(),
  Tag: TagAdapter(),
  Caliber: CaliberAdapter(),
  HuntingSeason: HuntingSeasonAdapter(),
  FederalState: FederalStateAdapter(),
  Shooting: ShootingAdapter(),
  UploadUnprocessedMedia: UploadUnprocessedMediaAdapter(),
  Media: MediaAdapter(),
  HuntingGroundUserRole: HuntingGroundUserRoleAdapter(),
  Sighting: SightingAdapter(),
  Upload: UploadAdapter(),
  SightingTag: SightingTagAdapter(),
  AnimalFilter: AnimalFilterAdapter(),
  UploadMedia: UploadMediaAdapter()
};
final supabaseModelDictionary = SupabaseModelDictionary(supabaseMappings);

/// Sqlite mappings should only be used when initializing a [SqliteProvider]
final Map<Type, SqliteAdapter<SqliteModel>> sqliteMappings = {
  WeatherCondition: WeatherConditionAdapter(),
  Animal: AnimalAdapter(),
  HuntingGround: HuntingGroundAdapter(),
  Weapon: WeaponAdapter(),
  AllowedCaliber: AllowedCaliberAdapter(),
  Camera: CameraAdapter(),
  Country: CountryAdapter(),
  Species: SpeciesAdapter(),
  Tag: TagAdapter(),
  Caliber: CaliberAdapter(),
  HuntingSeason: HuntingSeasonAdapter(),
  FederalState: FederalStateAdapter(),
  Shooting: ShootingAdapter(),
  UploadUnprocessedMedia: UploadUnprocessedMediaAdapter(),
  Media: MediaAdapter(),
  HuntingGroundUserRole: HuntingGroundUserRoleAdapter(),
  Sighting: SightingAdapter(),
  Upload: UploadAdapter(),
  SightingTag: SightingTagAdapter(),
  AnimalFilter: AnimalFilterAdapter(),
  UploadMedia: UploadMediaAdapter()
};
final sqliteModelDictionary = SqliteModelDictionary(sqliteMappings);
