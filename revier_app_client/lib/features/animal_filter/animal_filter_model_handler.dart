import 'dart:async';

import 'package:brick_core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revier_app_client/brick/models/animal_filter.model.dart';
import 'package:revier_app_client/brick/models/hunting_ground.model.dart';
import 'package:revier_app_client/brick/models/species.model.dart';
import 'package:revier_app_client/common/model_management/field_config.dart';
import 'package:revier_app_client/common/model_management/model_handler.dart';
import 'package:revier_app_client/data/providers/widget_ref_provider.dart';
import 'package:revier_app_client/data/reference_data_service.dart';
import 'package:revier_app_client/data/model_registry.dart';
import 'package:revier_app_client/data/providers/model_registry_provider.dart';
import 'package:flutter/material.dart';
import 'package:revier_app_client/core/services/logging_service.dart';
import 'package:revier_app_client/data/reference_data_sync_service.dart';
import 'package:revier_app_client/data/repositories/generic_repository.dart';
import 'package:revier_app_client/features/hunting_ground/providers/hunting_ground_provider.dart';
import 'package:revier_app_client/presentation/state/generic_model_notifier.dart';

/// Handles CRUD operations and form configuration for Animal Filters
class AnimalFilterModelHandler extends ModelHandler<AnimalFilter> {
  final ReferenceDataService? _referenceDataService;
  final _log = loggingService.getLogger('AnimalFilterModelHandler');

  AnimalFilterModelHandler([this._referenceDataService]);

  ReferenceDataService _getRefService(WidgetRef ref) {
    return _referenceDataService ?? ref.read(referenceDataServiceProvider);
  }

  @override
  String get modelTitle => 'Animal Filter';

  @override
  List<String> get listDisplayFields =>
      ['name', 'animalCount', 'animalCountType'];

  @override
  List<String> get searchableFields => ['name'];

  @override
  Map<String, FieldConfig> get fieldConfigurations => ({
        'name': FieldConfig(
          label: 'Filter Name',
          isRequired: true,
          fieldType: FieldType.text,
          icon: Icons.filter_list,
        ),
        'huntingGroundId': FieldConfig(
          label: 'Hunting Ground',
          isRequired: true,
          fieldType: FieldType.relation,
          isVisibleInDetail: false,
          icon: Icons.location_on,
        ),
        'huntingGround': FieldConfig(
          label: 'Hunting Ground',
          fieldType: FieldType.relation,
          isEditable: false,
          isRequired: true,
          icon: Icons.location_on,
        ),
        'speciesId': FieldConfig(
          label: 'Species',
          isRequired: true,
          fieldType: FieldType.relation,
          isVisibleInDetail: false,
          icon: Icons.pets,
        ),
        'species': FieldConfig(
          label: 'Species',
          fieldType: FieldType.relation,
          isEditable: false,
          isRequired: true,
          icon: Icons.pets,
        ),
        'animalCount': FieldConfig(
            label: 'Animal Count',
            isRequired: true,
            fieldType: FieldType.number,
            icon: Icons.numbers),
        'animalCountType': FieldConfig(
          label: 'Count Type',
          isRequired: true,
          fieldType: FieldType.dropdown,
          icon: Icons.format_list_numbered,
          options: [
            DropdownOption(value: 'exact', label: 'Exact'),
            DropdownOption(value: 'minimum', label: 'Minimum'),
            DropdownOption(value: 'maximum', label: 'Maximum'),
            DropdownOption(value: 'approximately', label: 'Approximately'),
          ],
        ),
        'customColor': FieldConfig(
          label: 'Custom Color',
          fieldType: FieldType.custom,
          icon: Icons.palette,
          customFieldBuilder: (context, value, onChanged) =>
              _buildColorPicker(context, value, onChanged),
        ),
      });

  @override
  Map<String, FieldConfig> getFieldConfigurations(WidgetRef? ref) {
    _log.debug('Getting field configurations');
    return {
      "name": fieldConfigurations['name']!,
      'huntingGroundId': fieldConfigurations["huntingGroundId"]!.copyWith(
        optionsLoader:
            ref == null ? null : () => _loadHuntingGroundOptions(ref),
      ),
      'huntingGround': fieldConfigurations['huntingGround']!,
      'speciesId': fieldConfigurations["speciesId"]!.copyWith(
        optionsLoader: ref == null ? null : () => _loadSpeciesOptions(ref),
      ),
      'species': fieldConfigurations['species']!,
      'animalCount': fieldConfigurations['animalCount']!,
      'animalCountType': fieldConfigurations['animalCountType']!,
      'customColor': fieldConfigurations['customColor']!,
    };
  }

