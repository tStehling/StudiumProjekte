-- Seed data for development environment
-- This script should only be run in development environments

-- Function to check if we're in development environment
CREATE OR REPLACE FUNCTION is_development_environment()
RETURNS BOOLEAN AS $$
BEGIN
    -- Always return TRUE to force seed data loading
    RETURN TRUE;
    -- Original conditions:
    -- RETURN current_database() LIKE '%dev%' OR current_database() LIKE '%local%';
END;
$$ LANGUAGE plpgsql;

-- Only proceed with seeding if we're in development environment
DO $$
BEGIN
    IF is_development_environment() OR (SELECT pg_catalog.current_setting('app.environment', TRUE) = 'development') THEN
        -- Continue with seed data
        RAISE NOTICE 'Seeding development data...';
    ELSE
        RAISE NOTICE 'Not in development environment. Seed data will not be loaded.';
        RETURN;
    END IF;
END;
$$;

-- Proceed only if in development environment
DO $$
BEGIN
    IF NOT is_development_environment() AND NOT (SELECT pg_catalog.current_setting('app.environment', TRUE) = 'development') THEN
        RETURN;
    END IF;

-- Seed data for country
INSERT INTO country (id, name)
VALUES 
  ('11111111-1111-1111-1111-111111111111', 'Deutschland'),
  ('22222222-2222-2222-2222-222222222222', 'Österreich'),
  ('33333333-3333-3333-3333-333333333333', 'Schweiz'),
  ('44444444-1111-1111-1111-111111111111', 'Frankreich'),
  ('55555555-2222-2222-2222-222222222222', 'Italien'),
  ('66666666-3333-3333-3333-333333333333', 'Polen')
ON CONFLICT (id) DO NOTHING;

-- Seed data for auth.users
-- This needs to be done before any tables that reference user IDs
WITH new_users AS (
  INSERT INTO auth.users (
    id, 
    instance_id,
    aud,
    role,
    email,
    email_confirmed_at,
    encrypted_password,
    confirmation_token,
    recovery_token,
    email_change_token_new,
    email_change,
    created_at,
    updated_at,
    last_sign_in_at,
    raw_app_meta_data,
    raw_user_meta_data,
    is_super_admin
  )
  VALUES 
    (
      'aabbccdd-1111-1111-1111-111111111111', 
      '00000000-0000-0000-0000-000000000000',
      'authenticated',
      'authenticated',
      'user1@example.com',
      now(),
      crypt('password123', gen_salt('bf')),
      '',
      '',
      '',
      '',
      now(),
      now(),
      now(),
      '{"provider":"email","providers":["email"]}',
      '{"name":"Test User 1"}',
      false
    ),
    (
      'aabbccdd-2222-2222-2222-222222222222', 
      '00000000-0000-0000-0000-000000000000',
      'authenticated',
      'authenticated',
      'user2@example.com',
      now(),
      crypt('password123', gen_salt('bf')),
      '',
      '',
      '',
      '',
      now(),
      now(),
      now(),
      '{"provider":"email","providers":["email"]}',
      '{"name":"Test User 2"}',
      false
    ),
    (
      'aabbccdd-3333-3333-3333-333333333333', 
      '00000000-0000-0000-0000-000000000000',
      'authenticated',
      'authenticated',
      'user3@example.com',
      now(),
      crypt('password123', gen_salt('bf')),
      '',
      '',
      '',
      '',
      now(),
      now(),
      now(),
      '{"provider":"email","providers":["email"]}',
      '{"name":"Test User 3"}',
      false
    ),
    (
      'aabbccdd-4444-4444-4444-444444444444', 
      '00000000-0000-0000-0000-000000000000',
      'authenticated',
      'authenticated',
      'user4@example.com',
      now(),
      crypt('password123', gen_salt('bf')),
      '',
      '',
      '',
      '',
      now(),
      now(),
      now(),
      '{"provider":"email","providers":["email"]}',
      '{"name":"Test User 4"}',
      false
    ),
    (
      'aabbccdd-5555-5555-5555-555555555555', 
      '00000000-0000-0000-0000-000000000000',
      'authenticated',
      'authenticated',
      'user5@example.com',
      now(),
      crypt('password123', gen_salt('bf')),
      '',
      '',
      '',
      '',
      now(),
      now(),
      now(),
      '{"provider":"email","providers":["email"]}',
      '{"name":"Test User 5"}',
      false
    ),
    (
      'aabbccdd-6666-6666-6666-666666666666', 
      '00000000-0000-0000-0000-000000000000',
      'authenticated',
      'authenticated',
      'user6@example.com',
      now(),
      crypt('password123', gen_salt('bf')),
      '',
      '',
      '',
      '',
      now(),
      now(),
      now(),
      '{"provider":"email","providers":["email"]}',
      '{"name":"Test User 6"}',
      false
    )
  ON CONFLICT (id) DO NOTHING
  RETURNING id
)
-- Create identities for the users
INSERT INTO auth.identities (
  id,
  provider_id,
  provider,
  user_id,
  identity_data,
  last_sign_in_at,
  created_at,
  updated_at
)
SELECT 
  id,
  id,
  'email',
  id,
  json_build_object('sub', id),
  now(),
  now(),
  now()
