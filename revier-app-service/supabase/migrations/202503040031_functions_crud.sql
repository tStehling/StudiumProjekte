-- CREATE
--------------------------------
CREATE OR REPLACE FUNCTION on_created_update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW."created_at" := CURRENT_TIMESTAMP;
  NEW."updated_at" := CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION on_created_update_created_by_id()
RETURNS TRIGGER AS $$
BEGIN
  NEW."created_by_id" := auth.uid();
  NEW."updated_by_id" := auth.uid();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply the updated_at trigger to all tables with updated_at column
DO $$
DECLARE
    t text;
BEGIN
    FOR t IN 
        SELECT table_name 
        FROM information_schema.columns 
        WHERE column_name = 'created_at' 
        AND table_schema = 'public'
    LOOP
        EXECUTE format('
            CREATE TRIGGER set_created_at
            BEFORE INSERT ON %I
            FOR EACH ROW
            EXECUTE FUNCTION on_created_update_timestamp();
        ', t);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

DO $$
DECLARE
    t text;
BEGIN
    FOR t IN 
        SELECT table_name 
        FROM information_schema.columns 
        WHERE column_name = 'created_by_id' 
        AND table_schema = 'public'
    LOOP
        EXECUTE format('
            CREATE TRIGGER set_created_by_id
            BEFORE INSERT ON %I
            FOR EACH ROW
            EXECUTE FUNCTION on_created_update_created_by_id();
        ', t);
    END LOOP;
END;
$$ LANGUAGE plpgsql;
--------------------------------

-- UPDATE
--------------------------------
-- Function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION on_updated_update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW."updated_at" := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION on_updated_update_updated_by_id()
RETURNS TRIGGER AS $$
BEGIN
    NEW."updated_by_id" := auth.uid();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply the updated_at trigger to all tables with updated_at column
DO $$
DECLARE
    t text;
BEGIN
    FOR t IN 
        SELECT table_name 
        FROM information_schema.columns 
        WHERE column_name = 'updated_at' 
        AND table_schema = 'public'
    LOOP
        EXECUTE format('
            CREATE TRIGGER set_updated_at
            BEFORE UPDATE ON %I
            FOR EACH ROW
            EXECUTE FUNCTION on_updated_update_timestamp();
        ', t);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

DO $$
DECLARE
    t text;
BEGIN
    FOR t IN 
        SELECT table_name 
        FROM information_schema.columns 
        WHERE column_name = 'updated_by_id' 
        AND table_schema = 'public'
    LOOP
        EXECUTE format('
            CREATE TRIGGER set_updated_by_id
            BEFORE UPDATE ON %I
            FOR EACH ROW
            EXECUTE FUNCTION on_updated_update_updated_by_id();
        ', t);
    END LOOP;
END;
$$ LANGUAGE plpgsql;
--------------------------------

-- DELETE
--------------------------------
CREATE OR REPLACE FUNCTION on_deleted_update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW."deleted_at" := CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION on_deleted_update_deleted_by_id()
RETURNS TRIGGER AS $$
BEGIN
    NEW."deleted_by_id" := auth.uid();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply the deleted_at trigger to all tables with deleted_at column
DO $$
DECLARE
    t text;
BEGIN
    FOR t IN 
        SELECT table_name 
        FROM information_schema.columns 
        WHERE column_name = 'deleted_at' 
        AND table_schema = 'public'
    LOOP
        EXECUTE format('
            CREATE TRIGGER set_deleted_at
            BEFORE DELETE ON %I
            FOR EACH ROW
            EXECUTE FUNCTION on_deleted_update_timestamp();
        ', t);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

DO $$
DECLARE
    t text;
BEGIN
    FOR t IN 
        SELECT table_name 
        FROM information_schema.columns 
        WHERE column_name = 'deleted_by_id' 
        AND table_schema = 'public'
    LOOP
        EXECUTE format('
            CREATE TRIGGER set_deleted_by_id
            BEFORE DELETE ON %I
            FOR EACH ROW
            EXECUTE FUNCTION on_deleted_update_deleted_by_id();
        ', t);
    END LOOP;
END;
$$ LANGUAGE plpgsql;
--------------------------------
-- -- Add a function to automatically set created_by_id and updated_by_id fields
-- CREATE OR REPLACE FUNCTION set_user_tracking_fields()
-- RETURNS TRIGGER AS $$
-- BEGIN
--     IF TG_OP = 'INSERT' THEN
--         NEW.created_by_id = auth.uid();
--         NEW.updated_by_id = auth.uid();
--     ELSIF TG_OP = 'UPDATE' THEN
--         NEW.updated_by_id = auth.uid();
--         IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
--             NEW.deleted_by_id = auth.uid();
--         END IF;
--     END IF;
--     RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;

-- Function to delete a record from any table by ID
CREATE OR REPLACE FUNCTION delete_record(p_table_name text, p_id uuid)
RETURNS void AS $$
DECLARE
  dynamic_query text;
BEGIN
  -- Input validation
  IF p_table_name IS NULL OR p_id IS NULL THEN
    RAISE EXCEPTION 'Table name and ID are required';
  END IF;
  
  -- Create the dynamic query with proper quoting to prevent SQL injection
  dynamic_query := format('DELETE FROM %I WHERE id = %L', p_table_name, p_id);
  
  -- Execute the query
  EXECUTE dynamic_query;
  
  -- Log the operation
  RAISE NOTICE 'Deleted record with ID % from table %', p_id, p_table_name;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission to authenticated users and anon
GRANT EXECUTE ON FUNCTION delete_record(text, uuid) TO authenticated;
-- GRANT EXECUTE ON FUNCTION delete_record(text, uuid) TO anon;

-- Comment function
COMMENT ON FUNCTION delete_record IS 'Generic function to delete a record from any table by ID. Used as fallback when standard delete operations fail.';

-- Grant execute permissions
GRANT EXECUTE ON FUNCTION public.has_hunting_ground_permission(UUID, TEXT) TO authenticated; 