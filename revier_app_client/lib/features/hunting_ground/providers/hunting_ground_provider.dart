import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:revier_app_client/brick/models/hunting_ground.model.dart';
import 'package:revier_app_client/features/hunting_ground/hunting_ground_model_handler.dart';
import 'package:revier_app_client/data/reference_data_service.dart';
import 'package:revier_app_client/data/repositories/generic_repository.dart';
import 'package:revier_app_client/data/providers/model_registry_provider.dart'
    as model_providers;

/// Key for storing the selected hunting ground ID in shared preferences
const _selectedHuntingGroundKey = 'selected_hunting_ground_id';

/// Provider for the hunting ground model handler
final huntingGroundModelHandlerProvider =
    Provider<HuntingGroundModelHandler>((ref) {
  final referenceDataService = ref.read(referenceDataServiceProvider);
  return HuntingGroundModelHandler(referenceDataService);
});

/// Provider for the hunting ground repository
final huntingGroundRepositoryProvider =
    Provider<GenericRepository<HuntingGround>>((ref) {
  final modelRegistry = ref.read(model_providers.modelRegistryProvider);
  return ref.read(modelRegistry.getRepositoryProvider<HuntingGround>());
});

/// State notifier for managing the selected hunting ground
class SelectedHuntingGroundNotifier extends StateNotifier<HuntingGround?> {
  final Ref _ref;

  SelectedHuntingGroundNotifier(this._ref) : super(null) {
    _loadSavedHuntingGround();
  }

  /// Get the repository directly
  GenericRepository<HuntingGround> get _repository =>
      _ref.read(huntingGroundRepositoryProvider);

  /// Load the selected hunting ground from shared preferences
  Future<void> _loadSavedHuntingGround() async {
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getString(_selectedHuntingGroundKey);

    if (savedId != null && savedId.isNotEmpty) {
      final huntingGround = await _repository.getById(savedId);
      if (huntingGround != null) {
        state = huntingGround;
      }
    }
  }

  /// Select a hunting ground and save it to shared preferences
  Future<void> selectHuntingGround(HuntingGround huntingGround) async {
    state = huntingGround;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedHuntingGroundKey, huntingGround.id);
  }

  /// Clear the selected hunting ground
  Future<void> clearSelectedHuntingGround() async {
    state = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_selectedHuntingGroundKey);
  }

  /// Check if the user has any hunting grounds
  Future<bool> hasHuntingGrounds() async {
    final grounds = await _repository.getAll();
    return grounds.isNotEmpty;
  }

  /// Get all hunting grounds accessible to the user
  Future<List<HuntingGround>> getAllHuntingGrounds() async {
    return await _repository.getAll();
  }

  /// Get hunting grounds owned by the current user
  Future<List<HuntingGround>> getOwnedHuntingGrounds() async {
    // This would typically use a query to filter by current user ID
    // For now, we're just returning all hunting grounds
    return await _repository.getAll();

    // Example with actual user ID filtering:
    // final userId = _ref.read(currentUserProvider).id;
    // return await _repository.getWhere(query: Query(
    //   where: [WhereCondition('ownerId', Equal(userId))],
    // ));
  }
}

/// Provider for the selected hunting ground
final selectedHuntingGroundProvider =
    StateNotifierProvider<SelectedHuntingGroundNotifier, HuntingGround?>((ref) {
  return SelectedHuntingGroundNotifier(ref);
});

/// Provide a hunting ground ID for other components to use
final activeHuntingGroundIdProvider = Provider<String?>((ref) {
  final selectedHuntingGround = ref.watch(selectedHuntingGroundProvider);
  return selectedHuntingGround?.id;
});