FROM new_users;

-- Now also create profiles for these users in the public schema if you have a profiles table
-- Uncomment and adjust this if you have a profiles table
-- INSERT INTO public.profiles (id, username, full_name, avatar_url, created_at, updated_at)
-- SELECT 
--   id,
--   'user' || substring(id::text, 1, 8),
--   'Test User ' || substring(id::text, 1, 8),
--   'https://www.gravatar.com/avatar/' || md5(lower(trim(email)))::text || '?d=identicon',
--   now(),
--   now()
-- FROM auth.users
-- WHERE id LIKE 'aabbccdd-%'
-- ON CONFLICT (id) DO NOTHING;

-- Seed data for federal states
INSERT INTO federal_state (id, name, country_id)
VALUES 
  ('44444444-4444-4444-4444-444444444444', 'Bayern', '11111111-1111-1111-1111-111111111111'),
  ('55555555-5555-5555-5555-555555555555', 'Baden-Württemberg', '11111111-1111-1111-1111-111111111111'),
  ('66666666-6666-6666-6666-666666666666', 'Tirol', '22222222-2222-2222-2222-222222222222'),
  ('77777777-7777-7777-7777-777777777777', 'Zürich', '33333333-3333-3333-3333-333333333333'),
  ('44444444-4444-4444-4444-444444444445', 'Sachsen', '11111111-1111-1111-1111-111111111111'),
  ('55555555-5555-5555-5555-555555555556', 'Hessen', '11111111-1111-1111-1111-111111111111'),
  ('66666666-6666-6666-6666-666666666667', 'Salzburg', '22222222-2222-2222-2222-222222222222'),
  ('77777777-7777-7777-7777-777777777778', 'Bern', '33333333-3333-3333-3333-333333333333'),
  ('88888888-4444-4444-4444-444444444444', 'Elsass', '44444444-1111-1111-1111-111111111111'),
  ('99999999-5555-5555-5555-555555555555', 'Lombardei', '55555555-2222-2222-2222-222222222222')
ON CONFLICT (id) DO NOTHING;

-- Seed data for species
INSERT INTO species (id, name, is_pest)
VALUES 
  ('88888888-8888-8888-8888-888888888888', 'Rothirsch', false),
  ('99999999-9999-9999-9999-999999999999', 'Wildschwein', false),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Fuchs', true),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Reh', false),
  ('cccccccc-8888-8888-8888-888888888888', 'Damhirsch', false),
  ('dddddddd-9999-9999-9999-999999999999', 'Mufflon', false),
  ('eeeeeeee-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Dachs', true),
  ('ffffffff-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Gämse', false),
  ('11111111-cccc-cccc-cccc-cccccccccccc', 'Marder', true),
  ('22222222-dddd-dddd-dddd-dddddddddddd', 'Kaninchen', false),
  ('33333333-eeee-eeee-eeee-eeeeeeeeeeee', 'Hase', false),
  ('44444444-ffff-ffff-ffff-ffffffffffff', 'Fasan', false)
