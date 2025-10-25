import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revier_app_client/features/auth/services/auth_service.dart';
import 'package:revier_app_client/features/auth/presentation/screens/auth_screen.dart';
import 'package:revier_app_client/features/auth/presentation/state/auth_state_notifier.dart'
    show authStateListenerProvider;
import 'package:revier_app_client/core/services/logging_service.dart';

/// A widget that wraps a child widget and redirects to the auth screen if the user is not signed in
class AuthWrapper extends ConsumerWidget {
  /// The child widget to display if the user is authenticated
  final Widget child;

  /// Creates an AuthWrapper
  const AuthWrapper({super.key, required this.child});

  // Declare as a getter to avoid initialization issues with const constructor
  static final _logger = loggingService.getLogger('AuthWrapper');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _logger.debug('Building AuthWrapper');
    final isSignedIn = ref.watch(isSignedInProvider);
    _logger.info(
        'User authentication status: ${isSignedIn ? 'Authenticated' : 'Not authenticated'}');

    // Watch auth state listener to keep updates flowing
    ref.watch(authStateListenerProvider);

    // Also watch the auth state provider to ensure we get stream updates
    ref.watch(authStateProvider);

    // If user is not signed in, redirect to auth screen
    if (!isSignedIn) {
      _logger.info('User not signed in, redirecting to AuthScreen');
      return const AuthScreen();
    }

    // User is signed in, show the protected content
    _logger.info('User is signed in, showing protected content');
    return child;
  }
}
