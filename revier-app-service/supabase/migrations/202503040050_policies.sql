-- Enable Row Level Security (RLS) on the tables
ALTER TABLE hunting_season ENABLE ROW LEVEL SECURITY;
ALTER TABLE allowed_caliber ENABLE ROW LEVEL SECURITY;
ALTER TABLE federal_state ENABLE ROW LEVEL SECURITY;
ALTER TABLE country ENABLE ROW LEVEL SECURITY;
ALTER TABLE species ENABLE ROW LEVEL SECURITY;
ALTER TABLE hunting_ground ENABLE ROW LEVEL SECURITY;

-- Add a policy for inserting media (including anonymous)
CREATE POLICY "Allow new media uploads"
    ON media
    FOR INSERT
    WITH CHECK (true);

-- Add policies for upload_media and upload_unprocessed_media junction tables
CREATE POLICY "Allow upload_media operations"
    ON upload_media
    FOR ALL
    USING (true);

CREATE POLICY "Allow upload_unprocessed_media operations"
    ON upload_unprocessed_media
    FOR ALL
    USING (true);


-- Hunting grounds policies
DROP POLICY IF EXISTS "Users can view hunting grounds they are members of" ON hunting_ground;
DROP POLICY IF EXISTS "Admin users can update hunting grounds" ON hunting_ground;
DROP POLICY IF EXISTS "Users can create hunting_ground" ON hunting_ground;
DROP POLICY IF EXISTS "Users can read hunting_ground where they are owner or member" ON hunting_ground;
DROP POLICY IF EXISTS "Users can update hunting_ground where they are owner" ON hunting_ground;
DROP POLICY IF EXISTS "Users can delete hunting_ground where they are owner" ON hunting_ground;
DROP POLICY IF EXISTS "Admins can update any hunting_ground" ON hunting_ground;
DROP POLICY IF EXISTS "Admins can delete any hunting_ground" ON hunting_ground;

-- Add new permission-based hunting ground policies
CREATE POLICY "Users can create hunting grounds"
  ON hunting_ground
  FOR INSERT
  WITH CHECK (auth.uid() IS NOT NULL);

CREATE POLICY "Users can read hunting grounds with permission"
  ON hunting_ground
  FOR SELECT
  USING (
    has_hunting_ground_permission(hunting_ground.id, 'hunting_ground.read') OR
    auth.jwt() ->> 'role' = 'service_role'
  );

CREATE POLICY "Users can update hunting grounds with permission"
  ON hunting_ground
  FOR UPDATE
  USING (
    has_hunting_ground_permission(hunting_ground.id, 'hunting_ground.update') OR
    auth.jwt() ->> 'role' = 'service_role'
  )
  WITH CHECK (
    has_hunting_ground_permission(hunting_ground.id, 'hunting_ground.update') OR
    auth.jwt() ->> 'role' = 'service_role'
  );

CREATE POLICY "Users can delete hunting grounds with permission"
  ON hunting_ground
  FOR DELETE
  USING (
    has_hunting_ground_permission(hunting_ground.id, 'hunting_ground.delete') OR
    auth.jwt() ->> 'role' = 'service_role'
  );

-- Insert default role permissions for hunting grounds
-- Note: These same permissions are also defined in seed.sql with specific IDs
-- The ON CONFLICT clause ensures no duplicates are created
INSERT INTO hunting_ground_role_permission (role, permission)
VALUES 
  ('owner', 'hunting_ground.delete'),
  ('owner', 'hunting_ground.update'),
  ('owner', 'hunting_ground.create'),
  ('owner', 'hunting_ground.read'),
  ('owner', 'hunting_ground.manage_members'),
  ('co-owner', 'hunting_ground.update'),
  ('co-owner', 'hunting_ground.read'),
  ('co-owner', 'hunting_ground.manage_members'),
  ('member', 'hunting_ground.read')
ON CONFLICT (role, permission) DO NOTHING;

