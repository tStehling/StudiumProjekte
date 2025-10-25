import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:brick_core/query.dart';
import 'package:revier_app_client/brick/models/sighting.model.dart';
import 'package:revier_app_client/brick/models/species.model.dart';
import 'package:revier_app_client/brick/models/weather_condition.model.dart';
import 'package:revier_app_client/brick/models/camera.model.dart';
import 'package:revier_app_client/brick/models/hunting_ground.model.dart';
import 'package:revier_app_client/brick/models/upload.model.dart';
import 'package:revier_app_client/common/model_management/index.dart';
import 'package:revier_app_client/data/model_registry.dart';
import 'package:revier_app_client/data/providers/model_registry_provider.dart'
    show modelRegistryProvider;
import 'package:revier_app_client/data/providers/widget_ref_provider.dart';
import 'package:revier_app_client/data/reference_data_service.dart';
import 'package:revier_app_client/data/reference_data_sync_service.dart';
import 'package:revier_app_client/data/repositories/generic_repository.dart';
import 'package:revier_app_client/features/hunting_ground/providers/hunting_ground_provider.dart';
import 'package:revier_app_client/presentation/state/generic_model_notifier.dart';
import 'package:revier_app_client/core/services/logging_service.dart';

/// Model handler for Sighting entities.
class SightingModelHandler implements ModelHandler<Sighting> {
  final ReferenceDataService? _referenceService;
  static final _log = loggingService.getLogger('SightingModelHandler');

  /// Creates a new SightingModelHandler.
  ///
  /// If [referenceService] is not provided, it will use the provider to get it.
  SightingModelHandler({ReferenceDataService? referenceService})
      : _referenceService = referenceService;

  // Get reference service from provider or use injected service
  ReferenceDataService _getRefService(WidgetRef ref) {
    // Reference to the ModelRegistry is needed to access referenceDataServiceProvider
    // This is a workaround until we have the proper provider
    return _referenceService ?? ReferenceDataService(getModelRegistry(ref));
  }

  @override
  String get modelTitle => 'Sighting';

  @override
  List<String> get listDisplayFields => ['species', 'sightingStart'];

  @override
  List<String> get searchableFields =>
      ['species.name', 'groupType', 'sightingStart'];

