import 'package:flutter/material.dart';
import 'package:revier_app_client/localization/app_localizations.dart'
    show AppLocalizations;

enum FlyoutDirection {
  up,
  upRight,
  right,
  downRight,
  down,
  downLeft,
  left,
  upLeft,
}

enum ButtonType {
  add,
  edit,
  delete,
  custom;

  IconData get defaultIcon {
    switch (this) {
      case ButtonType.add:
        return Icons.add;
      case ButtonType.edit:
        return Icons.edit;
      case ButtonType.delete:
        return Icons.delete;
      case ButtonType.custom:
        return Icons.circle;
    }
  }
}

class FlyoutButtonItem {
  final VoidCallback onPressed;
  final Widget? icon;
  final String? assetPath;
  final String? tooltip;
  final String? label;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final double? focusElevation;
  final double? hoverElevation;
  final double? highlightElevation;
  final Color? splashColor;
  final bool? enableFeedback;
  final MouseCursor? mouseCursor;
  final WidgetStateProperty<Color?>? backgroundColor_m3;
  final WidgetStateProperty<double?>? elevation_m3;
  final FlyoutDirection? flyoutDirection;
  final ButtonType type;

  const FlyoutButtonItem({
    required this.onPressed,
    this.icon,
    this.assetPath,
    this.tooltip,
    this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.focusElevation,
    this.hoverElevation,
    this.highlightElevation,
    this.splashColor,
    this.enableFeedback,
    this.mouseCursor,
    this.backgroundColor_m3,
    this.elevation_m3,
    this.flyoutDirection,
    this.type = ButtonType.custom,
  }) : assert(
          (icon != null || assetPath != null) || type != ButtonType.custom,
          'Either icon/assetPath must be provided or a non-custom button type must be specified',
        );

  Widget get iconWidget {
    if (icon != null) {
      return icon!;
    }

    if (assetPath != null) {
      return Image.asset(
        assetPath!,
        width: 24,
        height: 24,
        fit: BoxFit.contain,
      );
    }

    // Use the default icon for the button type
    return Icon(type.defaultIcon);
  }
}

/// An extended version of FloatingActionButton that supports flyout actions
/// and follows Material 3 design specifications.
///
/// This widget enhances the standard FAB with additional features while
/// maintaining Material 3 design principles:
/// - Supports flyout actions in multiple directions
/// - Follows M3 elevation and interaction states
/// - Uses M3 size specifications (56dp default, 40dp mini)
/// - Implements proper touch targets (48x48dp minimum)
/// - Supports both IconData and asset-based icons
/// - Optional label support for extended FAB style
///
/// Callback behavior:
/// - `onPressed`: Called when the button is pressed in non-flyout mode or when the flyout is opened
/// - `onClose`: Called when the flyout is closed (only in flyout mode)
///
/// Example usage with flyout buttons using ButtonType:
///
/// ```dart
/// ExtendedFloatingActionButton(
///   type: ButtonType.add,
///   isFlyoutMode: true,
///   onPressed: () => print('Flyout opened'),
///   onClose: () => print('Flyout closed'),
///   flyoutButtons: [
///     FlyoutButtonItem(
///       type: ButtonType.edit,
///       onPressed: () => print('Edit pressed'),
///     ),
///     FlyoutButtonItem(
///       type: ButtonType.delete,
///       onPressed: () => print('Delete pressed'),
///     ),
///   ],
/// )
/// ```
class ExtendedFloatingActionButton extends StatefulWidget {
  final List<FlyoutButtonItem> flyoutButtons;
  final ButtonType type;
  final Widget? icon;
  final Widget? closeIcon;
  final String? assetPath;
  final VoidCallback? onPressed;
  final VoidCallback? onClose;
  final bool isFlyoutMode;
  final FlyoutDirection flyoutDirection;
  final Duration animationDuration;
  final bool mini;
  final double flyoutSpacing;
  final String? tooltip;
  final String? label;
  final EdgeInsets margin;
  final Alignment alignment;

