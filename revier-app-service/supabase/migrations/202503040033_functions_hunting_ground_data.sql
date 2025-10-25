-- Migration to add policies and permissions for hunting ground data retrieval functions
-- These functions allow fetching all data related to a hunting ground in a single request

-- Get all animals for a hunting ground
CREATE OR REPLACE FUNCTION get_hunting_ground_animals(p_hunting_ground_id UUID)
RETURNS SETOF animal AS $$
BEGIN
  -- Check if user has permission to access this hunting ground
  IF NOT has_hunting_ground_permission(p_hunting_ground_id, 'hunting_ground.read') THEN
    RAISE EXCEPTION 'Permission denied: User does not have access to this hunting ground';
  END IF;

  RETURN QUERY
  SELECT 
    a.id, a.hunting_ground_id, a.name, a.dead, a.age, a.weight, 
    a.abnormalities, a.shooting_priority, a.notes, a.shooting_id,
    a.species_id, a.custom_color, a.created_at, a.updated_at, 
    a.deleted_at, a.is_deleted
  FROM animal a
  WHERE a.hunting_ground_id = p_hunting_ground_id
  AND a.is_deleted = FALSE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Get all animal filters for a hunting ground
CREATE OR REPLACE FUNCTION get_hunting_ground_animal_filters(p_hunting_ground_id UUID)
RETURNS SETOF animal_filter AS $$
BEGIN
  -- Check if user has permission to access this hunting ground
  IF NOT has_hunting_ground_permission(p_hunting_ground_id, 'hunting_ground.read') THEN
    RAISE EXCEPTION 'Permission denied: User does not have access to this hunting ground';
  END IF;

  RETURN QUERY
  SELECT 
    af.id, af.name, af.hunting_ground_id, af.species_id, af.animal_count, 
    af.animal_count_type, af.custom_color, af.created_at, af.updated_at,
    af.deleted_at, af.is_deleted
  FROM animal_filter af
  WHERE af.hunting_ground_id = p_hunting_ground_id
  AND af.is_deleted = FALSE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Get all cameras related to a hunting ground (via sightings)
CREATE OR REPLACE FUNCTION get_hunting_ground_cameras(p_hunting_ground_id UUID)
RETURNS SETOF camera AS $$
BEGIN
  -- Check if user has permission to access this hunting ground
  IF NOT has_hunting_ground_permission(p_hunting_ground_id, 'hunting_ground.read') THEN
    RAISE EXCEPTION 'Permission denied: User does not have access to this hunting ground';
  END IF;

  RETURN QUERY
  SELECT DISTINCT 
    c.id, c.name, c.latitude, c.longitude, c.created_at, c.updated_at, 
    c.deleted_at, c.is_deleted
  FROM camera c
  JOIN sighting s ON s.camera_id = c.id
  JOIN sighting_animal sa ON sa.sighting_id = s.id
  JOIN hunting_ground hg ON hg.id = c.hunting_ground_id
  JOIN animal a ON a.id = sa.animal_id
  WHERE hg.id = p_hunting_ground_id
  AND a.is_deleted = FALSE
  AND s.is_deleted = FALSE
  AND c.is_deleted = FALSE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Get all sightings related to a hunting ground
CREATE OR REPLACE FUNCTION get_hunting_ground_sightings(p_hunting_ground_id UUID)
RETURNS SETOF sighting AS $$
BEGIN
  -- Check if user has permission to access this hunting ground
  IF NOT has_hunting_ground_permission(p_hunting_ground_id, 'hunting_ground.read') THEN
    RAISE EXCEPTION 'Permission denied: User does not have access to this hunting ground';
  END IF;

  RETURN QUERY
  SELECT DISTINCT 
    s.id, s.species_id, s.group_type, s.animal_count, s.animal_count_precision,
    s.weather_condition_id, s.camera_id, s.upload_id, s.latitude, s.longitude,
    s.sighting_start, s.sighting_end, s.created_at, s.updated_at, s.deleted_at, s.is_deleted
  FROM sighting s
  JOIN sighting_animal sa ON sa.sighting_id = s.id
  JOIN animal a ON a.id = sa.animal_id
  WHERE a.hunting_ground_id = p_hunting_ground_id
  AND a.is_deleted = FALSE
  AND s.is_deleted = FALSE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Get all uploads related to a hunting ground (via sightings)
