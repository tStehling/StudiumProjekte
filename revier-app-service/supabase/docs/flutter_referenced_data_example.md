# Handling Referenced Data in Flutter

This guide shows how to efficiently handle referenced data (like species information for animals) in your Flutter app using our enhanced Supabase functions.

## Problem

When working with foreign key relationships in Supabase, references are not automatically resolved. For example, when you retrieve an animal with a `species_id`, Supabase doesn't automatically include the full species data.

## Solution

We've created enhanced PostgreSQL functions that include resolved references directly in the response:

1. `get_hunting_ground_animals_with_species`: Returns animals with their species information
2. `get_hunting_ground_data_with_references`: Returns all hunting ground data with resolved references

## Flutter Implementation

### 1. Create Model Classes

First, create Dart model classes that match the JSON structure returned by our functions:

```dart
// species.dart
class Species {
  final String id;
  final String name;
  final bool isPest;

  Species({
    required this.id,
    required this.name,
    required this.isPest,
  });

  factory Species.fromJson(Map<String, dynamic> json) {
    return Species(
      id: json['id'],
      name: json['name'],
      isPest: json['is_pest'],
    );
  }
}

// animal_with_species.dart
class AnimalWithSpecies {
  final String id;
  final String huntingGroundId;
  final String name;
  final bool dead;
  final double? age;
  final double? weight;
  final String? abnormalities;
  final int? shootingPriority;
  final String? notes;
  final String? shootingId;
  final String speciesId;
  final int? customColor;
  final Species species;  // Embedded species data

  AnimalWithSpecies({
    required this.id,
    required this.huntingGroundId,
    required this.name,
    required this.dead,
    this.age,
    this.weight,
    this.abnormalities,
    this.shootingPriority,
    this.notes,
    this.shootingId,
    required this.speciesId,
    this.customColor,
    required this.species,
  });

  factory AnimalWithSpecies.fromJson(Map<String, dynamic> json) {
    return AnimalWithSpecies(
      id: json['id'],
      huntingGroundId: json['hunting_ground_id'],
      name: json['name'],
      dead: json['dead'],
      age: json['age'],
      weight: json['weight'],
      abnormalities: json['abnormalities'],
      shootingPriority: json['shooting_priority'],
      notes: json['notes'],
      shootingId: json['shooting_id'],
      speciesId: json['species_id'],
      customColor: json['custom_color'],
      species: Species.fromJson(json['species']),
    );
  }
}
```

### 2. Create a Service to Fetch Data

```dart
// hunting_ground_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'animal_with_species.dart';

class HuntingGroundService {
  final SupabaseClient _supabase;

  HuntingGroundService(this._supabase);

  // Get all animals with species for a hunting ground
  Future<List<AnimalWithSpecies>> getAnimalsWithSpecies(String huntingGroundId) async {
    final response = await _supabase
        .rpc('get_hunting_ground_animals_with_species', params: {'hunting_ground_id': huntingGroundId});
        
    if (response.error != null) {
      throw response.error!;
    }
    
    return (response.data as List)
        .map((json) => AnimalWithSpecies.fromJson(json))
        .toList();
  }

  // Get all hunting ground data with references
  Future<Map<String, dynamic>> getHuntingGroundWithReferences(String huntingGroundId) async {
    final response = await _supabase
        .rpc('get_hunting_ground_data_with_references', params: {'hunting_ground_id': huntingGroundId});
        
    if (response.error != null) {
      throw response.error!;
    }
    
    // Convert response data to your model classes
    // This is a simplified example - you would create full models for all data types
    final data = response.data;
    return {
      'hunting_ground': data['hunting_ground'],
      'animals': (data['animals'] as List)
          .map((json) => AnimalWithSpecies.fromJson(json))
          .toList(),
      'sightings': data['sightings'],
      'cameras': data['cameras'],
      'uploads': data['uploads'],
      'animal_filters': data['animal_filters'],
    };
  }
}
```

### 3. Use in Flutter Widgets

```dart
// animals_list_screen.dart
import 'package:flutter/material.dart';
import 'hunting_ground_service.dart';
import 'animal_with_species.dart';

class AnimalsListScreen extends StatefulWidget {
  final String huntingGroundId;

  const AnimalsListScreen({Key? key, required this.huntingGroundId}) : super(key: key);

  @override
  _AnimalsListScreenState createState() => _AnimalsListScreenState();
}

class _AnimalsListScreenState extends State<AnimalsListScreen> {
  late HuntingGroundService _service;
  List<AnimalWithSpecies> _animals = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _service = HuntingGroundService(Supabase.instance.client);
    _loadAnimals();
  }

  Future<void> _loadAnimals() async {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });
      
      final animals = await _service.getAnimalsWithSpecies(widget.huntingGroundId);
      
      setState(() {
        _animals = animals;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text('Error: $_error'));
    }

    return ListView.builder(
      itemCount: _animals.length,
      itemBuilder: (context, index) {
        final animal = _animals[index];
        // Notice how we can directly access species information
        return ListTile(
          title: Text(animal.name),
          subtitle: Text('Species: ${animal.species.name}'),
          trailing: animal.species.isPest 
              ? const Icon(Icons.warning, color: Colors.red)
              : null,
        );
      },
    );
  }
}
```

## Benefits of This Approach

1. **Single Network Request**: Get all needed data in one call
2. **Type Safety**: Complete type definitions with nested objects
3. **Simplified UI Code**: Direct access to referenced data (animal.species.name)
4. **Reduced Data Processing**: Data structures are ready to use
5. **Consistent Data**: All references are resolved at the same point in time

## Handling Local Updates

When updating data locally, you'll need to ensure references stay in sync:

```dart
// Example of updating an animal while preserving species info
void updateAnimal(AnimalWithSpecies animal, String newName) {
  // Create a copy with the updated name but preserve the species reference
  final updatedAnimal = AnimalWithSpecies(
    id: animal.id,
    huntingGroundId: animal.huntingGroundId,
    name: newName,  // Updated name
    dead: animal.dead,
    speciesId: animal.speciesId,
    species: animal.species,  // Preserve the species reference
    // ... other properties ...
  );
  
  // Use the updated animal in your UI
  setState(() {
    final index = _animals.indexWhere((a) => a.id == animal.id);
    if (index >= 0) {
      _animals[index] = updatedAnimal;
    }
  });
  
  // Send the update to the server (omitting the species object)
  _supabase.from('animal').update({
    'name': newName,
    // ... other properties to update ...
  }).eq('id', animal.id);
}
```

## Using With State Management

This approach works well with state management solutions like Provider, Riverpod, or Bloc. For example, with Provider:

```dart
// animals_provider.dart
import 'package:flutter/foundation.dart';
import 'animal_with_species.dart';
import 'hunting_ground_service.dart';

class AnimalsProvider with ChangeNotifier {
  final HuntingGroundService _service;
  List<AnimalWithSpecies> _animals = [];
  bool _loading = false;
  String? _error;

  AnimalsProvider(this._service);

  List<AnimalWithSpecies> get animals => _animals;
  bool get isLoading => _loading;
  String? get error => _error;

  Future<void> loadAnimals(String huntingGroundId) async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();
      
      _animals = await _service.getAnimalsWithSpecies(huntingGroundId);
      
      _loading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
    }
  }
}
``` 