import 'package:brick_core/query.dart';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:revier_app_client/brick/brick_repository.dart';
import 'package:revier_app_client/core/services/logging_service.dart';

/// A generic repository for working with Brick models
class GenericRepository<T extends OfflineFirstWithSupabaseModel> {
  final BrickRepository _repository;
  final ClassNameLogger _logger = loggingService.getLogger('GenericRepository');

  /// Constructor
  GenericRepository(this._repository);

  /// Get all models
  Future<List<T>> getAll() async {
    _logger.info('getAll<${T.toString()}> called');
    try {
      final result = await _repository.get<T>();
      _logger.info('getAll<${T.toString()}> returned ${result.length} results');
      return result;
    } catch (e, stackTrace) {
      _logger.error('getAll<${T.toString()}> error',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Get models with a specific query
  Future<List<T>> getWhere({required Query query}) async {
    _logger.info(
        'getWhere<${T.toString()}> called with query: ${query.toString()}');
    try {
      final result = await _repository.get<T>(query: query);
      _logger
          .info('getWhere<${T.toString()}> returned ${result.length} results');
      return result;
    } catch (e, stackTrace) {
      _logger.error('getWhere<${T.toString()}> error',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Get a specific model by ID
  Future<T?> getById(String id) async {
    _logger.info('getById<${T.toString()}> called with id: $id');
    try {
      final models = await _repository.get<T>(
        query: Query.where('id', id),
      );
      _logger.info(
          'getById<${T.toString()}> returned ${models.isNotEmpty ? 'a model' : 'no model'}');
      return models.isNotEmpty ? models.first : null;
    } catch (e, stackTrace) {
      _logger.error('getById<${T.toString()}> error',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Create or update a model
  Future<T> upsert(T model) async {
    _logger.info('upsert<${T.toString()}> called');
    try {
      final result = await _repository.upsert<T>(model);
      _logger.info('upsert<${T.toString()}> completed successfully');
      return result;
    } catch (e, stackTrace) {
      _logger.error('upsert<${T.toString()}> error',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Delete a model
  Future<void> delete(T model) async {
    _logger.info('delete<${T.toString()}> called');
    try {
      await _repository.delete<T>(model);
      _logger.info('delete<${T.toString()}> completed successfully');
    } catch (e, stackTrace) {
      _logger.error('delete<${T.toString()}> error',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Stream of models for reactivity
  Stream<List<T>> watch({Query? query}) {
    _logger.info(
        'watch<${T.toString()}> called with query: ${query?.toString() ?? 'null'}');
    final stream = _repository.subscribe<T>(query: query);
    return stream.map((data) {
      _logger.info('watch<${T.toString()}> emitted ${data.length} items');
      return data;
    }).handleError((e, stackTrace) {
      _logger.error('watch<${T.toString()}> error',
          error: e, stackTrace: stackTrace);
      throw e;
    });
  }

  /// Force synchronization with the server
  Future<void> sync() async {
    _logger.info('sync<${T.toString()}> called');
    try {
      await _repository.get<T>();
      _logger.info('sync<${T.toString()}> completed successfully');
    } catch (e, stackTrace) {
      _logger.error('sync<${T.toString()}> error',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
