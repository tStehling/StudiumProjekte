import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brick_core/query.dart';
import 'package:revier_app_client/brick/models/country.model.dart';
import 'package:revier_app_client/brick/models/hunting_ground.model.dart';
import 'package:revier_app_client/brick/models/federal_state.model.dart';
import 'package:revier_app_client/common/model_management/index.dart';
import 'package:revier_app_client/data/model_registry.dart';
import 'package:revier_app_client/data/providers/model_registry_provider.dart'
    as model_providers;
import 'package:revier_app_client/data/reference_data_service.dart';
import 'package:revier_app_client/data/repositories/generic_repository.dart';
import 'package:revier_app_client/presentation/state/generic_model_notifier.dart';
import 'package:revier_app_client/core/services/logging_service.dart';

/// Handler for HuntingGround model operations
class HuntingGroundModelHandler implements ModelHandler<HuntingGround> {
  final ReferenceDataService? _referenceService;
  String? _selectedCountryId;
  static final _log = loggingService.getLogger('HuntingGroundModelHandler');

  HuntingGroundModelHandler([this._referenceService]);

  ReferenceDataService _getRefService(WidgetRef ref) {
    return _referenceService ?? ref.read(referenceDataServiceProvider);
  }

  @override
  String get modelTitle => 'Hunting Grounds';

  @override
  List<String> get listDisplayFields => ['name', 'federalState'];

  @override
  List<String> get searchableFields => ['name'];

  @override
  Map<String, FieldConfig> get fieldConfigurations => {
        'name': FieldConfig(
          label: 'Name',
          fieldType: FieldType.text,
          isRequired: true,
          icon: Icons.terrain,
        ),
        'countryId': FieldConfig(
          label: 'Country',
          fieldType: FieldType.relation,
          isRequired: true,
          icon: Icons.public,
        ),
        'federalStateId': FieldConfig(
          label: 'Federal State',
          fieldType: FieldType.relation,
          isRequired: true,
          icon: Icons.location_on,
        ),
        'createdAt': FieldConfig(
          label: 'Created At',
          fieldType: FieldType.dateTime,
          isEditable: false,
          icon: Icons.access_time,
        ),
        'updatedAt': FieldConfig(
          label: 'Updated At',
          fieldType: FieldType.dateTime,
          isEditable: false,
          icon: Icons.update,
        ),
        'deletedAt': FieldConfig(
          label: 'Deleted At',
          fieldType: FieldType.dateTime,
          isEditable: false,
          icon: Icons.delete_outline,
        ),
        'isDeleted': FieldConfig(
          label: 'Is Deleted',
          fieldType: FieldType.boolean,
          isEditable: false,
          icon: Icons.delete,
        ),
      };

  /// Returns field configurations with context-aware options loaders
  @override
  Map<String, FieldConfig> getFieldConfigurations(WidgetRef ref) {
    final map = <String, FieldConfig>{
      'name': FieldConfig(
        label: 'Name',
        fieldType: FieldType.text,
        isRequired: true,
        icon: Icons.terrain,
      ),
      'countryId': FieldConfig(
        label: 'Country',
        fieldType: FieldType.relation,
        isRequired: true,
        icon: Icons.public,
        optionsLoader: () {
          _selectedCountryId = null; // Reset when country dropdown is shown
          return _loadCountryOptions(ref);
        },
        // Validator to capture the selected country ID for filtering federal states
        validator: (value) {
          _selectedCountryId = value as String?;
          return null; // No validation error
        },
      ),
      'federalStateId': FieldConfig(
        label: 'Federal State',
        fieldType: FieldType.relation,
        isRequired: true,
        icon: Icons.location_on,
        optionsLoader: () => _loadFederalStateOptions(ref),
        // Add a validator that prevents selection if no country is selected
        validator: (value) {
          if (_selectedCountryId == null || _selectedCountryId!.isEmpty) {
            return 'Please select a country first';
          }
          return null;
        },
        // Use a custom hint to indicate country selection is needed
        hint: _selectedCountryId == null || _selectedCountryId!.isEmpty
            ? 'Select a country first'
            : 'Select a federal state',
      ),
      'createdAt': FieldConfig(
        label: 'Created At',
        fieldType: FieldType.dateTime,
        isEditable: false,
        icon: Icons.access_time,
      ),
      'updatedAt': FieldConfig(
        label: 'Updated At',
        fieldType: FieldType.dateTime,
        isEditable: false,
        icon: Icons.update,
      ),
      'deletedAt': FieldConfig(
        label: 'Deleted At',
        fieldType: FieldType.dateTime,
        isEditable: false,
        icon: Icons.delete_outline,
      ),
      'isDeleted': FieldConfig(
        label: 'Is Deleted',
        fieldType: FieldType.boolean,
        isEditable: false,
        icon: Icons.delete,
      ),
    };

    return map;
  }

