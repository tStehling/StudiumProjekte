import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revier_app_client/features/auth/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:revier_app_client/core/services/logging_service.dart';

// Create a provider that listens to Supabase auth changes
final authStateListenerProvider = Provider<void>((ref) {
  final log = loggingService.getLogger('AuthStateListener');
  log.info('Setting up auth state change listener');

  // Get auth service
  final authService = ref.watch(authServiceProvider);

  final subscription = authService.authStateChanges().listen((data) {
    final event = data.event;
    final session = data.session;

    log.info('Auth state changed: $event');

    // Update isSignedInProvider based on auth state
    if (event == AuthChangeEvent.signedIn || session != null) {
      log.info('User signed in, user ID: ${session?.user.id}');
      ref.read(isSignedInProvider.notifier).state = true;
    } else if (event == AuthChangeEvent.signedOut) {
      log.info('User signed out');
      ref.read(isSignedInProvider.notifier).state = false;
    } else if (event == AuthChangeEvent.userUpdated) {
      log.info('User profile updated, user ID: ${session?.user.id}');
    } else if (event == AuthChangeEvent.passwordRecovery) {
      log.info('Password recovery initiated');
    } else if (event == AuthChangeEvent.tokenRefreshed) {
      log.debug('Token refreshed');
    } else {
      log.info('Other auth event: $event');
    }
  });

  subscription.onError((error, stackTrace) {
    log.error('Auth state change error', error: error, stackTrace: stackTrace);
    log.info('Attempting to refresh session');
    authService.refreshSession();
  });

  // Clean up subscription when provider is disposed
  ref.onDispose(() {
    log.debug('Disposing auth state change listener');
    subscription.cancel();
  });
});
