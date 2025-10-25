-- Now create triggers to sync deleted_at and is_deleted columns
-- This ensures that whenever deleted_at is set, is_deleted becomes TRUE and vice versa

-- Create trigger functions for each table with soft delete functionality
CREATE OR REPLACE FUNCTION sync_user_deleted_at_and_is_deleted()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
      NEW.is_deleted := TRUE;
    ELSIF NEW.deleted_at IS NULL AND OLD.deleted_at IS NOT NULL THEN
      NEW.is_deleted := FALSE;
    ELSIF NEW.is_deleted = TRUE AND NEW.deleted_at IS NULL THEN
      NEW.deleted_at := CURRENT_TIMESTAMP;
    ELSIF NEW.is_deleted = FALSE AND NEW.deleted_at IS NOT NULL THEN
      NEW.deleted_at := NULL;
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create similar functions for other tables
CREATE OR REPLACE FUNCTION sync_hunting_ground_deleted_at_and_is_deleted()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
      NEW.is_deleted := TRUE;
    ELSIF NEW.deleted_at IS NULL AND OLD.deleted_at IS NOT NULL THEN
      NEW.is_deleted := FALSE;
    ELSIF NEW.is_deleted = TRUE AND NEW.deleted_at IS NULL THEN
      NEW.deleted_at := CURRENT_TIMESTAMP;
    ELSIF NEW.is_deleted = FALSE AND NEW.deleted_at IS NOT NULL THEN
      NEW.deleted_at := NULL;
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sync_tag_deleted_at_and_is_deleted()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
      NEW.is_deleted := TRUE;
    ELSIF NEW.deleted_at IS NULL AND OLD.deleted_at IS NOT NULL THEN
      NEW.is_deleted := FALSE;
    ELSIF NEW.is_deleted = TRUE AND NEW.deleted_at IS NULL THEN
      NEW.deleted_at := CURRENT_TIMESTAMP;
    ELSIF NEW.is_deleted = FALSE AND NEW.deleted_at IS NOT NULL THEN
      NEW.deleted_at := NULL;
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sync_caliber_deleted_at_and_is_deleted()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
      NEW.is_deleted := TRUE;
    ELSIF NEW.deleted_at IS NULL AND OLD.deleted_at IS NOT NULL THEN
      NEW.is_deleted := FALSE;
    ELSIF NEW.is_deleted = TRUE AND NEW.deleted_at IS NULL THEN
      NEW.deleted_at := CURRENT_TIMESTAMP;
    ELSIF NEW.is_deleted = FALSE AND NEW.deleted_at IS NOT NULL THEN
      NEW.deleted_at := NULL;
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sync_weapon_deleted_at_and_is_deleted()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
      NEW.is_deleted := TRUE;
    ELSIF NEW.deleted_at IS NULL AND OLD.deleted_at IS NOT NULL THEN
      NEW.is_deleted := FALSE;
    ELSIF NEW.is_deleted = TRUE AND NEW.deleted_at IS NULL THEN
      NEW.deleted_at := CURRENT_TIMESTAMP;
    ELSIF NEW.is_deleted = FALSE AND NEW.deleted_at IS NOT NULL THEN
      NEW.deleted_at := NULL;
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sync_weather_condition_deleted_at_and_is_deleted()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
      NEW.is_deleted := TRUE;
    ELSIF NEW.deleted_at IS NULL AND OLD.deleted_at IS NOT NULL THEN
      NEW.is_deleted := FALSE;
    ELSIF NEW.is_deleted = TRUE AND NEW.deleted_at IS NULL THEN
      NEW.deleted_at := CURRENT_TIMESTAMP;
    ELSIF NEW.is_deleted = FALSE AND NEW.deleted_at IS NOT NULL THEN
      NEW.deleted_at := NULL;
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sync_media_deleted_at_and_is_deleted()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
      NEW.is_deleted := TRUE;
    ELSIF NEW.deleted_at IS NULL AND OLD.deleted_at IS NOT NULL THEN
      NEW.is_deleted := FALSE;
    ELSIF NEW.is_deleted = TRUE AND NEW.deleted_at IS NULL THEN
      NEW.deleted_at := CURRENT_TIMESTAMP;
    ELSIF NEW.is_deleted = FALSE AND NEW.deleted_at IS NOT NULL THEN
      NEW.deleted_at := NULL;
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sync_camera_deleted_at_and_is_deleted()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
      NEW.is_deleted := TRUE;
    ELSIF NEW.deleted_at IS NULL AND OLD.deleted_at IS NOT NULL THEN
      NEW.is_deleted := FALSE;
    ELSIF NEW.is_deleted = TRUE AND NEW.deleted_at IS NULL THEN
      NEW.deleted_at := CURRENT_TIMESTAMP;
    ELSIF NEW.is_deleted = FALSE AND NEW.deleted_at IS NOT NULL THEN
      NEW.deleted_at := NULL;
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sync_upload_deleted_at_and_is_deleted()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
      NEW.is_deleted := TRUE;
    ELSIF NEW.deleted_at IS NULL AND OLD.deleted_at IS NOT NULL THEN
      NEW.is_deleted := FALSE;
    ELSIF NEW.is_deleted = TRUE AND NEW.deleted_at IS NULL THEN
      NEW.deleted_at := CURRENT_TIMESTAMP;
    ELSIF NEW.is_deleted = FALSE AND NEW.deleted_at IS NOT NULL THEN
      NEW.deleted_at := NULL;
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sync_shooting_deleted_at_and_is_deleted()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
      NEW.is_deleted := TRUE;
    ELSIF NEW.deleted_at IS NULL AND OLD.deleted_at IS NOT NULL THEN
      NEW.is_deleted := FALSE;
    ELSIF NEW.is_deleted = TRUE AND NEW.deleted_at IS NULL THEN
      NEW.deleted_at := CURRENT_TIMESTAMP;
    ELSIF NEW.is_deleted = FALSE AND NEW.deleted_at IS NOT NULL THEN
      NEW.deleted_at := NULL;
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sync_sighting_deleted_at_and_is_deleted()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
      NEW.is_deleted := TRUE;
    ELSIF NEW.deleted_at IS NULL AND OLD.deleted_at IS NOT NULL THEN
      NEW.is_deleted := FALSE;
    ELSIF NEW.is_deleted = TRUE AND NEW.deleted_at IS NULL THEN
      NEW.deleted_at := CURRENT_TIMESTAMP;
    ELSIF NEW.is_deleted = FALSE AND NEW.deleted_at IS NOT NULL THEN
      NEW.deleted_at := NULL;
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