  /// Loads dropdown options for countries
  Future<List<DropdownOption<dynamic>>> _loadCountryOptions(
      WidgetRef ref) async {
    try {
      _log.debug('Loading country options');
      final referenceDataService = _getRefService(ref);
      final options = await referenceDataService.getCountryOptions(
        ref,
        includeEmpty: true,
        emptyLabel: '-- Select Country --',
      );
      return options;
    } catch (e) {
      _log.error('Failed to load country options', error: e);
      return [DropdownOption(value: '', label: 'Error loading countries')];
    }
  }

  /// Loads dropdown options for federal states
  Future<List<DropdownOption<dynamic>>> _loadFederalStateOptions(
      WidgetRef ref) async {
    try {
      _log.debug('Loading federal state options' +
          (_selectedCountryId != null
              ? ' for country: $_selectedCountryId'
              : ''));

      final referenceDataService = _getRefService(ref);
      final countryId = _selectedCountryId;

      final options = await referenceDataService.getFederalStateOptions(
        ref,
        includeEmpty: true,
        emptyLabel: '-- Select Federal State --',
        countryId: countryId,
      );
      return options;
    } catch (e) {
      _log.error('Failed to load federal state options', error: e);
      return [DropdownOption(value: '', label: 'Error loading federal states')];
    }
  }

  @override
  Future<HuntingGround> createNew() async {
    _log.debug('Creating new Hunting Ground');
    try {
      return HuntingGround(
        name: '',
        federalState:
            FederalState(id: '', name: '', country: Country(id: '', name: '')),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        deletedAt: null,
        isDeleted: false,
      );
    } catch (e) {
      _log.error('Failed to create new hunting ground', error: e);
      throw Exception('Failed to create new hunting ground: ${e.toString()}');
    }
  }