  @override
  Map<String, FieldConfig> get fieldConfigurations => {
        'speciesId': FieldConfig(
          label: 'Species',
          fieldType: FieldType.relation,
          isRequired: true,
          isVisibleInDetail: false,
          icon: Icons.pets,
          optionsLoader: () => _loadSpeciesOptions(null),
        ),
        'species': FieldConfig(
          label: 'Species',
          fieldType: FieldType.relation,
          isEditable: false,
          isRequired: true,
          icon: Icons.pets,
        ),
        'groupType': FieldConfig(
          label: 'Group Type',
          fieldType: FieldType.text,
          hint: 'E.g., Herd, Pair, Solo',
        ),
        'animalCount': FieldConfig(
          label: 'Animal Count',
          fieldType: FieldType.number,
          isRequired: true,
          icon: Icons.numbers,
          validator: (value) {
            if (value != null && value is num) {
              if (value <= 0) {
                return 'Count must be greater than 0';
              }
            }
            return null;
          },
        ),
        'animalCountPrecision': FieldConfig(
          label: 'Count Precision',
          fieldType: FieldType.dropdown,
          hint: 'How precise is the count?',
          options: [
            DropdownOption(value: 0, label: 'Exact'),
            DropdownOption(value: 1, label: 'Approximate'),
            DropdownOption(value: 2, label: 'Estimated'),
          ],
        ),
        'weatherConditionId': FieldConfig(
          label: 'Weather Condition',
          fieldType: FieldType.relation,
          isVisibleInDetail: false,
          icon: Icons.cloud,
          optionsLoader: () => _loadWeatherConditionOptions(null),
        ),
        'weatherCondition': FieldConfig(
          label: 'Weather Condition',
          fieldType: FieldType.relation,
          isEditable: false,
          icon: Icons.cloud,
        ),
        'cameraId': FieldConfig(
          label: 'Camera',
          fieldType: FieldType.relation,
          isVisibleInDetail: false,
          icon: Icons.camera_alt,
          optionsLoader: () => _loadCameraOptions(null),
        ),
        'camera': FieldConfig(
          label: 'Camera',
          fieldType: FieldType.relation,
          isEditable: false,
          icon: Icons.camera_alt,
        ),
        'latitude': FieldConfig(
          label: 'Latitude',
          fieldType: FieldType.number,
          isRequired: true,
          validator: (value) {
            if (value != null && value is num) {
              if (value < -90 || value > 90) {
                return 'Must be between -90 and 90';
              }
            }
            return null;
          },
        ),
        'longitude': FieldConfig(
          label: 'Longitude',
          fieldType: FieldType.number,
          isRequired: true,
          validator: (value) {
            if (value != null && value is num) {
              if (value < -180 || value > 180) {
                return 'Must be between -180 and 180';
              }
            }
            return null;
          },
        ),
        'location': FieldConfig(
          label: 'Location',
          fieldType: FieldType.location,
          customFieldBuilder: (context, value, onChanged) {
            // Custom location picker could be implemented here
            return ListTile(
              title: const Text('Location'),
              subtitle: value != null
                  ? Text(
                      'Lat: ${value['latitude']}, Lng: ${value['longitude']}')
                  : const Text('No location selected'),
              onTap: () {
                // Show location picker
              },
            );
          },
        ),
        'sightingStart': FieldConfig(
          label: 'Start Time',
          fieldType: FieldType.dateTime,
          isRequired: true,
          icon: Icons.access_time,
          formatter: (value) =>
              DateFormat('yyyy-MM-dd HH:mm').format(value as DateTime),
        ),
        'sightingEnd': FieldConfig(
          label: 'End Time',
          fieldType: FieldType.dateTime,
          isRequired: true,
          icon: Icons.access_time,
          formatter: (value) =>
              DateFormat('yyyy-MM-dd HH:mm').format(value as DateTime),
          validator: (value) {
            // Validate that end time is after start time
            // This would require access to sightingStart value
            return null;
          },
        ),
      };

  /// Get field configurations with context-aware optionsLoaders
  @override
  Map<String, FieldConfig> getFieldConfigurations(WidgetRef ref) {
    final configs = Map<String, FieldConfig>.from(fieldConfigurations);

    // Replace relation field optionsLoaders with context-aware versions
    configs['speciesId'] = configs['speciesId']!.copyWith(
      optionsLoader: () => _loadSpeciesOptions(ref),
    );

    configs['weatherConditionId'] = configs['weatherConditionId']!.copyWith(
      optionsLoader: () => _loadWeatherConditionOptions(ref),
    );

    configs['cameraId'] = configs['cameraId']!.copyWith(
      optionsLoader: () => _loadCameraOptions(ref),
    );

    return configs;
  }

  Future<List<DropdownOption<dynamic>>> _loadSpeciesOptions(
      WidgetRef? ref) async {
    if (ref == null) {
      // Fallback for when we don't have a WidgetRef
      return [
        DropdownOption<String>(value: 'species1', label: 'Deer'),
        DropdownOption<String>(value: 'species2', label: 'Boar'),
        DropdownOption<String>(value: 'species3', label: 'Fox'),
      ];
    }

    return await _getRefService(ref).getDropdownOptions<Species>(
      ref,
      valueField: 'id',
      labelField: 'name',
      includeEmpty: true,
      emptyLabel: '-- Select Species --',
    );
  }

  Future<List<DropdownOption<dynamic>>> _loadWeatherConditionOptions(
      WidgetRef? ref) async {
    if (ref == null) {
      // Fallback for when we don't have a WidgetRef
      return [
        DropdownOption<String>(value: 'weather1', label: 'Sunny'),
        DropdownOption<String>(value: 'weather2', label: 'Cloudy'),
        DropdownOption<String>(value: 'weather3', label: 'Rainy'),
      ];
    }

    return await _getRefService(ref).getDropdownOptions<WeatherCondition>(
      ref,
      valueField: 'id',
      labelField: 'timestamp',
      labelFormatter: (weatherCondition) {
        final timestamp = weatherCondition.timestamp;
        final temp = weatherCondition.temperature;
        return timestamp != null
            ? 'Weather on ${DateFormat('yyyy-MM-dd').format(timestamp)} - ${temp != null ? '$temp°C' : 'Unknown temp'}'
            : 'Weather (no timestamp)';
      },
      includeEmpty: true,
      emptyLabel: '-- Select Weather --',
    );
  }

