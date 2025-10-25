-- Create extension for UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- country table
CREATE TABLE IF NOT EXISTS country (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(100) NOT NULL
);

-- Federal states table
CREATE TABLE IF NOT EXISTS federal_state (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(100) NOT NULL,
  country_id UUID NOT NULL REFERENCES country(id)
);

-- Species table
CREATE TABLE IF NOT EXISTS species (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(100) NOT NULL,
  is_pest BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Hunting grounds table
CREATE TABLE IF NOT EXISTS hunting_ground (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL,
  federal_state_id UUID NOT NULL REFERENCES federal_state(id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  is_deleted BOOLEAN DEFAULT FALSE
);

-- Hunting grounds members table
CREATE TABLE IF NOT EXISTS hunting_ground_user_role (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  hunting_ground_id UUID REFERENCES hunting_ground(id) NOT NULL,
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  role hunting_ground_role NOT NULL
);
comment on table hunting_ground_user_role is 'Hunting ground roles for each user.';

-- ROLE PERMISSIONS
create table public.hunting_ground_role_permission (
  id           UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  role         hunting_ground_role not null,
  permission   hunting_ground_permission not null,
  unique (role, permission)
);
comment on table hunting_ground_role_permission is 'Hunting ground permissions for each role.';

-- Hunting seasons table
CREATE TABLE IF NOT EXISTS hunting_season (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  federal_state_id UUID NOT NULL REFERENCES federal_state(id),
  species_id UUID NOT NULL REFERENCES species(id),
  animal_age_min INTEGER,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  valid_from TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  valid_until TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- tag table
CREATE TABLE IF NOT EXISTS tag (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(100) NOT NULL,
  color VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  is_deleted BOOLEAN DEFAULT FALSE
);

-- caliber table
CREATE TABLE IF NOT EXISTS caliber (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(50) NOT NULL,
  created_by_id UUID REFERENCES auth.users(id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_by_id UUID REFERENCES auth.users(id),
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  is_deleted BOOLEAN DEFAULT FALSE
);

-- Allowed caliber table
CREATE TABLE IF NOT EXISTS allowed_caliber (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  caliber_id UUID NOT NULL REFERENCES caliber(id),
  federal_state UUID NOT NULL REFERENCES federal_state(id),
  species_id UUID NOT NULL REFERENCES species(id),
  valid_from TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  valid_until TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- weapon table
CREATE TABLE IF NOT EXISTS weapon (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL,
  user_id UUID NOT NULL REFERENCES auth.users(id),
  default_caliber_id UUID REFERENCES caliber(id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP UNIQUE,
  is_deleted BOOLEAN DEFAULT FALSE
);

-- Weather conditions table
CREATE TABLE IF NOT EXISTS weather_condition (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  wind_direction INTEGER,
  wind_speed DECIMAL,
  temperature DECIMAL,
  air_pressure DECIMAL,
  precipitation DECIMAL,
  ground_conditions VARCHAR(255),
  moon_phase VARCHAR(50),
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  is_deleted BOOLEAN DEFAULT FALSE
);

-- Media table
CREATE TABLE IF NOT EXISTS media (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  remote_file_path VARCHAR(1000),
  local_file_path VARCHAR(1000),
  media_type VARCHAR(50) NOT NULL,
  time_offset BIGINT DEFAULT 0,
  timestamp_original TIMESTAMP,
  timestamp TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  is_deleted BOOLEAN DEFAULT FALSE,
  created_by_id UUID REFERENCES auth.users(id),
  updated_by_id UUID REFERENCES auth.users(id),
  deleted_by_id UUID REFERENCES auth.users(id)
);

-- Camera table
CREATE TABLE IF NOT EXISTS camera (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL,
  hunting_ground_id UUID NOT NULL REFERENCES hunting_ground(id),
  latitude DECIMAL NOT NULL,
  longitude DECIMAL NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  is_deleted BOOLEAN DEFAULT FALSE
);

-- Upload table
CREATE TABLE IF NOT EXISTS upload (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  status VARCHAR(50) NOT NULL,
  camera_id UUID REFERENCES camera(id),
  hunting_ground_id UUID NOT NULL REFERENCES hunting_ground(id),
  latitude DECIMAL,
  longitude DECIMAL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  is_deleted BOOLEAN DEFAULT FALSE,
  created_by_id UUID REFERENCES auth.users(id),
  updated_by_id UUID REFERENCES auth.users(id),
  deleted_by_id UUID REFERENCES auth.users(id)
);

-- Shooting table
CREATE TABLE IF NOT EXISTS shooting (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  shot_by_id UUID REFERENCES auth.users(id),
  weapon_id UUID REFERENCES weapon(id),
  caliber_id UUID REFERENCES caliber(id),
  distance DECIMAL,
  hit_location VARCHAR(255),
  shot_count INTEGER DEFAULT 1,
  notes TEXT,
  shot_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  is_deleted BOOLEAN DEFAULT FALSE
);

-- animal table
CREATE TABLE IF NOT EXISTS animal (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  hunting_ground_id UUID NOT NULL REFERENCES hunting_ground(id),
  name VARCHAR(255) NOT NULL,
  dead BOOLEAN NOT NULL,
  age DECIMAL,
  weight DECIMAL,
  abnormalities TEXT,
  shooting_priority INTEGER,
  notes TEXT,
  shooting_id UUID REFERENCES shooting(id),
  species_id UUID NOT NULL REFERENCES species(id),
  custom_color BIGINT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  is_deleted BOOLEAN DEFAULT FALSE
);

-- Animal filter table
CREATE TABLE IF NOT EXISTS animal_filter (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL,
  hunting_ground_id UUID NOT NULL REFERENCES hunting_ground(id),
  species_id UUID NOT NULL REFERENCES species(id),
  animal_count INTEGER DEFAULT 1,
  animal_count_type VARCHAR(50),
  custom_color BIGINT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  is_deleted BOOLEAN DEFAULT FALSE
);

-- sighting table
CREATE TABLE IF NOT EXISTS sighting (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  species_id UUID NOT NULL REFERENCES species(id),
  group_type VARCHAR(255),
  animal_count INTEGER NOT NULL,
  animal_count_precision INTEGER DEFAULT 0,
  weather_condition_id UUID REFERENCES weather_condition(id),
  hunting_ground_id UUID NOT NULL REFERENCES hunting_ground(id),
  camera_id UUID REFERENCES camera(id),
  upload_id UUID REFERENCES upload(id),
  latitude DECIMAL NOT NULL,
  longitude DECIMAL NOT NULL,
  sighting_start TIMESTAMP NOT NULL,
  sighting_end TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  is_deleted BOOLEAN DEFAULT FALSE
);

-- Junction tables for many-to-many relationships

-- Animal tag junction table
CREATE TABLE IF NOT EXISTS animal_tag (
  animal_id UUID NOT NULL REFERENCES animal(id),
  tag_id UUID NOT NULL REFERENCES tag(id),
  PRIMARY KEY (animal_id, tag_id)
);

-- Sighting animal junction table
CREATE TABLE IF NOT EXISTS sighting_animal (
  sighting_id UUID NOT NULL REFERENCES sighting(id) ON DELETE CASCADE,
  animal_id UUID NOT NULL REFERENCES animal(id) ON DELETE CASCADE,
  PRIMARY KEY (sighting_id, animal_id)
);

-- Sighting tag junction table
CREATE TABLE IF NOT EXISTS sighting_tag (
  sighting_id UUID NOT NULL REFERENCES sighting(id) ON DELETE CASCADE,
  tag_id UUID NOT NULL REFERENCES tag(id) ON DELETE CASCADE,
  PRIMARY KEY (sighting_id, tag_id)
);

-- Sighting media junction table
CREATE TABLE IF NOT EXISTS sighting_media (
  sighting_id UUID NOT NULL REFERENCES sighting(id) ON DELETE CASCADE,
  media_id UUID NOT NULL REFERENCES media(id) ON DELETE CASCADE,
  PRIMARY KEY (sighting_id, media_id)
);

-- Shooting media junction table
CREATE TABLE IF NOT EXISTS shooting_media (
  shooting_id UUID NOT NULL REFERENCES shooting(id) ON DELETE CASCADE,
  media_id UUID NOT NULL REFERENCES media(id) ON DELETE CASCADE,
  PRIMARY KEY (shooting_id, media_id)
);

-- Animal filter animal junction table
CREATE TABLE IF NOT EXISTS animal_filter_animal (
  animal_filter_id UUID NOT NULL REFERENCES animal_filter(id) ON DELETE CASCADE,
  animal_id UUID NOT NULL REFERENCES animal(id) ON DELETE CASCADE,
  PRIMARY KEY (animal_filter_id, animal_id)
);

-- Animal filter tag junction table
CREATE TABLE IF NOT EXISTS animal_filter_tag (
  animal_filter_id UUID NOT NULL REFERENCES animal_filter(id) ON DELETE CASCADE,
  tag_id UUID NOT NULL REFERENCES tag(id) ON DELETE CASCADE,
  PRIMARY KEY (animal_filter_id, tag_id)
);

-- Upload media junction table
CREATE TABLE IF NOT EXISTS upload_media (
  upload_id UUID NOT NULL REFERENCES upload(id) ON DELETE CASCADE,
  media_id UUID NOT NULL REFERENCES media(id) ON DELETE CASCADE,
  PRIMARY KEY (upload_id, media_id)
);

-- Upload unprocessed media junction table
CREATE TABLE IF NOT EXISTS upload_unprocessed_media (
  upload_id UUID NOT NULL REFERENCES upload(id) ON DELETE CASCADE,
  media_id UUID NOT NULL REFERENCES media(id) ON DELETE CASCADE,
  PRIMARY KEY (upload_id, media_id)
);

-- Caliber allowed caliber junction table
CREATE TABLE IF NOT EXISTS caliber_allowed_caliber (
  caliber_id UUID NOT NULL REFERENCES caliber(id) ON DELETE CASCADE,
  allowed_caliber_id UUID NOT NULL REFERENCES allowed_caliber(id) ON DELETE CASCADE,
  PRIMARY KEY (caliber_id, allowed_caliber_id)
);
