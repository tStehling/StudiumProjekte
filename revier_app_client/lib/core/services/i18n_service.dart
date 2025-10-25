import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Supported locales in the app
class AppLocale {
  static const Locale en = Locale('en', 'US');
  static const Locale de = Locale('de', 'DE');
  static const List<Locale> supportedLocales = [en, de];
}

/// A service that manages the app's internationalization
class I18nService {
  static const String _languageKey = 'app_language';
  late Locale _currentLocale;

  // Singleton instance
  static I18nService? _instance;

  /// Get the singleton instance
  static I18nService get instance => _instance ??= I18nService._();

  /// Private constructor
  I18nService._() {
    // Default to German
    _currentLocale = AppLocale.de;
  }

  /// The current locale
  Locale get currentLocale => _currentLocale;

  /// Initialize the service
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey);

      if (languageCode != null) {
        _currentLocale = Locale(languageCode);
      } else {
        // Use device locale if possible, defaulting to German
        final deviceLocale = PlatformDispatcher.instance.locale;
        if (AppLocale.supportedLocales.any(
            (locale) => locale.languageCode == deviceLocale.languageCode)) {
          _currentLocale = Locale(deviceLocale.languageCode);
        } else {
          _currentLocale = AppLocale.de;
        }
      }

      // Save the locale
      await prefs.setString(_languageKey, _currentLocale.languageCode);
    } catch (e) {
      debugPrint('Error initializing i18n service: $e');
      _currentLocale = AppLocale.de;
    }
  }

  /// Change the app locale
  Future<void> changeLocale(BuildContext context, Locale locale) async {
    try {
      if (!AppLocale.supportedLocales.any((supportedLocale) =>
          supportedLocale.languageCode == locale.languageCode)) {
        return;
      }

      _currentLocale = locale;

      // Save the preference
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, locale.languageCode);
    } catch (e) {
      debugPrint('Error changing locale: $e');
    }
  }

  /// Get translations map for a specific locale
  Map<String, dynamic> getTranslations(Locale locale) {
    if (locale.languageCode == 'de') {
      return _germanTranslations;
    }
    return _englishTranslations;
  }

  /// Get a translated string for the current locale
  String translate(BuildContext context, String key) {
    try {
      // Split the key by dots to access nested maps
      final keyParts = key.split('.');
      dynamic value;

      // Get translations for the current locale
      final translations = getTranslations(Localizations.localeOf(context));

      // Navigate through the nested maps to find the value
      value = translations;
      for (final part in keyParts) {
        if (value is! Map) {
          return key; // Return the key if we can't navigate further
        }
        value = value[part];
        if (value == null) {
          return key; // Return the key if the value is null
        }
      }

      return value.toString();
    } catch (e) {
      debugPrint('Translation error for key: $key - $e');
      return key.split('.').last;
    }
  }

  // English translations
  static final Map<String, dynamic> _englishTranslations = {
    'app': {'title': 'Revier App', 'welcomeMessage': 'Welcome to Revier App'},
    'auth': {
      'signIn': 'Sign In',
      'signUp': 'Sign Up',
      'email': 'Email',
      'password': 'Password',
      'forgotPassword': 'Forgot Password?',
      'confirmPassword': 'Confirm Password',
      'orContinueWith': 'or continue with',
      'dontHaveAccount': 'Don\'t have an account?',
      'alreadyHaveAccount': 'Already have an account?',
      'resetPassword': 'Reset Password',
      'resetPasswordInstructions':
          'Enter your email address and we\'ll send you a link to reset your password.',
      'sendResetLink': 'Send Reset Link',
      'checkEmail': 'Check Your Email',
      'checkEmailInstructions':
          'We\'ve sent a password reset link to your email address. Please check your inbox and follow the instructions.',
      'returnToLogin': 'Return to Login',
      'changePassword': 'Change Password',
      'updatePassword': 'Update Password'
    },
    'profile': {
      'title': 'My Profile',
      'email': 'Email',
      'userId': 'User ID',
      'lastLogin': 'Last Login',
      'accountCreated': 'Account Created',
      'accountActions': 'Account Actions',
      'signOut': 'Sign Out'
    },
    'uploads': {
      'title': 'Uploads',
      'syncWithServer': 'Sync with server',
      'createTestUpload': 'Create Test Upload',
      'forceSyncToSupabase': 'Force Sync to Supabase',
      'manuallyCheckUploads': 'Manually check uploads',
      'noUploads': 'No uploads yet',
      'uploadCreated': 'Upload created',
      'refreshingData': 'Refreshing data...',
      'found': 'Found',
      'uploadsInDatabase': 'uploads in database'
    },
    'common': {
      'cancel': 'Cancel',
      'save': 'Save',
      'update': 'Update',
      'create': 'Create',
      'delete': 'Delete',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'retry': 'Retry',
      'goBack': 'Go Back',
      'close': 'Close'
    },
    'errors': {
      'auth': {
        'invalidEmail': 'The email address is invalid.',
        'userNotFound': 'No user found with this email address.',
        'wrongPassword': 'The password is incorrect.',
        'emailAlreadyInUse': 'This email is already registered.',
        'weakPassword': 'The password is too weak.',
        'passwordsDoNotMatch': 'Passwords do not match.',
        'networkError': 'Network error. Please check your connection.',
        'unknownError': 'An unexpected error occurred. Please try again.'
      },
      'general': {
        'offline': 'You are offline. Some features may not be available.',
        'permissionDenied':
            'Permission denied. You don\'t have access to this feature.',
        'serverError': 'Server error. Please try again later.',
        'unexpectedError': 'An unexpected error occurred. Please try again.'
      }
    }
  };

  // German translations
  static final Map<String, dynamic> _germanTranslations = {
    'app': {
      'title': 'Revier App',
      'welcomeMessage': 'Willkommen bei der Revier App'
    },
    'auth': {
      'signIn': 'Anmelden',
      'signUp': 'Registrieren',
      'email': 'E-Mail',
      'password': 'Passwort',
      'forgotPassword': 'Passwort vergessen?',
      'confirmPassword': 'Passwort bestätigen',
      'orContinueWith': 'oder fortfahren mit',
      'dontHaveAccount': 'Noch kein Konto?',
      'alreadyHaveAccount': 'Bereits ein Konto?',
      'resetPassword': 'Passwort zurücksetzen',
      'resetPasswordInstructions':
          'Geben Sie Ihre E-Mail-Adresse ein und wir senden Ihnen einen Link zum Zurücksetzen Ihres Passworts.',
      'sendResetLink': 'Link zum Zurücksetzen senden',
      'checkEmail': 'Überprüfen Sie Ihre E-Mail',
      'checkEmailInstructions':
          'Wir haben einen Link zum Zurücksetzen des Passworts an Ihre E-Mail-Adresse gesendet. Bitte überprüfen Sie Ihren Posteingang und folgen Sie den Anweisungen.',
      'returnToLogin': 'Zurück zur Anmeldung',
      'changePassword': 'Passwort ändern',
      'updatePassword': 'Passwort aktualisieren'
    },
    'profile': {
      'title': 'Mein Profil',
      'email': 'E-Mail',
      'userId': 'Benutzer-ID',
      'lastLogin': 'Letzte Anmeldung',
      'accountCreated': 'Konto erstellt',
      'accountActions': 'Kontoaktionen',
      'signOut': 'Abmelden'
    },
    'uploads': {
      'title': 'Uploads',
      'syncWithServer': 'Mit Server synchronisieren',
      'createTestUpload': 'Test-Upload erstellen',
      'forceSyncToSupabase': 'Synchronisierung mit Supabase erzwingen',
      'manuallyCheckUploads': 'Uploads manuell prüfen',
      'noUploads': 'Noch keine Uploads',
      'uploadCreated': 'Upload erstellt',
      'refreshingData': 'Daten werden aktualisiert...',
      'found': 'Gefunden',
      'uploadsInDatabase': 'Uploads in der Datenbank'
    },
    'common': {
      'cancel': 'Abbrechen',
      'save': 'Speichern',
      'update': 'Aktualisieren',
      'create': 'Erstellen',
      'delete': 'Löschen',
      'loading': 'Wird geladen...',
      'error': 'Fehler',
      'success': 'Erfolg',
      'retry': 'Wiederholen',
      'goBack': 'Zurück',
      'close': 'Schließen'
    },
    'errors': {
      'auth': {
        'invalidEmail': 'Die E-Mail-Adresse ist ungültig.',
        'userNotFound': 'Kein Benutzer mit dieser E-Mail-Adresse gefunden.',
        'wrongPassword': 'Das Passwort ist falsch.',
        'emailAlreadyInUse': 'Diese E-Mail ist bereits registriert.',
        'weakPassword': 'Das Passwort ist zu schwach.',
        'passwordsDoNotMatch': 'Passwörter stimmen nicht überein.',
        'networkError': 'Netzwerkfehler. Bitte überprüfen Sie Ihre Verbindung.',
        'unknownError':
            'Ein unerwarteter Fehler ist aufgetreten. Bitte versuchen Sie es erneut.'
      },
      'general': {
        'offline':
            'Sie sind offline. Einige Funktionen sind möglicherweise nicht verfügbar.',
        'permissionDenied':
            'Zugriff verweigert. Sie haben keinen Zugang zu dieser Funktion.',
        'serverError':
            'Serverfehler. Bitte versuchen Sie es später noch einmal.',
        'unexpectedError':
            'Ein unerwarteter Fehler ist aufgetreten. Bitte versuchen Sie es erneut.'
      }
    }
  };
}

/// Extension for easy translations
extension TranslateX on BuildContext {
  String tr(String key) {
    return I18nService.instance.translate(this, key);
  }
}
