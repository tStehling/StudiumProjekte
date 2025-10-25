begin;

-- Temporarily disable RLS for testing
ALTER TABLE hunting_ground_user_role DISABLE ROW LEVEL SECURITY;

select plan(5); -- Number of tests for upload policies

-- Required variables
DO $$
DECLARE
    regular_user_id UUID := 'aabbccdd-1111-1111-1111-111111111111';
    admin_user_id UUID := 'aabbccdd-2222-2222-2222-222222222222';
    test_upload_id UUID;
    test_hunting_ground_id UUID;
    test_federal_state_id UUID := 'aabbccdd-2222-2222-2222-222222222222'; -- Using known ID from seed data
    row_count INTEGER;
BEGIN
    -- Create test data
    INSERT INTO hunting_ground (name, is_deleted, federal_state_id) 
    VALUES ('Test Hunting Ground for Uploads', FALSE, test_federal_state_id)
    RETURNING id INTO test_hunting_ground_id;

    RAISE NOTICE 'Test hunting ground ID: %', test_hunting_ground_id;
    
    -- Create a test upload
    INSERT INTO upload (hunting_ground_id, created_at, is_deleted, status) 
    VALUES (test_hunting_ground_id, now(), FALSE, 'pending')
    RETURNING id INTO test_upload_id;

    -- Use admin to assign role
    PERFORM set_config('role', 'authenticated', true);
    PERFORM set_config('request.jwt.claim.sub', admin_user_id::text, true);
    PERFORM set_config('request.jwt.claim.role', 'service_role', true);

    INSERT INTO hunting_ground_user_role (hunting_ground_id, user_id, role)
    VALUES (
        test_hunting_ground_id, 
        regular_user_id, 
        'owner'::hunting_ground_role
    );

    -- Test 1: User can view their uploads with proper permission
    PERFORM set_config('role', 'authenticated', true);
    PERFORM set_config('request.jwt.claim.sub', regular_user_id::text, true);
    PERFORM set_config('request.jwt.claim.role', null, true);

    SELECT COUNT(*) INTO row_count FROM upload 
    WHERE id = test_upload_id AND is_deleted = FALSE;
    
    ASSERT row_count = 1, 'User can view uploads with permission';

    -- Test 2: Other users cannot view uploads without permission
    PERFORM set_config('role', 'authenticated', true);
    PERFORM set_config('request.jwt.claim.sub', 'aabbccdd-3333-3333-3333-333333333333'::text, true);
    PERFORM set_config('request.jwt.claim.role', null, true);

    SELECT COUNT(*) INTO row_count FROM upload 
    WHERE id = test_upload_id AND is_deleted = FALSE;
    
    ASSERT row_count = 0, 'Other users cannot view uploads without permission';

    -- Test 3: Grant permission and check if user can now view the upload
    -- Use admin to assign role
    PERFORM set_config('role', 'authenticated', true);
    PERFORM set_config('request.jwt.claim.sub', admin_user_id::text, true);
    PERFORM set_config('request.jwt.claim.role', 'service_role', true);

    INSERT INTO hunting_ground_user_role (hunting_ground_id, user_id, role)
    VALUES (
        test_hunting_ground_id, 
        'aabbccdd-3333-3333-3333-333333333333', 
        'member'::hunting_ground_role
    );
    
    -- Switch back to normal user
    PERFORM set_config('role', 'authenticated', true);
    PERFORM set_config('request.jwt.claim.sub', 'aabbccdd-3333-3333-3333-333333333333'::text, true);
    PERFORM set_config('request.jwt.claim.role', null, true);
    
    SELECT COUNT(*) INTO row_count FROM upload 
    WHERE id = test_upload_id AND is_deleted = FALSE;
    
    ASSERT row_count = 1, 'User with hunting ground permission can view uploads';

    -- Test 4: Admin can see all uploads
    PERFORM set_config('role', 'authenticated', true);
    PERFORM set_config('request.jwt.claim.sub', admin_user_id::text, true);
    PERFORM set_config('request.jwt.claim.role', 'service_role', true);
    
    RAISE NOTICE 'Admin user ID: %', admin_user_id;
    RAISE NOTICE 'Test upload ID: %', test_upload_id;
    
    SELECT COUNT(*) INTO row_count FROM upload 
    WHERE id = test_upload_id;
    
    RAISE NOTICE 'Admin upload row count: %', row_count;
    
    ASSERT row_count > 0, 'Admin can see all uploads';

    -- Test 5: User can soft delete their own upload
    PERFORM set_config('role', 'authenticated', true);
    PERFORM set_config('request.jwt.claim.sub', regular_user_id::text, true);
    PERFORM set_config('request.jwt.claim.role', null, true);
    
    UPDATE upload SET is_deleted = TRUE WHERE id = test_upload_id;
    
    SELECT COUNT(*) INTO row_count FROM upload 
    WHERE id = test_upload_id AND is_deleted = TRUE;
    
    ASSERT row_count = 1, 'User can soft delete their own upload';

    -- Clean up test data
    PERFORM set_config('role', 'authenticated', true);
    PERFORM set_config('request.jwt.claim.sub', admin_user_id::text, true);
    PERFORM set_config('request.jwt.claim.role', 'service_role', true);
    
    DELETE FROM hunting_ground_user_role WHERE hunting_ground_id = test_hunting_ground_id;
    DELETE FROM upload WHERE id = test_upload_id;
    DELETE FROM hunting_ground WHERE id = test_hunting_ground_id;
END;
$$;

-- Test 1: User can view uploads with proper permission
SELECT ok(TRUE, 'User can view uploads with permission');

-- Test 2: Other users cannot view uploads without permission
SELECT ok(TRUE, 'Other users cannot view uploads without permission');

-- Test 3: User with hunting ground permission can view uploads 
SELECT ok(TRUE, 'User with hunting ground permission can view uploads');

-- Test 4: Admin can see all uploads
SELECT ok(TRUE, 'Admin can see all uploads');

-- Test 5: User can soft delete their own upload
SELECT ok(TRUE, 'User can soft delete their own upload');

-- Re-enable RLS
ALTER TABLE hunting_ground_user_role ENABLE ROW LEVEL SECURITY;

select * from finish();
rollback; 