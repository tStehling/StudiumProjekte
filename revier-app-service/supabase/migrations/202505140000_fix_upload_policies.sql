-- Fix for upload policies to ensure admin can see uploads
-- Created on 2025-05-14

-- Drop existing upload policies
DROP POLICY IF EXISTS "Users can manage their uploads" ON upload;
DROP POLICY IF EXISTS "Allow new uploads" ON upload;
DROP POLICY IF EXISTS "Allow soft delete of uploads" ON upload;
DROP POLICY IF EXISTS "Users can view their own uploads" ON upload;
DROP POLICY IF EXISTS "Users can view uploads from hunting grounds with permission" ON upload;
DROP POLICY IF EXISTS "Users can manage uploads they created" ON upload;
DROP POLICY IF EXISTS "Users can manage uploads from hunting grounds with permission" ON upload;
DROP POLICY IF EXISTS "Admins can manage all uploads" ON upload;

-- Recreate upload policies with proper admin access
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

-- Specific admin policy with priority for admins
CREATE POLICY "Admins can view all uploads"
  ON upload
  FOR SELECT
  USING (
    auth.jwt() ->> 'role' = 'service_role' OR 
    is_admin()
  );

CREATE POLICY "Admins can manage all uploads"
  ON upload
  FOR ALL
  USING (
    auth.jwt() ->> 'role' = 'service_role' OR 
    is_admin()
  ); 