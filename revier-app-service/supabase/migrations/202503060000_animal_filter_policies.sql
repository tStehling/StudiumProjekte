-- Enable RLS on animal_filter table
ALTER TABLE animal_filter ENABLE ROW LEVEL SECURITY;

-- Create policies for animal_filter table
CREATE POLICY "Users can read animal filters with permission"
  ON animal_filter
  FOR SELECT
  USING (
    has_hunting_ground_permission(animal_filter.hunting_ground_id, 'hunting_ground.read') OR
    auth.jwt() ->> 'role' = 'service_role'
  );

CREATE POLICY "Users can create animal filters with permission"
  ON animal_filter
  FOR INSERT
  WITH CHECK (
    has_hunting_ground_permission(animal_filter.hunting_ground_id, 'hunting_ground.create') OR
    auth.jwt() ->> 'role' = 'service_role'
  );

CREATE POLICY "Users can update animal filters with permission"
  ON animal_filter
  FOR UPDATE
  USING (
    has_hunting_ground_permission(animal_filter.hunting_ground_id, 'hunting_ground.update') OR
    auth.jwt() ->> 'role' = 'service_role'
  )
  WITH CHECK (
    has_hunting_ground_permission(animal_filter.hunting_ground_id, 'hunting_ground.update') OR
    auth.jwt() ->> 'role' = 'service_role'
  );

CREATE POLICY "Users can delete animal filters with permission"
  ON animal_filter
  FOR DELETE
  USING (
    has_hunting_ground_permission(animal_filter.hunting_ground_id, 'hunting_ground.delete') OR
    auth.jwt() ->> 'role' = 'service_role'
  );

-- Enable RLS on animal_filter_animal and animal_filter_tag
ALTER TABLE animal_filter_animal ENABLE ROW LEVEL SECURITY;
ALTER TABLE animal_filter_tag ENABLE ROW LEVEL SECURITY;

-- Create policies for animal_filter_animal junction table
CREATE POLICY "Users can read animal filter animals with permission"
  ON animal_filter_animal
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM animal_filter
      WHERE animal_filter.id = animal_filter_animal.animal_filter_id
      AND has_hunting_ground_permission(animal_filter.hunting_ground_id, 'hunting_ground.read')
    ) OR
    auth.jwt() ->> 'role' = 'service_role'
  );

CREATE POLICY "Users can manage animal filter animals with permission"
  ON animal_filter_animal
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM animal_filter
      WHERE animal_filter.id = animal_filter_animal.animal_filter_id
      AND has_hunting_ground_permission(animal_filter.hunting_ground_id, 'hunting_ground.update')
    ) OR
    auth.jwt() ->> 'role' = 'service_role'
  );

-- Create policies for animal_filter_tag junction table
CREATE POLICY "Users can read animal filter tags with permission"
  ON animal_filter_tag
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM animal_filter
      WHERE animal_filter.id = animal_filter_tag.animal_filter_id
      AND has_hunting_ground_permission(animal_filter.hunting_ground_id, 'hunting_ground.read')
    ) OR
    auth.jwt() ->> 'role' = 'service_role'
  );

CREATE POLICY "Users can manage animal filter tags with permission"
  ON animal_filter_tag
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM animal_filter
      WHERE animal_filter.id = animal_filter_tag.animal_filter_id
      AND has_hunting_ground_permission(animal_filter.hunting_ground_id, 'hunting_ground.update')
    ) OR
    auth.jwt() ->> 'role' = 'service_role'
  ); 