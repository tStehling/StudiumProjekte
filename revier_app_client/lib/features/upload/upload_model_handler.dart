import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brick_core/query.dart';
import 'package:revier_app_client/brick/models/upload.model.dart';
import 'package:revier_app_client/brick/models/camera.model.dart';
import 'package:revier_app_client/common/model_management/index.dart';
import 'package:revier_app_client/data/model_registry.dart';
import 'package:revier_app_client/data/providers/model_registry_provider.dart';
import 'package:revier_app_client/data/repositories/generic_repository.dart';
import 'package:revier_app_client/data/reference_data_service.dart';
import 'package:revier_app_client/presentation/state/generic_model_notifier.dart';
import 'package:revier_app_client/core/services/logging_service.dart';
import 'package:revier_app_client/data/providers/widget_ref_provider.dart';
import 'package:revier_app_client/features/hunting_ground/providers/hunting_ground_provider.dart';
import 'package:intl/intl.dart';

/// Handler for Upload model operations
class UploadModelHandler implements ModelHandler<Upload> {
  final ReferenceDataService? _referenceService;
  static final _log = loggingService.getLogger('UploadModelHandler');
  static const int _pageSize = 20;
  static const String _defaultErrorMessage = 'An error occurred';

  UploadModelHandler([this._referenceService]);

  ReferenceDataService _getRefService(WidgetRef ref) {
    return _referenceService ?? ref.read(referenceDataServiceProvider);
  }

  @override
  String get modelTitle => 'Uploads';

  @override
  List<String> get listDisplayFields => ['status', 'camera', 'createdAt'];

  @override
  List<String> get searchableFields => ['status'];

  @override
  Map<String, FieldConfig> get fieldConfigurations => {
        'status': FieldConfig(
          label: 'Status',
          fieldType: FieldType.text,
          isRequired: true,
          icon: Icons.info_outline,
        ),
        'cameraId': FieldConfig(
          label: 'Camera',
          fieldType: FieldType.relation,
          isVisibleInDetail:
              false, // Hide in detail view, only used for editing
          icon: Icons.camera_alt,
        ),
        'camera': FieldConfig(
          label: 'Camera',
          fieldType: FieldType.relation,
          isEditable: false, // Not editable directly, use cameraId instead
          icon: Icons.camera_alt,
        ),
        'latitude': FieldConfig(
          label: 'Latitude',
          fieldType: FieldType.number,
          icon: Icons.location_on,
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
          icon: Icons.location_on,
          validator: (value) {
            if (value != null && value is num) {
              if (value < -180 || value > 180) {
                return 'Must be between -180 and 180';
              }
            }
            return null;
          },
        ),
        'createdAt': FieldConfig(
          label: 'Created At',
          fieldType: FieldType.dateTime,
          isEditable: false,
          icon: Icons.access_time,
          formatter: (value) => value != null
              ? DateFormat('yyyy-MM-dd HH:mm').format(value as DateTime)
              : '',
        ),
        'updatedAt': FieldConfig(
          label: 'Updated At',
          fieldType: FieldType.dateTime,
          isEditable: false,
          icon: Icons.update,
          formatter: (value) => value != null
              ? DateFormat('yyyy-MM-dd HH:mm').format(value as DateTime)
              : '',
        ),
        'deletedAt': FieldConfig(
          label: 'Deleted At',
          fieldType: FieldType.dateTime,
          isEditable: false,
          icon: Icons.delete_outline,
          formatter: (value) => value != null
              ? DateFormat('yyyy-MM-dd HH:mm').format(value as DateTime)
              : '',
        ),
        'isDeleted': FieldConfig(
          label: 'Is Deleted',
          fieldType: FieldType.boolean,
          isEditable: false,
          icon: Icons.delete,
        ),
      };

  @override
  Map<String, FieldConfig> getFieldConfigurations(WidgetRef ref) {
    _log.debug('Getting field configurations for Upload');
    try {
      return {
        'status': fieldConfigurations['status']!,
        'cameraId': fieldConfigurations['cameraId']!.copyWith(
          optionsLoader: () =>
              _loadCameraOptions(ref, page: 0, pageSize: _pageSize),
        ),
        'camera': fieldConfigurations['camera']!,
        'latitude': fieldConfigurations['latitude']!,
        'longitude': fieldConfigurations['longitude']!,
        'createdAt': fieldConfigurations['createdAt']!,
        'updatedAt': fieldConfigurations['updatedAt']!,
        'deletedAt': fieldConfigurations['deletedAt']!,
        'isDeleted': fieldConfigurations['isDeleted']!,
      };
    } catch (e) {
      _log.error('Failed to get field configurations', error: e);
      throw Exception('Failed to load field configurations: ${e.toString()}');
    }
  }

