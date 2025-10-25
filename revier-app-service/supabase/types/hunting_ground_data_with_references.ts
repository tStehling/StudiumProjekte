/**
 * TypeScript type definitions for the Hunting Ground Data API with resolved references
 * Use these types with the get_hunting_ground_data_with_references function.
 */

// Species type
export interface Species {
  id: string;
  name: string;
  is_pest: boolean;
}

// Country type
export interface Country {
  id: string;
  name: string;
}

// Federal State type
export interface FederalState {
  id: string;
  name: string;
  country: Country;
}

// Animal with species type
export interface AnimalWithSpecies {
  id: string;
  hunting_ground_id: string;
  name: string;
  dead: boolean;
  age: number | null;
  weight: number | null;
  abnormalities: string | null;
  shooting_priority: number | null;
  notes: string | null;
  shooting_id: string | null;
  species_id: string;
  custom_color: number | null;
  is_deleted: boolean;
  created_at: string;
  updated_at: string;
  deleted_at: string | null;
  // Referenced data
  species: Species;
}

// Animal Filter type
export interface AnimalFilter {
  id: string;
  hunting_ground_id: string;
  name: string;
  description: string | null;
  filter_criteria: Record<string, any>;
  is_deleted: boolean;
  created_at: string;
  updated_at: string;
}

// Camera type
export interface Camera {
  id: string;
  name: string;
  description: string | null;
  latitude: number;
  longitude: number;
  is_deleted: boolean;
  created_at: string;
  updated_at: string;
}

// Sighting with species type
export interface SightingWithSpecies {
  id: string;
  species_id: string;
  group_type: string | null;
  animal_count: number;
  animal_count_precision: number;
  weather_condition_id: string | null;
  camera_id: string | null;
  upload_id: string | null;
  latitude: number;
  longitude: number;
  sighting_start: string;
  sighting_end: string;
  is_deleted: boolean;
  created_at: string;
  updated_at: string;
  // Referenced data
  species: Species;
}

// Upload type
export interface Upload {
  id: string;
  status: string;
  camera_id: string | null;
  latitude: number | null;
  longitude: number | null;
  created_by_id: string | null;
  created_at: string;
  updated_at: string;
  is_deleted: boolean;
}

// Hunting Ground type with federal state
export interface HuntingGroundWithReferences {
  id: string;
  name: string;
  federal_state_id: string;
  created_at: string;
  updated_at: string;
  deleted_at: string | null;
  is_deleted: boolean;
  // Referenced data
  federal_state: FederalState;
}

// Complete Hunting Ground Data response type with references
export interface HuntingGroundDataWithReferences {
  hunting_ground: HuntingGroundWithReferences;
  animals: AnimalWithSpecies[];
  animal_filters: AnimalFilter[];
  cameras: Camera[];
  sightings: SightingWithSpecies[];
  uploads: Upload[];
}

/**
 * Example usage:
 * 
 * import { HuntingGroundDataWithReferences } from './types/hunting_ground_data_with_references';
 * 
 * // Get all data for a hunting ground with references
 * const { data, error } = await supabase
 *   .rpc('get_hunting_ground_data_with_references', { hunting_ground_id: '00000000-0000-0000-0000-000000000000' });
 * 
 * // Type the response
 * const huntingGroundData = data as HuntingGroundDataWithReferences;
 * 
 * // Access nested referenced data
 * console.log(`Hunting ground: ${huntingGroundData.hunting_ground.name}`);
 * console.log(`Federal state: ${huntingGroundData.hunting_ground.federal_state.name}`);
 * console.log(`Country: ${huntingGroundData.hunting_ground.federal_state.country.name}`);
 * 
 * // Access species data for an animal
 * const animal = huntingGroundData.animals[0];
 * console.log(`Animal: ${animal.name}, Species: ${animal.species.name}`);
 */ 