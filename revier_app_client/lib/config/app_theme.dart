import 'package:flutter/material.dart';
import 'package:revier_app_client/config/material_color_theme.dart';

/// Theme configuration for the Revier App
/// Implements Material 3 design system with optimized color schemes
class AppTheme {
  /// Main brand color: #2C3532 (dark grayish-green)
  static const Color brandColor = Color(0xFF2C3532);

  /// Lighter variant of brand color for better contrast in light theme
  static const Color brandColorLight = Color(0xFF3E4A47);

  /// A complementary accent color (teal)
  static const Color accentColor = Color(0xFF116466);

  /// A warm tertiary color (sand)
  static const Color tertiaryColor = Color(0xFFD9B08C);

  /// Utility method to adjust color opacity
  static Color withAlpha(Color color, double opacity) =>
      color.withValues(alpha: (opacity).toDouble());

  /// Create an optimized light color scheme based on the brand color
  static final ColorScheme lightColorScheme = MaterialColorTheme.lightScheme();

  /// Create an optimized dark color scheme based on the brand color
  static final ColorScheme darkColorScheme = MaterialColorTheme.darkScheme();

  /// Light theme with optimized components for better readability
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    // // AppBar with optimized contrast for light theme
    // appBarTheme: AppBarTheme(
    //   backgroundColor: lightColorScheme.surface,
    //   foregroundColor: lightColorScheme.onSurface,
    //   surfaceTintColor: Colors.transparent, // New in Material 3
    //   elevation: 0,
    //   iconTheme: IconThemeData(color: lightColorScheme.onSurface),
    //   titleTextStyle: TextStyle(
    //     color: lightColorScheme.onSurface,
    //     fontSize: 20,
    //     fontWeight: FontWeight.w500,
    //   ),
    // ),
    // // Card with subtle elevation and rounded corners
    // cardTheme: CardTheme(
    //   elevation: 2,
    //   shadowColor: withAlpha(lightColorScheme.shadow, 0.3), // 0.3 * 255 = ~77
    //   surfaceTintColor: Colors.transparent, // New in Material 3
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(16),
    //   ),
    // ),
    // // Elevated button with clear visual hierarchy
    // elevatedButtonTheme: ElevatedButtonThemeData(
    //   style: ButtonStyle(
    //     backgroundColor: WidgetStateProperty.all(lightColorScheme.primary),
    //     foregroundColor: WidgetStateProperty.all(lightColorScheme.onPrimary),
    //     elevation: WidgetStateProperty.all(2),
    //     padding: WidgetStateProperty.all(
    //       const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    //     ),
    //     shape: WidgetStateProperty.all(
    //       RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(8),
    //       ),
    //     ),
    //   ),
    // ),
    // // Text button with clear hierarchy
    // textButtonTheme: TextButtonThemeData(
    //   style: ButtonStyle(
    //     foregroundColor: WidgetStateProperty.all(lightColorScheme.primary),
    //     padding: WidgetStateProperty.all(
    //       const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    //     ),
    //   ),
    // ),
    // // Optimized text theme for readability
    // textTheme: TextTheme(
    //   displayLarge: TextStyle(color: lightColorScheme.onSurface),
    //   displayMedium: TextStyle(color: lightColorScheme.onSurface),
    //   displaySmall: TextStyle(color: lightColorScheme.onSurface),
    //   headlineLarge: TextStyle(
    //       color: lightColorScheme.primary, fontWeight: FontWeight.bold),
    //   headlineMedium: TextStyle(color: lightColorScheme.primary),
    //   headlineSmall: TextStyle(color: lightColorScheme.onSurface),
    //   titleLarge: TextStyle(
    //       color: lightColorScheme.onSurface, fontWeight: FontWeight.bold),
    //   titleMedium: TextStyle(color: lightColorScheme.onSurface),
    //   titleSmall: TextStyle(color: lightColorScheme.onSurface),
    //   bodyLarge: TextStyle(color: lightColorScheme.onSurface),
    //   bodyMedium: TextStyle(color: lightColorScheme.onSurface),
    //   bodySmall: TextStyle(color: lightColorScheme.surfaceContainerHighest),
    //   labelLarge: TextStyle(color: lightColorScheme.primary),
    //   labelSmall: TextStyle(color: lightColorScheme.surfaceContainerHighest),
    // ),
    // // SnackBar with good contrast
    // snackBarTheme: SnackBarThemeData(
    //   backgroundColor: lightColorScheme.inverseSurface,
    //   contentTextStyle: TextStyle(color: lightColorScheme.onInverseSurface),
    //   behavior: SnackBarBehavior.floating,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(8),
    //   ),
    // ),
    // // Bottom Navigation with clear visual hierarchy
    // navigationBarTheme: NavigationBarThemeData(
    //   backgroundColor: lightColorScheme.surface,
    //   indicatorColor: lightColorScheme.primaryContainer,
    //   iconTheme: WidgetStateProperty.resolveWith((states) {
    //     if (states.contains(WidgetState.selected)) {
    //       return IconThemeData(color: lightColorScheme.primary);
    //     }
    //     return IconThemeData(color: lightColorScheme.surfaceContainerHighest);
    //   }),
    //   labelTextStyle: WidgetStateProperty.resolveWith((states) {
    //     if (states.contains(WidgetState.selected)) {
    //       return TextStyle(color: lightColorScheme.primary, fontSize: 12);
    //     }
    //     return TextStyle(
    //         color: lightColorScheme.surfaceContainerHighest, fontSize: 12);
    //   }),
    // ),
    // inputDecorationTheme: InputDecorationTheme(
    //   filled: true,
    //   fillColor: withAlpha(lightColorScheme.surfaceContainerHighest, 0.3),
    //   border: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(8),
    //     borderSide: BorderSide.none,
    //   ),
    //   focusedBorder: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(8),
    //     borderSide: BorderSide(color: lightColorScheme.primary, width: 2),
    //   ),
    //   enabledBorder: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(8),
    //     borderSide: BorderSide.none,
    //   ),
    //   errorBorder: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(8),
    //     borderSide: BorderSide(color: lightColorScheme.error, width: 2),
    //   ),
    //   contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    // ),
  );

  /// Dark theme with optimized components for better visibility
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    // // AppBar with optimized contrast for dark theme
    // appBarTheme: AppBarTheme(
    //   backgroundColor: darkColorScheme.surface,
    //   foregroundColor: darkColorScheme.onSurface,
    //   surfaceTintColor: Colors.transparent, // New in Material 3
    //   elevation: 0,
    //   iconTheme: IconThemeData(color: darkColorScheme.onSurface),
    //   titleTextStyle: TextStyle(
    //     color: darkColorScheme.onSurface,
    //     fontSize: 20,
    //     fontWeight: FontWeight.w500,
    //   ),
    // ),
    // // Card with subtle elevation and rounded corners
    // cardTheme: CardTheme(
    //   elevation: 4,
    //   shadowColor: withAlpha(Colors.black, 0.4),
    //   surfaceTintColor: Colors.transparent, // New in Material 3
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(16),
    //   ),
    // ),
    // // Elevated button with clear visual hierarchy
    // elevatedButtonTheme: ElevatedButtonThemeData(
    //   style: ButtonStyle(
    //     backgroundColor: WidgetStateProperty.all(darkColorScheme.primary),
    //     foregroundColor: WidgetStateProperty.all(darkColorScheme.onPrimary),
    //     elevation: WidgetStateProperty.all(2),
    //     padding: WidgetStateProperty.all(
    //       const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    //     ),
    //     shape: WidgetStateProperty.all(
    //       RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(8),
    //       ),
    //     ),
    //   ),
    // ),
    // // Text button with clear hierarchy
    // textButtonTheme: TextButtonThemeData(
    //   style: ButtonStyle(
    //     foregroundColor: WidgetStateProperty.all(darkColorScheme.primary),
    //     padding: WidgetStateProperty.all(
    //       const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    //     ),
    //   ),
    // ),
    // // Optimized text theme for readability in dark mode
    // textTheme: TextTheme(
    //   displayLarge: TextStyle(color: darkColorScheme.onSurface),
    //   displayMedium: TextStyle(color: darkColorScheme.onSurface),
    //   displaySmall: TextStyle(color: darkColorScheme.onSurface),
    //   headlineLarge: TextStyle(
    //       color: darkColorScheme.primary, fontWeight: FontWeight.bold),
    //   headlineMedium: TextStyle(color: darkColorScheme.primary),
    //   headlineSmall: TextStyle(color: darkColorScheme.onSurface),
    //   titleLarge: TextStyle(
    //       color: darkColorScheme.onSurface, fontWeight: FontWeight.bold),
    //   titleMedium: TextStyle(color: darkColorScheme.onSurface),
    //   titleSmall: TextStyle(color: darkColorScheme.onSurface),
    //   bodyLarge: TextStyle(color: darkColorScheme.onSurface),
    //   bodyMedium: TextStyle(color: darkColorScheme.onSurface),
    //   bodySmall: TextStyle(color: darkColorScheme.surfaceContainerHighest),
    //   labelLarge: TextStyle(color: darkColorScheme.primary),
    //   labelSmall: TextStyle(color: darkColorScheme.surfaceContainerHighest),
    // ),
    // // SnackBar with good contrast for dark theme
    // snackBarTheme: SnackBarThemeData(
    //   backgroundColor: darkColorScheme.inverseSurface,
    //   contentTextStyle: TextStyle(color: darkColorScheme.onInverseSurface),
    //   behavior: SnackBarBehavior.floating,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(8),
    //   ),
    // ),
    // // Bottom Navigation with clear visual hierarchy for dark theme
    // navigationBarTheme: NavigationBarThemeData(
    //   backgroundColor: darkColorScheme.surface,
    //   indicatorColor: darkColorScheme.primaryContainer,
    //   iconTheme: WidgetStateProperty.resolveWith((states) {
    //     if (states.contains(WidgetState.selected)) {
    //       return IconThemeData(color: darkColorScheme.primary);
    //     }
    //     return IconThemeData(color: darkColorScheme.surfaceContainerHighest);
    //   }),
    //   labelTextStyle: WidgetStateProperty.resolveWith((states) {
    //     if (states.contains(WidgetState.selected)) {
    //       return TextStyle(color: darkColorScheme.primary, fontSize: 12);
    //     }
    //     return TextStyle(
    //         color: darkColorScheme.surfaceContainerHighest, fontSize: 12);
    //   }),
    // ),
    // inputDecorationTheme: InputDecorationTheme(
    //   filled: true,
    //   fillColor: withAlpha(darkColorScheme.surfaceContainerHighest, 0.2),
    //   border: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(8),
    //     borderSide: BorderSide.none,
    //   ),
    //   focusedBorder: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(8),
    //     borderSide: BorderSide(color: darkColorScheme.primary, width: 2),
    //   ),
    //   enabledBorder: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(8),
    //     borderSide: BorderSide.none,
    //   ),
    //   errorBorder: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(8),
    //     borderSide: BorderSide(color: darkColorScheme.error, width: 2),
    //   ),
    //   contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    // ),
  );

  /// Loading theme to be used during app startup/splash screen
  static final ThemeData loadingTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: brandColor,
      onPrimary: Colors.white,
      surface: brandColor,
    ),
    scaffoldBackgroundColor: brandColor,
  );
}
