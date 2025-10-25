import 'package:flutter/material.dart';
import 'package:revier_app_client/localization/app_localizations.dart';

/// A reusable search bar component with consistent styling.
///
/// This component provides a standardized search field that can be used
/// across different parts of the application to maintain a consistent UI.
class CoreSearchBar extends StatelessWidget {
  /// Callback function triggered when the search text changes
  final Function(String) onSearchChanged;

  /// Placeholder text shown when the search field is empty
  final String? searchHint;

  /// Whether to show a border around the search field
  final bool showBorder;

  /// Additional padding around the search field
  final EdgeInsets padding;

  /// Custom border radius for the search field
  final double borderRadius;

  const CoreSearchBar({
    super.key,
    required this.onSearchChanged,
    this.searchHint,
    this.showBorder = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    final effectiveHint = searchHint ?? l10n.search;

    return Padding(
      padding: padding,
      child: TextField(
        decoration: InputDecoration(
          hintText: effectiveHint,
          hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
          prefixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
          filled: true,
          fillColor: colorScheme.surfaceContainerLow,
          border: showBorder
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide.none,
                )
              : InputBorder.none,
          enabledBorder: showBorder
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide:
                      BorderSide(color: colorScheme.outlineVariant, width: 0.5),
                )
              : InputBorder.none,
          focusedBorder: showBorder
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide:
                      BorderSide(color: colorScheme.primary, width: 1.5),
                )
              : InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        onChanged: onSearchChanged,
        style: textTheme.bodyMedium,
      ),
    );
  }
}
