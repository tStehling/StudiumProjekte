import 'package:flutter/material.dart';
import 'package:revier_app_client/features/map/map_view.dart';
import 'package:revier_app_client/common/widgets/menu/bottom_menu.dart';
import 'package:revier_app_client/common/widgets/app_bar_button.dart';
import 'package:revier_app_client/localization/app_localizations.dart';

class MainMapScreen extends StatelessWidget {
  const MainMapScreen({super.key});
  static const String routeName = '/map';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l10n.huntingGroundTitle),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 2,
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
      body: const MapView(),
      bottomNavigationBar: const BottomMenu(),
    );
  }
}
