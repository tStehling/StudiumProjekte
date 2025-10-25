-- Migration to enable RLS on tables that don't have it enabled yet
-- Created on 2025-05-13

-- Enable RLS on remaining tables
ALTER TABLE shooting_media ENABLE ROW LEVEL SECURITY;
ALTER TABLE weapon ENABLE ROW LEVEL SECURITY;
ALTER TABLE upload ENABLE ROW LEVEL SECURITY;
ALTER TABLE sighting_tag ENABLE ROW LEVEL SECURITY;
ALTER TABLE weather_condition ENABLE ROW LEVEL SECURITY;
ALTER TABLE caliber_allowed_caliber ENABLE ROW LEVEL SECURITY;
ALTER TABLE upload_unprocessed_media ENABLE ROW LEVEL SECURITY;
ALTER TABLE shooting ENABLE ROW LEVEL SECURITY;
ALTER TABLE upload_media ENABLE ROW LEVEL SECURITY;
ALTER TABLE sighting_media ENABLE ROW LEVEL SECURITY;
ALTER TABLE sighting ENABLE ROW LEVEL SECURITY;
ALTER TABLE hunting_ground_role_permission ENABLE ROW LEVEL SECURITY;
ALTER TABLE caliber ENABLE ROW LEVEL SECURITY;
ALTER TABLE animal_tag ENABLE ROW LEVEL SECURITY;
ALTER TABLE media ENABLE ROW LEVEL SECURITY;
ALTER TABLE sighting_animal ENABLE ROW LEVEL SECURITY;
ALTER TABLE tag ENABLE ROW LEVEL SECURITY;
ALTER TABLE camera ENABLE ROW LEVEL SECURITY;

-- Add missing RLS policies

-- weather_condition policies
CREATE POLICY "Users can read weather conditions"
  ON weather_condition
  FOR SELECT
  USING (weather_condition.is_deleted = FALSE);

CREATE POLICY "Admins can manage all weather conditions"
  ON weather_condition
  FOR ALL
  USING (auth.jwt() ->> 'role' = 'service_role' OR is_admin());

-- caliber policies
CREATE POLICY "Users can read calibers"
  ON caliber
  FOR SELECT
  USING (caliber.is_deleted = FALSE);

CREATE POLICY "Users can manage calibers they created"
  ON caliber
  FOR ALL
  USING (
    caliber.is_deleted = FALSE AND
    caliber.created_by_id = auth.uid()
  );

CREATE POLICY "Admins can manage all calibers"
  ON caliber
  FOR ALL
  USING (auth.jwt() ->> 'role' = 'service_role' OR is_admin());

-- tag policies
DROP POLICY IF EXISTS "Users can view tag" ON tag;
DROP POLICY IF EXISTS "Users can manage tag they created" ON tag;

CREATE POLICY "Users can read tags"
  ON tag
  FOR SELECT
  USING (tag.is_deleted = FALSE);

CREATE POLICY "Users can manage tags they created"
  ON tag
  FOR ALL
  USING (
    tag.is_deleted = FALSE
  );

CREATE POLICY "Admins can manage all tags"
  ON tag
  FOR ALL
  USING (auth.jwt() ->> 'role' = 'service_role' OR is_admin());

-- hunting_ground_role_permission policies
CREATE POLICY "Users can read role permissions"
  ON hunting_ground_role_permission
  FOR SELECT
  USING (true);

CREATE POLICY "Admins can manage role permissions"
  ON hunting_ground_role_permission
  FOR ALL
  USING (auth.jwt() ->> 'role' = 'service_role' OR is_admin());

-- caliber_allowed_caliber policies
CREATE POLICY "Users can read allowed caliber assignments"
  ON caliber_allowed_caliber
  FOR SELECT
  USING (true);

CREATE POLICY "Admins can manage allowed caliber assignments"
  ON caliber_allowed_caliber
  FOR ALL
  USING (auth.jwt() ->> 'role' = 'service_role' OR is_admin());

-- media policies (if not already defined)
DROP POLICY IF EXISTS "Users can view media related to their sighting or shootings" ON media;

CREATE POLICY "Users can view media they created or have access to"
  ON media
  FOR SELECT
  USING (
    media.is_deleted = FALSE AND
    EXISTS (
      SELECT 1 FROM upload_media
      JOIN upload ON upload.id = upload_media.upload_id
      WHERE upload_media.media_id = media.id
      AND (upload.created_by_id = auth.uid() OR
           has_hunting_ground_permission(upload.hunting_ground_id, 'hunting_ground.read'))
    ) OR
    EXISTS (
      SELECT 1 FROM sighting_media
      JOIN sighting ON sighting.id = sighting_media.sighting_id
      WHERE sighting_media.media_id = media.id
      AND has_hunting_ground_permission(sighting.hunting_ground_id, 'hunting_ground.read')
    )
  );

