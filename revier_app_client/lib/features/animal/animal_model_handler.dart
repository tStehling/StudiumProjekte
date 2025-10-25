import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:brick_core/query.dart';
import 'package:revier_app_client/brick/models/animal.model.dart';
import 'package:revier_app_client/brick/models/species.model.dart';
import 'package:revier_app_client/brick/models/hunting_ground.model.dart';
import 'package:revier_app_client/brick/models/shooting.model.dart';
import 'package:revier_app_client/common/model_management/index.dart';
import 'package:revier_app_client/common/widgets/index.dart';
import 'package:revier_app_client/data/model_registry.dart';
import 'package:revier_app_client/data/providers/model_registry_provider.dart'
    as model_providers;
import 'package:revier_app_client/data/providers/widget_ref_provider.dart';
import 'package:revier_app_client/data/reference_data_service.dart';
import 'package:revier_app_client/data/repositories/generic_repository.dart';
import 'package:revier_app_client/features/hunting_ground/providers/hunting_ground_provider.dart';
import 'package:revier_app_client/presentation/state/generic_model_notifier.dart';
import 'package:revier_app_client/core/services/logging_service.dart';
import 'package:revier_app_client/localization/app_localizations.dart';

/// Handler for Animal model operations
class AnimalModelHandler implements ModelHandler<Animal> {
  final ReferenceDataService? _referenceService;
  static final _log = loggingService.getLogger('AnimalModelHandler');

  // Constants for pagination
  static const int _pageSize = 20;
  static const String _defaultErrorMessage = 'An error occurred';

  AnimalModelHandler([this._referenceService]);

  ReferenceDataService _getRefService(WidgetRef ref) {
    return _referenceService ?? ref.read(referenceDataServiceProvider);
  }

  @override
  String get modelTitle => 'Animals';

  @override
  List<String> get listDisplayFields => ['name', 'speciesId', 'age', 'weight'];

  @override
  List<String> get searchableFields => ['name', 'notes'];

  @override
  Map<String, FieldConfig> get fieldConfigurations => {
        'name': FieldConfig(
          label: 'Name',
          fieldType: FieldType.text,
          isRequired: true,
          icon: Icons.pets,
        ),
        'speciesId': FieldConfig(
          label: 'Species',
          fieldType: FieldType.relation,
          isRequired: true,
          isVisibleInDetail: false,
          icon: Icons.category,
        ),
        'species': FieldConfig(
          label: 'Species',
          fieldType: FieldType.relation,
          isEditable: false,
          isRequired: true,
          icon: Icons.category,
        ),
        'age': FieldConfig(
          label: 'Age (years)',
          fieldType: FieldType.number,
          icon: Icons.calendar_today,
        ),
        'weight': FieldConfig(
          label: 'Weight (kg)',
          fieldType: FieldType.number,
          icon: Icons.monitor_weight,
        ),
        'dead': FieldConfig(
          label: 'Is Dead',
          fieldType: FieldType.boolean,
          icon: Icons.warning,
        ),
        'notes': FieldConfig(
          label: 'Notes',
          fieldType: FieldType.text,
          hint: 'Additional information about the animal',
          icon: Icons.note,
        ),
        'huntingGroundId': FieldConfig(
          label: 'Hunting Ground',
          fieldType: FieldType.relation,
          isVisibleInDetail: false,
          icon: Icons.map,
        ),
        'huntingGround': FieldConfig(
          label: 'Hunting Ground',
          fieldType: FieldType.relation,
          isEditable: false,
          icon: Icons.map,
        ),
        'shootingId': FieldConfig(
          label: 'Shooting Record',
          fieldType: FieldType.relation,
          isVisibleInDetail: false,
          icon: Icons.sports_handball,
        ),
        'shooting': FieldConfig(
          label: 'Shooting Record',
          fieldType: FieldType.relation,
          isEditable: false,
          icon: Icons.sports_handball,
        ),
        'customColor': FieldConfig(
          label: 'Custom Color',
          fieldType: FieldType.custom,
          icon: Icons.color_lens,
          customFieldBuilder: (context, value, onChanged) {
            final l10n = AppLocalizations.of(context);
            return ColorPickerWidget(
              colorValue: value,
              onColorChanged: onChanged,
              title: l10n.tapToSelectColor ?? 'Tap to select color',
            );
          },
        ),
      };

