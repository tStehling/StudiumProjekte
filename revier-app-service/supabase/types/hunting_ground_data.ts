/**
 * TypeScript type definitions for the Hunting Ground Data API
 * Use these types with the get_hunting_ground_data function.
 */

// Animal type
export interface Animal {
  id: string;
  hunting_ground_id: string;
  species_id: number;
  name: string;
  tag_number: string | null;
  dob: string | null;
  gender: 'male' | 'female' | null;
  weight: number | null;
  is_deleted: boolean;
  created_at: string;
  updated_at: string;
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
  location: { lat: number; lng: number } | null;
  is_deleted: boolean;
  created_at: string;
  updated_at: string;
}

// Sighting type
export interface Sighting {
  id: string;
  upload_id: string | null;
  camera_id: string | null;
  sighting_date: string;
  location: { lat: number; lng: number } | null;
  is_deleted: boolean;
  created_at: string;
  updated_at: string;
}

// Upload type
export interface Upload {
  id: string;
  user_id: string;
  storage_path: string;
  content_type: string;
  file_name: string;
  is_deleted: boolean;
  created_at: string;
  updated_at: string;
}

// Hunting Ground type
export interface HuntingGround {
  id: string;
  name: string;
  description: string | null;
  location: { lat: number; lng: number } | null;
  boundary: any | null;
  federal_state_id: number | null;
  is_deleted: boolean;
  created_at: string;
  updated_at: string;
}

// Complete Hunting Ground Data response type
export interface HuntingGroundData {
  hunting_ground: HuntingGround;
  animals: Animal[];
  animal_filters: AnimalFilter[];
  cameras: Camera[];
  sightings: Sighting[];
  uploads: Upload[];
}

/**
 * Example usage:
 * 
 * import { HuntingGroundData } from './types/hunting_ground_data';
 * 
 * // Get all data for a hunting ground
 * const { data, error } = await supabase
 *   .rpc('get_hunting_ground_data', { hunting_ground_id: '00000000-0000-0000-0000-000000000000' })
 * 
 * // Type the response
 * const huntingGroundData = data as HuntingGroundData;
 * 
 * // Access specific data
 * console.log(huntingGroundData.hunting_ground.name);
 * console.log(huntingGroundData.animals.length);
 */ 