ON CONFLICT (id) DO NOTHING;

-- Seed data for hunting grounds
INSERT INTO hunting_ground (id, name, federal_state_id)
VALUES 
  ('abcdef11-1111-1111-1111-111111111111', 'Schwarzwald Nord', '55555555-5555-5555-5555-555555555555'),
  ('abcdef22-2222-2222-2222-222222222222', 'Alpenwiesen', '44444444-4444-4444-4444-444444444444'),
  ('abcdef33-3333-3333-3333-333333333333', 'Ostwald', '44444444-4444-4444-4444-444444444445'),
  ('abcdef44-4444-4444-4444-444444444444', 'Bergpass', '66666666-6666-6666-6666-666666666666'),
  ('abcdef55-5555-5555-5555-555555555555', 'Taljagd', '77777777-7777-7777-7777-777777777777'),
  ('abcdef66-6666-6666-6666-666666666666', 'Rheinwald', '55555555-5555-5555-5555-555555555556')
ON CONFLICT (id) DO NOTHING;

INSERT INTO hunting_ground_role_permission (id, role, permission)
VALUES
  ('11111111-1111-1111-1111-111111111111', 'owner', 'hunting_ground.read'),
  ('22222222-2222-2222-2222-222222222222', 'owner', 'hunting_ground.create'),
  ('33333333-3333-3333-3333-333333333333', 'owner', 'hunting_ground.update'),
  ('44444444-4444-4444-4444-444444444444', 'owner', 'hunting_ground.delete'),
  ('55555555-5555-5555-5555-555555555555', 'member', 'hunting_ground.read')
ON CONFLICT (role, permission) DO NOTHING; 

-- Seed data for hunting grounds members
INSERT INTO hunting_ground_user_role (id, user_id, hunting_ground_id, role)
VALUES 
  (uuid_generate_v4(), 'aabbccdd-1111-1111-1111-111111111111', 'abcdef11-1111-1111-1111-111111111111', 'owner'),
  (uuid_generate_v4(), 'aabbccdd-2222-2222-2222-222222222222', 'abcdef11-1111-1111-1111-111111111111', 'member'),
  (uuid_generate_v4(), 'aabbccdd-3333-3333-3333-333333333333', 'abcdef22-2222-2222-2222-222222222222', 'owner'),
  (uuid_generate_v4(), 'aabbccdd-4444-4444-4444-444444444444', 'abcdef22-2222-2222-2222-222222222222', 'member'),
  (uuid_generate_v4(), 'aabbccdd-5555-5555-5555-555555555555', 'abcdef33-3333-3333-3333-333333333333', 'owner'),
  (uuid_generate_v4(), 'aabbccdd-6666-6666-6666-666666666666', 'abcdef33-3333-3333-3333-333333333333', 'member'),
  (uuid_generate_v4(), 'aabbccdd-1111-1111-1111-111111111111', 'abcdef44-4444-4444-4444-444444444444', 'member'),
  (uuid_generate_v4(), 'aabbccdd-2222-2222-2222-222222222222', 'abcdef55-5555-5555-5555-555555555555', 'member'),
  (uuid_generate_v4(), 'aabbccdd-3333-3333-3333-333333333333', 'abcdef66-6666-6666-6666-666666666666', 'owner')
ON CONFLICT DO NOTHING;