-- Hunting grounds members policies
DROP POLICY IF EXISTS "Admin users can manage hunting ground members" ON hunting_ground_user_role;
DROP POLICY IF EXISTS "Users can view hunting ground members they are in" ON hunting_ground_user_role;

-- Enable RLS for hunting_ground_user_role
ALTER TABLE hunting_ground_user_role ENABLE ROW LEVEL SECURITY;

-- Add policies for hunting_ground_user_role
CREATE POLICY "Users can view hunting ground members"
  ON hunting_ground_user_role
  FOR SELECT
  USING (
    has_hunting_ground_permission(hunting_ground_user_role.hunting_ground_id, 'hunting_ground.read') OR
    auth.jwt() ->> 'role' = 'service_role'
  );

CREATE POLICY "Users can manage hunting ground members with permission"
  ON hunting_ground_user_role
  FOR ALL
  USING (
    has_hunting_ground_permission(hunting_ground_user_role.hunting_ground_id, 'hunting_ground.manage_members') OR
    auth.jwt() ->> 'role' = 'service_role'
  );

-- Animals policies
CREATE POLICY "Users can view animal in their hunting grounds"
    ON animal
    FOR SELECT
    USING (
        animal.is_deleted = FALSE AND
        is_hunting_ground_user_role(animal.hunting_ground_id)
    );

CREATE POLICY "Users can manage animal in their hunting grounds"
    ON animal
    FOR ALL
    USING (
        animal.is_deleted = FALSE AND
        is_hunting_ground_user_role(animal.hunting_ground_id)
    );

-- Sightings policies
CREATE POLICY "Users can view sighting in their hunting grounds"
    ON sighting
    FOR SELECT
    USING (
        sighting.is_deleted = FALSE and
        is_hunting_ground_user_role(sighting.hunting_ground_id)
    );

CREATE POLICY "Users can manage sighting for their animal"
    ON sighting
    FOR ALL
    USING (
        sighting.is_deleted = FALSE AND
        EXISTS (
            SELECT 1 FROM hunting_ground_user_role
            JOIN animal ON animal.hunting_ground_id = hunting_ground_user_role.hunting_ground_id
            JOIN sighting_animal ON sighting_animal.animal_id = animal.id
            WHERE sighting_animal.sighting_id = sighting.id
            AND hunting_ground_user_role.user_id = auth.uid()
            AND animal.is_deleted = FALSE
        )
    );

-- Add policy to allow direct access to sightings by hunting_ground_id
CREATE POLICY "Users can access sightings directly by hunting_ground_id"
    ON sighting
    FOR ALL
    USING (
        sighting.is_deleted = FALSE AND
        has_hunting_ground_permission(sighting.hunting_ground_id, 'hunting_ground.read')
    );

-- Weapons policies
CREATE POLICY "Users can manage their own weapon"
    ON weapon
    FOR ALL
    USING (
        user_id = auth.uid()
    );

-- Shooting policies
CREATE POLICY "Users can view shootings they performed"
    ON shooting
    FOR SELECT
    USING (
        shot_by_id = auth.uid()
    );

CREATE POLICY "Users can manage shootings they performed"
    ON shooting
    FOR ALL
    USING (
        shot_by_id = auth.uid()
    );

-- Media policies
CREATE POLICY "Users can view media related to their sighting or shootings"
    ON media
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM sighting_media
            JOIN sighting ON sighting.id = sighting_media.sighting_id
            JOIN sighting_animal ON sighting_animal.sighting_id = sighting.id
            JOIN animal ON animal.id = sighting_animal.animal_id
            WHERE sighting_media.media_id = media.id
            AND is_hunting_ground_user_role(animal.hunting_ground_id)
        )
        OR
        EXISTS (
            SELECT 1 FROM shooting_media
            JOIN shooting ON shooting.id = shooting_media.shooting_id
            WHERE shooting_media.media_id = media.id
            AND shooting.shot_by_id = auth.uid()
        )
    );

