import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brick_core/query.dart';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:revier_app_client/data/model_registry.dart';
import 'package:revier_app_client/data/repositories/generic_repository.dart';
import 'package:revier_app_client/presentation/state/generic_model_notifier.dart';
import 'field_config.dart';

/// A generic interface for handling model data operations and configurations.
///
/// This interface defines the contract for model-specific handlers that provide
/// the necessary configuration and data operations for a specific model type.
abstract class ModelHandler<T extends OfflineFirstWithSupabaseModel> {
  /// Gets the display title for the model type.
  String get modelTitle;

  /// Gets the fields to display in list views.
  List<String> get listDisplayFields;

  /// Gets the fields that should be searchable.
  List<String> get searchableFields;

  /// Gets the field configurations for form and detail views.
  Map<String, FieldConfig> get fieldConfigurations;

  /// Gets the model registry used by this handler
  ModelRegistry getModelRegistry(WidgetRef ref);

  /// Gets the notifier for this model type
  GenericModelNotifier<T> getNotifier(WidgetRef ref) {
    return getModelRegistry(ref).getNotifier<T>(ref);
  }

  /// Gets the repository for this model type
  GenericRepository<T> getRepository(WidgetRef ref) {
    return ref.read(getModelRegistry(ref).getRepositoryProvider<T>());
  }

  /// Fetches all entities of the model type.
  Future<List<T>> fetchAll(WidgetRef ref) async {
    return await getRepository(ref).getAll();
  }

  /// Fetches entities with a specific query
  Future<List<T>> fetchWhere(WidgetRef ref, {required Query query}) async {
    return await getRepository(ref).getWhere(query: query);
  }

  /// Fetches a specific entity by ID.
  Future<T?> fetchById(WidgetRef ref, String id) async {
    return await getRepository(ref).getById(id);
  }

  /// Saves an entity (creates or updates).
  Future<T> save(WidgetRef ref, T entity) async {
    final registry = getModelRegistry(ref);

    // Determine if this is a new entity or an update
    final isNewEntity = getEntityId(entity).isEmpty;

    if (isNewEntity) {
      await registry.create<T>(ref, entity);
    } else {
      await registry.update<T>(ref, entity);
    }

    // Return the saved entity
    // Note: In a real implementation, you might want to fetch the entity again
    // to get the updated version with any server-generated values
    return entity;
  }

  /// Deletes an entity.
  Future<void> delete(WidgetRef ref, T entity) async {
    await getModelRegistry(ref).delete<T>(ref, entity);
  }

  /// Forces synchronization with the server
  Future<void> syncWithServer(WidgetRef ref) async {
    await getModelRegistry(ref).sync<T>(ref);
  }

  /// Refreshes the list of entities
  Future<void> refresh(WidgetRef ref) async {
    await getModelRegistry(ref).refresh<T>(ref);
  }

  /// Creates a new instance of the model type with default values.
  Future<T> createNew();

  /// Extracts a display value from an entity for a given field.
  dynamic getFieldValue(T entity, String fieldName);

  /// Formats a field value for display.
  String formatDisplayValue(String fieldName, dynamic value);

  /// Sets a field value on an entity.
  T setFieldValue(T entity, String fieldName, dynamic value);

  /// Sets a relation field value by ID asynchronously.
  ///
  /// This method is used when a relation field is set by ID rather than by entity.
  /// It fetches the related entity and then sets it on the entity.
  ///
  /// Parameters:
  ///   - ref: The WidgetRef to access providers
  ///   - entity: The entity to update
  ///   - fieldName: The name of the relation field
  ///   - relationId: The ID of the related entity
  ///
  /// Returns:
  ///   A Future that resolves to the updated entity
  Future<T> setRelationFieldValue(
      WidgetRef ref, T entity, String fieldName, String relationId) async {
    // Default implementation returns the entity unchanged
    // Override this in your concrete implementation to handle relations properly
    return entity;
  }

  /// Validates an entity before saving.
  Map<String, String?> validate(T entity, [BuildContext? context]);

  /// Extracts the ID from an entity.
  String getEntityId(T entity);

  /// Returns a simple display string for the entity in lists.
  String getDisplayText(T entity);

  /// Creates a model handler with field configurations that use WidgetRef
  ///
  /// This is useful for handlers that need access to providers or services
  /// that require a WidgetRef.
  Map<String, FieldConfig> getFieldConfigurations(WidgetRef ref) {
    // Default implementation returns the static configurations
    return fieldConfigurations;
  }

  /// Factory method to create model handlers
  ///
  /// Useful for simplifying creation of common model handlers
  static ModelHandler<T> create<T extends OfflineFirstWithSupabaseModel>({
    required String modelTitle,
    required List<String> listDisplayFields,
    required List<String> searchableFields,
    required Map<String, FieldConfig> fieldConfigurations,
    required T Function() createNewFunc,
    required dynamic Function(T entity, String fieldName) getFieldValueFunc,
    required String Function(String fieldName, dynamic value)
        formatDisplayValueFunc,
    required T Function(T entity, String fieldName, dynamic value)
        setFieldValueFunc,
    required Map<String, String?> Function(T entity, BuildContext? context)
        validateFunc,
    required String Function(T entity) getEntityIdFunc,
    required String Function(T entity) getDisplayTextFunc,
  }) {
    return _GenericModelHandler<T>(
      modelTitle: modelTitle,
      listDisplayFields: listDisplayFields,
      searchableFields: searchableFields,
      fieldConfigurations: fieldConfigurations,
      createNewFunc: createNewFunc,
      getFieldValueFunc: getFieldValueFunc,
      formatDisplayValueFunc: formatDisplayValueFunc,
      setFieldValueFunc: setFieldValueFunc,
      validateFunc: validateFunc,
      getEntityIdFunc: getEntityIdFunc,
      getDisplayTextFunc: getDisplayTextFunc,
    );
  }
}