CREATE OR REPLACE FUNCTION get_hunting_ground_uploads(p_hunting_ground_id UUID)
RETURNS SETOF upload AS $$
BEGIN
  -- Check if user has permission to access this hunting ground
  IF NOT has_hunting_ground_permission(p_hunting_ground_id, 'hunting_ground.read') THEN
    RAISE EXCEPTION 'Permission denied: User does not have access to this hunting ground';
  END IF;

  RETURN QUERY
  SELECT DISTINCT 
    u.id, u.status, u.camera_id, u.latitude, u.longitude, u.created_at, 
    u.updated_at, u.deleted_at, u.is_deleted, u.created_by_id, u.updated_by_id, u.deleted_by_id
  FROM upload u
  JOIN sighting s ON s.upload_id = u.id
  JOIN sighting_animal sa ON sa.sighting_id = s.id
  JOIN animal a ON a.id = sa.animal_id
  WHERE u.hunting_ground_id = p_hunting_ground_id
  AND a.is_deleted = FALSE
  AND s.is_deleted = FALSE
  AND u.is_deleted = FALSE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Get all data for a hunting ground in a single function call (returns JSON)
CREATE OR REPLACE FUNCTION get_hunting_ground_data(p_hunting_ground_id UUID)
RETURNS JSON AS $$
DECLARE
  result JSON;
  hunting_ground_json JSON;
  animals_json JSON;
  animal_filters_json JSON;
  cameras_json JSON;
  sightings_json JSON;
  uploads_json JSON;
BEGIN
  -- Check if user has permission to access this hunting ground
  IF NOT has_hunting_ground_permission(p_hunting_ground_id, 'hunting_ground.read') THEN
    RAISE EXCEPTION 'Permission denied: User does not have access to this hunting ground';
  END IF;

  -- Get hunting ground
  SELECT row_to_json(hg)
  FROM hunting_ground hg 
  WHERE hg.id = p_hunting_ground_id
  INTO hunting_ground_json;

  -- Get animals
  SELECT COALESCE(json_agg(a), '[]'::json)
  FROM get_hunting_ground_animals(p_hunting_ground_id) a
  INTO animals_json;

  -- Get animal filters
  SELECT COALESCE(json_agg(af), '[]'::json)
  FROM get_hunting_ground_animal_filters(p_hunting_ground_id) af
  INTO animal_filters_json;

  -- Get cameras
  SELECT COALESCE(json_agg(c), '[]'::json)
  FROM get_hunting_ground_cameras(p_hunting_ground_id) c
  INTO cameras_json;

  -- Get sightings
  SELECT COALESCE(json_agg(s), '[]'::json)
  FROM get_hunting_ground_sightings(p_hunting_ground_id) s
  INTO sightings_json;

  -- Get uploads
  SELECT COALESCE(json_agg(u), '[]'::json)
  FROM get_hunting_ground_uploads(p_hunting_ground_id) u
  INTO uploads_json;

  -- Build the final result
  SELECT json_build_object(
    'hunting_ground', hunting_ground_json,
    'animals', animals_json,
    'animal_filters', animal_filters_json,
    'cameras', cameras_json,
    'sightings', sightings_json,
    'uploads', uploads_json
  ) INTO result;
  
  RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER; 

-- Function to get animals with their species data for a hunting ground
CREATE OR REPLACE FUNCTION get_hunting_ground_animals_with_species(p_hunting_ground_id UUID)
RETURNS TABLE (
  id UUID,
  hunting_ground_id UUID,
  name VARCHAR,
  dead BOOLEAN,
  age DECIMAL,
  weight DECIMAL,
  abnormalities TEXT,
  shooting_priority INTEGER,
  notes TEXT,
  shooting_id UUID,
  species_id UUID,
  custom_color INTEGER,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  deleted_at TIMESTAMP,
  is_deleted BOOLEAN,
  -- Species data
  species_name VARCHAR,
  species_is_pest BOOLEAN
) AS $$
BEGIN
  -- Check if user has permission to access this hunting ground
  IF NOT has_hunting_ground_permission(p_hunting_ground_id, 'hunting_ground.read') THEN
    RAISE EXCEPTION 'Permission denied: User does not have access to this hunting ground';
  END IF;

  RETURN QUERY
  SELECT 
    a.id,
    a.hunting_ground_id,
    a.name,
    a.dead,
    a.age,
    a.weight,
    a.abnormalities,
    a.shooting_priority,
    a.notes,
    a.shooting_id,
    a.species_id,
    a.custom_color,
    a.created_at,
    a.updated_at,
    a.deleted_at,
    a.is_deleted,
    s.name AS species_name,
    s.is_pest AS species_is_pest
  FROM animal a
  JOIN species s ON a.species_id = s.id
  WHERE a.hunting_ground_id = p_hunting_ground_id
  AND a.is_deleted = FALSE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Get all data for a hunting ground with resolved references in a single function call (returns JSON)