  @override
  Map<String, FieldConfig> getFieldConfigurations(WidgetRef ref) {
    _log.debug('Getting field configurations for Animal');
    try {
      return {
        'name': fieldConfigurations['name']!,
        'speciesId': fieldConfigurations['speciesId']!.copyWith(
          optionsLoader: () =>
              _loadSpeciesOptions(ref, page: 0, pageSize: _pageSize),
        ),
        'species': fieldConfigurations['species']!,
        'age': fieldConfigurations['age']!,
        'weight': fieldConfigurations['weight']!,
        'dead': fieldConfigurations['dead']!,
        'notes': fieldConfigurations['notes']!,
        'huntingGroundId': fieldConfigurations['huntingGroundId']!.copyWith(
          optionsLoader: () =>
              _loadHuntingGroundOptions(ref, page: 0, pageSize: _pageSize),
        ),
        'huntingGround': fieldConfigurations['huntingGround']!,
        'shootingId': fieldConfigurations['shootingId']!.copyWith(
          optionsLoader: () =>
              _loadShootingOptions(ref, page: 0, pageSize: _pageSize),
        ),
        'shooting': fieldConfigurations['shooting']!,
        'customColor': fieldConfigurations['customColor']!,
      };
    } catch (e) {
      _log.error('Failed to get field configurations', error: e);
      throw Exception('Failed to load field configurations: ${e.toString()}');
    }
  }

  Future<List<DropdownOption<dynamic>>> _loadSpeciesOptions(WidgetRef ref,
      {int page = 0, int pageSize = 20}) async {
    try {
      _log.debug('Loading species options (page: $page, pageSize: $pageSize)');
      final l10n = AppLocalizations.of(ref.context);
      return await _getRefService(ref).getSpeciesOptions(
        ref,
        includeEmpty: true,
        emptyLabel: l10n.selectSpecies ?? '-- Select Species --',
        page: page,
        pageSize: pageSize,
      );
    } catch (e) {
      _log.error('Failed to load species options', error: e);
      return [DropdownOption(value: '', label: _defaultErrorMessage)];
    }
  }

  Future<List<DropdownOption<dynamic>>> _loadHuntingGroundOptions(WidgetRef ref,
      {int page = 0, int pageSize = 20}) async {
    try {
      _log.debug(
          'Loading hunting ground options (page: $page, pageSize: $pageSize)');
      final l10n = AppLocalizations.of(ref.context);
      return await _getRefService(ref).getDropdownOptions<HuntingGround>(
        ref,
        valueField: 'id',
        labelField: 'name',
        includeEmpty: true,
        emptyLabel: l10n.selectHuntingGround ?? '-- Select Hunting Ground --',
        page: page,
        pageSize: pageSize,
      );
    } catch (e) {
      _log.error('Failed to load hunting ground options', error: e);
      return [DropdownOption(value: '', label: _defaultErrorMessage)];
    }
  }

  Future<List<DropdownOption<dynamic>>> _loadShootingOptions(WidgetRef ref,
      {int page = 0, int pageSize = 20}) async {
    try {
      _log.debug('Loading shooting options (page: $page, pageSize: $pageSize)');
      final l10n = AppLocalizations.of(ref.context);
      return await _getRefService(ref).getDropdownOptions<Shooting>(
        ref,
        valueField: 'id',
        labelField: 'id', // Shooting might not have a name field
        labelFormatter: (shooting) {
          final date = shooting.shotAt ?? DateTime.now();
          final formattedDate = DateFormat('yyyy-MM-dd').format(date);
          return l10n?.shotOnDate(formattedDate) ?? 'Shot on $formattedDate';
        },
        includeEmpty: true,
        emptyLabel: l10n.selectShootingRecord ?? '-- Select Shooting Record --',
        page: page,
        pageSize: pageSize,
      );
    } catch (e) {
      _log.error('Failed to load shooting options', error: e);
      return [DropdownOption(value: '', label: _defaultErrorMessage)];
    }
  }