  Future<List<DropdownOption<dynamic>>> _loadCameraOptions(WidgetRef ref,
      {int page = 0, int pageSize = 20}) async {
    try {
      _log.debug('Loading camera options (page: $page, pageSize: $pageSize)');

      return await _getRefService(ref).getDropdownOptions<Camera>(
        ref,
        valueField: 'id',
        labelField: 'name',
        includeEmpty: true,
        emptyLabel: '-- Select Camera --',
        page: page,
        pageSize: pageSize,
      );
    } catch (e) {
      _log.error('Failed to load camera options', error: e);
      return [DropdownOption(value: '', label: _defaultErrorMessage)];
    }
  }

  @override
  Future<Upload> createNew() async {
    _log.debug('Creating new Upload');
    try {
      final ref = GlobalRef().ref;
      final currentHuntingGround = ref.read(selectedHuntingGroundProvider);
      if (currentHuntingGround == null) {
        _log.warning('No hunting ground selected when creating new animal');
        throw Exception('No hunting ground selected');
      }

      return Upload(
        status: 'pending',
        latitude: 0,
        longitude: 0,
        createdAt: DateTime.now(),
        huntingGround: currentHuntingGround,
      );
    } catch (e) {
      _log.error('Failed to create new upload', error: e);
      throw Exception('Failed to create new upload: ${e.toString()}');
    }
  }

