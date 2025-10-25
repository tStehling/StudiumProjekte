import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revier_app_client/data/model_registry.dart';
import 'package:revier_app_client/data/reference_data_service.dart';
import 'package:revier_app_client/data/providers/model_registry_provider.dart';
import 'package:revier_app_client/brick/models/country.model.dart';
import 'package:revier_app_client/brick/models/federal_state.model.dart';
import 'package:revier_app_client/data/providers/widget_ref_provider.dart';

/// A widget that ensures reference data is properly initialized
///
/// This widget should be placed high in the widget tree, preferably
/// just inside the MaterialApp, to ensure reference data is available
/// throughout the app.
class ReferenceDataInitializer extends ConsumerStatefulWidget {
  final Widget child;

  const ReferenceDataInitializer({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<ReferenceDataInitializer> createState() =>
      _ReferenceDataInitializerState();
}

class _ReferenceDataInitializerState
    extends ConsumerState<ReferenceDataInitializer> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize reference data after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeReferenceData();
    });
  }

  /// Initialize reference data synchronization
  Future<void> _initializeReferenceData() async {
    if (_initialized) return;

    // Provide global access to WidgetRef
    try {
      provideGlobalWidgetRef(ref);
    } catch (e) {
      debugPrint('ReferenceDataInitializer: Error setting global ref: $e');
    }

    try {
      // Get the reference data service and model registry
      final referenceDataService = ref.read(referenceDataServiceProvider);
      final modelRegistry = ref.read(modelRegistryProvider);

      Country? germany;

      // Load countries
      final countries = await referenceDataService.getCountryOptions(ref);

      // If no countries found, create some sample data
      if (countries.isEmpty || countries.length == 1) {
        try {
          // Try to create default countries
          germany = Country(name: 'Germany');
          final usa = Country(name: 'United States');
          final france = Country(name: 'France');

          // Use create method which is available on modelRegistry
          await modelRegistry.create<Country>(ref, germany);
          await modelRegistry.create<Country>(ref, usa);
          await modelRegistry.create<Country>(ref, france);

          // Clear the cache so we reload with new data
          referenceDataService.clearOptionsCache('Country');
        } catch (e) {
          debugPrint('Error creating default countries: $e');
        }
      }

      // Load federal states
      final states = await referenceDataService.getFederalStateOptions(ref);

      // If no federal states found, create some sample data
      if (states.isEmpty || states.length == 1) {
        try {
          // First refresh countries to get their IDs
          final refreshedCountries =
              await referenceDataService.getReferenceData<Country>(ref);
          if (refreshedCountries.isNotEmpty) {
            final countryId = refreshedCountries.first.id;

            germany ??= Country(name: 'Germany', id: countryId);

            final bavaria = FederalState(name: 'Bavaria', country: germany);
            final saxony = FederalState(name: 'Saxony', country: germany);
            final berlin = FederalState(name: 'Berlin', country: germany);

            await modelRegistry.create<FederalState>(ref, bavaria);
            await modelRegistry.create<FederalState>(ref, saxony);
            await modelRegistry.create<FederalState>(ref, berlin);

            // Clear the cache so we reload with new data
            referenceDataService.clearOptionsCache('FederalState');
          }
        } catch (e) {
          debugPrint('Error creating default federal states: $e');
        }
      }

      // Load species
      await referenceDataService.getSpeciesOptions(ref);

      setState(() {
        _initialized = true;
      });
    } catch (e, stackTrace) {
      debugPrint(
          'ReferenceDataInitializer: Error initializing reference data: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Set up global widget ref access
void provideGlobalWidgetRef(WidgetRef ref) {
  try {
    // Use the existing container from the provider scope
    final container = ProviderScope.containerOf(ref.context);

    container.updateOverrides([
      widgetRefProvider.overrideWithValue(ref),
    ]);

    // Verify it's working
    GlobalRef().setRef(ref);
  } catch (e) {
    debugPrint('Error setting global widget ref: $e');
  }
}