-- camera policies
DROP POLICY IF EXISTS "Users can manage cameras in their hunting grounds" ON camera;

CREATE POLICY "Users can view cameras in hunting grounds with permission"
  ON camera
  FOR SELECT
  USING (
    camera.is_deleted = FALSE AND
    has_hunting_ground_permission(camera.hunting_ground_id, 'hunting_ground.read')
  );

CREATE POLICY "Users can create cameras in hunting grounds with permission"
  ON camera
  FOR INSERT
  WITH CHECK (
    has_hunting_ground_permission(camera.hunting_ground_id, 'hunting_ground.create')
  );

CREATE POLICY "Users can update cameras in hunting grounds with permission"
  ON camera
  FOR UPDATE
  USING (
    camera.is_deleted = FALSE AND
    has_hunting_ground_permission(camera.hunting_ground_id, 'hunting_ground.update')
  )
  WITH CHECK (
    has_hunting_ground_permission(camera.hunting_ground_id, 'hunting_ground.update')
  );

CREATE POLICY "Users can delete cameras in hunting grounds with permission"
  ON camera
  FOR DELETE
  USING (
    camera.is_deleted = FALSE AND
    has_hunting_ground_permission(camera.hunting_ground_id, 'hunting_ground.delete')
  );

CREATE POLICY "Admins can manage all cameras"
  ON camera
  FOR ALL
  USING (auth.jwt() ->> 'role' = 'service_role' OR is_admin());

-- weapon policies
DROP POLICY IF EXISTS "Users can manage their own weapon" ON weapon;

CREATE POLICY "Users can view their own weapons"
  ON weapon
  FOR SELECT
  USING (
    weapon.is_deleted = FALSE AND
    weapon.user_id = auth.uid()
  );

CREATE POLICY "Users can manage their own weapons"
  ON weapon
  FOR ALL
  USING (
    weapon.is_deleted = FALSE AND
    weapon.user_id = auth.uid()
  );

CREATE POLICY "Admins can manage all weapons"
  ON weapon
  FOR ALL
  USING (auth.jwt() ->> 'role' = 'service_role' OR is_admin());

-- shooting policies
DROP POLICY IF EXISTS "Users can view shootings they performed" ON shooting;
DROP POLICY IF EXISTS "Users can manage shootings they performed" ON shooting;

CREATE POLICY "Users can view their own shootings"
  ON shooting
  FOR SELECT
  USING (
    shooting.is_deleted = FALSE AND
    shooting.shot_by_id = auth.uid()
  );

CREATE POLICY "Users can manage their own shootings"
  ON shooting
  FOR ALL
  USING (
    shooting.is_deleted = FALSE AND
    shooting.shot_by_id = auth.uid()
  );

CREATE POLICY "Admins can manage all shootings"
  ON shooting
  FOR ALL
  USING (auth.jwt() ->> 'role' = 'service_role' OR is_admin());

-- Junction table policies

-- shooting_media policies
DROP POLICY IF EXISTS "Users can manage shooting media for their shootings" ON shooting_media;

CREATE POLICY "Users can view shooting media for their shootings"
  ON shooting_media
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM shooting
      WHERE shooting.id = shooting_media.shooting_id
      AND shooting.is_deleted = FALSE
      AND shooting.shot_by_id = auth.uid()
    )
  );

CREATE POLICY "Users can manage shooting media for their shootings"
  ON shooting_media
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM shooting
      WHERE shooting.id = shooting_media.shooting_id
      AND shooting.is_deleted = FALSE
      AND shooting.shot_by_id = auth.uid()
    )
  );

CREATE POLICY "Admins can manage all shooting media"
  ON shooting_media
  FOR ALL
  USING (auth.jwt() ->> 'role' = 'service_role' OR is_admin());

-- sighting_media policies
DROP POLICY IF EXISTS "Users can manage sighting media for their sighting" ON sighting_media;

CREATE POLICY "Users can view sighting media for sightings they have access to"
  ON sighting_media
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM sighting
      WHERE sighting.id = sighting_media.sighting_id
      AND sighting.is_deleted = FALSE
      AND has_hunting_ground_permission(sighting.hunting_ground_id, 'hunting_ground.read')
    )
  );

