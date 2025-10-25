import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:revier_app_client/brick/brick_repository.dart';

part 'brick_repository_provider.g.dart';

/// Provider for the Brick repository
/// This provider should be overridden in main.dart with the initialized repository
@riverpod
BrickRepository brickRepository(BrickRepositoryRef ref) {
  throw UnimplementedError('Override this in main.dart');
}
