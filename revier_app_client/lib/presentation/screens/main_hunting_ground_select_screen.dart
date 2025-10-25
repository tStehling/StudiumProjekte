import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revier_app_client/brick/models/hunting_ground.model.dart';
import 'package:revier_app_client/features/hunting_ground/providers/hunting_ground_provider.dart';
import 'package:revier_app_client/presentation/screens/main_map_screen.dart';
import 'package:revier_app_client/common/navigation/navigation_service.dart';
import 'package:revier_app_client/features/hunting_ground/hunting_ground_create_screen.dart';
import 'package:revier_app_client/features/hunting_ground/hunting_ground_model_handler.dart';
import 'package:revier_app_client/localization/app_localizations.dart';

/// Screen for selecting a hunting ground
class MainHuntingGroundSelectScreen extends ConsumerStatefulWidget {
  const MainHuntingGroundSelectScreen({super.key});

  @override
  ConsumerState<MainHuntingGroundSelectScreen> createState() =>
      _MainHuntingGroundSelectScreenState();
}

class _MainHuntingGroundSelectScreenState
    extends ConsumerState<MainHuntingGroundSelectScreen> {
  late final HuntingGroundModelHandler _huntingGroundHandler;
  Future<void>? _refreshFuture;

  @override
  void initState() {
    super.initState();
    _huntingGroundHandler = HuntingGroundModelHandler();

    // Schedule a refresh after the first frame to ensure we have the latest data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshHuntingGrounds();
    });
  }

  Future<void> _refreshHuntingGrounds() async {
    setState(() {
      _refreshFuture = _huntingGroundHandler.refresh(ref);
    });
    await _refreshFuture;
  }

  @override
  Widget build(BuildContext context) {
    // Watch the hunting grounds state
    final huntingGroundNotifier = _huntingGroundHandler.getNotifier(ref);
    final huntingGroundsAsync = huntingGroundNotifier.state;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.selectHuntingGround),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToCreateHuntingGround(context),
            tooltip: l10n.createNewHG,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshHuntingGrounds,
            tooltip: l10n.refreshHG,
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshFuture,
        builder: (context, snapshot) {
          // Show a loading indicator during the initial manual refresh
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // After initial refresh, use the async state from notifier
          return huntingGroundsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${l10n.errorLoadingHG}: $error',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshHuntingGrounds,
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            ),
            data: (huntingGrounds) {
              if (huntingGrounds.isEmpty) {
                // Delay navigation to avoid build issues
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _navigateToCreateHuntingGround(context);
                });

                return Center(
                  child: Text(
                    l10n.noHGFound,
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return ListView.builder(
                itemCount: huntingGrounds.length,
                itemBuilder: (context, index) {
                  final huntingGround = huntingGrounds[index];
                  return ListTile(
                    title: Text(huntingGround.name),
                    subtitle: huntingGround.federalState != null
                        ? Text(huntingGround.federalState!.name)
                        : null,
                    onTap: () => _selectHuntingGround(huntingGround, context),
                    leading: const Icon(Icons.terrain),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void _navigateToCreateHuntingGround(BuildContext context) {
    NavigationService.instance
        .navigateTo(
      const HuntingGroundCreateScreen(),
    )
        .then((_) {
      // Refresh the list when returning from the create screen
      _refreshHuntingGrounds();
    });
  }

  void _selectHuntingGround(
      HuntingGround huntingGround, BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    try {
      // Save the selected hunting ground
      await ref
          .read(selectedHuntingGroundProvider.notifier)
          .selectHuntingGround(huntingGround);

      // Navigate to the main screen
      NavigationService.instance.navigateAndClearStack(
        const MainMapScreen(),
      );
    } catch (e) {
      // Show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.errorSelectHG}: $e')),
        );
      }
    }
  }
}