  Future<List<DropdownOption<dynamic>>> _loadCameraOptions(
      WidgetRef? ref) async {
    if (ref == null) {
      // Fallback for when we don't have a WidgetRef
      return [
        DropdownOption<String>(value: 'camera1', label: 'Trail Cam 1'),
        DropdownOption<String>(value: 'camera2', label: 'Trail Cam 2'),
      ];
    }

    return await _getRefService(ref).getDropdownOptions<Camera>(
      ref,
      valueField: 'id',
      labelField: 'name',
      includeEmpty: true,
      emptyLabel: '-- Select Camera --',
    );
  }

  @override
  ModelRegistry getModelRegistry(WidgetRef ref) {
    return ref.read(modelRegistryProvider);
  }

  @override
  GenericModelNotifier<Sighting> getNotifier(WidgetRef ref) {
    return getModelRegistry(ref).getNotifier<Sighting>(ref);
  }

  @override
  GenericRepository<Sighting> getRepository(WidgetRef ref) {
    return ref.read(getModelRegistry(ref).getRepositoryProvider<Sighting>());
  }

  @override
  Future<List<Sighting>> fetchAll(WidgetRef ref) async {
    try {
      _log.debug('Fetching all sightings');
      return await getRepository(ref).getAll();
    } catch (e) {
      _log.error('Error fetching all sightings', error: e);
      return [];
    }
  }

  @override
  Future<List<Sighting>> fetchWhere(WidgetRef ref,
      {required Query query}) async {
    try {
      _log.debug('Fetching sightings with query');
      return await getRepository(ref).getWhere(query: query);
    } catch (e) {
      _log.error('Error fetching sightings with query $query', error: e);
      return [];
    }
  }

  @override
  Future<Sighting?> fetchById(WidgetRef ref, String id) async {
    try {
      _log.debug('Fetching sighting by ID: $id');
      return await getRepository(ref).getById(id);
    } catch (e) {
      _log.error('Error fetching sighting by ID: $id', error: e);
      return null;
    }
  }

  @override
  Future<Sighting> save(WidgetRef ref, Sighting entity) async {
    try {
      final registry = getModelRegistry(ref);

      // Determine if this is a new entity or an update
      final isNewEntity = getEntityId(entity).isEmpty;

      if (isNewEntity) {
        _log.debug('Creating new sighting');
        await registry.create<Sighting>(ref, entity);
      } else {
        _log.debug('Updating sighting with ID: ${entity.id}');
        await registry.update<Sighting>(ref, entity);
      }

      return entity;
    } catch (e) {
      _log.error('Error saving sighting', error: e);
      throw Exception('Failed to save sighting: ${e.toString()}');
    }
  }

  @override
  Future<void> delete(WidgetRef ref, Sighting entity) async {
    try {
      _log.debug('Deleting sighting with ID: ${entity.id}');
      await getModelRegistry(ref).delete<Sighting>(ref, entity);
    } catch (e) {
      _log.error('Error deleting sighting', error: e);
      throw Exception('Failed to delete sighting: ${e.toString()}');
    }
  }

  @override
  Future<void> syncWithServer(WidgetRef ref) async {
    try {
      _log.debug('Syncing sightings with server');
      await getModelRegistry(ref).sync<Sighting>(ref);
    } catch (e) {
      _log.error('Error syncing sightings with server', error: e);
      throw Exception('Failed to sync sightings with server: ${e.toString()}');
    }
  }

