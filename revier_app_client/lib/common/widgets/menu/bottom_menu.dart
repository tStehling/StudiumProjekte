import 'package:flutter/material.dart';
import 'package:revier_app_client/presentation/screens/main_animal_filter_screen.dart';
import 'package:revier_app_client/presentation/screens/main_map_screen.dart';
import 'package:revier_app_client/presentation/screens/main_sightings_uploads_screen.dart';
import 'package:revier_app_client/presentation/screens/main_settings_screen.dart';
import 'package:revier_app_client/localization/app_localizations.dart';

class MenuItem {
  final String route;
  final Widget component;
  final String icon;
  final String label;

  MenuItem({
    required this.route,
    required this.component,
    required this.icon,
    required this.label,
  });
}

class BottomMenu extends StatefulWidget {
  const BottomMenu({super.key});

  @override
  State<BottomMenu> createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  // Last selected index to track changes
  int _lastSelectedIndex = 0;

  List<MenuItem> _getMenuItems(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return [
      MenuItem(
        route: '/map',
        component: const MainMapScreen(),
        icon: 'assets/images/menu_revier.png',
        label: l10n.huntingGroundTitle,
      ),
      MenuItem(
        route: '/animal-filter-v2',
        component: const MainAnimalFilterScreen(),
        icon: 'assets/images/1deer.png',
        label: l10n.filter,
      ),
      MenuItem(
        route: '/sightings-uploads',
        component: const MainSightingsUploadsScreen(),
        icon: 'assets/images/menu_media.png',
        label: l10n.sightings,
      ),
      MenuItem(
        route: '/settings',
        component: const MainSettingsScreen(),
        icon: 'assets/images/menu_settings.png',
        label: l10n.settingsTitle,
      ),
    ];
  }

  int _getSelectedIndex(BuildContext context) {
    final routeName = ModalRoute.of(context)?.settings.name;
    final menuItems = _getMenuItems(context);

    if (routeName == null) {
      return 0;
    }

    final index = menuItems.indexWhere((item) => item.route == routeName);
    return index >= 0 ? index : 0;
  }

  void _onDestinationSelected(int index, List<MenuItem> menuItems) {
    if (index == _lastSelectedIndex) return;

    // Update last selected index
    _lastSelectedIndex = index;

    final menuItem = menuItems[index];

    // Use immediate navigation with no transitions
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            menuItem.component,
        settings: RouteSettings(name: menuItem.route),
        transitionDuration: Duration.zero, // No transition
        reverseTransitionDuration: Duration.zero, // No transition
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final menuItems = _getMenuItems(context);
    final selectedIndex = _getSelectedIndex(context);

    // If the selected index changes outside this widget (e.g., via back button),
    // update our tracking variable
    if (selectedIndex != _lastSelectedIndex) {
      _lastSelectedIndex = selectedIndex;
    }

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 8),
        child: NavigationBar(
          height: 72,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          backgroundColor: Colors.transparent,
          indicatorColor: colorScheme.primaryContainer.withOpacity(0.7),
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) =>
              _onDestinationSelected(index, menuItems),
          destinations: List.generate(
            menuItems.length,
            (index) {
              final item = menuItems[index];
              final isSelected = index == selectedIndex;

              return NavigationDestination(
                icon: ImageIcon(
                  AssetImage(item.icon),
                  size: 28.75,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface.withOpacity(0.65),
                ),
                label: item.label,
              );
            },
          ),
        ),
      ),
    );
  }
}
