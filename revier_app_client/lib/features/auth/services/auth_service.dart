import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revier_app_client/config/oauth_config.dart' show OAuthConfig;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:revier_app_client/core/services/logging_service.dart';

/// Provider for the auth service
final authServiceProvider = Provider<AuthService>((ref) {
  final supabase = Supabase.instance.client;
  return AuthService(supabase);
});

/// Provider for the authentication state
final isSignedInProvider = StateProvider<bool>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.isSignedIn();
});

/// Provider for accessing the current user
final currentUserProvider = Provider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.getCurrentUser();
});

/// Provider for authentication state changes as a stream
final authStateProvider = StreamProvider<AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges();
});

/// Service for handling authentication related operations
class AuthService {
  final SupabaseClient _supabaseClient;
  final _log = loggingService.getLogger('AuthService');

  /// Creates an auth service with the given Supabase client
  AuthService(this._supabaseClient) {
    _log.info('AuthService initialized');

    final currentUser = getCurrentUser();
    if (currentUser != null) {
      _log.info('Current user found: ${currentUser.id}');
    } else {
      _log.info('No user currently signed in');
    }
  }

  /// Sign in with email and password
  Future<AuthResponse> signInWithEmail(String email, String password) async {
    try {
      _log.info('Attempting to sign in with email: ${_maskEmail(email)}');
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      _log.info('Sign in successful for user: ${response.user?.id}');
      return response;
    } catch (e, stackTrace) {
      _log.error('Failed to sign in with email',
          error: e, stackTrace: stackTrace);
      rethrow; // Let the UI handle the error with context
    }
  }

  /// Sign up with email and password
  Future<AuthResponse> signUpWithEmail(String email, String password) async {
    try {
      _log.info('Attempting to sign up with email: ${_maskEmail(email)}');
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );
      _log.info('Sign up process initiated, user: ${response.user?.id}');
      return response;
    } catch (e, stackTrace) {
      _log.error('Failed to sign up with email',
          error: e, stackTrace: stackTrace);
      rethrow; // Let the UI handle the error with context
    }
  }

  /// Send password reset email
  Future<void> resetPassword(String email) async {
    try {
      _log.info('Sending password reset email to: ${_maskEmail(email)}');
      await _supabaseClient.auth.resetPasswordForEmail(email);
      _log.info('Password reset email sent successfully');
    } catch (e, stackTrace) {
      _log.error('Failed to send password reset email',
          error: e, stackTrace: stackTrace);
      rethrow; // Let the UI handle the error with context
    }
  }

  /// Sign in with Google
  Future<AuthResponse> signInWithGoogle() async {
    try {
      _log.info('Initiating Google sign-in process');
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: OAuthConfig.androidClientId,
        serverClientId: OAuthConfig.webClientId,
      );

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        _log.warning('Google sign-in canceled by user');
        throw 'Sign in was canceled by the user';
      }

      _log.info('Google user authenticated: ${googleUser.email}');
      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        _log.error('No Access Token found from Google authentication');
        throw 'No Access Token found.';
      }
      if (idToken == null) {
        _log.error('No ID Token found from Google authentication');
        throw 'No ID Token found.';
      }

      _log.info('Completing sign-in with Supabase using Google credentials');
      final response = await _supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        accessToken: accessToken,
        idToken: idToken,
      );
      _log.info(
          'Successfully signed in with Google, user: ${response.user?.id}');
      return response;
    } catch (e, stackTrace) {
      _log.error('Failed to sign in with Google',
          error: e, stackTrace: stackTrace);
      rethrow; // Let the UI handle the error with context
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      final userId = getCurrentUser()?.id;
      _log.info('Signing out user: $userId');
      await _supabaseClient.auth.signOut();
      _log.info('User signed out successfully');
    } catch (e, stackTrace) {
      _log.error('Failed to sign out', error: e, stackTrace: stackTrace);
      rethrow; // Let the UI handle the error with context
    }
  }

  /// Get the current user
  User? getCurrentUser() {
    return _supabaseClient.auth.currentUser;
  }

  /// Get the current session
  Session? getCurrentSession() {
    return _supabaseClient.auth.currentSession;
  }

  /// Check if a user is signed in
  bool isSignedIn() {
    final isUserSignedIn = _supabaseClient.auth.currentUser != null;
    _log.debug('Checking if user is signed in: $isUserSignedIn');
    return isUserSignedIn;
  }

  /// Update the password for a logged in user
  Future<UserResponse> updatePassword(String password) async {
    try {
      _log.info('Updating password for current user');
      final response = await _supabaseClient.auth.updateUser(
        UserAttributes(password: password),
      );
      _log.info('Password updated successfully');
      return response;
    } catch (e, stackTrace) {
      _log.error('Failed to update password', error: e, stackTrace: stackTrace);
      rethrow; // Let the UI handle the error with context
    }
  }

  /// Refreshes the current session
  Future<void> refreshSession() async {
    try {
      _log.info('Refreshing auth session for user: ${getCurrentUser()?.id}');
      await _supabaseClient.auth.refreshSession();
      _log.info('Session refreshed successfully');
    } catch (e, stackTrace) {
      _log.error('Error refreshing session', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Gets the user metadata
  Map<String, dynamic>? get userMetadata => getCurrentUser()?.userMetadata;

  /// Updates user metadata
  Future<UserResponse> updateUserMetadata(Map<String, dynamic> metadata) async {
    try {
      _log.info('Updating metadata for user: ${getCurrentUser()?.id}');
      final response = await _supabaseClient.auth.updateUser(
        UserAttributes(
          data: metadata,
        ),
      );
      _log.info('User metadata updated successfully: $metadata');
      return response;
    } catch (e, stackTrace) {
      _log.error('Error updating user metadata',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Listen to auth state changes
  Stream<AuthState> authStateChanges() {
    _log.debug('Setting up auth state change listener');
    return _supabaseClient.auth.onAuthStateChange;
  }

  /// Masks email for logging purposes
  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return '***@***.***';

    final name = parts[0];
    final domain = parts[1];

    final maskedName = name.length > 2
        ? '${name.substring(0, 2)}${'*' * (name.length - 2)}'
        : name;

    return '$maskedName@$domain';
  }
}
