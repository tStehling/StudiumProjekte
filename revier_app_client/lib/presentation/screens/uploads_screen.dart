import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:revier_app_client/brick/models/camera.model.dart';
import 'package:revier_app_client/brick/models/country.model.dart';
import 'package:revier_app_client/brick/models/federal_state.model.dart';
import 'package:revier_app_client/brick/models/hunting_ground.model.dart';
import 'package:revier_app_client/brick/models/upload.model.dart';
import 'package:revier_app_client/data/model_registry.dart';
import 'package:revier_app_client/data/providers/model_registry_provider.dart';
import 'package:revier_app_client/data/providers/widget_ref_provider.dart';
import 'package:revier_app_client/features/hunting_ground/providers/hunting_ground_provider.dart';
import 'package:revier_app_client/presentation/widgets/upload_tile.dart';
import 'package:revier_app_client/data/providers/brick_repository_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:revier_app_client/localization/app_localizations.dart';

// Provider to force UI updates when data is available but UI is still loading
final _forceUpdateProvider = StateProvider<int>((ref) => 0);

/// A screen that displays a list of uploads
class UploadsScreen extends HookConsumerWidget {
  /// Constructor
  const UploadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    debugPrint('DIRECT_DEBUG: Building UploadsScreen');

    // Use a try-catch block to catch any errors during the build
    try {
      debugPrint('DIRECT_DEBUG: About to read modelRegistryProvider');
      final registry = ref.watch(modelRegistryProvider);
      debugPrint('DIRECT_DEBUG: Got model registry: ${registry != null}');

      // Create a stream controller to force UI updates
      final forceUpdate = ref.watch(_forceUpdateProvider);

      // Force a manual refresh when the screen loads and set a timeout
      debugPrint('DIRECT_DEBUG: Setting up delayed refresh');
      Future.delayed(Duration.zero, () {
        debugPrint('DIRECT_DEBUG: Inside delayed refresh');
        try {
          debugPrint('DIRECT_DEBUG: About to call refresh');

          // Start a timer to detect if refresh takes too long
          Timer(const Duration(seconds: 3), () {
            debugPrint(
                'DIRECT_DEBUG: Refresh timer reached - checking if still loading');

            // Try to force a manual data load if still loading
            try {
              final notifier = registry.getNotifier<Upload>(ref);
              debugPrint(
                  'DIRECT_DEBUG: Got notifier state: ${notifier?.state}');

              if (notifier?.state is AsyncData) {
                debugPrint(
                    'DIRECT_DEBUG: Data exists but UI might still be loading - forcing update');
                // Force UI update
                ref
                    .read(_forceUpdateProvider.notifier)
                    .update((state) => state + 1);
              }
            } catch (e) {
              debugPrint('DIRECT_DEBUG: Error in timeout refresh attempt: $e');
            }
          });

          registry.refresh<Upload>(ref).then((_) {
            debugPrint('DIRECT_DEBUG: Initial refresh completed');

            // Check what happened after refresh
            try {
              final notifier = registry.getNotifier<Upload>(ref);
              debugPrint(
                  'DIRECT_DEBUG: After refresh, notifier state: ${notifier.state}');

              if (notifier.state is AsyncData) {
                final data = (notifier.state).value!;
                debugPrint(
                    'DIRECT_DEBUG: After refresh, found ${data.length} uploads');

                // Force UI update after successful data load
                ref
                    .read(_forceUpdateProvider.notifier)
                    .update((state) => state + 1);
              }
            } catch (e) {
              debugPrint(
                  'DIRECT_DEBUG: Error checking state after refresh: $e');
            }
          }).catchError((error) {
            debugPrint('DIRECT_DEBUG: Error in initial refresh: $error');
          });
        } catch (e) {
          debugPrint('DIRECT_DEBUG: Error in delayed refresh: $e');
        }
      });

      debugPrint('DIRECT_DEBUG: About to call watchAll<Upload>');
      final uploadsAsync = registry.watchAll<Upload>(ref);
      debugPrint(
          'DIRECT_DEBUG: Got uploadsAsync state: ${uploadsAsync.toString()}');

      // Try to get more details about the state
      if (uploadsAsync is AsyncData) {
        final data = uploadsAsync.value;
        debugPrint('DIRECT_DEBUG: AsyncData contains ${data?.length} uploads');

        // Print the first few upload IDs for debugging
        if (data != null && data.isNotEmpty) {
          for (int i = 0; i < math.min(3, data.length); i++) {
            debugPrint(
                'DIRECT_DEBUG: Upload[$i] id = ${data[i].id}, status = ${data[i].status}');
          }
        }
      } else if (uploadsAsync is AsyncLoading) {
        debugPrint(
            'DIRECT_DEBUG: State is AsyncLoading - checking if there is any value');
        final valueOrNull = uploadsAsync.valueOrNull;
        debugPrint(
            'DIRECT_DEBUG: valueOrNull = ${valueOrNull != null ? "not null" : "null"}');

        if (valueOrNull != null) {
          final data = valueOrNull;
          debugPrint(
              'DIRECT_DEBUG: AsyncLoading with ${data.length} cached uploads');

          // If we have data but still in loading state, force UI to show data
          if (data.isNotEmpty) {
            debugPrint(
                'DIRECT_DEBUG: Have data in loading state - will render it directly');
          }
        }
      } else if (uploadsAsync is AsyncError) {
        debugPrint(
            'DIRECT_DEBUG: State is AsyncError: ${(uploadsAsync as AsyncError).error}');
      }

      // Check if we need to override the loading state
      final manualUploads = _getManualUploads(ref, registry, uploadsAsync);

      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.uploads),
          actions: [
            IconButton(
              icon: const Icon(Icons.sync),
              tooltip: l10n.syncWithServer,
              onPressed: () {
                debugPrint('DIRECT_DEBUG: Manual sync requested');
                registry.sync<Upload>(ref);
              },
            ),
            // Add a debug button
            IconButton(
              icon: const Icon(Icons.bug_report),
              tooltip: l10n.createTestUpload,
              onPressed: () {
                debugPrint('DIRECT_DEBUG: Debug button pressed');
                _createTestUpload(context, ref);
              },
            ),
            // Add another button for manual db query
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: l10n.manuallyCheckUploads,
              onPressed: () {
                _manuallyCheckUploads(context, ref);
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _forceSyncToSupabase(context, ref),
          icon: const Icon(Icons.cloud_upload),
          label: Text(l10n.syncDatabase),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: RefreshIndicator(
          onRefresh: () {
            debugPrint('DIRECT_DEBUG: Pull-to-refresh triggered');
            return registry.refresh<Upload>(ref);
          },
          child: manualUploads != null
              ? _buildUploadsList(
                  context, manualUploads, ref) // Use manual data if available
              : uploadsAsync.when(
                    data: (uploads) {
                      debugPrint(
                          'DIRECT_DEBUG: Data state: ${uploads.length} uploads');
                      return _buildUploadsList(context, uploads, ref);
                    },
                    loading: () {
                      debugPrint('DIRECT_DEBUG: Loading state active');

                      // Use a Future.delayed as a timeout
                      return FutureBuilder(
                        future: Future.delayed(
                            const Duration(seconds: 5), () => true),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            debugPrint('DIRECT_DEBUG: Loading timeout reached');
                            // After timeout, show a more detailed loading message
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(),
                                  const SizedBox(height: 16),
                                  Text(
                                    l10n.stillLoading,
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () =>
                                        _createTestUpload(context, ref),
                                    child: Text(l10n.createTestUpload),
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () =>
                                        _manuallyCheckUploads(context, ref),
                                    child: Text(l10n.checkUploads),
                                  ),
                                ],
                              ),
                            );
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      );
                    },
                    error: (error, stackTrace) {
                      debugPrint('DIRECT_DEBUG: Error state: $error');
                      if (stackTrace != null) {
                        debugPrint('DIRECT_DEBUG: Stack trace: $stackTrace');
                      }
                      return _buildErrorWidget(context, error, stackTrace, ref);
                    },
                  ) ??
                  const Center(
                    child: Text('Model Registry is not available'),
                  ),
        ),
      );
    } catch (e, stack) {
      debugPrint('DIRECT_DEBUG: Exception in UploadsScreen build: $e');
      debugPrint('DIRECT_DEBUG: Stack trace: $stack');

      // Return a fallback UI when we catch an exception
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.uploadError),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('${l10n.errorBuildUploadScreen} $e'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.goBack),
              ),
            ],
          ),
        ),
      );
    }
  }

  // Get uploads manually if needed
  List<Upload>? _getManualUploads(WidgetRef ref, ModelRegistry? registry,
      AsyncValue<List<Upload>>? uploadsAsync) {
    // If we're stuck in loading state but have data in the notifier, return it directly
    if (uploadsAsync is AsyncLoading && ref.watch(_forceUpdateProvider) > 0) {
      try {
        // Try to get notifier state directly
        final notifier = registry?.getNotifier<Upload>(ref);
        if (notifier?.state is AsyncData) {
          final data = (notifier!.state as AsyncData).value as List<Upload>;
          debugPrint(
              'DIRECT_DEBUG: Bypassing loading state with ${data.length} manually retrieved uploads');
          return data;
        }
      } catch (e) {
        debugPrint('DIRECT_DEBUG: Error getting manual uploads: $e');
      }
    }

    return null;
  }

  /// Manually check for uploads in the database
  void _manuallyCheckUploads(BuildContext context, WidgetRef ref) {
    debugPrint('DIRECT_DEBUG: Manually checking uploads');
    try {
      final registry = ref.read(modelRegistryProvider);
      if (registry == null) {
        debugPrint('DIRECT_DEBUG: ModelRegistry is null in manual check');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: ModelRegistry is null')),
        );
        return;
      }

      // Try to get the notifier and trigger a refresh
      final notifier = registry.getNotifier<Upload>(ref);
      debugPrint('DIRECT_DEBUG: Current notifier state: ${notifier.state}');

      // Force a refresh
      notifier.refresh().then((_) {
        final state = notifier.state;
        debugPrint('DIRECT_DEBUG: After manual refresh, state: $state');

        if (state is AsyncData) {
          final uploads = state.value as List<Upload>;
          debugPrint(
              'DIRECT_DEBUG: Found ${uploads.length} uploads in database');

          // Show a snackbar with the count
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Found ${uploads.length} uploads in database')),
          );

          // Print the first few for debugging
          if (uploads.isNotEmpty) {
            for (int i = 0; i < math.min(3, uploads.length); i++) {
              debugPrint(
                  'DIRECT_DEBUG: Upload[$i] id = ${uploads[i].id}, status = ${uploads[i].status}');
            }
          }

          // Force a rebuild if we have data but UI still shows loading
          if (uploads.isNotEmpty) {
            // Force UI update
            ref
                .read(_forceUpdateProvider.notifier)
                .update((state) => state + 1);

            // Show info to user
            Future.delayed(Duration.zero, () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Forcing UI update with found data')),
              );
            });
          }
        } else if (state is AsyncError) {
          final error = (state as AsyncError).error;
          debugPrint('DIRECT_DEBUG: Error getting uploads: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $error')),
          );
        } else {
          debugPrint(
              'DIRECT_DEBUG: Still in loading state after manual refresh');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Still loading...')),
          );
        }
      }).catchError((error) {
        debugPrint('DIRECT_DEBUG: Error in manual refresh: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      });
    } catch (e) {
      debugPrint('DIRECT_DEBUG: Exception in manual check: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exception: $e')),
      );
    }
  }

  /// Builds the list of uploads
  Widget _buildUploadsList(
      BuildContext context, List<Upload> uploads, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    if (uploads.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.noUploadsYet),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _createTestUpload(context, ref),
              child: Text(l10n.createTestUpload),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: uploads.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final upload = uploads[index];
        return UploadTile(upload: upload);
      },
    );
  }

  /// Builds a widget to display errors
  Widget _buildErrorWidget(BuildContext context, Object error,
      [StackTrace? stackTrace, WidgetRef? ref]) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SelectableText.rich(
            TextSpan(
              text: l10n.errorLoadingUploads,
              children: [
                TextSpan(
                  text: error.toString(),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ),
          ),
          if (stackTrace != null)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              height: 200,
              child: SingleChildScrollView(
                child: SelectableText(
                  stackTrace.toString(),
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 16),
          if (ref != null)
            ElevatedButton(
              onPressed: () => _createTestUpload(context, ref),
              child: Text(l10n.createTestUpload),
            ),
        ],
      ),
    );
  }

  /// Shows a dialog to create a new upload
  void _createNewUpload(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _CreateUploadDialog(),
    );
  }

  /// Creates a test upload immediately
  void _createTestUpload(BuildContext context, WidgetRef ref) {
    debugPrint('DIRECT_DEBUG: Creating test upload');

    // Safe access to repository and model registry
    try {
      final registry = ref.read(modelRegistryProvider);
      if (registry == null) {
        debugPrint('DIRECT_DEBUG: ModelRegistry is null');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: ModelRegistry is null')),
        );
        return;
      }

      // First create a test camera
      final camera = Camera(
        name: 'Test Camera',
        latitude: 48.1351,
        longitude: 11.5820,
        huntingGround: HuntingGround(
            id: '',
            name: '',
            federalState: FederalState(
                id: '', name: '', country: Country(id: '', name: ''))),
        createdAt: DateTime.now(),
      );

      debugPrint('DIRECT_DEBUG: Created test camera with ID: ${camera.id}');

      // Create the camera directly without using the model registry first
      registry.create<Camera>(ref, camera).then((_) {
        debugPrint('DIRECT_DEBUG: Test camera created successfully');

        final currentHuntingGround = ref.read(selectedHuntingGroundProvider);
        if (currentHuntingGround == null) {
          throw Exception('No hunting ground selected');
        }

        // Create an upload with the camera's ID
        final upload = Upload(
          status: 'PENDING',
          camera: camera,
          huntingGround: currentHuntingGround,
          latitude: 48.1351,
          longitude: 11.5820,
          createdAt: DateTime.now(),
        );

        debugPrint('DIRECT_DEBUG: Created upload with ID: ${upload.id}');

        // Now create the upload
        registry.create<Upload>(ref, upload).then((_) {
          debugPrint('DIRECT_DEBUG: Test upload created successfully');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Test upload created: ${upload.id.substring(0, 8)}...')),
          );
        }).catchError((error) {
          debugPrint('DIRECT_DEBUG: Error creating test upload: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error creating test upload: $error')),
          );
        });
      }).catchError((error) {
        debugPrint('DIRECT_DEBUG: Error creating test camera: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating test camera: $error')),
        );
      });
    } catch (e, stack) {
      debugPrint('DIRECT_DEBUG: Exception in createTestUpload: $e');
      debugPrint('DIRECT_DEBUG: Stack trace: $stack');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  /// Force Sync to Supabase
  Future<void> _forceSyncToSupabase(BuildContext context, WidgetRef ref) async {
    debugPrint('FORCE_SYNC_DEBUG: ========== FORCE SYNC STARTED ==========');
    final l10n = AppLocalizations.of(context);
    // Get the repository
    final repository = ref.read(brickRepositoryProvider);
    if (repository == null) {
      debugPrint('FORCE_SYNC_DEBUG: Error - BrickRepository is null');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Repository not available')),
      );
      return;
    }

    // Check authentication status
    debugPrint('FORCE_SYNC_DEBUG: Checking Supabase authentication status');
    final supabase = Supabase.instance.client;
    final session = supabase.auth.currentSession;
    debugPrint('FORCE_SYNC_DEBUG: Auth session exists: ${session != null}');
    if (session == null) {
      debugPrint('FORCE_SYNC_DEBUG: Error - Not authenticated with Supabase');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Not authenticated with Supabase')),
      );
      return;
    }
    debugPrint('FORCE_SYNC_DEBUG: User ID: ${session.user.id}');

    // Show progress dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.syncToDB),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(l10n.plsWaitSync),
            ],
          ),
        );
      },
    );
    debugPrint('FORCE_SYNC_DEBUG: Progress dialog shown');

    try {
      // First sync Camera entities to ensure they exist for the foreign key constraint
      debugPrint('FORCE_SYNC_DEBUG: Starting sync of Camera entities');
      await repository.forceSyncAllOfType<Camera>();
      debugPrint(
          'FORCE_SYNC_DEBUG: Camera entities sync completed successfully');

      // Then sync Upload entities
      debugPrint('FORCE_SYNC_DEBUG: Starting sync of Upload entities');
      await repository.forceSyncAllOfType<Upload>();
      debugPrint(
          'FORCE_SYNC_DEBUG: Upload entities sync completed successfully');

      // Close the progress dialog
      Navigator.of(context, rootNavigator: true).pop();
      debugPrint('FORCE_SYNC_DEBUG: Progress dialog closed');

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully synced data to Supabase')),
      );
      debugPrint('FORCE_SYNC_DEBUG: Success message shown');

      // Refresh the UI
      final registry = ref.read(modelRegistryProvider);
      if (registry != null) {
        debugPrint('FORCE_SYNC_DEBUG: Refreshing UI after sync');
        registry.refresh<Upload>(ref);
        debugPrint('FORCE_SYNC_DEBUG: UI refresh initiated');
      } else {
        debugPrint(
            'FORCE_SYNC_DEBUG: Warning - ModelRegistry is null, cannot refresh UI');
      }

      debugPrint(
          'FORCE_SYNC_DEBUG: ========== FORCE SYNC COMPLETED SUCCESSFULLY ==========');
    } catch (e) {
      debugPrint('FORCE_SYNC_DEBUG: Error during sync: $e');

      // Close the progress dialog
      Navigator.of(context, rootNavigator: true).pop();
      debugPrint('FORCE_SYNC_DEBUG: Progress dialog closed after error');

      // Show error message with details
      String errorMessage = 'Failed to sync data to Supabase';

      // Check for foreign key constraint error
      if (e.toString().contains('foreign key constraint')) {
        errorMessage =
            'Foreign key constraint error. Make sure all related entities exist.';
        debugPrint('FORCE_SYNC_DEBUG: Foreign key constraint error detected');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      debugPrint('FORCE_SYNC_DEBUG: Error message shown');

      debugPrint('FORCE_SYNC_DEBUG: ========== FORCE SYNC FAILED ==========');
    }
  }
}