/// A simple implementation of ModelHandler that delegates to functions
class _GenericModelHandler<T extends OfflineFirstWithSupabaseModel>
    implements ModelHandler<T> {
  final String _modelTitle;
  final List<String> _listDisplayFields;
  final List<String> _searchableFields;
  final Map<String, FieldConfig> _fieldConfigurations;
  final T Function() _createNewFunc;
  final dynamic Function(T entity, String fieldName) _getFieldValueFunc;
  final String Function(String fieldName, dynamic value)
      _formatDisplayValueFunc;
  final T Function(T entity, String fieldName, dynamic value)
      _setFieldValueFunc;
  final Map<String, String?> Function(T entity, BuildContext? context)
      _validateFunc;
  final String Function(T entity) _getEntityIdFunc;
  final String Function(T entity) _getDisplayTextFunc;

  _GenericModelHandler({
    required String modelTitle,
    required List<String> listDisplayFields,
    required List<String> searchableFields,
    required Map<String, FieldConfig> fieldConfigurations,
    required T Function() createNewFunc,
    required dynamic Function(T entity, String fieldName) getFieldValueFunc,
    required String Function(String fieldName, dynamic value)
        formatDisplayValueFunc,
    required T Function(T entity, String fieldName, dynamic value)
        setFieldValueFunc,
    required Map<String, String?> Function(T entity, BuildContext? context)
        validateFunc,
    required String Function(T entity) getEntityIdFunc,
    required String Function(T entity) getDisplayTextFunc,
  })  : _modelTitle = modelTitle,
        _listDisplayFields = listDisplayFields,
        _searchableFields = searchableFields,
        _fieldConfigurations = fieldConfigurations,
        _createNewFunc = createNewFunc,
        _getFieldValueFunc = getFieldValueFunc,
        _formatDisplayValueFunc = formatDisplayValueFunc,
        _setFieldValueFunc = setFieldValueFunc,
        _validateFunc = validateFunc,
        _getEntityIdFunc = getEntityIdFunc,
        _getDisplayTextFunc = getDisplayTextFunc;

  @override
  String get modelTitle => _modelTitle;

  @override
  List<String> get listDisplayFields => _listDisplayFields;

  @override
  List<String> get searchableFields => _searchableFields;

  @override
  Map<String, FieldConfig> get fieldConfigurations => _fieldConfigurations;

  @override
  Future<T> createNew() async => await _createNewFunc();

  @override
  dynamic getFieldValue(T entity, String fieldName) =>
      _getFieldValueFunc(entity, fieldName);

  @override
  String formatDisplayValue(String fieldName, dynamic value) =>
      _formatDisplayValueFunc(fieldName, value);

  @override
  T setFieldValue(T entity, String fieldName, dynamic value) =>
      _setFieldValueFunc(entity, fieldName, value);

  @override
  Future<T> setRelationFieldValue(
      WidgetRef ref, T entity, String fieldName, String relationId) async {
    // Default implementation just calls the regular setFieldValue
    return setFieldValue(entity, fieldName, relationId);
  }

  @override
  Map<String, String?> validate(T entity, [BuildContext? context]) =>
      _validateFunc(entity, context);

  @override
  String getEntityId(T entity) => _getEntityIdFunc(entity);

  @override
  String getDisplayText(T entity) => _getDisplayTextFunc(entity);

  @override
  ModelRegistry getModelRegistry(WidgetRef ref) {
    throw UnimplementedError('You must provide a ModelRegistry implementation');
  }

  @override
  GenericModelNotifier<T> getNotifier(WidgetRef ref) {
    return getModelRegistry(ref).getNotifier<T>(ref);
  }

  @override
  GenericRepository<T> getRepository(WidgetRef ref) {
    return ref.read(getModelRegistry(ref).getRepositoryProvider<T>());
  }

  @override
  Future<List<T>> fetchAll(WidgetRef ref) async {
    return await getRepository(ref).getAll();
  }

  @override
  Future<List<T>> fetchWhere(WidgetRef ref, {required Query query}) async {
    return await getRepository(ref).getWhere(query: query);
  }

  @override
  Future<T?> fetchById(WidgetRef ref, String id) async {
    return await getRepository(ref).getById(id);
  }

  @override
  Future<T> save(WidgetRef ref, T entity) async {
    final registry = getModelRegistry(ref);

    // Determine if this is a new entity or an update
    final isNewEntity = getEntityId(entity).isEmpty;

    if (isNewEntity) {
      await registry.create<T>(ref, entity);
    } else {
      await registry.update<T>(ref, entity);
    }

    // Return the saved entity
    return entity;
  }

  @override
  Future<void> delete(WidgetRef ref, T entity) async {
    await getModelRegistry(ref).delete<T>(ref, entity);
  }

  @override
  Future<void> syncWithServer(WidgetRef ref) async {
    await getModelRegistry(ref).sync<T>(ref);
  }

  @override
  Future<void> refresh(WidgetRef ref) async {
    await getModelRegistry(ref).refresh<T>(ref);
  }

  @override
  Map<String, FieldConfig> getFieldConfigurations(WidgetRef ref) {
    return fieldConfigurations;
  }
}
