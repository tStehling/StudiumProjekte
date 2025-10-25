import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revier_app_client/core/services/logging_service.dart';
import 'package:revier_app_client/features/animal/animal_collection_view.dart';
import 'package:revier_app_client/features/animal_filter/animal_filter_collection_view.dart';
import 'package:revier_app_client/common/widgets/menu/bottom_menu.dart';
import 'package:revier_app_client/common/widgets/menu/divider_menu.dart';
import 'package:revier_app_client/common/widgets/app_bar_button.dart';
import 'package:revier_app_client/common/widgets/buttons/extended_floating_action_button.dart';
import 'package:revier_app_client/common/navigation/navigation_service.dart';
import 'package:revier_app_client/features/animal/animal_form_view.dart';
import 'package:revier_app_client/features/animal_filter/animal_filter_form_view.dart';
import 'package:revier_app_client/localization/app_localizations.dart';

class MainAnimalFilterScreen extends ConsumerStatefulWidget {
  const MainAnimalFilterScreen({super.key});
  static const String routeName = '/animal-filter';

  @override
  ConsumerState<MainAnimalFilterScreen> createState() =>
      _MainAnimalFilterScreenState();
}

class _MainAnimalFilterScreenState extends ConsumerState<MainAnimalFilterScreen>
    with SingleTickerProviderStateMixin {
  int _selectedTabIndex = 0;
  int _previousTabIndex = 0;
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  final _log = loggingService.getLogger('MainAnimalFilterScreen');

  @override
  void initState() {
    super.initState();
    _log.info('Initializing MainAnimalFilterScreen');

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onAnimalsPressed() {
    _log.info("Animals tab pressed");
    _updateSelectedTab(0);
  }

  void _onFiltersPressed() {
    _log.info("Filters tab pressed");
    _updateSelectedTab(1);
  }

  void _onTabChanged(int index) {
    _updateSelectedTab(index);
  }

  void _updateSelectedTab(int newIndex) {
    if (newIndex == _selectedTabIndex) return;

    setState(() {
      _previousTabIndex = _selectedTabIndex;
      _selectedTabIndex = newIndex;

      // Determine animation direction based on tab order
      final bool isForward = newIndex > _previousTabIndex;

      // Reset animation controller
      _animationController.reset();

      // Set animation values based on direction
      _animation = Tween<Offset>(
        begin: Offset(isForward ? 1.0 : -1.0, 0.0),
        end: const Offset(0.0, 0.0),
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ));

      // Start animation
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    // Create menu items for the DividerMenu
    final menuItems = [
      DividerMenuItem(
        label: l10n.animal,
        iconPath: 'assets/images/1deer.png',
        onPressed: _onAnimalsPressed,
      ),
      DividerMenuItem(
        label: l10n.filter,
        iconPath: 'assets/images/3deer.png',
        onPressed: _onFiltersPressed,
      ),
    ];

    // Floating action button - only show for Animals tab
    final floatingActionButton = _selectedTabIndex == 0
        ? ExtendedFloatingActionButton(
            alignment: Alignment.bottomRight,
            type: ButtonType.add,
            isFlyoutMode: true,
            flyoutButtons: [
              FlyoutButtonItem(
                assetPath: 'assets/images/1deer.png',
                onPressed: () => NavigationService.instance.navigateWithScale(
                  const AnimalFormView(),
                ),
                flyoutDirection: FlyoutDirection.left,
              ),
              FlyoutButtonItem(
                assetPath: 'assets/images/3deer.png',
                onPressed: () => NavigationService.instance.navigateWithScale(
                  const AnimalFilterFormView(),
                ),
                flyoutDirection: FlyoutDirection.up,
              ),
            ],
          )
        : null;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(_selectedTabIndex == 0 ? l10n.animal : l10n.filter),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: AppBarButton(
              onOptionSelected: (option) {
                // Handle selection
                _log.info("Selected: $option");
              },
              selectOptionText: l10n.selectOption,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DividerMenu(
              menuItems: menuItems,
              initialSelectedIndex: _selectedTabIndex,
              onTabChanged: _onTabChanged,
            ),
          ),
          Expanded(
            // Wrap in SlideTransition for directional sliding animation
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return SlideTransition(
                  position: _animation,
                  child: _selectedTabIndex == 0
                      ? const AnimalCollectionView() // Using our new implementation
                      : const AnimalFilterCollectionView(),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: const BottomMenu(),
    );
  }
}