-- Camera policies
CREATE POLICY "Users can manage cameras in their hunting grounds"
    ON camera
    FOR ALL
    USING (
       camera.is_deleted = FALSE AND
       is_hunting_ground_user_role(camera.hunting_ground_id)
    );

-- Upload policies
CREATE POLICY "Users can manage their uploads"
    ON upload
    FOR ALL
    USING (
        (upload.is_deleted = FALSE AND 
         (upload.created_by_id = auth.uid() OR upload.created_by_id IS NULL))
        OR
        (upload.is_deleted = FALSE AND
            EXISTS (
                SELECT 1 FROM hunting_ground_user_role
                WHERE hunting_ground_user_role.user_id = auth.uid()
                AND hunting_ground_user_role.role = 'owner'
            )
        )
    );

-- Add a policy for inserting uploads (including anonymous)
CREATE POLICY "Allow new uploads"
    ON upload
    FOR INSERT
    WITH CHECK (true);

-- Tags policies
CREATE POLICY "Users can view tag"
    ON tag
    FOR SELECT
    USING (true);

CREATE POLICY "Users can manage tag they created"
    ON tag
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM animal_tag
            JOIN animal ON animal.id = animal_tag.animal_id
            WHERE animal_tag.tag_id = tag.id
            AND is_hunting_ground_user_role(animal.hunting_ground_id)
        )
    );
    -- Junction tables policies

-- Animal tag junction table policies
CREATE POLICY "Users can manage animal tag for their animal"
    ON animal_tag
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM animal
            WHERE animal.id = animal_tag.animal_id
            AND is_hunting_ground_user_role(animal.hunting_ground_id)
        )
    );

-- Sighting animal junction table policies
CREATE POLICY "Users can manage sighting animal for their sighting"
    ON sighting_animal
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM animal
            WHERE animal.id = sighting_animal.animal_id
            AND animal.is_deleted = FALSE
            AND is_hunting_ground_user_role(animal.hunting_ground_id)
        )
    );

-- Sighting tag junction table policies
CREATE POLICY "Users can manage sighting tag for their sighting"
    ON sighting_tag
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM sighting
            JOIN sighting_animal ON sighting_animal.sighting_id = sighting.id
            JOIN animal ON animal.id = sighting_animal.animal_id
            WHERE sighting_tag.sighting_id = sighting.id
            AND is_hunting_ground_user_role(animal.hunting_ground_id)
        )
    );

-- Sighting media junction table policies
CREATE POLICY "Users can manage sighting media for their sighting"
    ON sighting_media
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM sighting
            JOIN sighting_animal ON sighting_animal.sighting_id = sighting.id
            JOIN animal ON animal.id = sighting_animal.animal_id
            WHERE sighting_media.sighting_id = sighting.id
            AND is_hunting_ground_user_role(animal.hunting_ground_id)
        )
    );

-- Shooting media junction table policies
CREATE POLICY "Users can manage shooting media for their shootings"
    ON shooting_media
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM shooting
            WHERE shooting_media.shooting_id = shooting.id
            AND shooting.shot_by_id = auth.uid()
        )
    );

-- Read-only policies for users and full access for admins on specified tables
-- Country table policies
CREATE POLICY "Users can read country data" ON country
  FOR SELECT USING (true);

CREATE POLICY "Admins can insert country data" ON country
  FOR INSERT WITH CHECK (auth.jwt() ->> 'role' = 'service_role' OR is_admin());

CREATE POLICY "Admins can update country data" ON country
  FOR UPDATE USING (auth.jwt() ->> 'role' = 'service_role' OR is_admin())
  WITH CHECK (auth.jwt() ->> 'role' = 'service_role' OR is_admin());

CREATE POLICY "Admins can delete country data" ON country
  FOR DELETE USING (auth.jwt() ->> 'role' = 'service_role' OR is_admin());

-- Federal state table policies
CREATE POLICY "Users can read federal_state data" ON federal_state
  FOR SELECT USING (true);

CREATE POLICY "Admins can insert federal_state data" ON federal_state
  FOR INSERT WITH CHECK (auth.jwt() ->> 'role' = 'service_role' OR is_admin());