  // M3 FAB properties
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? splashColor;
  final double? elevation;
  final double? focusElevation;
  final double? hoverElevation;
  final double? highlightElevation;
  final WidgetStateProperty<double?>? elevation_m3;
  final WidgetStateProperty<Color?>? backgroundColor_m3;
  final WidgetStateProperty<Color?>? foregroundColor_m3;
  final WidgetStateProperty<Color?>? iconColor_m3;
  final bool? enableFeedback;
  final MouseCursor? mouseCursor;
  final ShapeBorder? shape;
  final bool autofocus;
  final FocusNode? focusNode;
  final Clip clipBehavior;

  /// Creates an extended floating action button.
  ///
  /// The [mini] property determines the size of the button. When true,
  /// the button will be 40x40dp (M3 spec for small screens), otherwise 56x56dp.
  const ExtendedFloatingActionButton({
    super.key,
    this.flyoutButtons = const [],
    this.type = ButtonType.add,
    this.icon,
    this.closeIcon,
    this.assetPath,
    this.onPressed,
    this.onClose,
    this.isFlyoutMode = true,
    this.flyoutDirection = FlyoutDirection.up,
    this.animationDuration = const Duration(milliseconds: 250),
    this.mini = false,
    this.flyoutSpacing = 70.0,
    this.tooltip,
    this.label,
    this.margin = const EdgeInsets.only(left: 25, right: 25, bottom: 20),
    this.alignment = Alignment.bottomRight,
    this.foregroundColor,
    this.backgroundColor,
    this.focusColor,
    this.hoverColor,
    this.splashColor,
    this.elevation,
    this.focusElevation,
    this.hoverElevation,
    this.highlightElevation,
    this.elevation_m3,
    this.backgroundColor_m3,
    this.foregroundColor_m3,
    this.iconColor_m3,
    this.enableFeedback,
    this.mouseCursor,
    this.shape,
    this.autofocus = false,
    this.focusNode,
    this.clipBehavior = Clip.none,
  }) : assert(
          type == ButtonType.custom
              ? (icon != null || assetPath != null)
              : true,
          'Either icon or assetPath must be provided when type is ButtonType.custom',
        );

  @override
  State<ExtendedFloatingActionButton> createState() =>
      _ExtendedFloatingActionButtonState();
}