CREATE OR REPLACE FUNCTION get_hunting_ground_data_with_references(p_hunting_ground_id UUID)
RETURNS JSON AS $$
DECLARE
  result JSON;
  hunting_ground_json JSON;
  animals_with_species_json JSON;
  animal_filters_json JSON;
  cameras_json JSON;
  sightings_json JSON;
  uploads_json JSON;
BEGIN
  -- Check if user has permission to access this hunting ground
  IF NOT has_hunting_ground_permission(p_hunting_ground_id, 'hunting_ground.read') THEN
    RAISE EXCEPTION 'Permission denied: User does not have access to this hunting ground';
  END IF;

  -- Get hunting ground with federal state
  SELECT json_build_object(
    'id', hg.id,
    'name', hg.name,
    'federal_state_id', hg.federal_state_id,
    'federal_state', json_build_object(
      'id', fs.id,
      'name', fs.name,
      'country', json_build_object(
        'id', c.id,
        'name', c.name
      )
    ),
    'created_at', hg.created_at,
    'updated_at', hg.updated_at,
    'deleted_at', hg.deleted_at,
    'is_deleted', hg.is_deleted
  )
  FROM hunting_ground hg
  LEFT JOIN federal_state fs ON hg.federal_state_id = fs.id
  LEFT JOIN country c ON fs.country_id = c.id
  WHERE hg.id = p_hunting_ground_id
  INTO hunting_ground_json;

  -- Get animals with their species information using fully qualified column names
  SELECT COALESCE(json_agg(
    json_build_object(
      'id', aws.id,
      'hunting_ground_id', aws.hunting_ground_id,
      'name', aws.name,
      'dead', aws.dead,
      'age', aws.age,
      'weight', aws.weight,
      'abnormalities', aws.abnormalities,
      'shooting_priority', aws.shooting_priority,
      'notes', aws.notes,
      'shooting_id', aws.shooting_id,
      'species_id', aws.species_id,
      'custom_color', aws.custom_color,
      'created_at', aws.created_at,
      'updated_at', aws.updated_at,
      'deleted_at', aws.deleted_at,
      'is_deleted', aws.is_deleted,
      'species', json_build_object(
        'id', aws.species_id,
        'name', aws.species_name,
        'is_pest', aws.species_is_pest
      )
    )
  ), '[]'::json)
  FROM get_hunting_ground_animals_with_species(p_hunting_ground_id) aws
  INTO animals_with_species_json;

  -- Get animal filters with explicit table aliases
  SELECT COALESCE(json_agg(
    json_build_object(
      'id', af.id,
      'hunting_ground_id', af.hunting_ground_id,
      'name', af.name,
      'species_id', af.species_id,
      'animal_count', af.animal_count,
      'animal_count_type', af.animal_count_type,
      'custom_color', af.custom_color,
      'created_at', af.created_at,
      'updated_at', af.updated_at,
      'deleted_at', af.deleted_at,
      'is_deleted', af.is_deleted
    )
  ), '[]'::json)
  FROM get_hunting_ground_animal_filters(p_hunting_ground_id) af
  INTO animal_filters_json;

  -- Get cameras with explicit table aliases
  SELECT COALESCE(json_agg(
    json_build_object(
      'id', c.id,
      'name', c.name,
      'latitude', c.latitude,
      'longitude', c.longitude,
      'created_at', c.created_at,
      'updated_at', c.updated_at,
      'deleted_at', c.deleted_at,
      'is_deleted', c.is_deleted
    )
  ), '[]'::json)
  FROM get_hunting_ground_cameras(p_hunting_ground_id) c
  INTO cameras_json;

  -- Get sightings with species info, using explicit table aliases
  WITH sightings_with_species AS (
    SELECT 
      s.id,
      s.species_id,
      s.group_type,
      s.animal_count,
      s.animal_count_precision,
      s.weather_condition_id,
      s.camera_id,
      s.upload_id,
      s.latitude,
      s.longitude,
      s.sighting_start,
      s.sighting_end,
      s.created_at,
      s.updated_at,
      s.deleted_at,
      s.is_deleted,
      json_build_object(
        'id', sp.id,
        'name', sp.name,
        'is_pest', sp.is_pest
      ) AS species
    FROM get_hunting_ground_sightings(p_hunting_ground_id) s
    JOIN species sp ON s.species_id = sp.id
  )
  SELECT COALESCE(json_agg(
    json_build_object(
      'id', sws.id,
      'species_id', sws.species_id,
      'group_type', sws.group_type,
      'animal_count', sws.animal_count,
      'animal_count_precision', sws.animal_count_precision,
      'weather_condition_id', sws.weather_condition_id,
      'camera_id', sws.camera_id,
      'upload_id', sws.upload_id,
      'latitude', sws.latitude,
      'longitude', sws.longitude,
      'sighting_start', sws.sighting_start,
      'sighting_end', sws.sighting_end,
      'created_at', sws.created_at,
      'updated_at', sws.updated_at,
      'deleted_at', sws.deleted_at,
      'is_deleted', sws.is_deleted,
      'species', sws.species
    )
  ), '[]'::json)
  FROM sightings_with_species sws
  INTO sightings_json;

  -- Get uploads with explicit table aliases
  SELECT COALESCE(json_agg(
    json_build_object(
      'id', u.id,
      'status', u.status,
      'camera_id', u.camera_id,
      'latitude', u.latitude,
      'longitude', u.longitude,
      'created_at', u.created_at,
      'updated_at', u.updated_at,
      'deleted_at', u.deleted_at,
      'is_deleted', u.is_deleted,
      'created_by_id', u.created_by_id,
      'updated_by_id', u.updated_by_id,
      'deleted_by_id', u.deleted_by_id
    )
  ), '[]'::json)
  FROM get_hunting_ground_uploads(p_hunting_ground_id) u
  INTO uploads_json;

  -- Build the final result
  SELECT json_build_object(
    'hunting_ground', hunting_ground_json,
    'animals', animals_with_species_json,
    'animal_filters', animal_filters_json,
    'cameras', cameras_json,
    'sightings', sightings_json,
    'uploads', uploads_json
  ) INTO result;
  
  RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permissions for the new functions
