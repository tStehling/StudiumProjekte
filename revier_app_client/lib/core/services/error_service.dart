import 'package:flutter/material.dart';
import 'package:revier_app_client/localization/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for handling errors and providing user-friendly messages
class ErrorService {
  /// Converts a Supabase auth error to a user-friendly error message
  static String getAuthError(BuildContext context, dynamic error) {
    debugPrint('Auth error: $error');
    final l10n = AppLocalizations.of(context);

    if (error is AuthException) {
      // Handle Supabase authentication errors
      switch (error.message) {
        case 'Invalid login credentials':
          return l10n.invalidCredentials;
        case 'Email already registered':
          return l10n.emailAlreadyInUse;
        case 'Password should be at least 6 characters':
          return l10n.weakPassword;
        default:
          if (error.message.contains('foreign key constraint')) {
            return l10n.foreignKeyConstraint;
          }
          return error.message;
      }
    } else if (error is PostgrestException) {
      // Handle database errors
      if (error.message.contains('foreign key constraint')) {
        return l10n.foreignKeyConstraint;
      }
      return error.message;
    } else {
      // Handle other types of errors
      return l10n.unknownError;
    }
  }

  /// Show an error message in a SnackBar
  static void showErrorSnackBar(BuildContext context, dynamic error) {
    final errorMessage = getAuthError(context, error);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Show a success message in a SnackBar
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
