import 'package:flutter/material.dart';
import 'package:revier_app_client/common/navigation/navigation_service.dart';
import 'package:revier_app_client/common/widgets/buttons/extended_floating_action_button.dart';
import 'package:revier_app_client/features/sighting/sighting_form_view.dart';
import 'package:revier_app_client/features/upload/upload_form_view.dart';
import 'package:revier_app_client/features/upload/upload_collection_view.dart';
import 'package:revier_app_client/features/sighting/sighting_collection_view.dart';
import 'package:revier_app_client/common/widgets/menu/bottom_menu.dart';
import 'package:revier_app_client/common/widgets/menu/divider_menu.dart';
import 'package:revier_app_client/common/widgets/app_bar_button.dart';
import 'package:revier_app_client/localization/app_localizations.dart';
import 'dart:developer' as developer;

class MainSightingsUploadsScreen extends StatefulWidget {
  const MainSightingsUploadsScreen({super.key});
  static const String routeName = '/sightings-uploads';

  @override
  State<MainSightingsUploadsScreen> createState() =>
      _MainSightingsUploadsScreenState();
}

class _MainSightingsUploadsScreenState extends State<MainSightingsUploadsScreen>
    with SingleTickerProviderStateMixin {
  int _selectedTabIndex = 0;
  int _previousTabIndex = 0;
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
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

  void _onSightingsPressed() {
    developer.log("Sightings tab pressed");
    _updateSelectedTab(0);
  }

  void _onMediaPressed() {
    developer.log("Media tab pressed");
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
        label: l10n.sightingsTitle,
        iconPath: 'assets/images/1deer.png',
        onPressed: _onSightingsPressed,
      ),
      DividerMenuItem(
        label: l10n.mediaTitle,
        iconPath: 'assets/images/media_icon.png',
        onPressed: _onMediaPressed,
      ),
    ];

    // Floating action button - only show for Animals tab
    final floatingActionButton = ExtendedFloatingActionButton(
      alignment: Alignment.bottomRight,
      type: ButtonType.add,
      isFlyoutMode: true,
      flyoutButtons: [
        FlyoutButtonItem(
          icon: const Icon(Icons.add),
          tooltip: 'Add Sighting',
          onPressed: () => NavigationService.instance.navigateWithScale(
            const SightingFormView(),
          ),
          flyoutDirection: FlyoutDirection.left,
        ),
        FlyoutButtonItem(
          icon: const Icon(Icons.add_photo_alternate),
          tooltip: 'Upload Media',
          onPressed: () => NavigationService.instance.navigateWithScale(
            const UploadFormView(),
          ),
          flyoutDirection: FlyoutDirection.up,
        ),
      ],
    );

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
            _selectedTabIndex == 0 ? l10n.sightingsTitle : l10n.mediaTitle),
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
                      ? const SightingCollectionView()
                      : const UploadCollectionView(),
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