  @override
  Future<void> refresh(WidgetRef ref) async {
    try {
      _log.debug('Refreshing sightings');
      await getModelRegistry(ref).refresh<Sighting>(ref);
    } catch (e) {
      _log.error('Error refreshing sightings', error: e);
      throw Exception('Failed to refresh sightings: ${e.toString()}');
    }
  }

  @override
  Future<Sighting> createNew() async {
    _log.debug('Creating new sighting');
    try {
      // Create a new sighting with default values
      final ref = GlobalRef().ref;
      final species = await ref.read(speciesProvider);
      final huntingGround = await ref.read(selectedHuntingGroundProvider);

      if (huntingGround == null) {
        _log.warning('No hunting ground selected when creating new sighting');
        throw Exception('No hunting ground selected');
      }

      _log.debug(
          'Creating sighting with hunting ground: ${huntingGround.name} (${huntingGround.id})');

      return Sighting(
        species: species.first,
        huntingGround: huntingGround,
        animalCount: 1,
        latitude: 0,
        longitude: 0,
        sightingStart: DateTime.now(),
        sightingEnd: DateTime.now().add(const Duration(minutes: 30)),
      );
    } catch (e) {
      _log.error('Failed to create new sighting', error: e);
      throw Exception('Failed to create new sighting: ${e.toString()}');
    }
  }

  @override
  dynamic getFieldValue(Sighting entity, String fieldName) {
    try {
      switch (fieldName) {
        case 'id':
          return entity.id;
        case 'species':
          return entity.species;
        case 'speciesId':
          return entity.speciesId;
        case 'huntingGround':
          return entity.huntingGround;
        case 'huntingGroundId':
          return entity.huntingGroundId;
        case 'groupType':
          return entity.groupType;
        case 'animalCount':
          return entity.animalCount;
        case 'animalCountPrecision':
          return entity.animalCountPrecision;
        case 'weatherCondition':
          return entity.weatherCondition;
        case 'weatherConditionId':
          return entity.weatherConditionId;
        case 'camera':
          return entity.camera;
        case 'cameraId':
          return entity.cameraId;
        case 'upload':
          return entity.upload;
        case 'uploadId':
          return entity.uploadId;
        case 'latitude':
          return entity.latitude;
        case 'longitude':
          return entity.longitude;
        case 'location':
          return {'latitude': entity.latitude, 'longitude': entity.longitude};
        case 'sightingStart':
          return entity.sightingStart;
        case 'sightingEnd':
          return entity.sightingEnd;
        case 'createdAt':
          return entity.createdAt;
        case 'updatedAt':
          return entity.updatedAt;
        case 'deletedAt':
          return entity.deletedAt;
        case 'isDeleted':
          return entity.isDeleted;
        default:
          _log.warning('Attempted to get unknown field: $fieldName');
          return null;
      }
    } catch (e) {
      _log.error('Error getting field value for $fieldName', error: e);
      return null;
    }
  }

  @override
  String formatDisplayValue(String fieldName, dynamic value) {
    if (value == null) return '';

    try {
      switch (fieldName) {
        case 'species':
          return value is Species ? value.name : '';
        case 'huntingGround':
          return value is HuntingGround ? value.name : '';
        case 'weatherCondition':
          if (value is WeatherCondition) {
            return 'Temperature: ${value.temperature}°C, Wind: ${value.windSpeed} km/h';
          }
          return '';
        case 'camera':
          return value is Camera ? value.name : '';
        case 'upload':
          return value is Upload ? 'Upload ${value.id}' : '';
        case 'sightingStart':
        case 'sightingEnd':
        case 'createdAt':
        case 'updatedAt':
        case 'deletedAt':
          if (value is DateTime) {
            return DateFormat('yyyy-MM-dd HH:mm').format(value);
          }
          return value.toString();
        case 'location':
          if (value is Map) {
            return 'Lat: ${value['latitude']}, Lng: ${value['longitude']}';
          }
          return value.toString();
        case 'isDeleted':
          return value == true ? 'Yes' : 'No';
        default:
          return value.toString();
      }
    } catch (e) {
      _log.error('Error formatting display value for $fieldName', error: e);
      return value?.toString() ?? '';
    }
  }