  @override
  Future<Animal> createNew() async {
    _log.debug('Creating new Animal');
    try {
      final ref = GlobalRef().ref;
      final currentHuntingGround = ref.read(selectedHuntingGroundProvider);
      if (currentHuntingGround == null) {
        _log.warning('No hunting ground selected when creating new animal');
        throw Exception('No hunting ground selected');
      }

      // Ensure we have a valid species
      final defaultSpecies = Species(name: 'Unspecified', id: '');

      _log.debug(
          'Creating animal with hunting ground: ${currentHuntingGround.name} (${currentHuntingGround.id})');

      // Create a new animal with required fields
      final animal = Animal(
        name: '',
        dead: false,
        species: defaultSpecies,
        huntingGround: currentHuntingGround,
        notes: '',
      );

      // Log the created animal to verify all fields
      _log.debug(
          'Created new animal with species: ${animal.species?.name}, huntingGround: ${animal.huntingGround?.name}');

      return animal;
    } catch (e) {
      _log.error('Failed to create new animal', error: e);
      throw Exception('Failed to create new animal: ${e.toString()}');
    }
  }

  @override
  dynamic getFieldValue(Animal entity, String fieldName) {
    try {
      switch (fieldName) {
        case 'name':
          return entity.name;
        case 'species':
          return entity.species;
        case 'speciesId':
          return entity.speciesId;
        case 'age':
          return entity.age;
        case 'weight':
          return entity.weight;
        case 'dead':
          return entity.dead;
        case 'notes':
          return entity.notes;
        case 'huntingGround':
          return entity.huntingGround;
        case 'huntingGroundId':
          return entity.huntingGroundId;
        case 'shooting':
          return entity.shooting;
        case 'shootingId':
          return entity.shootingId;
        case 'customColor':
          // Safely handle custom color which can be null
          return entity.customColor; // Already nullable in model
        default:
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
        case 'speciesId':
          // This might need to lookup species name from ID
          return value.toString();
        case 'dead':
          return value is bool ? (value ? 'Yes' : 'No') : '';
        case 'age':
          return value != null ? '$value years' : '';
        case 'weight':
          return value != null ? '$value kg' : '';
        case 'huntingGround':
          return value is HuntingGround ? value.name : '';
        case 'huntingGroundId':
          // This might need to lookup hunting ground name from ID
          return value.toString();
        case 'shooting':
          if (value is Shooting) {
            return value.shotAt != null
                ? 'Shot on ${DateFormat('yyyy-MM-dd').format(value.shotAt!)}'
                : 'Shooting record';
          }
          return '';
        case 'shootingId':
          // This might need to lookup shooting details from ID
          return value.toString();
        case 'customColor':
          if (value != null) {
            try {
              final color = Color(value);
              // Convert to hex without using deprecated value property directly
              final hexColor =
                  '${color.r.round().toRadixString(16).padLeft(2, '0')}'
                  '${color.g.round().toRadixString(16).padLeft(2, '0')}'
                  '${color.b.round().toRadixString(16).padLeft(2, '0')}';
              return '#$hexColor'.toUpperCase();
            } catch (e) {
              _log.error('Error formatting customColor', error: e);
              return '';
            }
          }
          return '';
        default:
          return value.toString();
      }
    } catch (e) {
      _log.error('Error formatting display value for $fieldName', error: e);
      return value?.toString() ?? '';
    }
  }

