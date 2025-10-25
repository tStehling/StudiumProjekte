-- Migration to add RLS policies for the animal table
-- This ensures users can only access animals for hunting grounds they have permission to read

-- First enable RLS on the animal table if not already enabled
ALTER TABLE animal ENABLE ROW LEVEL SECURITY;

-- Add policy for users to read animals in hunting grounds they have read access to
CREATE POLICY "Users can read animals in accessible hunting grounds"
  ON animal
  FOR SELECT
  USING (
    -- Check if user has hunting_ground.read permission for this animal's hunting ground
    has_hunting_ground_permission(animal.hunting_ground_id, 'hunting_ground.read')
  );

-- Add policy for users to insert animals in hunting grounds they have create access to
CREATE POLICY "Users can insert animals in accessible hunting grounds"
  ON animal
  FOR INSERT
  WITH CHECK (
    -- Check if user has hunting_ground.create permission for this animal's hunting ground
    has_hunting_ground_permission(animal.hunting_ground_id, 'hunting_ground.create')
  );

-- Add policy for users to update animals in hunting grounds they have update access to
CREATE POLICY "Users can update animals in accessible hunting grounds"
  ON animal
  FOR UPDATE
  USING (
    -- Check if user has hunting_ground.update permission for this animal's hunting ground
    has_hunting_ground_permission(animal.hunting_ground_id, 'hunting_ground.update')
  )
  WITH CHECK (
    -- Check if user has hunting_ground.update permission for this animal's hunting ground
    has_hunting_ground_permission(animal.hunting_ground_id, 'hunting_ground.update')
  );

-- Add policy for users to delete animals in hunting grounds they have delete access to
CREATE POLICY "Users can delete animals in accessible hunting grounds"
  ON animal
  FOR DELETE
  USING (
    -- Check if user has hunting_ground.delete permission for this animal's hunting ground
    has_hunting_ground_permission(animal.hunting_ground_id, 'hunting_ground.delete')
  );

-- Add policy for admins to have full access to all animal records
CREATE POLICY "Admins have full access to all animals"
  ON animal
  FOR ALL
  USING (
    auth.jwt() ->> 'role' = 'service_role' OR 
    is_admin()
  ); 