  @override
  Map<String, String?> validate(Sighting entity, [BuildContext? context]) {
    final errors = <String, String?>{};

    try {
      // Check required fields
      if (entity.species == null) {
        errors['species'] = 'Species is required';
      }

      if (entity.animalCount <= 0) {
        errors['animalCount'] = 'Animal count must be greater than 0';
      }

      if (entity.latitude < -90 || entity.latitude > 90) {
        errors['latitude'] = 'Latitude must be between -90 and 90';
      }

      if (entity.longitude < -180 || entity.longitude > 180) {
        errors['longitude'] = 'Longitude must be between -180 and 180';
      }

      // Check time relationship - both fields are required in the model
      if (entity.sightingEnd.isBefore(entity.sightingStart)) {
        errors['sightingEnd'] = 'End time must be after start time';
      }

      // Log validation result
      if (errors.isEmpty) {
        _log.debug('Sighting validation passed');
      } else {
        _log.debug('Sighting validation failed with errors: $errors');
      }

      return errors;
    } catch (e) {
      _log.error('Error validating sighting', error: e);
      errors['general'] = 'Validation error occurred';
      return errors;
    }
  }

  @override
  Sighting setFieldValue(Sighting entity, String fieldName, dynamic value) {
    try {
      switch (fieldName) {
        case 'groupType':
          return entity.copyWith(groupType: value);
        case 'animalCount':
          return entity.copyWith(animalCount: value);
        case 'animalCountPrecision':
          return entity.copyWith(animalCountPrecision: value);
        case 'species':
          if (value is Species) {
            return entity.copyWith(species: value);
          }
          return entity;
        case 'speciesId':
          // Cannot set speciesId directly, should be set via setRelationFieldValue
          _log.warning(
              'Cannot set speciesId directly - use setRelationFieldValue instead');
          return entity;
        case 'huntingGround':
          if (value is HuntingGround) {
            return entity.copyWith(huntingGround: value);
          }
          return entity;
        case 'huntingGroundId':
          // Cannot set huntingGroundId directly
          _log.warning(
              'Cannot set huntingGroundId directly - use setRelationFieldValue instead');
          return entity;
        case 'weatherCondition':
          if (value is WeatherCondition) {
            return entity.copyWith(weatherCondition: value);
          }
          return entity;
        case 'weatherConditionId':
          // Cannot set weatherConditionId directly
          _log.warning(
              'Cannot set weatherConditionId directly - use setRelationFieldValue instead');
          return entity;
        case 'camera':
          if (value is Camera) {
            return entity.copyWith(camera: value);
          }
          return entity;
        case 'cameraId':
          // Cannot set cameraId directly
          _log.warning(
              'Cannot set cameraId directly - use setRelationFieldValue instead');
          return entity;
        case 'upload':
          if (value is Upload) {
            return entity.copyWith(upload: value);
          }
          return entity;
        case 'uploadId':
          // Cannot set uploadId directly
          _log.warning(
              'Cannot set uploadId directly - use setRelationFieldValue instead');
          return entity;
        case 'latitude':
          return entity.copyWith(latitude: value);
        case 'longitude':
          return entity.copyWith(longitude: value);
        case 'location':
          if (value is Map) {
            return entity.copyWith(
              latitude: value['latitude'],
              longitude: value['longitude'],
            );
          }
          return entity;
        case 'sightingStart':
          return entity.copyWith(sightingStart: value);
        case 'sightingEnd':
          return entity.copyWith(sightingEnd: value);
        // Typically these fields are managed by the system, but adding for completeness
        case 'createdAt':
          return entity.copyWith(createdAt: value);
        case 'updatedAt':
          return entity.copyWith(updatedAt: value);
        case 'deletedAt':
          return entity.copyWith(deletedAt: value);
        case 'isDeleted':
          return entity.copyWith(isDeleted: value);
        default:
          _log.warning('Attempted to set unknown field: $fieldName');
          return entity;
      }
    } catch (e) {
      _log.error('Error setting field value for $fieldName', error: e);
      return entity;
    }
  }