GRANT EXECUTE ON FUNCTION public.get_hunting_ground_animals_with_species(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_hunting_ground_data_with_references(UUID) TO authenticated; 


-- Grant execute permission on functions to authenticated users
GRANT EXECUTE ON FUNCTION public.has_hunting_ground_permission(UUID, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_hunting_ground_animals(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_hunting_ground_animal_filters(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_hunting_ground_cameras(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_hunting_ground_sightings(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_hunting_ground_uploads(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_hunting_ground_data(UUID) TO authenticated;

-- Usage examples for frontend developers:
/*
  1. Get all data for a hunting ground in a single request:
  
  const { data, error } = await supabase
    .rpc('get_hunting_ground_data', { hunting_ground_id: '00000000-0000-0000-0000-000000000000' })
  
  // This returns a JSON object with all related data:
  {
    "hunting_ground": {...},
    "animals": [...],
    "animal_filters": [...],
    "cameras": [...],
    "sightings": [...],
    "uploads": [...]
  }
  
  2. Get just the animals for a hunting ground:
  
  const { data, error } = await supabase
    .rpc('get_hunting_ground_animals', { hunting_ground_id: '00000000-0000-0000-0000-000000000000' })
  
  3. Get just the sightings for a hunting ground:
  
  const { data, error } = await supabase
    .rpc('get_hunting_ground_sightings', { hunting_ground_id: '00000000-0000-0000-0000-000000000000' })
*/ 