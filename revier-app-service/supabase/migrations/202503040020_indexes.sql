
-- Create indexes for efficient queries on is_deleted
CREATE INDEX IF NOT EXISTS idx_hunting_ground_is_deleted ON hunting_ground (is_deleted) WHERE is_deleted = FALSE;
CREATE INDEX IF NOT EXISTS idx_tag_is_deleted ON tag (is_deleted) WHERE is_deleted = FALSE;
CREATE INDEX IF NOT EXISTS idx_caliber_is_deleted ON caliber (is_deleted) WHERE is_deleted = FALSE;
CREATE INDEX IF NOT EXISTS idx_weapon_is_deleted ON weapon (is_deleted) WHERE is_deleted = FALSE;
CREATE INDEX IF NOT EXISTS idx_weather_condition_is_deleted ON weather_condition (is_deleted) WHERE is_deleted = FALSE;
CREATE INDEX IF NOT EXISTS idx_media_is_deleted ON media (is_deleted) WHERE is_deleted = FALSE;
CREATE INDEX IF NOT EXISTS idx_camera_is_deleted ON camera (is_deleted) WHERE is_deleted = FALSE;
CREATE INDEX IF NOT EXISTS idx_upload_is_deleted ON upload (is_deleted) WHERE is_deleted = FALSE;
CREATE INDEX IF NOT EXISTS idx_shooting_is_deleted ON shooting (is_deleted) WHERE is_deleted = FALSE;
CREATE INDEX IF NOT EXISTS idx_sighting_is_deleted ON sighting (is_deleted) WHERE is_deleted = FALSE;
CREATE INDEX IF NOT EXISTS idx_animal_is_deleted ON animal (is_deleted) WHERE is_deleted = FALSE;

-- Also update any RLS policies to include is_deleted checks
-- This assumes existing RLS policies were already created
-- Add your RLS policies here or in a separate file

-- Example:
-- ALTER POLICY "Users can view their own records" ON "user"
--   USING (auth.uid() = id AND is_deleted = FALSE);

-- Make sure to initialize all existing records to have consistent is_deleted values
UPDATE hunting_ground SET is_deleted = (deleted_at IS NOT NULL);
UPDATE tag SET is_deleted = (deleted_at IS NOT NULL);
UPDATE caliber SET is_deleted = (deleted_at IS NOT NULL);
UPDATE weapon SET is_deleted = (deleted_at IS NOT NULL);
UPDATE weather_condition SET is_deleted = (deleted_at IS NOT NULL);
UPDATE media SET is_deleted = (deleted_at IS NOT NULL);
UPDATE camera SET is_deleted = (deleted_at IS NOT NULL);
UPDATE upload SET is_deleted = (deleted_at IS NOT NULL);
UPDATE shooting SET is_deleted = (deleted_at IS NOT NULL);
UPDATE sighting SET is_deleted = (deleted_at IS NOT NULL);

-- Indexes for foreign keys
CREATE INDEX IF NOT EXISTS idx_federal_state_country_id ON federal_state(country_id);
CREATE INDEX IF NOT EXISTS idx_hunting_ground_federal_state_id ON hunting_ground(federal_state_id);
CREATE INDEX IF NOT EXISTS idx_hunting_ground_user_role_user_id ON hunting_ground_user_role(user_id);
CREATE INDEX IF NOT EXISTS idx_hunting_ground_user_role_hunting_ground_id ON hunting_ground_user_role(hunting_ground_id);
CREATE INDEX IF NOT EXISTS idx_hunting_season_federal_state_id ON hunting_season(federal_state_id);
CREATE INDEX IF NOT EXISTS idx_hunting_season_species_id ON hunting_season(species_id);
CREATE INDEX IF NOT EXISTS idx_animal_hunting_ground_id ON animal(hunting_ground_id);
CREATE INDEX IF NOT EXISTS idx_animal_species_id ON animal(species_id);
CREATE INDEX IF NOT EXISTS idx_animal_shooting_id ON animal(shooting_id);
CREATE INDEX IF NOT EXISTS idx_animal_filter_hunting_ground_id ON animal_filter(hunting_ground_id);
CREATE INDEX IF NOT EXISTS idx_animal_filter_species_id ON animal_filter(species_id);
CREATE INDEX IF NOT EXISTS idx_camera_hunting_ground_id ON camera(hunting_ground_id);
CREATE INDEX IF NOT EXISTS idx_sighting_species_id ON sighting(species_id);
CREATE INDEX IF NOT EXISTS idx_sighting_weather_condition_id ON sighting(weather_condition_id);
CREATE INDEX IF NOT EXISTS idx_sighting_camera_id ON sighting(camera_id);
CREATE INDEX IF NOT EXISTS idx_sighting_upload_id ON sighting(upload_id);
CREATE INDEX IF NOT EXISTS idx_sighting_hunting_ground_id ON sighting(hunting_ground_id);
CREATE INDEX IF NOT EXISTS idx_upload_hunting_ground_id ON upload(hunting_ground_id);
CREATE INDEX IF NOT EXISTS idx_weapon_user_id ON weapon(user_id);
CREATE INDEX IF NOT EXISTS idx_weapon_default_caliber_id ON weapon(default_caliber_id);
CREATE INDEX IF NOT EXISTS idx_caliber_created_by_id ON caliber(created_by_id);
CREATE INDEX IF NOT EXISTS idx_allowed_caliber_federal_state ON allowed_caliber(federal_state);
CREATE INDEX IF NOT EXISTS idx_allowed_caliber_species_id ON allowed_caliber(species_id);
CREATE INDEX IF NOT EXISTS idx_shooting_shot_by_id ON shooting(shot_by_id);
CREATE INDEX IF NOT EXISTS idx_shooting_weapon_id ON shooting(weapon_id);
CREATE INDEX IF NOT EXISTS idx_shooting_caliber_id ON shooting(caliber_id);

