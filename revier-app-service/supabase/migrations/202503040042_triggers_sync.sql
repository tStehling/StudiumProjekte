
-- Create triggers for each table

CREATE OR REPLACE TRIGGER sync_hunting_ground_deleted_at_and_is_deleted_trigger
BEFORE UPDATE ON hunting_ground
FOR EACH ROW
EXECUTE FUNCTION sync_hunting_ground_deleted_at_and_is_deleted();

CREATE OR REPLACE TRIGGER sync_tag_deleted_at_and_is_deleted_trigger
BEFORE UPDATE ON tag
FOR EACH ROW
EXECUTE FUNCTION sync_tag_deleted_at_and_is_deleted();

CREATE OR REPLACE TRIGGER sync_caliber_deleted_at_and_is_deleted_trigger
BEFORE UPDATE ON caliber
FOR EACH ROW
EXECUTE FUNCTION sync_caliber_deleted_at_and_is_deleted();

CREATE OR REPLACE TRIGGER sync_weapon_deleted_at_and_is_deleted_trigger
BEFORE UPDATE ON weapon
FOR EACH ROW
EXECUTE FUNCTION sync_weapon_deleted_at_and_is_deleted();

CREATE OR REPLACE TRIGGER sync_weather_condition_deleted_at_and_is_deleted_trigger
BEFORE UPDATE ON weather_condition
FOR EACH ROW
EXECUTE FUNCTION sync_weather_condition_deleted_at_and_is_deleted();

CREATE OR REPLACE TRIGGER sync_media_deleted_at_and_is_deleted_trigger
BEFORE UPDATE ON media
FOR EACH ROW
EXECUTE FUNCTION sync_media_deleted_at_and_is_deleted();

CREATE OR REPLACE TRIGGER sync_camera_deleted_at_and_is_deleted_trigger
BEFORE UPDATE ON camera
FOR EACH ROW
EXECUTE FUNCTION sync_camera_deleted_at_and_is_deleted();

CREATE OR REPLACE TRIGGER sync_upload_deleted_at_and_is_deleted_trigger
BEFORE UPDATE ON upload
FOR EACH ROW
EXECUTE FUNCTION sync_upload_deleted_at_and_is_deleted();

CREATE OR REPLACE TRIGGER sync_shooting_deleted_at_and_is_deleted_trigger
BEFORE UPDATE ON shooting
FOR EACH ROW
EXECUTE FUNCTION sync_shooting_deleted_at_and_is_deleted();

CREATE OR REPLACE TRIGGER sync_sighting_deleted_at_and_is_deleted_trigger
BEFORE UPDATE ON sighting
FOR EACH ROW
EXECUTE FUNCTION sync_sighting_deleted_at_and_is_deleted();