  @override
  Animal setFieldValue(Animal entity, String fieldName, dynamic value) {
    try {
      switch (fieldName) {
        case 'name':
          return entity.copyWith(name: value);
        case 'species':
          if (value is Species) {
            return entity.copyWith(species: value);
          }
          return entity;
        case 'speciesId':
          // Cannot set speciesId directly, it should be set via setRelationFieldValue
          _log.warning(
              'Cannot set speciesId directly - use setRelationFieldValue instead');
          return entity;
        case 'age':
          return entity.copyWith(age: value);
        case 'weight':
          return entity.copyWith(weight: value);
        case 'dead':
          return entity.copyWith(dead: value);
        case 'notes':
          return entity.copyWith(notes: value);
        case 'huntingGround':
          if (value is HuntingGround) {
            return entity.copyWith(huntingGround: value);
          }
          return entity;
        case 'huntingGroundId':
          // Cannot set huntingGroundId directly, it should be set via setRelationFieldValue
          _log.warning(
              'Cannot set huntingGroundId directly - use setRelationFieldValue instead');
          return entity;
        case 'shooting':
          if (value is Shooting) {
            return entity.copyWith(shooting: value);
          }
          return entity;
        case 'shootingId':
          // Cannot set shootingId directly, it should be set via setRelationFieldValue
          _log.warning(
              'Cannot set shootingId directly - use setRelationFieldValue instead');
          return entity;
        case 'customColor':
          // Handle nullable custom color field
          // If value is null, explicitly set customColor to null
          if (value == null) {
            _log.debug('Setting customColor to null');
            return entity.copyWith(customColor: null);
          }

          // Otherwise set the color value - ensure it's an integer
          try {
            final colorValue =
                value is int ? value : int.tryParse(value.toString());
            _log.debug('Setting customColor to $colorValue');
            return entity.copyWith(customColor: colorValue);
          } catch (e) {
            _log.error('Failed to set customColor', error: e);
            return entity;
          }
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
  Future<Animal> setRelationFieldValue(
    WidgetRef ref,
    Animal entity,
    String fieldName,
    String relationId,
  ) async {
    try {
      _log.debug('Setting relation field "$fieldName" with ID: "$relationId"');

      // Handle null or empty ID cases correctly
      if (relationId == null || relationId.isEmpty) {
        _log.debug(
            'Empty or null relationId for field "$fieldName", setting to null');
        switch (fieldName) {
          case 'speciesId':
            return entity.copyWith(species: null);
          case 'huntingGroundId':
            return entity.copyWith(huntingGround: null);
          case 'shootingId':
            return entity.copyWith(shooting: null);
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
          }
          return species != null ? entity.copyWith(species: species) : entity;

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
          }
          return huntingGround != null
              ? entity.copyWith(huntingGround: huntingGround)
              : entity;

        case 'shootingId':
          final shootingRepo =
              ref.read(getModelRegistry(ref).getRepositoryProvider<Shooting>());
          _log.debug('Fetching shooting with ID: "$relationId"');
          final shooting = await shootingRepo.getById(relationId);
          if (shooting == null) {
            _log.warning('Failed to find shooting with ID: "$relationId"');
            // Return entity as is rather than with null shooting to avoid issues
            return entity;
          } else {
            _log.debug('Found shooting with ID: ${shooting.id}');
            // Only set shooting if we found a valid shooting entity
            return entity.copyWith(shooting: shooting);
          }

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
  Map<String, String?> validate(Animal entity, [BuildContext? context]) {
    final errors = <String, String?>{};

    final l10n = context != null ? AppLocalizations.of(context) : null;

    try {
      _log.debug('Validating animal - customColor: ${entity.customColor}');

      // Validate required fields
      if (entity.name.isEmpty) {
        errors['name'] = l10n?.nameRequired ?? 'Name is required';
      }

      // Check species - required relation
      if (entity.speciesId == null || entity.speciesId!.isEmpty) {
        errors['speciesId'] = l10n?.speciesRequired ?? 'Species is required';
      }

      // Check hunting ground - required relation
      if (entity.huntingGroundId == null || entity.huntingGroundId!.isEmpty) {
        errors['huntingGroundId'] =
            l10n?.huntingGroundRequired ?? 'Hunting Ground is required';
      }

      // Note: shooting is optional, so we don't validate it as required

      // Validate numeric fields
      if (entity.age != null && entity.age! < 0) {
        errors['age'] = l10n?.ageCannotBeNegative ?? 'Age cannot be negative';
      }

      if (entity.weight != null && entity.weight! <= 0) {
        errors['weight'] =
            l10n?.weightMustBePositive ?? 'Weight must be greater than zero';
      }

      // Validate custom color - should be null or a valid color value
      if (entity.customColor != null) {
        try {
          // Test that we can create a Color from the value
          final _ = Color(entity.customColor!);
        } catch (e) {
          _log.error('Invalid custom color value: ${entity.customColor}',
              error: e);
          errors['customColor'] = 'Invalid color format';
        }
      }

      // Log validation result
      if (errors.isEmpty) {
        _log.debug('Animal validation passed');
      } else {
        _log.debug('Animal validation failed with errors: $errors');
      }

      return errors;
    } catch (e) {
      _log.error('Error validating animal', error: e);
      errors['general'] = l10n?.validationError ?? 'Validation error occurred';
      return errors;
    }
  }

  @override
  String getEntityId(Animal entity) {
    return entity.id ?? '';
  }

  @override
  String getDisplayText(Animal entity) {
    try {
      final speciesName = entity.species?.name ?? 'Unknown species';
      return '${entity.name} ($speciesName)';
    } catch (e) {
      _log.error('Error getting display text', error: e);
      return entity.name ?? 'Unknown animal';
    }
  }

  @override
  ModelRegistry getModelRegistry(WidgetRef ref) {
    try {
      return ref.read(model_providers.modelRegistryProvider);
    } catch (e) {
      _log.error('Error getting model registry', error: e);
      throw Exception('Failed to get model registry: ${e.toString()}');
    }
  }

  @override
  GenericModelNotifier<Animal> getNotifier(WidgetRef ref) {
    try {
      return getModelRegistry(ref).getNotifier<Animal>(ref);
    } catch (e) {
      _log.error('Error getting notifier', error: e);
      throw Exception('Failed to get notifier: ${e.toString()}');
    }
  }

  @override
  GenericRepository<Animal> getRepository(WidgetRef ref) {
    try {
      return ref.read(getModelRegistry(ref).getRepositoryProvider<Animal>());
    } catch (e) {
      _log.error('Error getting repository', error: e);
      throw Exception('Failed to get repository: ${e.toString()}');
    }
  }

  @override
  Future<List<Animal>> fetchAll(WidgetRef ref) async {
    try {
      _log.debug('Fetching all animals');
      return await getRepository(ref).getAll();
    } catch (e) {
      _log.error('Error fetching all animals', error: e);
      return [];
    }
  }

  @override
  Future<List<Animal>> fetchWhere(WidgetRef ref, {required Query query}) async {
    try {
      _log.debug('Fetching animals with query');
      return await getRepository(ref).getWhere(query: query);
    } catch (e) {
      _log.error('Error fetching animals with query', error: e);
      return [];
    }
  }

  @override
  Future<Animal?> fetchById(WidgetRef ref, String id) async {
    try {
      _log.debug('Fetching animal by ID: $id');
      return await getRepository(ref).getById(id);
    } catch (e) {
      _log.error('Error fetching animal by ID: $id', error: e);
      return null;
    }
  }

  @override
  Future<Animal> save(WidgetRef ref, Animal entity) async {
    final registry = getModelRegistry(ref);

    // Determine if this is a new entity or an update
    final isNewEntity = getEntityId(entity).isEmpty;

    if (isNewEntity) {
      await registry.create<Animal>(ref, entity);
    } else {
      await registry.update<Animal>(ref, entity);
    }

    return entity;
  }

  @override
  Future<void> delete(WidgetRef ref, Animal entity) async {
    try {
      _log.debug('Deleting animal: ${entity.name}');
      await getModelRegistry(ref).delete<Animal>(ref, entity);
    } catch (e) {
      _log.error('Error deleting animal', error: e);
      throw Exception('Failed to delete animal: ${e.toString()}');
    }
  }

  @override
  Future<void> syncWithServer(WidgetRef ref) async {
    try {
      _log.debug('Syncing animals with server');
      await getModelRegistry(ref).sync<Animal>(ref);
    } catch (e) {
      _log.error('Error syncing animals with server', error: e);
      throw Exception('Failed to sync animals with server: ${e.toString()}');
    }
  }

  @override
  Future<void> refresh(WidgetRef ref) async {
    try {
      _log.debug('Refreshing animals');
      await getModelRegistry(ref).refresh<Animal>(ref);
    } catch (e) {
      _log.error('Error refreshing animals', error: e);
      throw Exception('Failed to refresh animals: ${e.toString()}');
    }
  }

  // Method to handle field changes
  Future<void> onFieldChanged(
    BuildContext context,
    WidgetRef ref,
    String fieldName,
    dynamic value,
    Map<String, dynamic> formData,
  ) async {
    try {
      // Handle field dependencies or side effects
      if (fieldName == 'speciesId') {
        // Example: When species changes, we might want to update other fields
        _log.debug('Species changed to $value');
      }
    } catch (e) {
      _log.error('Error handling field change for $fieldName', error: e);
    }
  }
}
