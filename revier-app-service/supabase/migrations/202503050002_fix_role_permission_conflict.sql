-- Fix for role permission conflict between migrations and seed
-- This migration ensures that the seed.sql file can run without conflicts

-- First, make sure the hunting_ground_role_permission table has the correct constraints
DO $$
BEGIN
    -- Check if the unique constraint exists
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conname = 'hunting_ground_role_permission_role_permission_key'
    ) THEN
        -- Add the constraint if it doesn't exist
        ALTER TABLE hunting_ground_role_permission 
        ADD CONSTRAINT hunting_ground_role_permission_role_permission_key 
        UNIQUE (role, permission);
    END IF;
END;
$$;

-- Update the seed data to use ON CONFLICT (role, permission) instead of ON CONFLICT (id)
-- This is handled in the seed.sql file directly

-- Make sure all required permissions exist
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