/// A dialog for creating a new upload
class _CreateUploadDialog extends ConsumerStatefulWidget {
  @override
  ConsumerState<_CreateUploadDialog> createState() =>
      _CreateUploadDialogState();
}

class _CreateUploadDialogState extends ConsumerState<_CreateUploadDialog> {
  final _cameraIdController = TextEditingController();
  double? _latitude;
  double? _longitude;
  bool _useCurrentLocation = false;

  @override
  void dispose() {
    _cameraIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.createNewUpload),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _cameraIdController,
              decoration: InputDecoration(
                labelText: l10n.cameraID,
                hintText: l10n.enterCameraID,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text(l10n.useCurrentLocation),
              value: _useCurrentLocation,
              onChanged: (value) {
                setState(() {
                  _useCurrentLocation = value;
                  if (value) {
                    // In a real app, we would get the actual location here
                    _latitude = 48.123456;
                    _longitude = 11.654321;
                  } else {
                    _latitude = null;
                    _longitude = null;
                  }
                });
              },
            ),
            if (_useCurrentLocation)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '${l10n.location} : ${_latitude?.toStringAsFixed(6)}, '
                  '${_longitude?.toStringAsFixed(6)}',
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: _createUpload,
          child: Text(l10n.create),
        ),
      ],
    );
  }

  /// Creates a new upload
  void _createUpload() {
    try {
      final registry = ref.read(modelRegistryProvider);
      if (registry == null) {
        debugPrint('Dialog: ModelRegistry is null');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: ModelRegistry is null')),
        );
        return;
      }

      // Create a camera first
      final camera = Camera(
        name: 'Camera from dialog',
        latitude: _latitude ?? 48.1351,
        longitude: _longitude ?? 11.5820,
        huntingGround: HuntingGround(
            id: '',
            name: '',
            federalState: FederalState(
                id: '', name: '', country: Country(id: '', name: ''))),
        createdAt: DateTime.now(),
      );

      debugPrint('Dialog: Creating camera with ID: ${camera.id}');

      registry.create<Camera>(ref, camera).then((_) {
        debugPrint('Dialog: Camera created successfully');

        try {
          final currentHuntingGround = ref.read(selectedHuntingGroundProvider);
          if (currentHuntingGround == null) {
            throw Exception('No hunting ground selected');
          }

          // Now create the upload with the camera ID
          final upload = Upload(
            status: 'PENDING',
            camera: camera,
            huntingGround: currentHuntingGround,
            latitude: _latitude,
            longitude: _longitude,
            createdAt: DateTime.now(),
          );

          debugPrint('Dialog: Creating upload with ID: ${upload.id}');

          registry.create<Upload>(ref, upload).then((_) {
            debugPrint('Dialog: Upload created successfully');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Upload created with Camera: ${camera.name}')),
            );
            Navigator.of(context).pop();
          }).catchError((error) {
            debugPrint('Dialog: Error creating upload: $error');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error creating upload: $error')),
            );
          });
        } catch (uploadError) {
          debugPrint('Dialog: Exception creating upload: $uploadError');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Exception: $uploadError')),
          );
        }
      }).catchError((error) {
        debugPrint('Dialog: Error creating camera: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating camera: $error')),
        );
      });
    } catch (e) {
      debugPrint('Dialog: Exception in _createUpload: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exception: $e')),
      );
    }
  }
}