CREATE POLICY "Users can manage sighting media for sightings they have access to"
  ON sighting_media
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM sighting
      WHERE sighting.id = sighting_media.sighting_id
      AND sighting.is_deleted = FALSE
      AND has_hunting_ground_permission(sighting.hunting_ground_id, 'hunting_ground.update')
    )
  );

CREATE POLICY "Admins can manage all sighting media"
  ON sighting_media
  FOR ALL
  USING (auth.jwt() ->> 'role' = 'service_role' OR is_admin());

-- sighting_tag policies
DROP POLICY IF EXISTS "Users can manage sighting tag for their sighting" ON sighting_tag;

CREATE POLICY "Users can view sighting tags for sightings they have access to"
  ON sighting_tag
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM sighting
      WHERE sighting.id = sighting_tag.sighting_id
      AND sighting.is_deleted = FALSE
      AND has_hunting_ground_permission(sighting.hunting_ground_id, 'hunting_ground.read')
    )
  );

CREATE POLICY "Users can manage sighting tags for sightings they have access to"
  ON sighting_tag
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM sighting
      WHERE sighting.id = sighting_tag.sighting_id
      AND sighting.is_deleted = FALSE
      AND has_hunting_ground_permission(sighting.hunting_ground_id, 'hunting_ground.update')
    )
  );

CREATE POLICY "Admins can manage all sighting tags"
  ON sighting_tag
  FOR ALL
  USING (auth.jwt() ->> 'role' = 'service_role' OR is_admin());

-- animal_tag policies
DROP POLICY IF EXISTS "Users can manage animal tag for their animal" ON animal_tag;

CREATE POLICY "Users can view animal tags for animals they have access to"
  ON animal_tag
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM animal
      WHERE animal.id = animal_tag.animal_id
      AND animal.is_deleted = FALSE
      AND has_hunting_ground_permission(animal.hunting_ground_id, 'hunting_ground.read')
    )
  );

CREATE POLICY "Users can manage animal tags for animals they have access to"
  ON animal_tag
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM animal
      WHERE animal.id = animal_tag.animal_id
      AND animal.is_deleted = FALSE
      AND has_hunting_ground_permission(animal.hunting_ground_id, 'hunting_ground.update')
    )
  );

CREATE POLICY "Admins can manage all animal tags"
  ON animal_tag
  FOR ALL
  USING (auth.jwt() ->> 'role' = 'service_role' OR is_admin());

-- sighting_animal policies
DROP POLICY IF EXISTS "Users can manage sighting animal for their sighting" ON sighting_animal;

CREATE POLICY "Users can view sighting animals for sightings they have access to"
  ON sighting_animal
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM sighting
      WHERE sighting.id = sighting_animal.sighting_id
      AND sighting.is_deleted = FALSE
      AND has_hunting_ground_permission(sighting.hunting_ground_id, 'hunting_ground.read')
    )
  );

CREATE POLICY "Users can manage sighting animals for sightings they have access to"
  ON sighting_animal
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM sighting
      WHERE sighting.id = sighting_animal.sighting_id
      AND sighting.is_deleted = FALSE
      AND has_hunting_ground_permission(sighting.hunting_ground_id, 'hunting_ground.update')
    )
  );

CREATE POLICY "Admins can manage all sighting animals"
  ON sighting_animal
  FOR ALL
  USING (auth.jwt() ->> 'role' = 'service_role' OR is_admin());

-- upload policies
DROP POLICY IF EXISTS "Users can manage their uploads" ON upload;
DROP POLICY IF EXISTS "Allow new uploads" ON upload;
DROP POLICY IF EXISTS "Allow soft delete of uploads" ON upload;

CREATE POLICY "Users can view their own uploads"
  ON upload
  FOR SELECT
  USING (
    upload.is_deleted = FALSE AND
    upload.created_by_id = auth.uid()
  );

CREATE POLICY "Users can view uploads from hunting grounds with permission"
  ON upload
  FOR SELECT
  USING (
    upload.is_deleted = FALSE AND
    has_hunting_ground_permission(upload.hunting_ground_id, 'hunting_ground.read')
  );

CREATE POLICY "Users can manage uploads they created"
  ON upload
  FOR ALL
  USING (
    upload.is_deleted = FALSE AND
    upload.created_by_id = auth.uid()
  );

CREATE POLICY "Users can manage uploads from hunting grounds with permission"
  ON upload
  FOR ALL
  USING (
    upload.is_deleted = FALSE AND
    has_hunting_ground_permission(upload.hunting_ground_id, 'hunting_ground.update')
  );

