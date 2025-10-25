-- Fix for Upload soft delete
-- This migration adds a specific policy to allow updating uploads to be marked as deleted
-- The current policy only allows operations when is_deleted = FALSE which prevents marking as deleted

-- First drop the existing policy
DROP POLICY IF EXISTS "Users can manage their uploads" ON upload;

-- Create an updated policy that allows both normal operations and soft delete
CREATE POLICY "Users can manage their uploads"
    ON upload
    FOR ALL
    USING (
        -- Normal operations on non-deleted records
        (upload.is_deleted = FALSE AND 
         (upload.created_by_id = auth.uid() OR upload.created_by_id IS NULL))
        OR
        -- Admins can manage non-deleted records 
        (upload.is_deleted = FALSE AND
            EXISTS (
                SELECT 1 FROM hunting_ground_user_role
                WHERE hunting_ground_user_role.user_id = auth.uid()
                AND hunting_ground_user_role.role = 'owner'
            )
        )
        OR
        -- Allow soft delete operations (specifically for updating is_deleted to TRUE)
        (upload.is_deleted = FALSE AND 
         (upload.created_by_id = auth.uid() OR upload.created_by_id IS NULL) AND
         (coalesce(current_setting('request.method', true), '') = 'PATCH' OR 
          coalesce(current_setting('request.method', true), '') = 'PUT'))
    );

-- Add a separate policy specifically for updating uploads to be soft deleted
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

-- Add trigger function to sync soft delete fields if not already
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger 
        WHERE tgname = 'sync_upload_deleted_at_and_is_deleted_trigger'
    ) THEN
        CREATE TRIGGER sync_upload_deleted_at_and_is_deleted_trigger
        BEFORE UPDATE ON upload
        FOR EACH ROW
        EXECUTE FUNCTION sync_upload_deleted_at_and_is_deleted();
    END IF;
END
$$; 