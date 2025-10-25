import 'package:revier_app_client/brick/models/allowed_caliber.model.dart';
import 'package:revier_app_client/brick/models/animal.model.dart';
import 'package:revier_app_client/brick/models/animal_filter.model.dart';
import 'package:revier_app_client/brick/models/caliber.model.dart';
import 'package:revier_app_client/brick/models/camera.model.dart';
import 'package:revier_app_client/brick/models/country.model.dart';
import 'package:revier_app_client/brick/models/federal_state.model.dart';
import 'package:revier_app_client/brick/models/hunting_ground.model.dart';
import 'package:revier_app_client/brick/models/hunting_ground_role_permission.dart';
import 'package:revier_app_client/brick/models/hunting_ground_user_role.model.dart';
import 'package:revier_app_client/brick/models/hunting_season.model.dart';
import 'package:revier_app_client/brick/models/media.model.dart';
import 'package:revier_app_client/brick/models/shooting.model.dart';
import 'package:revier_app_client/brick/models/sighting_tag.model.dart';
import 'package:revier_app_client/brick/models/sighting.model.dart';
import 'package:revier_app_client/brick/models/species.model.dart';
import 'package:revier_app_client/brick/models/tag.model.dart';
import 'package:revier_app_client/brick/models/upload_media.model.dart';
import 'package:revier_app_client/brick/models/upload_unprocessed_media.model.dart';
import 'package:revier_app_client/brick/models/upload.model.dart';
import 'package:revier_app_client/brick/models/weapon.model.dart';
import 'package:revier_app_client/brick/models/weather_condition.model.dart';
import 'package:revier_app_client/data/model_registry.dart';

/// Register all models with the ModelRegistry
void registerModels(ModelRegistry registry) {
  // Register models
  registry.register<AllowedCaliber>();
  registry.register<AnimalFilter>();
  registry.register<Animal>();
  registry.register<Caliber>();
  registry.register<Camera>();
  registry.register<Country>();
  registry.register<FederalState>();
  registry.register<HuntingGroundRolePermission>();
  registry.register<HuntingGroundUserRole>();
  registry.register<HuntingGround>();
  registry.register<HuntingSeason>();
  registry.register<Media>();
  registry.register<Shooting>();
  registry.register<SightingTag>();
  registry.register<Sighting>();
  registry.register<Species>();
  registry.register<Tag>();
  registry.register<UploadMedia>();
  registry.register<UploadUnprocessedMedia>();
  registry.register<Upload>();
  registry.register<Weapon>();
  registry.register<WeatherCondition>();
  // TODO: Register more models as they are added to the app
  // Example:
  // registry.register<User>();
  // registry.register<Profile>();
  // registry.register<HuntingGround>();
}
