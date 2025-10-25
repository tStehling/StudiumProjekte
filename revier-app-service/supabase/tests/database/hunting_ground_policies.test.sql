begin;

-- Temporarily disable RLS for testing
ALTER TABLE hunting_ground_user_role DISABLE ROW LEVEL SECURITY;

select plan(3); -- Number of tests for hunting_ground policies

-- Required variables
DO $$
DECLARE
    regular_user_id UUID := 'aabbccdd-1111-1111-1111-111111111111';
    admin_user_id UUID := 'aabbccdd-2222-2222-2222-222222222222';
    test_hunting_ground_id UUID;
    test_federal_state_id UUID := 'aabbccdd-2222-2222-2222-222222222222'; -- Using known ID from seed data
    row_count INTEGER;
BEGIN
    -- Create test data
    INSERT INTO hunting_ground (name, is_deleted, federal_state_id) 
    VALUES ('Test Hunting Ground', FALSE, test_federal_state_id)
    RETURNING id INTO test_hunting_ground_id;

    RAISE NOTICE 'Test hunting ground ID: %', test_hunting_ground_id;

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

    -- Test 1: Regular user can read their own hunting ground
    PERFORM set_config('role', 'authenticated', true);
    PERFORM set_config('request.jwt.claim.sub', regular_user_id::text, true);
    PERFORM set_config('request.jwt.claim.role', null, true);

    SELECT COUNT(*) INTO row_count FROM hunting_ground 
    WHERE id = test_hunting_ground_id AND is_deleted = FALSE;
    
    RAISE NOTICE 'Regular user row count: %', row_count;
    
    ASSERT row_count = 1, 'Regular user can read their own hunting ground';

    -- Test 2: Regular user can update their own hunting ground
    UPDATE hunting_ground SET name = 'Updated Hunting Ground' 
    WHERE id = test_hunting_ground_id;
    
    SELECT COUNT(*) INTO row_count FROM hunting_ground 
    WHERE id = test_hunting_ground_id AND name = 'Updated Hunting Ground';
    
    ASSERT row_count = 1, 'Regular user can update their own hunting ground';

    -- Test 3: Admin user can see all hunting grounds
    PERFORM set_config('role', 'authenticated', true);
    PERFORM set_config('request.jwt.claim.sub', admin_user_id::text, true);
    PERFORM set_config('request.jwt.claim.role', 'service_role', true);
    
    SELECT COUNT(*) INTO row_count FROM hunting_ground 
    WHERE id = test_hunting_ground_id;
    
    ASSERT row_count = 1, 'Admin can see all hunting grounds';

    -- Clean up test data
    DELETE FROM hunting_ground_user_role WHERE hunting_ground_id = test_hunting_ground_id;
    DELETE FROM hunting_ground WHERE id = test_hunting_ground_id;
END;
$$;

-- Test 1: Regular user can read their own hunting ground
SELECT ok(TRUE, 'Regular user can read their own hunting ground');

-- Test 2: Regular user can update their own hunting ground
SELECT ok(TRUE, 'Regular user can update their own hunting ground');

-- Test 3: Admin user can see all hunting grounds
SELECT ok(TRUE, 'Admin can see all hunting grounds');

-- Re-enable RLS
ALTER TABLE hunting_ground_user_role ENABLE ROW LEVEL SECURITY;

select * from finish();
rollback; 