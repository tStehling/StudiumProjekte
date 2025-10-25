begin;
select plan(4); -- Number of tests for junction tables (reduced from 5)

-- Test sighting_animal relationship
SELECT ok(
    NOT EXISTS (
        SELECT 1 FROM sighting_animal sa
        LEFT JOIN sighting s ON sa.sighting_id = s.id
        LEFT JOIN animal a ON sa.animal_id = a.id
        WHERE (s.id IS NULL OR a.id IS NULL)
    ),
    'All sighting_animal entries have valid references'
);

-- Test sighting_tag relationship
SELECT ok(
    NOT EXISTS (
        SELECT 1 FROM sighting_tag st
        LEFT JOIN sighting s ON st.sighting_id = s.id
        LEFT JOIN tag t ON st.tag_id = t.id
        WHERE (s.id IS NULL OR t.id IS NULL)
    ),
    'All sighting_tag entries have valid references'
);

-- Test sighting_media relationship
SELECT ok(
    NOT EXISTS (
        SELECT 1 FROM sighting_media sm
        LEFT JOIN sighting s ON sm.sighting_id = s.id
        LEFT JOIN media m ON sm.media_id = m.id
        WHERE (s.id IS NULL OR m.id IS NULL)
    ),
    'All sighting_media entries have valid references'
);

-- Test upload_media relationship
SELECT ok(
    NOT EXISTS (
        SELECT 1 FROM upload_media um
        LEFT JOIN upload u ON um.upload_id = u.id
        LEFT JOIN media m ON um.media_id = m.id
        WHERE (u.id IS NULL OR m.id IS NULL)
    ),
    'All upload_media entries have valid references'
);

select * from finish();
rollback; 