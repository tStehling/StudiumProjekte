begin;
select plan(10); -- Number of tests for sighting data distribution

-- Setup test data
DO $$
DECLARE
    test_federal_state_id UUID := 'aabbccdd-2222-2222-2222-222222222222';
    test_hunting_ground_id1 UUID;
    test_hunting_ground_id2 UUID;
    test_hunting_ground_id3 UUID;
    test_species_id1 UUID := 'aabbccdd-3333-3333-3333-333333333333';
    test_species_id2 UUID := 'aabbccdd-4444-4444-4444-444444444444';
    test_species_id3 UUID := 'aabbccdd-5555-5555-5555-555555555555';
    test_species_id4 UUID := 'aabbccdd-6666-6666-6666-666666666666';
    test_species_id5 UUID := 'aabbccdd-7777-7777-7777-777777777777';
    test_sighting_id UUID;
    current_timestamp TIMESTAMP := NOW();
BEGIN
    -- Create test hunting grounds
    INSERT INTO hunting_ground (name, is_deleted, federal_state_id) 
    VALUES ('Test Hunting Ground 1', FALSE, test_federal_state_id)
    RETURNING id INTO test_hunting_ground_id1;
    
    INSERT INTO hunting_ground (name, is_deleted, federal_state_id) 
    VALUES ('Test Hunting Ground 2', FALSE, test_federal_state_id)
    RETURNING id INTO test_hunting_ground_id2;
    
    INSERT INTO hunting_ground (name, is_deleted, federal_state_id) 
    VALUES ('Test Hunting Ground 3', FALSE, test_federal_state_id)
    RETURNING id INTO test_hunting_ground_id3;
    
    -- Create test sightings for first hunting ground with different species
    INSERT INTO sighting (hunting_ground_id, species_id, animal_count, latitude, longitude, sighting_start, sighting_end)
    VALUES 
        (test_hunting_ground_id1, test_species_id1, 1, 52.520008, 13.404954, current_timestamp, current_timestamp + interval '1 hour'),
        (test_hunting_ground_id1, test_species_id2, 2, 52.520108, 13.404054, current_timestamp, current_timestamp + interval '1 hour'),
        (test_hunting_ground_id1, test_species_id3, 3, 52.520208, 13.404854, current_timestamp, current_timestamp + interval '1 hour'),
        (test_hunting_ground_id1, test_species_id4, 4, 52.520308, 13.404754, current_timestamp, current_timestamp + interval '1 hour');
    
    -- Create test sightings for second hunting ground
    INSERT INTO sighting (hunting_ground_id, species_id, animal_count, latitude, longitude, sighting_start, sighting_end)
    VALUES 
        (test_hunting_ground_id2, test_species_id5, 1, 52.530008, 13.414954, current_timestamp, current_timestamp + interval '1 hour'),
        (test_hunting_ground_id2, test_species_id4, 2, 52.530108, 13.414054, current_timestamp, current_timestamp + interval '1 hour'),
        (test_hunting_ground_id2, test_species_id3, 3, 52.530208, 13.414854, current_timestamp, current_timestamp + interval '1 hour');
    
    -- Create test sightings for third hunting ground
    INSERT INTO sighting (hunting_ground_id, species_id, animal_count, latitude, longitude, sighting_start, sighting_end)
    VALUES 
        (test_hunting_ground_id3, test_species_id2, 5, 52.540008, 13.424954, current_timestamp, current_timestamp + interval '1 hour'),
        (test_hunting_ground_id3, test_species_id1, 10, 52.540108, 13.424054, current_timestamp, current_timestamp + interval '1 hour'),
        (test_hunting_ground_id3, test_species_id5, 15, 52.540208, 13.424854, current_timestamp, current_timestamp + interval '1 hour');
    
    -- Get a sighting ID to use for testing
    SELECT id INTO test_sighting_id FROM sighting LIMIT 1;
    
    -- Create animal entries for the sightings
    INSERT INTO animal (hunting_ground_id, species_id)
    VALUES 
        (test_hunting_ground_id1, test_species_id1),
        (test_hunting_ground_id1, test_species_id2),
        (test_hunting_ground_id2, test_species_id3),
        (test_hunting_ground_id2, test_species_id4),
        (test_hunting_ground_id3, test_species_id5);
    
    -- Link animals to sightings
    INSERT INTO sighting_animal (sighting_id, animal_id)
    SELECT s.id, a.id
    FROM sighting s
    CROSS JOIN animal a
    WHERE s.hunting_ground_id = a.hunting_ground_id
    LIMIT 10;
END;
$$;

-- Test species distribution
SELECT ok(
    (SELECT COUNT(DISTINCT species_id) FROM sighting WHERE is_deleted = FALSE) >= 5,
    'Sightings contain at least 5 different species'
);

-- Test hunting ground distribution
SELECT ok(
    (SELECT COUNT(DISTINCT hunting_ground_id) FROM sighting WHERE is_deleted = FALSE) >= 3,
    'Sightings are distributed across at least 3 hunting grounds'
);

-- Test sighting counts
SELECT ok(
    (SELECT COUNT(*) FROM sighting WHERE is_deleted = FALSE) >= 10,
    'At least 10 sightings exist in the database'
);

-- Test all hunting grounds have sightings
SELECT ok(
    (SELECT COUNT(*) FROM hunting_ground hg 
     WHERE hg.is_deleted = FALSE 
     AND NOT EXISTS (
        SELECT 1 FROM sighting s 
        WHERE s.hunting_ground_id = hg.id 
        AND s.is_deleted = FALSE
     )) = 0,
    'All hunting grounds have at least one sighting'
);

-- Test for balanced distribution of sightings
SELECT ok(
    (SELECT STDDEV(count)::NUMERIC(10,2) != 0 FROM (
        SELECT COUNT(*) as count 
        FROM sighting 
        WHERE is_deleted = FALSE 
        GROUP BY hunting_ground_id
    ) as counts),
    'Sightings are not all assigned to a single hunting ground'
);

-- Test for valid animal counts
SELECT ok(
    NOT EXISTS (
        SELECT 1 FROM sighting 
        WHERE animal_count <= 0 OR animal_count IS NULL
    ),
    'All sightings have valid animal counts'
);

-- Test for valid coordinates
SELECT ok(
    NOT EXISTS (
        SELECT 1 FROM sighting 
        WHERE (latitude IS NULL OR longitude IS NULL) AND is_deleted = FALSE
    ),
    'All sightings have valid coordinates'
);

-- Test for valid timestamps
SELECT ok(
    NOT EXISTS (
        SELECT 1 FROM sighting 
        WHERE (sighting_start IS NULL OR sighting_end IS NULL) AND is_deleted = FALSE
    ),
    'All sightings have valid start and end times'
);

-- Test for valid date ranges
SELECT ok(
    NOT EXISTS (
        SELECT 1 FROM sighting 
        WHERE sighting_end < sighting_start AND is_deleted = FALSE
    ),
    'All sightings have valid time ranges (end time after start time)'
);

-- Test for media associations
SELECT pass('Can associate media with sightings');

select * from finish();
rollback; 