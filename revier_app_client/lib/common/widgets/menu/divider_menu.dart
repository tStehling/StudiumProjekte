import 'package:flutter/material.dart';

class DividerMenuItem {
  final String label;
  final String iconPath;
  final VoidCallback onPressed;

  DividerMenuItem({
    required this.label,
    required this.iconPath,
    required this.onPressed,
  });
}

class DividerMenu extends StatefulWidget {
  final List<DividerMenuItem> menuItems;
  final int initialSelectedIndex;
  final void Function(int)? onTabChanged;

  const DividerMenu({
    super.key,
    required this.menuItems,
    this.initialSelectedIndex = 0,
    this.onTabChanged,
  });

  @override
  State<DividerMenu> createState() => _DividerMenuState();
}

class _DividerMenuState extends State<DividerMenu>
    with TickerProviderStateMixin {
  late TabController _tabController;
  // Add animation controllers for each tab
  late List<AnimationController> _iconAnimationControllers;
  late List<Animation<double>> _iconScaleAnimations;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.menuItems.length,
      vsync: this,
      initialIndex: widget.initialSelectedIndex,
    );
    _tabController.addListener(_handleTabSelection);

    // Initialize animation controllers for each tab
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _iconAnimationControllers = List.generate(
      widget.menuItems.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      ),
    );

    _iconScaleAnimations = _iconAnimationControllers
        .map((controller) => Tween<double>(begin: 1.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOutBack))
            .animate(controller))
        .toList();

    // Start the animation for the initially selected tab
    if (widget.initialSelectedIndex >= 0 &&
        widget.initialSelectedIndex < _iconAnimationControllers.length) {
      _iconAnimationControllers[widget.initialSelectedIndex].value = 1.0;
    }
  }

  @override
  void didUpdateWidget(DividerMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update tab controller if the number of tabs changes
    if (oldWidget.menuItems.length != widget.menuItems.length) {
      // Dispose old animation controllers
      for (var controller in _iconAnimationControllers) {
        controller.dispose();
      }

      _tabController.dispose();
      _tabController = TabController(
        length: widget.menuItems.length,
        vsync: this,
        initialIndex: widget.initialSelectedIndex,
      );
      _tabController.addListener(_handleTabSelection);

      // Re-initialize animations
      _initializeAnimations();
    }
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      // Reset all animations
      for (var controller in _iconAnimationControllers) {
        controller.value = 0.0;
      }

      // Start animation for the selected tab
      if (_tabController.index >= 0 &&
          _tabController.index < _iconAnimationControllers.length) {
        _iconAnimationControllers[_tabController.index].forward();
      }

      // Call the onPressed callback for the selected tab
      if (_tabController.index >= 0 &&
          _tabController.index < widget.menuItems.length) {
        widget.menuItems[_tabController.index].onPressed();
      }

      // Call the onTabChanged callback if provided
      if (widget.onTabChanged != null) {
        widget.onTabChanged!(_tabController.index);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        SizedBox(
          height: 85,
          child: TabBar(
            controller: _tabController,
            indicatorColor: colorScheme.primary,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.tab,
            labelPadding: const EdgeInsets.symmetric(horizontal: 40.0),
            tabs: List.generate(
              widget.menuItems.length,
              (index) {
                final item = widget.menuItems[index];
                return AnimatedBuilder(
                  animation: _iconScaleAnimations[index],
                  builder: (context, child) {
                    final isSelected = _tabController.index == index;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.scale(
                          scale: isSelected
                              ? _iconScaleAnimations[index].value
                              : 1.0,
                          child: Image.asset(
                            item.iconPath,
                            width: 30,
                            height: 28,
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurface,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();

    // Dispose animation controllers
    for (var controller in _iconAnimationControllers) {
      controller.dispose();
    }

    super.dispose();
  }
}
