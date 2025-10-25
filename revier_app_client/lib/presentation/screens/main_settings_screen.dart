import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revier_app_client/localization/app_localizations.dart';
import 'package:revier_app_client/common/widgets/menu/bottom_menu.dart';
import 'package:revier_app_client/common/widgets/app_bar_button.dart';
import 'package:revier_app_client/settings/settings_view.dart';

class MainSettingsScreen extends ConsumerWidget {
  const MainSettingsScreen({super.key});
  static const String routeName = '/settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l10n.settingsTitle),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: AppBarButton(
              onOptionSelected: (option) {
                // Handle selection hier
                print("Ausgewählt: $option");
              },
              selectOptionText: l10n.selectOption,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: const SettingsView(),
      ),
      bottomNavigationBar: const BottomMenu(),
    );
  }
}