CREATE POLICY "Admins can update federal_state data" ON federal_state
  FOR UPDATE USING (auth.jwt() ->> 'role' = 'service_role' OR is_admin())
  WITH CHECK (auth.jwt() ->> 'role' = 'service_role' OR is_admin());

CREATE POLICY "Admins can delete federal_state data" ON federal_state
  FOR DELETE USING (auth.jwt() ->> 'role' = 'service_role' OR is_admin());

-- Species table policies
CREATE POLICY "Users can read species data" ON species
  FOR SELECT USING (true);

CREATE POLICY "Admins can insert species data" ON species
  FOR INSERT WITH CHECK (auth.jwt() ->> 'role' = 'service_role' OR is_admin());

CREATE POLICY "Admins can update species data" ON species
  FOR UPDATE USING (auth.jwt() ->> 'role' = 'service_role' OR is_admin())
  WITH CHECK (auth.jwt() ->> 'role' = 'service_role' OR is_admin());

CREATE POLICY "Admins can delete species data" ON species
  FOR DELETE USING (auth.jwt() ->> 'role' = 'service_role' OR is_admin());

-- Hunting season table policies
CREATE POLICY "Users can read hunting_season data" ON hunting_season
  FOR SELECT USING (true);

CREATE POLICY "Admins can insert hunting_season data" ON hunting_season
  FOR INSERT WITH CHECK (auth.jwt() ->> 'role' = 'service_role' OR is_admin());

CREATE POLICY "Admins can update hunting_season data" ON hunting_season
  FOR UPDATE USING (auth.jwt() ->> 'role' = 'service_role' OR is_admin())
  WITH CHECK (auth.jwt() ->> 'role' = 'service_role' OR is_admin());

CREATE POLICY "Admins can delete hunting_season data" ON hunting_season
  FOR DELETE USING (auth.jwt() ->> 'role' = 'service_role' OR is_admin());

-- Allowed caliber table policies
CREATE POLICY "Users can read allowed_caliber data" ON allowed_caliber
  FOR SELECT USING (true);

CREATE POLICY "Admins can insert allowed_caliber data" ON allowed_caliber
  FOR INSERT WITH CHECK (auth.jwt() ->> 'role' = 'service_role' OR is_admin());

CREATE POLICY "Admins can update allowed_caliber data" ON allowed_caliber
  FOR UPDATE USING (auth.jwt() ->> 'role' = 'service_role' OR is_admin())
  WITH CHECK (auth.jwt() ->> 'role' = 'service_role' OR is_admin());

CREATE POLICY "Admins can delete allowed_caliber data" ON allowed_caliber
  FOR DELETE USING (auth.jwt() ->> 'role' = 'service_role' OR is_admin());

-- Policies for hunting ground data retrieval functions
CREATE POLICY "Users can access hunting ground data functions"
  ON hunting_ground
  FOR SELECT
  USING (
    has_hunting_ground_permission(hunting_ground.id, 'hunting_ground.read') OR
    auth.jwt() ->> 'role' = 'service_role' OR
    is_admin()
  );

-- Add policies for executing the functions
DO $$
BEGIN
  -- Grant execute permissions on the functions
  EXECUTE format('GRANT EXECUTE ON FUNCTION get_hunting_ground_animals(UUID) TO authenticated');
  EXECUTE format('GRANT EXECUTE ON FUNCTION get_hunting_ground_animal_filters(UUID) TO authenticated');
  EXECUTE format('GRANT EXECUTE ON FUNCTION get_hunting_ground_cameras(UUID) TO authenticated');
  EXECUTE format('GRANT EXECUTE ON FUNCTION get_hunting_ground_sightings(UUID) TO authenticated');
  EXECUTE format('GRANT EXECUTE ON FUNCTION get_hunting_ground_uploads(UUID) TO authenticated');
  EXECUTE format('GRANT EXECUTE ON FUNCTION get_hunting_ground_data(UUID) TO authenticated');
END
$$;