-- Seed data for hunting seasons
INSERT INTO hunting_season (id, federal_state_id, species_id, animal_age_min, start_date, end_date)
VALUES 
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', '44444444-4444-4444-4444-444444444444', '88888888-8888-8888-8888-888888888888', 2, '2023-08-01', '2024-01-31'),
  ('dddddddd-dddd-dddd-dddd-dddddddddddd', '44444444-4444-4444-4444-444444444444', '99999999-9999-9999-9999-999999999999', NULL, '2023-06-01', '2024-01-31'),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', '55555555-5555-5555-5555-555555555555', '88888888-8888-8888-8888-888888888888', 2, '2023-09-01', '2024-02-28'),
  ('ffffffff-ffff-ffff-ffff-ffffffffffff', '55555555-5555-5555-5555-555555555555', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 1, '2023-05-01', '2023-10-31'),
  (uuid_generate_v4(), '66666666-6666-6666-6666-666666666666', 'cccccccc-8888-8888-8888-888888888888', 2, '2023-10-01', '2024-02-15'),
  (uuid_generate_v4(), '77777777-7777-7777-7777-777777777777', 'dddddddd-9999-9999-9999-999999999999', 1, '2023-09-15', '2024-01-15'),
  (uuid_generate_v4(), '44444444-4444-4444-4444-444444444445', 'eeeeeeee-aaaa-aaaa-aaaa-aaaaaaaaaaaa', NULL, '2023-07-01', '2024-03-31'),
  (uuid_generate_v4(), '55555555-5555-5555-5555-555555555556', 'ffffffff-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 2, '2023-11-01', '2024-02-28'),
  (uuid_generate_v4(), '66666666-6666-6666-6666-666666666667', '11111111-cccc-cccc-cccc-cccccccccccc', NULL, '2023-08-15', '2024-03-15'),
  (uuid_generate_v4(), '77777777-7777-7777-7777-777777777778', '22222222-dddd-dddd-dddd-dddddddddddd', NULL, '2023-10-15', '2024-01-31')
ON CONFLICT (id) DO NOTHING;

-- Seed data for tag
INSERT INTO tag (id, name, color)
VALUES 
  ('11111111-1111-1111-1111-111111111112', 'Jungtier', '#00FF00'),
  ('22222222-2222-2222-2222-222222222223', 'Alt', '#FF0000'),
  ('33333333-3333-3333-3333-333333333334', 'Verletzt', '#FFFF00'),
  ('44444444-4444-4444-4444-444444444445', 'Gesund', '#0000FF'),
  ('55555555-5555-5555-5555-555555555557', 'Männlich', '#FF00FF'),
  ('66666666-6666-6666-6666-666666666668', 'Weiblich', '#00FFFF'),
  ('77777777-7777-7777-7777-777777777779', 'Trächtig', '#FF8800'),
  ('88888888-8888-8888-8888-88888888888a', 'Aggressiv', '#880000'),
  ('99999999-9999-9999-9999-99999999999b', 'Ruhig', '#008800'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', 'Überwacht', '#888888')
ON CONFLICT (id) DO NOTHING;

-- Seed data for caliber
INSERT INTO caliber (id, name, created_by_id)
VALUES 
  ('55555555-5555-5555-5555-555555555556', '.308 Winchester', 'aabbccdd-1111-1111-1111-111111111111'),
  ('66666666-6666-6666-6666-666666666667', '.30-06 Springfield', 'aabbccdd-1111-1111-1111-111111111111'),
  ('77777777-7777-7777-7777-777777777778', '7x64', 'aabbccdd-2222-2222-2222-222222222222'),
  ('88888888-8888-8888-8888-888888888889', '9.3x62', 'aabbccdd-2222-2222-2222-222222222222'),
  ('99999999-9999-9999-9999-99999999999c', '6.5 Creedmoor', 'aabbccdd-3333-3333-3333-333333333333'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa3', '7mm Remington Magnum', 'aabbccdd-3333-3333-3333-333333333333'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb4', '.270 Winchester', 'aabbccdd-4444-4444-4444-444444444444'),
  ('cccccccc-cccc-cccc-cccc-ccccccccccc5', '.300 Winchester Magnum', 'aabbccdd-4444-4444-4444-444444444444'),
  ('dddddddd-dddd-dddd-dddd-ddddddddddd6', '8x57 IS', 'aabbccdd-5555-5555-5555-555555555555'),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7', '.243 Winchester', 'aabbccdd-5555-5555-5555-555555555555')
ON CONFLICT (id) DO NOTHING;

-- Seed data for allowed caliber
INSERT INTO allowed_caliber (id, federal_state, species_id, caliber_id)
VALUES 
  ('99999999-9999-9999-9999-99999999999a', '44444444-4444-4444-4444-444444444444', '88888888-8888-8888-8888-888888888888', '55555555-5555-5555-5555-555555555556'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '44444444-4444-4444-4444-444444444444', '99999999-9999-9999-9999-999999999999', '66666666-6666-6666-6666-666666666667'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb2', '55555555-5555-5555-5555-555555555555', '88888888-8888-8888-8888-888888888888', '77777777-7777-7777-7777-777777777778'),
  ('cccccccc-cccc-cccc-cccc-ccccccccccc3', '55555555-5555-5555-5555-555555555555', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '88888888-8888-8888-8888-888888888889'),
  (uuid_generate_v4(), '66666666-6666-6666-6666-666666666666', 'cccccccc-8888-8888-8888-888888888888', '99999999-9999-9999-9999-99999999999c'),
  (uuid_generate_v4(), '77777777-7777-7777-7777-777777777777', 'dddddddd-9999-9999-9999-999999999999', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa3'),
  (uuid_generate_v4(), '44444444-4444-4444-4444-444444444445', 'eeeeeeee-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb4'),
  (uuid_generate_v4(), '55555555-5555-5555-5555-555555555556', 'ffffffff-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'cccccccc-cccc-cccc-cccc-ccccccccccc5'),
  (uuid_generate_v4(), '66666666-6666-6666-6666-666666666667', '11111111-cccc-cccc-cccc-cccccccccccc', 'dddddddd-dddd-dddd-dddd-ddddddddddd6'),
  (uuid_generate_v4(), '77777777-7777-7777-7777-777777777778', '22222222-dddd-dddd-dddd-dddddddddddd', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7')
ON CONFLICT (id) DO NOTHING;

-- Seed data for weapon
INSERT INTO weapon (id, name, user_id, default_caliber_id)
VALUES 
  (uuid_generate_v4(), 'Blaser R8', 'aabbccdd-1111-1111-1111-111111111111', '55555555-5555-5555-5555-555555555556'),
  (uuid_generate_v4(), 'Mauser M12', 'aabbccdd-2222-2222-2222-222222222222', '66666666-6666-6666-6666-666666666667'),
  (uuid_generate_v4(), 'Sauer 404', 'aabbccdd-3333-3333-3333-333333333333', '77777777-7777-7777-7777-777777777778'),
  (uuid_generate_v4(), 'Tikka T3x', 'aabbccdd-4444-4444-4444-444444444444', '88888888-8888-8888-8888-888888888889'),
  (uuid_generate_v4(), 'Steyr Mannlicher', 'aabbccdd-5555-5555-5555-555555555555', '99999999-9999-9999-9999-99999999999c'),
  (uuid_generate_v4(), 'Merkel Helix', 'aabbccdd-6666-6666-6666-666666666666', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa3'),
  (uuid_generate_v4(), 'Browning X-Bolt', 'aabbccdd-1111-1111-1111-111111111111', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb4'),
  (uuid_generate_v4(), 'Sako 85', 'aabbccdd-2222-2222-2222-222222222222', 'cccccccc-cccc-cccc-cccc-ccccccccccc5'),
  (uuid_generate_v4(), 'Krieghoff Hubertus', 'aabbccdd-3333-3333-3333-333333333333', 'dddddddd-dddd-dddd-dddd-ddddddddddd6'),
  (uuid_generate_v4(), 'Anschütz 1782', 'aabbccdd-4444-4444-4444-444444444444', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7')
ON CONFLICT (id) DO NOTHING;

-- Seed data for weather conditions
INSERT INTO weather_condition (id, wind_direction, wind_speed, temperature, air_pressure, precipitation, ground_conditions, moon_phase, timestamp)
VALUES 
  (uuid_generate_v4(), 180, 5.2, 12.5, 1013.2, 0.0, 'Trocken', 'Vollmond', '2023-09-10 07:30:00'),
  (uuid_generate_v4(), 270, 8.7, 8.3, 1008.5, 1.2, 'Nass', 'Erstes Viertel', '2023-09-15 16:45:00'),
  (uuid_generate_v4(), 90, 3.1, 15.7, 1015.8, 0.0, 'Trocken', 'Neumond', '2023-09-20 05:15:00'),
  (uuid_generate_v4(), 0, 10.5, 5.2, 1005.3, 3.8, 'Verschneit', 'Letztes Viertel', '2023-09-25 18:20:00'),
  (uuid_generate_v4(), 225, 6.8, 11.4, 1010.7, 0.5, 'Feucht', 'Abnehmender Mond', '2023-10-01 06:10:00'),
  (uuid_generate_v4(), 315, 4.3, 9.8, 1011.9, 0.0, 'Trocken', 'Zunehmender Mond', '2023-10-05 17:35:00'),
  (uuid_generate_v4(), 45, 7.9, 14.2, 1014.1, 0.0, 'Trocken', 'Zunehmender Mond', '2023-10-10 08:25:00'),
  (uuid_generate_v4(), 135, 9.2, 7.1, 1009.4, 2.5, 'Nass', 'Abnehmender Mond', '2023-10-15 19:50:00'),
  (uuid_generate_v4(), 180, 2.5, 16.3, 1016.2, 0.0, 'Trocken', 'Vollmond', '2023-10-20 06:40:00'),
  (uuid_generate_v4(), 270, 11.3, 4.5, 1004.8, 4.2, 'Verschneit', 'Neumond', '2023-10-25 15:15:00')
ON CONFLICT (id) DO NOTHING;

-- Seed data for camera
INSERT INTO camera (id, name, latitude, longitude, hunting_ground_id)
VALUES 
  (uuid_generate_v4(), 'Waldrand Kamera 1', 48.1351, 11.5820, 'abcdef11-1111-1111-1111-111111111111'),
  (uuid_generate_v4(), 'Wiesen Kamera 2', 48.2084, 11.6256, 'abcdef11-1111-1111-1111-111111111111'),
  (uuid_generate_v4(), 'Bach Kamera 3', 48.1550, 11.5418, 'abcdef11-1111-1111-1111-111111111111'),
  (uuid_generate_v4(), 'Futterstelle Kamera 4', 48.1839, 11.5604, 'abcdef11-1111-1111-1111-111111111111'),
  (uuid_generate_v4(), 'Bergrücken Kamera 5', 48.1651, 11.6089, 'abcdef11-1111-1111-1111-111111111111'),
  (uuid_generate_v4(), 'Tal Kamera 6', 48.1768, 11.5933, 'abcdef11-1111-1111-1111-111111111111'),
  (uuid_generate_v4(), 'Wildpfad Kamera 7', 48.1432, 11.5677, 'abcdef11-1111-1111-1111-111111111111'),
  (uuid_generate_v4(), 'Teich Kamera 8', 48.1957, 11.5764, 'abcdef11-1111-1111-1111-111111111111'),
  (uuid_generate_v4(), 'Wildwechsel Kamera 9', 48.1587, 11.5503, 'abcdef11-1111-1111-1111-111111111111'),
  (uuid_generate_v4(), 'Aussichtspunkt Kamera 10', 48.1879, 11.6123, 'abcdef11-1111-1111-1111-111111111111')
ON CONFLICT (id) DO NOTHING;

-- Seed data for caliber allowed caliber junction table
INSERT INTO caliber_allowed_caliber (allowed_caliber_id, caliber_id)
VALUES 
  ('99999999-9999-9999-9999-99999999999a', '55555555-5555-5555-5555-555555555556'),
  ('99999999-9999-9999-9999-99999999999a', '66666666-6666-6666-6666-666666666667'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '77777777-7777-7777-7777-777777777778'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '88888888-8888-8888-8888-888888888889'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb2', '55555555-5555-5555-5555-555555555556'),
  ('cccccccc-cccc-cccc-cccc-ccccccccccc3', '66666666-6666-6666-6666-666666666667')
ON CONFLICT (allowed_caliber_id, caliber_id) DO NOTHING;

-- Additional example data for more complex entities

-- Create shooting records
INSERT INTO shooting (id, shot_by_id, weapon_id, caliber_id, distance, hit_location, shot_count, notes, shot_at)
SELECT 
  uuid_generate_v4(),
  u.id,
  w.id,
  c.id,
  (50 + random() * 150)::numeric(10,2),
  (ARRAY['Schulter', 'Hals', 'Herz', 'Lunge', 'Kopf'])[floor(random() * 5 + 1)],
  floor(random() * 2 + 1)::integer,
  'Jagdnotizen für Schuss #' || row_number() over(),
  (current_date - (random() * 90)::integer * interval '1 day') + (random() * 24)::integer * interval '1 hour'
FROM 
  (SELECT id FROM auth.users LIMIT 6) u
  CROSS JOIN LATERAL (SELECT id FROM weapon WHERE user_id = u.id LIMIT 1) w
  CROSS JOIN LATERAL (SELECT id FROM caliber LIMIT 10) c
LIMIT 20;

-- Create animal
INSERT INTO animal (id, hunting_ground_id, name, dead, age, weight, abnormalities, shooting_priority, notes, shooting_id, species_id, custom_color)
SELECT 
  uuid_generate_v4(),
  hg.id,
  (ARRAY['Bock', 'Ricke', 'Keiler', 'Bache', 'Fuchs', 'Hirsch'])[floor(random() * 6 + 1)] || ' #' || row_number() over(),
  random() > 0.7,
  (1 + random() * 10)::numeric(10,2),
  (20 + random() * 80)::numeric(10,2),
  CASE WHEN random() > 0.8 THEN 'Abnormes Geweih' WHEN random() > 0.6 THEN 'Lahmheit' ELSE NULL END,
  floor(random() * 5 + 1)::integer,
  'Tiernotizen für #' || row_number() over(),
  CASE WHEN random() > 0.7 THEN (SELECT id FROM shooting ORDER BY random() LIMIT 1) ELSE NULL END,
  s.id,
  floor(random() * 16777215)::integer
FROM 
  (SELECT id FROM hunting_ground LIMIT 6) hg
  CROSS JOIN LATERAL (SELECT id FROM species LIMIT 12) s
LIMIT 50;

-- Create animal tag
INSERT INTO animal_tag (animal_id, tag_id)
SELECT 
  a.id, 
  t.id
FROM 
  (SELECT id FROM animal LIMIT 50) a
  CROSS JOIN LATERAL (SELECT id FROM tag ORDER BY random() LIMIT 1) t
ON CONFLICT DO NOTHING;

-- Create animal filters
INSERT INTO animal_filter (id, name, hunting_ground_id, species_id, animal_count, animal_count_type)
SELECT 
  uuid_generate_v4(),
  'Filter für ' || s.name || ' in ' || hg.name,
  hg.id,
  s.id,
  floor(random() * 10 + 1)::integer,
  (ARRAY['minimum', 'maximum', 'exact', 'approximately'])[floor(random() * 3 + 1)]
FROM 
  (SELECT id, name FROM hunting_ground LIMIT 6) hg
  CROSS JOIN LATERAL (SELECT id, name FROM species LIMIT 12) s
LIMIT 15;

-- Create animal filter animal
INSERT INTO animal_filter_animal (animal_filter_id, animal_id)
SELECT 
  af.id, 
  a.id
FROM 
  (SELECT id FROM animal_filter LIMIT 15) af
  CROSS JOIN LATERAL (SELECT id FROM animal ORDER BY random() LIMIT 3) a
ON CONFLICT DO NOTHING;

-- Create media records
INSERT INTO media (id, remote_file_path, local_file_path, media_type, time_offset, timestamp_original, timestamp, created_by_id)
SELECT 
  uuid_generate_v4(),
  '/storage/media/' || md5(random()::text) || (ARRAY['.jpg', '.mp4', '.png'])[floor(random() * 3 + 1)],
  '/storage/media/' || md5(random()::text) || (ARRAY['.jpg', '.mp4', '.png'])[floor(random() * 3 + 1)],
  (ARRAY['Bild', 'Video'])[floor(random() * 2 + 1)],
  floor(random() * 60)::integer,
  current_timestamp - (random() * 90)::integer * interval '1 day',
  current_timestamp - (random() * 89)::integer * interval '1 day',
  (SELECT id FROM auth.users ORDER BY random() LIMIT 1)
FROM generate_series(1, 30);

-- Create uploads
INSERT INTO upload (id, status, camera_id, latitude, longitude, created_by_id, hunting_ground_id)
WITH 
  numbered_rows AS (
    SELECT 
      ROW_NUMBER() OVER () as rnum,
      c.id as camera_id,
      u.id as user_id,
      h.id as hunting_ground_id
    FROM 
      camera c,
      auth.users u,
      hunting_ground h
    WHERE random() < 0.5
    ORDER BY random()
    LIMIT 15
  )
SELECT 
  uuid_generate_v4(),
  (ARRAY['ausstehend', 'verarbeitung', 'abgeschlossen', 'fehlgeschlagen'])[1 + (rnum % 4)],
  camera_id,
  48.1 + (rnum * 0.01),
  11.5 + (rnum * 0.01),
  user_id,
  hunting_ground_id
FROM 
  numbered_rows;

-- Create upload media relations
INSERT INTO upload_media (upload_id, media_id)
SELECT 
  u.id, 
  m.id
FROM 
  (SELECT id FROM upload) u
  CROSS JOIN LATERAL (SELECT id FROM media ORDER BY random() LIMIT 2) m
ON CONFLICT DO NOTHING;

-- Create sighting
INSERT INTO sighting (id, species_id, group_type, animal_count, animal_count_precision, weather_condition_id, camera_id, upload_id, latitude, longitude, sighting_start, sighting_end, hunting_ground_id)
WITH 
  numbered_rows AS (
    SELECT 
      ROW_NUMBER() OVER () as rnum,
      s.id as species_id,
      w.id as weather_id,
      c.id as camera_id,
      u.id as upload_id,
      h.id as hunting_ground_id
    FROM 
      species s,
      weather_condition w,
      camera c,
      upload u,
      hunting_ground h
    WHERE random() < 0.5
    ORDER BY random()
    LIMIT 25
  )
SELECT 
  uuid_generate_v4(),
  species_id,
  (ARRAY['Familie', 'Rotte', 'Einzeltier', 'Paar'])[1 + (rnum % 4)],
  1 + (rnum % 10),
  rnum % 3,
  weather_id,
  camera_id,
  upload_id,
  48.1 + (rnum * 0.01),
  11.5 + (rnum * 0.01),
  current_timestamp - ((30 + rnum)::integer * interval '1 day'),
  current_timestamp - (rnum::integer * interval '1 day'),
  hunting_ground_id
FROM 
  numbered_rows;

-- Create sighting animal
INSERT INTO sighting_animal (sighting_id, animal_id)
SELECT 
  s.id, 
  a.id
FROM 
  (SELECT id FROM sighting LIMIT 25) s
  CROSS JOIN LATERAL (SELECT id FROM animal ORDER BY random() LIMIT 2) a
ON CONFLICT DO NOTHING;

-- Create sighting tag
INSERT INTO sighting_tag (sighting_id, tag_id)
SELECT 
  s.id, 
  t.id
FROM 
  (SELECT id FROM sighting LIMIT 25) s
  CROSS JOIN LATERAL (SELECT id FROM tag ORDER BY random() LIMIT 2) t
ON CONFLICT DO NOTHING;

-- Create sighting media
INSERT INTO sighting_media (sighting_id, media_id)
SELECT 
  s.id, 
  m.id
FROM 
  (SELECT id FROM sighting LIMIT 25) s
  CROSS JOIN LATERAL (SELECT id FROM media ORDER BY random() LIMIT 2) m
ON CONFLICT DO NOTHING;

-- Create shooting media
INSERT INTO shooting_media (shooting_id, media_id)
SELECT 
  sh.id, 
  m.id
FROM 
  (SELECT id FROM shooting LIMIT 20) sh
  CROSS JOIN LATERAL (SELECT id FROM media ORDER BY random() LIMIT 2) m
ON CONFLICT DO NOTHING;

-- End of development environment block
END;
$$; 