  Widget _buildColorPicker(
      BuildContext context, dynamic value, Function(dynamic) onChanged) {
    final currentColor = value != null ? Color(value) : Colors.blue;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Choose a color for this filter:',
              style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              // Show color picker
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Pick a color'),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (final color in [
                            Colors.red,
                            Colors.orange,
                            Colors.yellow,
                            Colors.green,
                            Colors.blue,
                            Colors.indigo,
                            Colors.purple,
                            Colors.pink,
                            Colors.brown,
                            Colors.grey,
                          ])
                            InkWell(
                              onTap: () {
                                onChanged(color.value);
                                Navigator.of(context).pop();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 16.0,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      _colorToName(color),
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: currentColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Loads dropdown options for hunting grounds
  Future<List<DropdownOption<dynamic>>> _loadHuntingGroundOptions(
      WidgetRef ref) async {
    return await _getRefService(ref).getDropdownOptions<HuntingGround>(
      ref,
      valueField: 'id',
      labelField: 'name',
      cacheKey: 'hunting_grounds_options',
      includeEmpty: false,
      emptyLabel: '-- Select Hunting Ground --',
    );
  }

  /// Loads dropdown options for species
  Future<List<DropdownOption<dynamic>>> _loadSpeciesOptions(
      WidgetRef ref) async {
    return await _getRefService(ref).getSpeciesOptions(
      ref,
      includeEmpty: true,
      emptyLabel: '-- Select Species --',
    );
  }

  @override
  Future<AnimalFilter> createNew() async {
    _log.debug('Creating new AnimalFilter');
    final ref = GlobalRef().ref;
    final species = await ref.read(speciesProvider);
    final huntingGround = await ref.read(selectedHuntingGroundProvider);
    if (huntingGround == null) {
      throw Exception('No hunting ground selected');
    }
    return AnimalFilter(
      name: '',
      animalCount: 0,
      animalCountType: 'exact',
      species: species.first,
      huntingGround: huntingGround,
      createdAt: DateTime.now(),
    );
  }

  // Standardize animalCountType values from database
  String _standardizeAnimalCountType(String? value) {
    if (value == null) return 'exact';

    // Convert German to English and standardize casing
    switch (value) {
      case 'Exakt':
        return 'exact';
      case 'Minimum':
        return 'minimum';
      case 'Maximum':
        return 'maximum';
      case 'Mindestens':
        return 'minimum';
      case 'Höchstens':
        return 'maximum';
      case 'Ungefähr':
        return 'approximately';
      default:
        // Already in English format or unknown
        return value.toLowerCase();
    }
  }

  @override
  dynamic getFieldValue(AnimalFilter entity, String fieldName) {
    try {
      switch (fieldName) {
        case 'name':
          return entity.name;
        case 'huntingGroundId':
          return entity.huntingGroundId;
        case 'huntingGround':
          return entity.huntingGround;
        case 'speciesId':
          return entity.speciesId;
        case 'species':
          return entity.species;
        case 'animalCount':
          return entity.animalCount;
        case 'animalCountType':
          _log.debug('Original animalCountType: ${entity.animalCountType}');
          final standardized =
              _standardizeAnimalCountType(entity.animalCountType);
          _log.debug('Standardized animalCountType: $standardized');
          return standardized;
        case 'customColor':
          return entity.customColor;
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
        case 'customColor':
          if (value is int) {
            return '#${value.toRadixString(16).padLeft(6, '0').toUpperCase()}';
          }
          return '';
        case 'species':
          return value is Species ? value.name : '';
        case 'huntingGround':
          return value is HuntingGround ? value.name : '';
        case 'animalCountType':
          // Format animalCountType for display
          switch (value.toString().toLowerCase()) {
            case 'exact':
              return 'Exact';
            case 'minimum':
              return 'Minimum';
            case 'maximum':
              return 'Maximum';
            case 'approximately':
              return 'Approximately';
            default:
              return value.toString();
          }
        default:
          return value.toString();
      }
    } catch (e) {
      _log.error('Error formatting display value for $fieldName', error: e);
      return value?.toString() ?? '';
    }
  }

  @override
  AnimalFilter setFieldValue(
      AnimalFilter entity, String fieldName, dynamic value) {
    try {
      switch (fieldName) {
        case 'name':
          return entity.copyWith(name: value);
        case 'animalCount':
          return entity.copyWith(animalCount: value);
        case 'animalCountType':
          return entity.copyWith(animalCountType: value);
        case 'customColor':
          return entity.copyWith(customColor: value);
        case 'species':
          if (value is Species) {
            return entity.copyWith(species: value);
          }
          _log.warning(
              'Attempted to set species directly with non-Species value');
          return entity;
        case 'speciesId':
          // Cannot set speciesId directly, it should be set via setRelationFieldValue
          _log.warning(
              'Cannot set speciesId directly - use setRelationFieldValue instead');
          return entity;
        case 'huntingGround':
          if (value is HuntingGround) {
            return entity.copyWith(huntingGround: value);
          }
          _log.warning(
              'Attempted to set huntingGround directly with non-HuntingGround value');
          return entity;
        case 'huntingGroundId':
          // Cannot set huntingGroundId directly, it should be set via setRelationFieldValue
          _log.warning(
              'Cannot set huntingGroundId directly - use setRelationFieldValue instead');
          return entity;
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
  Future<AnimalFilter> setRelationFieldValue(
    WidgetRef ref,
    AnimalFilter entity,
    String fieldName,
    String relationId,
  ) async {
    try {
      _log.debug('Setting relation field "$fieldName" with ID: "$relationId"');

      // Handle null or empty ID cases correctly
      if (relationId.isEmpty) {
        _log.debug('Empty relationId for field "$fieldName", setting to null');
        // For empty IDs, return the entity unchanged or set the relation to null
        switch (fieldName) {
          case 'speciesId':
            return entity.copyWith(species: null);
          case 'huntingGroundId':
            return entity.copyWith(huntingGround: null);
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

  @override
  Map<String, String?> validate(AnimalFilter entity, [BuildContext? context]) {
    final errors = <String, String?>{};

    if (entity.name.isEmpty) {
      errors['name'] = 'Name is required';
    }

    if (entity.huntingGroundId == null || entity.huntingGroundId!.isEmpty) {
      errors['huntingGroundId'] = 'Hunting Ground is required';
    }

    if (entity.speciesId == null || entity.speciesId!.isEmpty) {
      errors['speciesId'] = 'Species is required';
    }

    // Debug logging for animalCountType
    _log.debug('Validating animalCountType: ${entity.animalCountType}');

    return errors;
  }

  // Helper method to convert color to name
  String _colorToName(Color color) {
    if (color == Colors.red) return 'Red';
    if (color == Colors.orange) return 'Orange';
    if (color == Colors.yellow) return 'Yellow';
    if (color == Colors.green) return 'Green';
    if (color == Colors.blue) return 'Blue';
    if (color == Colors.indigo) return 'Indigo';
    if (color == Colors.purple) return 'Purple';
    if (color == Colors.pink) return 'Pink';
    if (color == Colors.brown) return 'Brown';
    if (color == Colors.grey) return 'Grey';
    return 'Custom';
  }

  @override
  String getEntityId(AnimalFilter entity) {
    return entity.id;
  }

  @override
  String getDisplayText(AnimalFilter entity) {
    return entity.name;
  }

  @override
  ModelRegistry getModelRegistry(WidgetRef ref) {
    return ref.read(modelRegistryProvider);
  }

  @override
  GenericModelNotifier<AnimalFilter> getNotifier(WidgetRef ref) {
    return getModelRegistry(ref).getNotifier<AnimalFilter>(ref);
  }

  @override
  GenericRepository<AnimalFilter> getRepository(WidgetRef ref) {
    return ref
        .read(getModelRegistry(ref).getRepositoryProvider<AnimalFilter>());
  }

  @override
  Future<List<AnimalFilter>> fetchAll(WidgetRef ref) async {
    return await getRepository(ref).getAll();
  }

  @override
  Future<List<AnimalFilter>> fetchWhere(WidgetRef ref,
      {required Query query}) async {
    return await getRepository(ref).getWhere(query: query);
  }

  @override
  Future<AnimalFilter?> fetchById(WidgetRef ref, String id) async {
    return await getRepository(ref).getById(id);
  }

  @override
  Future<AnimalFilter> save(WidgetRef ref, AnimalFilter entity) async {
    final registry = getModelRegistry(ref);

    // Determine if this is a new entity or an update
    final isNewEntity = getEntityId(entity).isEmpty;

    if (isNewEntity) {
      await registry.create<AnimalFilter>(ref, entity);
    } else {
      await registry.update<AnimalFilter>(ref, entity);
    }

    return entity;
  }

  @override
  Future<void> delete(WidgetRef ref, AnimalFilter entity) async {
    await getModelRegistry(ref).delete<AnimalFilter>(ref, entity);
  }

  @override
  Future<void> syncWithServer(WidgetRef ref) async {
    await getModelRegistry(ref).sync<AnimalFilter>(ref);
  }

  @override
  Future<void> refresh(WidgetRef ref) async {
    await getModelRegistry(ref).refresh<AnimalFilter>(ref);
  }
}
