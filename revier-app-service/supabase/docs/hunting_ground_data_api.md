# Hunting Ground Data API

This document describes the PostgreSQL functions created to easily retrieve all data related to a hunting ground. These functions simplify data fetching for the frontend by providing comprehensive data in a single request.

## Available Functions

### Main Function

- `get_hunting_ground_data(hunting_ground_id UUID)`: Returns all data related to a hunting ground in a single JSON object.

### Individual Data Functions

- `get_hunting_ground_animals(hunting_ground_id UUID)`: Returns all animals for a hunting ground.
- `get_hunting_ground_animal_filters(hunting_ground_id UUID)`: Returns all animal filters for a hunting ground.
- `get_hunting_ground_cameras(hunting_ground_id UUID)`: Returns all cameras related to a hunting ground.
- `get_hunting_ground_sightings(hunting_ground_id UUID)`: Returns all sightings related to a hunting ground.
- `get_hunting_ground_uploads(hunting_ground_id UUID)`: Returns all uploads related to a hunting ground.

## Helper Function

- `has_hunting_ground_permission(hunting_ground_id UUID, permission TEXT)`: Checks if the current user has a specific permission for a hunting ground.

## Security

All functions check permissions before returning data. A user can only access data for hunting grounds they have membership in with the proper permissions. The exception is admin users, who can access all hunting ground data.

## Usage in Frontend

### TypeScript Support

TypeScript type definitions are available in `supabase/types/hunting_ground_data.ts`.

### Example: Get All Data for a Hunting Ground

```typescript
import { createClient } from '@supabase/supabase-js';
import { HuntingGroundData } from './types/hunting_ground_data';

const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

async function getHuntingGroundData(huntingGroundId: string) {
  const { data, error } = await supabase
    .rpc('get_hunting_ground_data', { hunting_ground_id: huntingGroundId });
  
  if (error) {
    console.error('Error fetching hunting ground data:', error);
    return null;
  }
  
  return data as HuntingGroundData;
}

// Usage
const huntingGroundData = await getHuntingGroundData('00000000-0000-0000-0000-000000000000');
if (huntingGroundData) {
  console.log(`Hunting ground: ${huntingGroundData.hunting_ground.name}`);
  console.log(`Animals: ${huntingGroundData.animals.length}`);
  console.log(`Sightings: ${huntingGroundData.sightings.length}`);
}
```

### Example: Get Only Animals for a Hunting Ground

```typescript
import { createClient } from '@supabase/supabase-js';
import { Animal } from './types/hunting_ground_data';

const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

async function getHuntingGroundAnimals(huntingGroundId: string) {
  const { data, error } = await supabase
    .rpc('get_hunting_ground_animals', { hunting_ground_id: huntingGroundId });
  
  if (error) {
    console.error('Error fetching animals:', error);
    return [];
  }
  
  return data as Animal[];
}

// Usage
const animals = await getHuntingGroundAnimals('00000000-0000-0000-0000-000000000000');
console.log(`Found ${animals.length} animals`);
```

## Benefits Over Multiple Requests

Using these functions offers several advantages:

1. **Reduced Network Overhead**: A single HTTP request instead of multiple requests
2. **Improved Performance**: Data is fetched on the server side with optimized queries
3. **Simplified Frontend Code**: No need to manage multiple async requests and their states
4. **Built-in Security**: Permissions are checked server-side for all data
5. **Atomic Data**: All data is from the same point in time, avoiding consistency issues

## Error Handling

All functions will throw an exception if the user does not have permission to access the hunting ground. Handle these errors in your frontend code as shown in the examples above. 