  @override
  String getEntityId(Sighting entity) {
    return entity.id;
  }

  @override
  String getDisplayText(Sighting entity) {
    final speciesName = entity.species?.name ?? 'Unknown Species';
    final date = DateFormat('yyyy-MM-dd').format(entity.sightingStart);

    return '$speciesName - $date';
  }

  @override
  Future<Sighting> setRelationFieldValue(
    WidgetRef ref,
    Sighting entity,
    String fieldName,
    String relationId,
  ) async {
    try {
      _log.debug('Setting relation field "$fieldName" with ID: "$relationId"');

      // Handle null or empty ID cases correctly
      if (relationId.isEmpty) {
        _log.debug('Empty relationId for field "$fieldName", setting to null');
        switch (fieldName) {
          case 'speciesId':
            return entity.copyWith(species: null);
          case 'weatherConditionId':
            return entity.copyWith(weatherCondition: null);
          case 'cameraId':
            return entity.copyWith(camera: null);
          case 'uploadId':
            return entity.copyWith(upload: null);
          // HuntingGround is required so we don't null it out
          default:
            return entity;
        }
      }

      // Process non-empty relation IDs
      switch (fieldName) {
        case 'speciesId':
          final speciesRepo =
              ref.read(getModelRegistry(ref).getRepositoryProvider<Species>());
          _log.debug('Fetching species with ID: "$relationId"');
          final species = await speciesRepo.getById(relationId);
          if (species == null) {
            _log.warning('Failed to find species with ID: "$relationId"');
          } else {
            _log.debug('Found species: ${species.name} (${species.id})');
            return entity.copyWith(species: species);
          }
          return entity;

        case 'huntingGroundId':
          final huntingGroundRepo = ref.read(
              getModelRegistry(ref).getRepositoryProvider<HuntingGround>());
          _log.debug('Fetching hunting ground with ID: "$relationId"');
          final huntingGround = await huntingGroundRepo.getById(relationId);
          if (huntingGround == null) {
            _log.warning(
                'Failed to find hunting ground with ID: "$relationId"');
          } else {
            _log.debug(
                'Found hunting ground: ${huntingGround.name} (${huntingGround.id})');
            return entity.copyWith(huntingGround: huntingGround);
          }
          return entity;

        case 'weatherConditionId':
          final weatherConditionRepo = ref.read(
              getModelRegistry(ref).getRepositoryProvider<WeatherCondition>());
          _log.debug('Fetching weather condition with ID: "$relationId"');
          final weatherCondition =
              await weatherConditionRepo.getById(relationId);
          if (weatherCondition == null) {
            _log.warning(
                'Failed to find weather condition with ID: "$relationId"');
          } else {
            _log.debug(
                'Found weather condition with ID: ${weatherCondition.id}');
            return entity.copyWith(weatherCondition: weatherCondition);
          }
          return entity;

        case 'cameraId':
          final cameraRepo =
              ref.read(getModelRegistry(ref).getRepositoryProvider<Camera>());
          _log.debug('Fetching camera with ID: "$relationId"');
          final camera = await cameraRepo.getById(relationId);
          if (camera == null) {
            _log.warning('Failed to find camera with ID: "$relationId"');
          } else {
            _log.debug('Found camera: ${camera.name} (${camera.id})');
            return entity.copyWith(camera: camera);
          }
          return entity;

        case 'uploadId':
          final uploadRepo =
              ref.read(getModelRegistry(ref).getRepositoryProvider<Upload>());
          _log.debug('Fetching upload with ID: "$relationId"');
          final upload = await uploadRepo.getById(relationId);
          if (upload == null) {
            _log.warning('Failed to find upload with ID: "$relationId"');
          } else {
            _log.debug('Found upload with ID: ${upload.id}');
            return entity.copyWith(upload: upload);
          }
          return entity;

        default:
          _log.warning('Attempted to set unknown relation field: "$fieldName"');
          return entity;
      }
    } catch (e) {
      _log.error('Error setting relation field "$fieldName"', error: e);
      // Return the original entity to avoid crashes
      return entity;
    }
  }
}
