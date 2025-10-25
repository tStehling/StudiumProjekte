import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revier_app_client/core/providers/theme_provider.dart';
import 'package:revier_app_client/core/services/i18n_service.dart';
import 'package:revier_app_client/core/providers/locale_provider.dart';
import 'package:revier_app_client/localization/app_localizations.dart';
import 'package:revier_app_client/features/auth/services/auth_service.dart';
import 'package:revier_app_client/features/hunting_ground/providers/hunting_ground_provider.dart';
import 'package:revier_app_client/features/hunting_ground/hunting_ground_form_view.dart';
import 'package:revier_app_client/common/navigation/navigation_service.dart';
import 'package:revier_app_client/presentation/screens/main_hunting_ground_select_screen.dart'
    show MainHuntingGroundSelectScreen;
import 'package:revier_app_client/features/auth/presentation/widgets/auth_wrapper.dart';
import 'package:revier_app_client/main.dart' show HomePage;

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context);
    final selectedHuntingGround = ref.watch(selectedHuntingGroundProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hunting Ground Selection Section
            Text(
              'Hunting Ground',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (selectedHuntingGround != null)
                      ListTile(
                        title: Text(selectedHuntingGround.name),
                        subtitle: Text(
                            selectedHuntingGround.federalState?.name ??
                                'No Federal State'),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _navigateToHuntingGroundForm(
                                context, selectedHuntingGround);
                          },
                        ),
                      )
                    else
                      const ListTile(
                        title: Text('No hunting ground selected'),
                      ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FilledButton.icon(
                          icon: const Icon(Icons.swap_horiz),
                          label: const Text('Change'),
                          onPressed: () {
                            _navigateToHuntingGroundSelection(context);
                          },
                        ),
                        FilledButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('Create New'),
                          onPressed: () {
                            _navigateToHuntingGroundForm(context, null);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Theme Selection Section
            Text(
              l10n.changeTheme,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: Text(l10n.systemTheme),
                  selected: currentThemeMode == ThemeMode.system,
                  onSelected: (_) {
                    ref.read(themeModeProvider.notifier).state =
                        ThemeMode.system;
                    ThemePreferences.saveThemeMode(ThemeMode.system);
                  },
                ),
                ChoiceChip(
                  label: Text(l10n.lightTheme),
                  selected: currentThemeMode == ThemeMode.light,
                  onSelected: (_) {
                    ref.read(themeModeProvider.notifier).state =
                        ThemeMode.light;
                    ThemePreferences.saveThemeMode(ThemeMode.light);
                  },
                ),
                ChoiceChip(
                  label: Text(l10n.darkTheme),
                  selected: currentThemeMode == ThemeMode.dark,
                  onSelected: (_) {
                    ref.read(themeModeProvider.notifier).state = ThemeMode.dark;
                    ThemePreferences.saveThemeMode(ThemeMode.dark);
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Language Selection Section
            Text(
              l10n.changeLanguage,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Deutsch'),
                  selected: locale.languageCode == 'de',
                  onSelected: (_) {
                    I18nService.instance
                        .changeLocale(context, const Locale('de'));
                    ref.read(localeProvider.notifier).state =
                        const Locale('de');
                  },
                ),
                ChoiceChip(
                  label: const Text('English'),
                  selected: locale.languageCode == 'en',
                  onSelected: (_) {
                    I18nService.instance
                        .changeLocale(context, const Locale('en'));
                    ref.read(localeProvider.notifier).state =
                        const Locale('en');
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Logout Button
            FilledButton.icon(
              icon: const Icon(Icons.logout),
              label: Text(l10n.logout),
              onPressed: () async {
                try {
                  final authService = ref.read(authServiceProvider);
                  await authService.signOut();
                  NavigationService.instance.navigateAndClearStack(
                    const AuthWrapper(child: HomePage()),
                  );
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error signing out: $e')),
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _navigateToHuntingGroundSelection(BuildContext context) {
    NavigationService.instance.navigateTo(
      const MainHuntingGroundSelectScreen(),
    );
  }

  void _navigateToHuntingGroundForm(
      BuildContext context, dynamic huntingGround) {
    NavigationService.instance.navigateTo(
      HuntingGroundFormView(
        initialEntity: huntingGround,
        navigateToMainAfterSave: false,
        onCancel: () => NavigationService.instance.goBack(),
        onSave: (_) => NavigationService.instance.goBack(),
      ),
    );
  }
}
