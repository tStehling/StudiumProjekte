import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revier_app_client/data/model_registry.dart';

/// Provider for the ModelRegistry
/// This provider should be overridden in main.dart with the initialized registry
final modelRegistryProvider = Provider<ModelRegistry>((ref) {
  throw UnimplementedError('Override this in main.dart');
});
