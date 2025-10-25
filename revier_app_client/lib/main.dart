import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:revier_app_client/brick/brick_repository.dart';
import 'package:revier_app_client/config/supabase_config.dart'
    show SupabaseConfig;
import 'package:revier_app_client/config/app_theme.dart';
import 'package:revier_app_client/core/services/i18n_service.dart';
import 'package:revier_app_client/core/services/logging_service.dart';
import 'package:revier_app_client/data/model_registry.dart';
import 'package:revier_app_client/data/providers/brick_repository_provider.dart';
import 'package:revier_app_client/data/providers/model_registry_provider.dart';
import 'package:revier_app_client/core/providers/theme_provider.dart';
import 'package:revier_app_client/data/register_models.dart';
import 'package:revier_app_client/common/navigation/navigation_service.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:revier_app_client/data/providers/widget_ref_provider.dart';

import 'package:revier_app_client/features/auth/presentation/widgets/auth_wrapper.dart';
import 'package:revier_app_client/features/hunting_ground/providers/hunting_ground_provider.dart';
import 'package:revier_app_client/data/reference_data_initializer.dart';

import 'package:revier_app_client/localization/app_localizations.dart';
import 'package:revier_app_client/core/providers/locale_provider.dart';
import 'package:revier_app_client/presentation/screens/main_map_screen.dart';
import 'package:revier_app_client/presentation/screens/main_hunting_ground_select_screen.dart';

void main() async {
  try {
    // Initialize logging first
    loggingService.initialize(includeTimestamps: true, writeToFile: false);
    final log = loggingService.getLogger('main');

    // Preserve splash screen until app is fully loaded
    log.info('App starting... initializing services');
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    log.info('Flutter binding initialized');

    // Initialize i18n service
    log.info('Initializing i18n service...');
    await I18nService.instance.initialize();
    log.info(
        'I18n service initialized with locale: ${I18nService.instance.currentLocale}');

    // Load saved theme preference
    log.info('Loading saved theme...');
    final savedTheme = await ThemePreferences.loadSavedTheme();
    log.info('Theme loaded: $savedTheme');

    // Initialize Brick repository
    log.info('Configuring Brick repository...');
    await BrickRepository.configure(
        SupabaseConfig.supabaseUrl, SupabaseConfig.supabaseAnonKey);
    log.info('Brick repository configured successfully');

    // Setup connectivity listener for Brick
    log.info('Initializing Brick repository...');
    await BrickRepository().initialize();
    log.info('Brick repository initialized successfully');

    // Initialize the model registry
    log.info('Initializing Model Registry...');
    final modelRegistry = ModelRegistry(brickRepositoryProvider);
    registerModels(modelRegistry);
    log.info('Model Registry initialized with all models');

    // Create a container with the initial state
    log.info('Creating provider container...');
    final container = ProviderContainer(
      overrides: [
        // Override the brick repository provider with the initialized repository
        brickRepositoryProvider.overrideWithValue(BrickRepository()),
        // Override the model registry provider with the initialized registry
        modelRegistryProvider.overrideWithValue(modelRegistry),
        // Set the initial locale
        localeProvider
            .overrideWith((ref) => I18nService.instance.currentLocale),
      ],
      observers: [
        _ProviderLogger(),
      ],
    );
    log.info('Provider container created');

    // Set the initial theme state
    container.read(themeModeProvider.notifier).state = savedTheme;
    log.info('Theme state set');

    log.info('Running app...');

    // Remove splash screen after initialization is complete
    FlutterNativeSplash.remove();

    runApp(
      UncontrolledProviderScope(
        container: container,
        child: Consumer(
          builder: (context, ref, child) {
            // Set the global ref that will be used by services
            GlobalRef().setRef(ref);
            return const MyApp();
          },
        ),
      ),
    );
    log.info('App started successfully');
  } catch (e, stackTrace) {
    final log = loggingService.getLogger('main');
    log.error('Error during app initialization',
        error: e, stackTrace: stackTrace);

    // Remove splash screen if there's an error
    FlutterNativeSplash.remove();

    // Run a minimal app that displays the error
    runApp(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Error initializing app: $e',
                style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Logger for Riverpod providers that logs all provider state changes
class _ProviderLogger extends ProviderObserver {
  final _log = loggingService.getLogger('ProviderObserver');

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    _log.fine(
      'Provider ${provider.name ?? provider.runtimeType} updated: $newValue',
    );
  }

  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    _log.fine(
      'Provider ${provider.name ?? provider.runtimeType} added: $value',
    );
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    _log.fine(
      'Provider ${provider.name ?? provider.runtimeType} disposed',
    );
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final log = loggingService.getLogger('MyApp');
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    log.info('Building app with themeMode: $themeMode, locale: $locale');

    return ReferenceDataInitializer(
      child: MaterialApp(
        title: 'Revier App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        locale: locale,
        // Set up localization delegates
        localizationsDelegates: const [
          AppLocalizations.delegate, // Add the generated delegate
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const AuthWrapper(child: HomePage()),
        // Add navigation key for our navigation service
        navigatorKey: NavigationService.instance.navigatorKey,
        // Register route observer to track navigation events
        navigatorObservers: [NavigationService.instance.routeObserver],
        // Add custom page transitions for named routes
        onGenerateRoute: (settings) {
          log.fine('Generating route for: ${settings.name}');
          switch (settings.name) {
            // Define your named routes here with custom transitions
            default:
              return null;
          }
        },
      ),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final log = loggingService.getLogger('HomePage');

    // Check if a hunting ground is selected
    final selectedHuntingGround = ref.watch(selectedHuntingGroundProvider);

    log.info(
        'Building HomePage with selectedHuntingGround: ${selectedHuntingGround?.id}');

    // If no hunting ground is selected, show the hunting ground selection screen
    if (selectedHuntingGround == null) {
      log.info('No hunting ground selected, showing selection screen');
      return const MainHuntingGroundSelectScreen();
    }

    // Otherwise, show the main map screen
    log.info('Hunting ground selected, showing map screen');
    return const MainMapScreen();
  }
}