-- Re-add anonymous uploads policy
CREATE POLICY "Allow new uploads"
  ON upload
  FOR INSERT
  WITH CHECK (true);

-- Re-add soft delete policy
CREATE POLICY "Allow soft delete of uploads"
  ON upload
  FOR UPDATE
  USING (
    -- User owns the upload they want to delete
    (upload.created_by_id = auth.uid() OR upload.created_by_id IS NULL)
  )
  WITH CHECK (
    -- Only allow setting is_deleted to TRUE (soft delete)
    (is_deleted = TRUE)
  );

CREATE POLICY "Admins can manage all uploads"
  ON upload
  FOR ALL
  USING (auth.jwt() ->> 'role' = 'service_role' OR is_admin());

-- upload_media and upload_unprocessed_media policies
DROP POLICY IF EXISTS "Allow upload_media operations" ON upload_media;
DROP POLICY IF EXISTS "Allow upload_unprocessed_media operations" ON upload_unprocessed_media;

CREATE POLICY "Users can view upload media associations"
  ON upload_media
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM upload
      WHERE upload.id = upload_media.upload_id
      AND upload.is_deleted = FALSE
      AND (upload.created_by_id = auth.uid() OR
           has_hunting_ground_permission(upload.hunting_ground_id, 'hunting_ground.read'))
    )
  );

CREATE POLICY "Users can manage upload media they created"
  ON upload_media
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM upload
      WHERE upload.id = upload_media.upload_id
      AND upload.is_deleted = FALSE
      AND upload.created_by_id = auth.uid()
    )
  );

CREATE POLICY "Admins can manage all upload media"
  ON upload_media
  FOR ALL
  USING (auth.jwt() ->> 'role' = 'service_role' OR is_admin());

CREATE POLICY "Users can view upload unprocessed media associations"
  ON upload_unprocessed_media
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM upload
      WHERE upload.id = upload_unprocessed_media.upload_id
      AND upload.is_deleted = FALSE
      AND (upload.created_by_id = auth.uid() OR
           has_hunting_ground_permission(upload.hunting_ground_id, 'hunting_ground.read'))
    )
  );

CREATE POLICY "Users can manage upload unprocessed media they created"
  ON upload_unprocessed_media
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM upload
      WHERE upload.id = upload_unprocessed_media.upload_id
      AND upload.is_deleted = FALSE
      AND upload.created_by_id = auth.uid()
    )
  );

CREATE POLICY "Admins can manage all upload unprocessed media"
  ON upload_unprocessed_media
  FOR ALL
  USING (auth.jwt() ->> 'role' = 'service_role' OR is_admin());

-- Ensure policies for junction tables are complete
-- Note: Some of these might already exist in other migration files

-- Fix for any missing sighting policies
DROP POLICY IF EXISTS "Users can view sighting in their hunting grounds" ON sighting;
DROP POLICY IF EXISTS "Users can manage sighting for their animal" ON sighting;
DROP POLICY IF EXISTS "Users can access sightings directly by hunting_ground_id" ON sighting;

CREATE POLICY "Users can view sightings in hunting grounds with permission"
  ON sighting
  FOR SELECT
  USING (
    sighting.is_deleted = FALSE AND
    has_hunting_ground_permission(sighting.hunting_ground_id, 'hunting_ground.read')
  );

CREATE POLICY "Users can manage sightings in hunting grounds with permission"
  ON sighting
  FOR INSERT
  WITH CHECK (
    has_hunting_ground_permission(sighting.hunting_ground_id, 'hunting_ground.create')
  );

CREATE POLICY "Users can update sightings in hunting grounds with permission"
  ON sighting
  FOR UPDATE
  USING (
    sighting.is_deleted = FALSE AND
    has_hunting_ground_permission(sighting.hunting_ground_id, 'hunting_ground.update')
  )
  WITH CHECK (
    has_hunting_ground_permission(sighting.hunting_ground_id, 'hunting_ground.update')
  );

CREATE POLICY "Users can delete sightings in hunting grounds with permission"
  ON sighting
  FOR DELETE
  USING (
    sighting.is_deleted = FALSE AND
    has_hunting_ground_permission(sighting.hunting_ground_id, 'hunting_ground.delete')
  );

CREATE POLICY "Admins can manage all sightings"
  ON sighting
  FOR ALL
  USING (auth.jwt() ->> 'role' = 'service_role' OR is_admin()); 