  @override
  dynamic getFieldValue(HuntingGround entity, String fieldName) {
    try {
      switch (fieldName) {
        case 'name':
          return entity.name;
        case 'federalStateId':
          return entity.federalStateId;
        case 'federalState':
          return entity.federalState;
        case 'countryId':
          // Since countryId is not directly on HuntingGround, we get it from federalState if available
          return entity.federalState?.countryId ?? '';
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
    if (value == null) {
      return '';
    }

    switch (fieldName) {
      case 'name':
        return value.toString();
      case 'federalState':
        if (value is FederalState) {
          return value.name;
        }
        return value.toString();
      case 'createdAt':
      case 'updatedAt':
      case 'deletedAt':
        if (value is DateTime) {
          return '${value.day}/${value.month}/${value.year} ${value.hour}:${value.minute.toString().padLeft(2, '0')}';
        }
        return value.toString();
      case 'isDeleted':
        if (value is bool) {
          return value ? 'Yes' : 'No';
        }
        return value.toString();
      default:
        return value.toString();
    }
  }

  @override
  HuntingGround setFieldValue(
      HuntingGround entity, String fieldName, dynamic value) {
    switch (fieldName) {
      case 'name':
        return entity.copyWith(name: value);
      case 'federalStateId':
        // Cannot set federalStateId directly, should be set via setRelationFieldValue
        return entity;
      case 'countryId':
        // Store the selected country ID for filtering federal states
        _selectedCountryId = value;
        return entity; // No direct property to update
      case 'createdAt':
        return entity.copyWith(createdAt: value);
      case 'updatedAt':
        return entity.copyWith(updatedAt: value);
      case 'deletedAt':
        return entity.copyWith(deletedAt: value);
      case 'isDeleted':
        return entity.copyWith(isDeleted: value);
      default:
        return entity;
    }
  }

  @override
  Map<String, String?> validate(HuntingGround entity, [BuildContext? context]) {
    final errors = <String, String?>{};

    if (entity.name.isEmpty) {
      errors['name'] = 'Name is required';
    }

    if (entity.federalStateId.isEmpty) {
      errors['federalStateId'] = 'Federal State is required';
    }

    return errors;
  }

  @override
  String getEntityId(HuntingGround entity) {
    return entity.id;
  }

  @override
  String getDisplayText(HuntingGround entity) {
    return entity.name;
  }

  @override
  ModelRegistry getModelRegistry(WidgetRef ref) {
    return ref.read(model_providers.modelRegistryProvider);
  }

  @override
  GenericModelNotifier<HuntingGround> getNotifier(WidgetRef ref) {
    return getModelRegistry(ref).getNotifier<HuntingGround>(ref);
  }

  @override
  GenericRepository<HuntingGround> getRepository(WidgetRef ref) {
    return ref
        .read(getModelRegistry(ref).getRepositoryProvider<HuntingGround>());
  }

  @override
  Future<List<HuntingGround>> fetchAll(WidgetRef ref) async {
    try {
      _log.debug('Fetching all hunting grounds');
      return await getRepository(ref).getAll();
    } catch (e) {
      _log.error('Error fetching all hunting grounds', error: e);
      return [];
    }
  }

  @override
  Future<List<HuntingGround>> fetchWhere(WidgetRef ref,
      {required Query query}) async {
    try {
      _log.debug('Fetching hunting grounds with query');
      return await getRepository(ref).getWhere(query: query);
    } catch (e) {
      _log.error('Error fetching hunting grounds with query', error: e);
      return [];
    }
  }

  @override
  Future<HuntingGround?> fetchById(WidgetRef ref, String id) async {
    try {
      _log.debug('Fetching hunting ground by ID: $id');
      return await getRepository(ref).getById(id);
    } catch (e) {
      _log.error('Error fetching hunting ground by ID: $id', error: e);
      return null;
    }
  }

  @override
  Future<HuntingGround> save(WidgetRef ref, HuntingGround entity) async {
    try {
      final registry = getModelRegistry(ref);

      // Determine if this is a new entity or an update
      final isNewEntity = getEntityId(entity).isEmpty;

      if (isNewEntity) {
        _log.debug('Creating new hunting ground: ${entity.name}');
        await registry.create<HuntingGround>(ref, entity);
      } else {
        _log.debug('Updating hunting ground: ${entity.name} (${entity.id})');
        await registry.update<HuntingGround>(ref, entity);
      }

      return entity;
    } catch (e) {
      _log.error('Error saving hunting ground', error: e);
      throw Exception('Failed to save hunting ground: ${e.toString()}');
    }
  }

  @override
  Future<void> delete(WidgetRef ref, HuntingGround entity) async {
    try {
      _log.debug('Deleting hunting ground: ${entity.name}');
      await getModelRegistry(ref).delete<HuntingGround>(ref, entity);
    } catch (e) {
      _log.error('Error deleting hunting ground', error: e);
      throw Exception('Failed to delete hunting ground: ${e.toString()}');
    }
  }

  @override
  Future<void> syncWithServer(WidgetRef ref) async {
    try {
      _log.debug('Syncing hunting grounds with server');
      await getModelRegistry(ref).sync<HuntingGround>(ref);
    } catch (e) {
      _log.error('Error syncing hunting grounds with server', error: e);
      throw Exception(
          'Failed to sync hunting grounds with server: ${e.toString()}');
    }
  }

  @override
  Future<void> refresh(WidgetRef ref) async {
    try {
      _log.debug('Refreshing hunting grounds');
      await getModelRegistry(ref).refresh<HuntingGround>(ref);
    } catch (e) {
      _log.error('Error refreshing hunting grounds', error: e);
      throw Exception('Failed to refresh hunting grounds: ${e.toString()}');
    }
  }

  @override
  Future<HuntingGround> setRelationFieldValue(
    WidgetRef ref,
    HuntingGround entity,
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
          case 'federalStateId':
            return entity.copyWith(federalState: null);
          default:
            return entity;
        }
      }

      // Process non-empty relation IDs
      switch (fieldName) {
        case 'federalStateId':
          final federalStateRepo = ref.read(
              getModelRegistry(ref).getRepositoryProvider<FederalState>());

          _log.debug('Fetching federal state with ID: "$relationId"');
          final federalState = await federalStateRepo.getById(relationId);
          if (federalState != null) {
            _log.debug(
                'Found federal state: ${federalState.name} (${federalState.id})');
            // Return entity with updated federalState relation
            return entity.copyWith(federalState: federalState);
          } else {
            _log.warning('Failed to find federal state with ID: "$relationId"');
          }
          return entity;

        case 'countryId':
          // Country ID is handled indirectly through federal state
          _log.debug(
              'Storing selected country ID: "$relationId" for filtering federal states');
          // Just store the selected country ID for filtering federal states
          _selectedCountryId = relationId;
          return entity;

        default:
          _log.warning('Attempted to set unknown relation field: "$fieldName"');
          return entity;
      }
    } catch (e) {
      // Log error and return original entity to avoid crashes
      _log.error('Error setting relation field "$fieldName"', error: e);
      return entity;
    }
  }
}
