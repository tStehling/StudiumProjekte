import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Revier App'**
  String get appTitle;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Revier App'**
  String get welcomeMessage;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get orContinueWith;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @resetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset link has been sent to your email'**
  String get resetLinkSent;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordInstructions.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive a password reset link'**
  String get resetPasswordInstructions;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get profileTitle;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordTitle;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @uploadsTitle.
  ///
  /// In en, this message translates to:
  /// **'Uploads'**
  String get uploadsTitle;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @forceSync.
  ///
  /// In en, this message translates to:
  /// **'Force Sync'**
  String get forceSync;

  /// No description provided for @forceSyncSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data successfully synced to Supabase'**
  String get forceSyncSuccess;

  /// No description provided for @noUploads.
  ///
  /// In en, this message translates to:
  /// **'No uploads found'**
  String get noUploads;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get invalidCredentials;

  /// No description provided for @emailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'Email is already in use'**
  String get emailAlreadyInUse;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak'**
  String get weakPassword;

  /// No description provided for @internalServerError.
  ///
  /// In en, this message translates to:
  /// **'Server error, please try again later'**
  String get internalServerError;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error, please check your connection'**
  String get networkError;

  /// No description provided for @authRequired.
  ///
  /// In en, this message translates to:
  /// **'Authentication required'**
  String get authRequired;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error occurred'**
  String get unknownError;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @foreignKeyConstraint.
  ///
  /// In en, this message translates to:
  /// **'Please sync cameras first before syncing uploads'**
  String get foreignKeyConstraint;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailHint;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailInvalid;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmPasswordHint;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirmPasswordRequired;

  /// No description provided for @checkEmail.
  ///
  /// In en, this message translates to:
  /// **'Check Your Email'**
  String get checkEmail;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @resetPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get resetPasswordButton;

  /// No description provided for @registrationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Registration successful!'**
  String get registrationSuccessful;

  /// No description provided for @errorLoadingUploads.
  ///
  /// In en, this message translates to:
  /// **'Error loading uploads: '**
  String get errorLoadingUploads;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get changeLanguage;

  /// No description provided for @changeTheme.
  ///
  /// In en, this message translates to:
  /// **'Change theme'**
  String get changeTheme;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @sightingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sightings'**
  String get sightingsTitle;

  /// No description provided for @mediaTitle.
  ///
  /// In en, this message translates to:
  /// **'Media'**
  String get mediaTitle;

  /// No description provided for @animalFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get animalFilterTitle;

  /// No description provided for @huntingGroundTitle.
  ///
  /// In en, this message translates to:
  /// **'Hunting area'**
  String get huntingGroundTitle;

  /// Choose system theme
  ///
  /// In en, this message translates to:
  /// **'System theme'**
  String get systemTheme;

  /// Choose light theme
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get lightTheme;

  /// Choose dark theme
  ///
  /// In en, this message translates to:
  /// **'Dark theme'**
  String get darkTheme;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @animal.
  ///
  /// In en, this message translates to:
  /// **'Animals'**
  String get animal;

  /// No description provided for @sightings.
  ///
  /// In en, this message translates to:
  /// **'Sightings'**
  String get sightings;

  /// No description provided for @media.
  ///
  /// In en, this message translates to:
  /// **'Media'**
  String get media;

  /// No description provided for @selectOption.
  ///
  /// In en, this message translates to:
  /// **'Please select an option'**
  String get selectOption;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @noOptionsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No options available'**
  String get noOptionsAvailable;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @latitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get latitude;

  /// No description provided for @longitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get longitude;

  /// No description provided for @discardChanges.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get discardChanges;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @isRequired.
  ///
  /// In en, this message translates to:
  /// **'is required'**
  String get isRequired;

  /// No description provided for @wordNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get wordNew;

  /// No description provided for @plsEnterValNum.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number.'**
  String get plsEnterValNum;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @noResultFor.
  ///
  /// In en, this message translates to:
  /// **'No result for: '**
  String get noResultFor;

  /// No description provided for @errorLoadData.
  ///
  /// In en, this message translates to:
  /// **'Error loading data: '**
  String get errorLoadData;

  /// No description provided for @createHuntingGround.
  ///
  /// In en, this message translates to:
  /// **'Create hunting ground'**
  String get createHuntingGround;

  /// No description provided for @selectHuntingGround.
  ///
  /// In en, this message translates to:
  /// **'Select hunting ground'**
  String get selectHuntingGround;

  /// No description provided for @failLoadHuntingGround.
  ///
  /// In en, this message translates to:
  /// **'Failed loading hunting grounds'**
  String get failLoadHuntingGround;

  /// No description provided for @failSelectHuntingGround.
  ///
  /// In en, this message translates to:
  /// **'Failed to select hunting ground: '**
  String get failSelectHuntingGround;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noHGFound.
  ///
  /// In en, this message translates to:
  /// **'No hunting grounds found.\nTap + to create one'**
  String get noHGFound;

  /// No description provided for @noHGSelected.
  ///
  /// In en, this message translates to:
  /// **'No Hunting Ground Selected'**
  String get noHGSelected;

  /// No description provided for @selectHGFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a hunting ground first'**
  String get selectHGFirst;

  /// No description provided for @uploads.
  ///
  /// In en, this message translates to:
  /// **'Uploads'**
  String get uploads;

  /// No description provided for @syncWithServer.
  ///
  /// In en, this message translates to:
  /// **'Sync with server'**
  String get syncWithServer;

  /// No description provided for @createTestUpload.
  ///
  /// In en, this message translates to:
  /// **'Create test upload'**
  String get createTestUpload;

  /// No description provided for @manuallyCheckUploads.
  ///
  /// In en, this message translates to:
  /// **'Manually check uploads'**
  String get manuallyCheckUploads;

  /// No description provided for @syncDatabase.
  ///
  /// In en, this message translates to:
  /// **'Synchronize database'**
  String get syncDatabase;

  /// No description provided for @stillLoading.
  ///
  /// In en, this message translates to:
  /// **'Still loading...\nTap to create a test upload'**
  String get stillLoading;

  /// No description provided for @checkUploads.
  ///
  /// In en, this message translates to:
  /// **'Check uploads'**
  String get checkUploads;

  /// No description provided for @uploadError.
  ///
  /// In en, this message translates to:
  /// **'Uploads - Error'**
  String get uploadError;

  /// No description provided for @unsavedDiscardWarning.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Are you sure you want to discard them?'**
  String get unsavedDiscardWarning;

  /// No description provided for @species.
  ///
  /// In en, this message translates to:
  /// **'Species'**
  String get species;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get years;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'weight'**
  String get weight;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes: '**
  String get notes;

  /// No description provided for @noEmail.
  ///
  /// In en, this message translates to:
  /// **'No E-Mail'**
  String get noEmail;

  /// No description provided for @userID.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get userID;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account created'**
  String get accountCreated;

  /// No description provided for @accountOptions.
  ///
  /// In en, this message translates to:
  /// **'Account options'**
  String get accountOptions;

  /// No description provided for @plsEnterNewPW.
  ///
  /// In en, this message translates to:
  /// **'Please enter a new password'**
  String get plsEnterNewPW;

  /// No description provided for @pwLengthTip.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get pwLengthTip;

  /// No description provided for @plsConfirmPW.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get plsConfirmPW;

  /// No description provided for @pwUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get pwUpdateSuccess;

  /// No description provided for @newSighting.
  ///
  /// In en, this message translates to:
  /// **'New sighting'**
  String get newSighting;

  /// No description provided for @editSighting.
  ///
  /// In en, this message translates to:
  /// **'Edit sighting'**
  String get editSighting;

  /// No description provided for @createNewHG.
  ///
  /// In en, this message translates to:
  /// **'Create new hunting ground'**
  String get createNewHG;

  /// No description provided for @refreshHG.
  ///
  /// In en, this message translates to:
  /// **'Refresh Hunting Grounds'**
  String get refreshHG;

  /// No description provided for @errorLoadingHG.
  ///
  /// In en, this message translates to:
  /// **'Failed to load hunting grounds'**
  String get errorLoadingHG;

  /// No description provided for @errorSelectHG.
  ///
  /// In en, this message translates to:
  /// **'Failed to select hunting ground'**
  String get errorSelectHG;

  /// No description provided for @errorBuildUploadScreen.
  ///
  /// In en, this message translates to:
  /// **'Error building UploadsScreen: '**
  String get errorBuildUploadScreen;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get goBack;

  /// No description provided for @noUploadsYet.
  ///
  /// In en, this message translates to:
  /// **'No uploads yet'**
  String get noUploadsYet;

  /// No description provided for @syncToDB.
  ///
  /// In en, this message translates to:
  /// **'Syncing to Datenbank'**
  String get syncToDB;

  /// No description provided for @plsWaitSync.
  ///
  /// In en, this message translates to:
  /// **'Please wait while syncing data...'**
  String get plsWaitSync;

  /// No description provided for @createNewUpload.
  ///
  /// In en, this message translates to:
  /// **'Create New Upload'**
  String get createNewUpload;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @useCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use current location'**
  String get useCurrentLocation;

  /// No description provided for @cameraID.
  ///
  /// In en, this message translates to:
  /// **'Camera ID'**
  String get cameraID;

  /// No description provided for @enterCameraID.
  ///
  /// In en, this message translates to:
  /// **'Please enter camera ID'**
  String get enterCameraID;

  /// No description provided for @tapToSelectColor.
  ///
  /// In en, this message translates to:
  /// **'Tap to select color'**
  String get tapToSelectColor;

  /// No description provided for @selectSpecies.
  ///
  /// In en, this message translates to:
  /// **'Select species'**
  String get selectSpecies;

  /// No description provided for @selectShootingRecord.
  ///
  /// In en, this message translates to:
  /// **'Select shooting record'**
  String get selectShootingRecord;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @speciesRequired.
  ///
  /// In en, this message translates to:
  /// **'Species is required'**
  String get speciesRequired;

  /// No description provided for @huntingGroundRequired.
  ///
  /// In en, this message translates to:
  /// **'Hunting Ground is required'**
  String get huntingGroundRequired;

  /// No description provided for @ageCannotBeNegative.
  ///
  /// In en, this message translates to:
  /// **'Age cannot be negative'**
  String get ageCannotBeNegative;

  /// No description provided for @weightMustBePositive.
  ///
  /// In en, this message translates to:
  /// **'Weight must be greater than zero'**
  String get weightMustBePositive;

  /// No description provided for @validationError.
  ///
  /// In en, this message translates to:
  /// **'Validation error occurred'**
  String get validationError;

  /// No description provided for @modelRegistryNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Model Registry not available'**
  String get modelRegistryNotAvailable;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortBy;

  /// No description provided for @sortAscending.
  ///
  /// In en, this message translates to:
  /// **'Sort Ascending'**
  String get sortAscending;

  /// No description provided for @sortDescending.
  ///
  /// In en, this message translates to:
  /// **'Sort Descending'**
  String get sortDescending;

  /// No description provided for @noSortOptionsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No sort options available'**
  String get noSortOptionsAvailable;

  /// No description provided for @sortOptions.
  ///
  /// In en, this message translates to:
  /// **'Sort options'**
  String get sortOptions;

  /// No description provided for @listView.
  ///
  /// In en, this message translates to:
  /// **'List View'**
  String get listView;

  /// No description provided for @gridView.
  ///
  /// In en, this message translates to:
  /// **'Grid View'**
  String get gridView;

  /// No description provided for @shotOnDate.
  ///
  /// In en, this message translates to:
  /// **'Shot on {date}'**
  String shotOnDate(String date);

  /// Label for search field
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