-- Indexes for junction tables
CREATE INDEX IF NOT EXISTS idx_animal_tag_animal_id ON animal_tag(animal_id);
CREATE INDEX IF NOT EXISTS idx_animal_tag_tag_id ON animal_tag(tag_id);
CREATE INDEX IF NOT EXISTS idx_sighting_animal_sighting_id ON sighting_animal(sighting_id);
CREATE INDEX IF NOT EXISTS idx_sighting_animal_animal_id ON sighting_animal(animal_id);
CREATE INDEX IF NOT EXISTS idx_sighting_tag_sighting_id ON sighting_tag(sighting_id);
CREATE INDEX IF NOT EXISTS idx_sighting_tag_tag_id ON sighting_tag(tag_id);
CREATE INDEX IF NOT EXISTS idx_sighting_media_sighting_id ON sighting_media(sighting_id);
CREATE INDEX IF NOT EXISTS idx_sighting_media_media_id ON sighting_media(media_id);
CREATE INDEX IF NOT EXISTS idx_shooting_media_shooting_id ON shooting_media(shooting_id);
CREATE INDEX IF NOT EXISTS idx_shooting_media_media_id ON shooting_media(media_id);
CREATE INDEX IF NOT EXISTS idx_animal_filter_animal_filter_id ON animal_filter_animal(animal_filter_id);
CREATE INDEX IF NOT EXISTS idx_animal_filter_animal_animal_id ON animal_filter_animal(animal_id);
CREATE INDEX IF NOT EXISTS idx_animal_filter_tag_filter_id ON animal_filter_tag(animal_filter_id);
CREATE INDEX IF NOT EXISTS idx_animal_filter_tag_tag_id ON animal_filter_tag(tag_id);
CREATE INDEX IF NOT EXISTS idx_upload_media_upload_id ON upload_media(upload_id);
CREATE INDEX IF NOT EXISTS idx_upload_media_media_id ON upload_media(media_id);
CREATE INDEX IF NOT EXISTS idx_upload_unprocessed_media_upload_id ON upload_unprocessed_media(upload_id);
CREATE INDEX IF NOT EXISTS idx_upload_unprocessed_media_media_id ON upload_unprocessed_media(media_id);
CREATE INDEX IF NOT EXISTS idx_caliber_allowed_caliber_allowed_caliber_id ON caliber_allowed_caliber(allowed_caliber_id);
CREATE INDEX IF NOT EXISTS idx_caliber_allowed_caliber_caliber_id ON caliber_allowed_caliber(caliber_id);

-- Indexes for timestamp columns for efficient filtering
CREATE INDEX IF NOT EXISTS idx_hunting_season_valid_from ON hunting_season(valid_from);
CREATE INDEX IF NOT EXISTS idx_hunting_season_valid_until ON hunting_season(valid_until);
CREATE INDEX IF NOT EXISTS idx_weather_condition_timestamp ON weather_condition(timestamp);
CREATE INDEX IF NOT EXISTS idx_sighting_sighting_start ON sighting(sighting_start);
CREATE INDEX IF NOT EXISTS idx_sighting_sighting_end ON sighting(sighting_end);
CREATE INDEX IF NOT EXISTS idx_shooting_shot_at ON shooting(shot_at);

-- Indexes for soft delete columns
CREATE INDEX IF NOT EXISTS idx_hunting_ground_deleted_at ON hunting_ground(deleted_at) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_weather_condition_deleted_at ON weather_condition(deleted_at) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_shooting_deleted_at ON shooting(deleted_at) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_media_deleted_at ON media(deleted_at) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_sighting_deleted_at ON sighting(deleted_at) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_tag_deleted_at ON tag(deleted_at) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_weapon_deleted_at ON weapon(deleted_at) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_caliber_deleted_at ON caliber(deleted_at) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_camera_deleted_at ON camera(deleted_at) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_upload_deleted_at ON upload(deleted_at) WHERE deleted_at IS NULL;

-- Indexes for geospatial queries
CREATE INDEX IF NOT EXISTS idx_sighting_location ON sighting(latitude, longitude);
CREATE INDEX IF NOT EXISTS idx_camera_location ON camera(latitude, longitude);
CREATE INDEX IF NOT EXISTS idx_upload_location ON upload(latitude, longitude);