class _ExtendedFloatingActionButtonState
    extends State<ExtendedFloatingActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _fadeAnimation;

  bool _isExpanded = false;

  // Track indices per direction
  final Map<FlyoutDirection, int> _directionIndices = {};

  Widget get _buttonIcon {
    final bool hasFlyoutButtons =
        widget.isFlyoutMode && widget.flyoutButtons.isNotEmpty;

    // Only apply rotation to center-symmetric icons in flyout mode with available buttons
    final bool shouldRotate = hasFlyoutButtons &&
        (widget.type == ButtonType.add ||
            (widget.icon != null && _isIconCenterSymmetric(widget.icon!)));

    // Base icon without rotation
    Widget baseIcon;
    if (widget.icon != null) {
      baseIcon = widget.icon!;
    } else if (widget.assetPath != null) {
      baseIcon = Image.asset(
        widget.assetPath!,
        width: _iconSize,
        height: _iconSize,
        fit: BoxFit.contain,
      );
    } else {
      baseIcon = Icon(widget.type.defaultIcon);
    }

    // If no flyout buttons, just return the base icon without any rotation or close icon
    if (!hasFlyoutButtons) {
      return baseIcon;
    }

    if (!shouldRotate) {
      return _isExpanded
          ? (widget.closeIcon ?? const Icon(Icons.close))
          : baseIcon;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Switch to close icon only after rotation is complete
        if (_isExpanded && _controller.value == 1.0) {
          return widget.closeIcon ?? const Icon(Icons.close);
        }

        // Keep showing the rotated main icon during transition
        return Transform.rotate(
          angle: _controller.value * 0.785398, // pi/4 radians (45 degrees)
          child: child,
        );
      },
      child: baseIcon,
    );
  }

  bool _isIconCenterSymmetric(Widget icon) {
    // Check if the icon is center-symmetric (like add, plus, etc.)
    if (icon is Icon) {
      return icon.icon == Icons.add ||
          icon.icon == Icons.add_circle ||
          icon.icon == Icons.add_circle_outline ||
          icon.icon == Icons.plus_one ||
          icon.icon == Icons.close;
    }
    return false;
  }

  /// Gets a localized tooltip for a button type
  String? getLocalizedTooltip(ButtonType type) {
    if (type == ButtonType.custom) return null;

    final l10n = AppLocalizations.of(context);
    switch (type) {
      case ButtonType.add:
        return l10n.add;
      case ButtonType.edit:
        return l10n.edit;
      case ButtonType.delete:
        return l10n.delete;
      case ButtonType.custom:
        return null;
    }
  }

  String? get _buttonTooltip {
    if (widget.tooltip != null) return widget.tooltip;
    if (widget.type != ButtonType.custom) {
      return getLocalizedTooltip(widget.type);
    }
    return null;
  }

  // M3 spec sizes
  double get _buttonSize => widget.mini ? 40.0 : 56.0;
  double get _iconSize =>
      _buttonSize * 0.42857; // 24dp for default, 17.14dp for mini

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInBack,
    );

    // Rotate from 0 to 45 degrees when opening
    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 0.125, // 45 degrees rotation
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _initializeDirectionIndices();
  }

  void _initializeDirectionIndices() {
    _directionIndices.clear();
    for (var item in widget.flyoutButtons) {
      final direction = item.flyoutDirection ?? widget.flyoutDirection;
      _directionIndices[direction] = (_directionIndices[direction] ?? 0) + 1;
    }
  }

  void _toggleButtons() {
    final wasExpanded = _isExpanded;

    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });

    // Call onPressed when not in flyout mode or when opening the flyout
    if (widget.onPressed != null &&
        (!widget.isFlyoutMode || (_isExpanded && !wasExpanded))) {
      widget.onPressed!();
    }

    // Call onClose if it exists and we're closing the flyout
    if (wasExpanded &&
        !_isExpanded &&
        widget.onClose != null &&
        widget.isFlyoutMode) {
      widget.onClose!();
    }
  }

  EdgeInsets _getMarginForDirection(
      FlyoutButtonItem item, FlyoutDirection direction) {
    // Get the current index for this direction
    final directionItems = widget.flyoutButtons
        .where((element) =>
            (element.flyoutDirection ?? widget.flyoutDirection) == direction)
        .toList();
    final index = directionItems.indexOf(item);

    if (index == -1) return EdgeInsets.zero;

    final spacing = widget.flyoutSpacing * (index + 1);
    final diagonalSpacing = widget.flyoutSpacing * 0.7071 * (index + 1);

    switch (direction) {
      case FlyoutDirection.up:
        return EdgeInsets.only(bottom: spacing);
      case FlyoutDirection.upRight:
        return EdgeInsets.only(bottom: diagonalSpacing, left: diagonalSpacing);
      case FlyoutDirection.right:
        return EdgeInsets.only(left: spacing);
      case FlyoutDirection.downRight:
        return EdgeInsets.only(top: diagonalSpacing, left: diagonalSpacing);
      case FlyoutDirection.down:
        return EdgeInsets.only(top: spacing);
      case FlyoutDirection.downLeft:
        return EdgeInsets.only(top: diagonalSpacing, right: diagonalSpacing);
      case FlyoutDirection.left:
        return EdgeInsets.only(right: spacing);
      case FlyoutDirection.upLeft:
        return EdgeInsets.only(bottom: diagonalSpacing, right: diagonalSpacing);
    }
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required Widget icon,
    String? tooltip,
    String? label,
    required EdgeInsets margin,
    Color? backgroundColor,
    Color? foregroundColor,
    double? elevation,
    double? focusElevation,
    double? hoverElevation,
    double? highlightElevation,
    Color? splashColor,
    bool? enableFeedback,
    MouseCursor? mouseCursor,
    WidgetStateProperty<Color?>? backgroundColor_m3,
    WidgetStateProperty<double?>? elevation_m3,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    // If label is null but tooltip is provided, try to use tooltip as label
    // This helps with localization consistency
    final effectiveLabel = label; // ?? tooltip;

    final button = effectiveLabel != null
        ? FloatingActionButton.extended(
            heroTag: UniqueKey(),
            onPressed: onPressed,
            icon: icon,
            label: Text(effectiveLabel),
            backgroundColor: backgroundColor ?? colorScheme.primaryContainer,
            foregroundColor: foregroundColor ?? colorScheme.onPrimaryContainer,
            elevation: elevation ?? 3,
            focusElevation: focusElevation ?? 4,
            hoverElevation: hoverElevation ?? 4,
            highlightElevation: highlightElevation ?? 6,
            splashColor: splashColor,
            enableFeedback: enableFeedback,
            mouseCursor: mouseCursor,
            shape: widget.shape ?? const StadiumBorder(),
            clipBehavior: widget.clipBehavior,
          )
        : FloatingActionButton(
            heroTag: UniqueKey(),
            onPressed: onPressed,
            backgroundColor: backgroundColor ?? colorScheme.primaryContainer,
            foregroundColor: foregroundColor ?? colorScheme.onPrimaryContainer,
            elevation: elevation ?? 3,
            focusElevation: focusElevation ?? 4,
            hoverElevation: hoverElevation ?? 4,
            highlightElevation: highlightElevation ?? 6,
            splashColor: splashColor,
            enableFeedback: enableFeedback,
            mouseCursor: mouseCursor,
            shape: widget.shape ?? CircleBorder(),
            mini: widget.mini,
            clipBehavior: widget.clipBehavior,
            child: icon,
          );

    return Container(
      margin: margin,
      width: effectiveLabel != null ? null : _buttonSize,
      height: _buttonSize,
      child: tooltip != null
          ? Tooltip(
              message: tooltip,
              child: button,
            )
          : button,
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonStack = Stack(
      alignment: widget.alignment,
      children: [
        if (widget.isFlyoutMode)
          ...widget.flyoutButtons.map((item) {
            final direction = item.flyoutDirection ?? widget.flyoutDirection;

            // If no tooltip is provided, try to use our helper for common button types
            String? tooltip = item.tooltip;
            if (tooltip == null) {
              // First try to use the item's type if it's not custom
              if (item.type != ButtonType.custom) {
                tooltip = getLocalizedTooltip(item.type);
              }
              // If no type or it's custom, try to determine from icon
              else if (item.icon is Icon) {
                final iconData = (item.icon as Icon).icon;
                if (iconData == Icons.add) {
                  tooltip = getLocalizedTooltip(ButtonType.add);
                } else if (iconData == Icons.edit) {
                  tooltip = getLocalizedTooltip(ButtonType.edit);
                } else if (iconData == Icons.delete) {
                  tooltip = getLocalizedTooltip(ButtonType.delete);
                }
              }
            }

            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) =>
                  _isExpanded || _controller.isDismissed == false
                      ? FadeTransition(
                          opacity: _fadeAnimation,
                          child: ScaleTransition(
                            scale: _expandAnimation,
                            child: child,
                          ),
                        )
                      : const SizedBox.shrink(),
              child: _buildActionButton(
                onPressed: () {
                  _toggleButtons();
                  item.onPressed();
                },
                icon: item.iconWidget,
                tooltip: tooltip,
                label: item.label,
                margin: _getMarginForDirection(item, direction),
                backgroundColor: item.backgroundColor,
                foregroundColor: item.foregroundColor,
                elevation: item.elevation,
                focusElevation: item.focusElevation,
                hoverElevation: item.hoverElevation,
                highlightElevation: item.highlightElevation,
                splashColor: item.splashColor,
                enableFeedback: item.enableFeedback,
                mouseCursor: item.mouseCursor,
                backgroundColor_m3: item.backgroundColor_m3,
                elevation_m3: item.elevation_m3,
              ),
            );
          }),
        _buildActionButton(
          onPressed: _toggleButtons,
          icon: _buttonIcon,
          tooltip: _buttonTooltip,
          label: widget.label,
          margin: EdgeInsets.zero,
          backgroundColor: widget.backgroundColor,
          foregroundColor: widget.foregroundColor,
          elevation: widget.elevation,
          focusElevation: widget.focusElevation,
          hoverElevation: widget.hoverElevation,
          highlightElevation: widget.highlightElevation,
          splashColor: widget.splashColor,
          enableFeedback: widget.enableFeedback,
          mouseCursor: widget.mouseCursor,
          backgroundColor_m3: widget.backgroundColor_m3,
          elevation_m3: widget.elevation_m3,
        ),
      ],
    );

    return Align(
      alignment: widget.alignment,
      child: Container(
        margin: widget.margin,
        child: buttonStack,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
