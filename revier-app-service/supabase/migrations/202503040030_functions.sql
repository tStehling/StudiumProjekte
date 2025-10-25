-- Enable Row Level Security on all tables
CREATE OR REPLACE FUNCTION enable_rls_on_all()
RETURNS VOID AS $$
DECLARE
    t record;
BEGIN
    -- Enable RLS on all tables in the 'public' schema except the schema_migrations table
    FOR t IN 
        SELECT tablename 
        FROM pg_tables 
        WHERE schemaname = 'public'
        AND tablename NOT IN ('schema_migrations')
    LOOP
        EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY;', t.tablename);
    END LOOP;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to check if a user is a member of a hunting ground with a specific role
CREATE OR REPLACE FUNCTION is_hunting_ground_user_role(hunting_ground_id UUID, user_role TEXT DEFAULT NULL)
RETURNS BOOLEAN AS $$
DECLARE
    is_member BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1
        FROM hunting_ground_user_role
        WHERE hunting_ground_user_role.hunting_ground_id = $1
        AND hunting_ground_user_role.user_id = auth.uid()
        AND (user_role IS NULL OR hunting_ground_user_role.role = user_role::hunting_ground_role)
    ) INTO is_member;
    
    RETURN is_member;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to check if the current user is an admin
CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN AS $$
BEGIN
    -- Check if the user has service_role JWT or is marked as admin in auth.users
    RETURN auth.jwt() ->> 'role' = 'service_role' OR
           EXISTS (
               SELECT 1 
               FROM auth.users
               WHERE id = auth.uid()
               AND is_admin = TRUE
           );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to check if a user has a specific permission for a hunting ground
CREATE OR REPLACE FUNCTION has_hunting_ground_permission(p_hunting_ground_id UUID, p_permission TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    -- Admin users have all permissions
    IF is_admin() THEN
        RETURN TRUE;
    END IF;
    
    -- Check if the user has the required permission
    RETURN EXISTS (
        SELECT 1
        FROM hunting_ground_user_role hgur
        JOIN hunting_ground_role_permission hgrp ON hgur.role = hgrp.role
        WHERE hgur.hunting_ground_id = p_hunting_ground_id
        AND hgur.user_id = auth.uid()
        AND hgrp.permission = p_permission::hunting_ground_permission
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;