  @override
  dynamic getFieldValue(Upload entity, String fieldName) {
    try {
      switch (fieldName) {
        case 'status':
          return entity.status;
        case 'camera':
          return entity.camera;
        case 'cameraId':
          return entity.cameraId;
        case 'huntingGroundId':
          return entity.huntingGroundId;
        case 'latitude':
          return entity.latitude;
        case 'longitude':
          return entity.longitude;
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
        case 'camera':
          return value is Camera ? value.name : '';
        case 'cameraId':
          return value.toString();
        case 'status':
          return value.toString();
        case 'latitude':
        case 'longitude':
          if (value is double) {
            return value.toStringAsFixed(6);
          }
          return value.toString();
        case 'createdAt':
        case 'updatedAt':
        case 'deletedAt':
          if (value is DateTime) {
            return DateFormat('yyyy-MM-dd HH:mm').format(value);
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
    } catch (e) {
      _log.error('Error formatting display value for $fieldName', error: e);
      return value?.toString() ?? '';
    }
  }

  @override
  Upload setFieldValue(Upload entity, String fieldName, dynamic value) {
    try {
      switch (fieldName) {
        case 'status':
          return entity.copyWith(status: value);
        case 'camera':
          if (value is Camera) {
            return entity.copyWith(camera: value);
          }
          _log.warning(
              'Attempted to set camera directly with non-Camera value');
          return entity;
        case 'cameraId':
          _log.warning(
              'Cannot set cameraId directly - use setRelationFieldValue instead');
          return entity;
        case 'latitude':
          return entity.copyWith(latitude: value);
        case 'longitude':
          return entity.copyWith(longitude: value);
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
  Future<Upload> setRelationFieldValue(
    WidgetRef ref,
    Upload entity,
    String fieldName,
    String relationId,
  ) async {
    try {
      _log.debug('Setting relation field "$fieldName" with ID: "$relationId"');

      // Handle null or empty ID cases correctly
      if (relationId.isEmpty) {
        _log.debug('Empty relationId for field "$fieldName", setting to null');
        switch (fieldName) {
          case 'cameraId':
            return entity.copyWith(camera: null);
          default:
            return entity;
        }
      }

      // Process non-empty relation IDs
      switch (fieldName) {
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
  Map<String, String?> validate(Upload entity, [BuildContext? context]) {
    final errors = <String, String?>{};

    try {
      // Validate required fields
      if (entity.status.isEmpty) {
        errors['status'] = 'Status is required';
      }

      // Validate latitude and longitude
      if (entity.latitude != null) {
        if (entity.latitude! < -90 || entity.latitude! > 90) {
          errors['latitude'] = 'Latitude must be between -90 and 90';
        }
      }

      if (entity.longitude != null) {
        if (entity.longitude! < -180 || entity.longitude! > 180) {
          errors['longitude'] = 'Longitude must be between -180 and 180';
        }
      }

      // Log validation result
      if (errors.isEmpty) {
        _log.debug('Upload validation passed');
      } else {
        _log.debug('Upload validation failed with errors: $errors');
      }

      return errors;
    } catch (e) {
      _log.error('Error validating upload', error: e);
      errors['general'] = 'Validation error occurred';
      return errors;
    }
  }

  @override
  String getEntityId(Upload entity) {
    return entity.id;
  }

  @override
  String getDisplayText(Upload entity) {
    final statusText = entity.status;
    final dateText = entity.createdAt != null
        ? DateFormat('yyyy-MM-dd').format(entity.createdAt!)
        : 'Unknown date';

    return 'Upload ($statusText) - $dateText';
  }

  @override
  ModelRegistry getModelRegistry(WidgetRef ref) {
    return ref.read(modelRegistryProvider);
  }

  @override
  GenericModelNotifier<Upload> getNotifier(WidgetRef ref) {
    return getModelRegistry(ref).getNotifier<Upload>(ref);
  }

  @override
  GenericRepository<Upload> getRepository(WidgetRef ref) {
    return ref.read(getModelRegistry(ref).getRepositoryProvider<Upload>());
  }

  @override
  Future<List<Upload>> fetchAll(WidgetRef ref) async {
    try {
      _log.debug('Fetching all uploads');
      return await getRepository(ref).getAll();
    } catch (e) {
      _log.error('Error fetching all uploads', error: e);
      return [];
    }
  }

  @override
  Future<List<Upload>> fetchWhere(WidgetRef ref, {required Query query}) async {
    try {
      _log.debug('Fetching uploads with query');
      return await getRepository(ref).getWhere(query: query);
    } catch (e) {
      _log.error('Error fetching uploads with query: $query', error: e);
      return [];
    }
  }

  @override
  Future<Upload?> fetchById(WidgetRef ref, String id) async {
    try {
      _log.debug('Fetching upload by ID: $id');
      return await getRepository(ref).getById(id);
    } catch (e) {
      _log.error('Error fetching upload by ID: $id', error: e);
      return null;
    }
  }

  @override
  Future<Upload> save(WidgetRef ref, Upload entity) async {
    try {
      final registry = getModelRegistry(ref);

      // Determine if this is a new entity or an update
      final isNewEntity = getEntityId(entity).isEmpty;

      if (isNewEntity) {
        _log.debug('Creating new upload');
        await registry.create<Upload>(ref, entity);
      } else {
        _log.debug('Updating upload with ID: ${entity.id}');
        await registry.update<Upload>(ref, entity);
      }

      return entity;
    } catch (e) {
      _log.error('Error saving upload', error: e);
      throw Exception('Failed to save upload: ${e.toString()}');
    }
  }

  @override
  Future<void> delete(WidgetRef ref, Upload entity) async {
    try {
      _log.debug('Deleting upload with ID: ${entity.id}');
      await getModelRegistry(ref).delete<Upload>(ref, entity);
    } catch (e) {
      _log.error('Error deleting upload', error: e);
      throw Exception('Failed to delete upload: ${e.toString()}');
    }
  }

  @override
  Future<void> syncWithServer(WidgetRef ref) async {
    try {
      _log.debug('Syncing uploads with server');
      await getModelRegistry(ref).sync<Upload>(ref);
    } catch (e) {
      _log.error('Error syncing uploads with server', error: e);
      throw Exception('Failed to sync uploads with server: ${e.toString()}');
    }
  }

  @override
  Future<void> refresh(WidgetRef ref) async {
    try {
      _log.debug('Refreshing uploads');
      await getModelRegistry(ref).refresh<Upload>(ref);
    } catch (e) {
      _log.error('Error refreshing uploads', error: e);
      throw Exception('Failed to refresh uploads: ${e.toString()}');
    }
  }
}
