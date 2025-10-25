import "package:flutter/material.dart";

// from http://material-foundation.github.io?primary=%232C3532&secondary=%23116466&tertiary=%23D9B08C&colorMatch=false
// renamed from MaterialTheme to MaterialColorTheme
class MaterialColorTheme {
  final TextTheme textTheme;

  const MaterialColorTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff0a6b5a),
      surfaceTint: Color(0xff0a6b5a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffa1f2dc),
      onPrimaryContainer: Color(0xff005143),
      secondary: Color(0xff00696c),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff9cf1f3),
      onSecondaryContainer: Color(0xff004f51),
      tertiary: Color(0xff86521a),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffffdcbf),
      onTertiaryContainer: Color(0xff6a3b02),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff5fbf7),
      onSurface: Color(0xff171d1b),
      onSurfaceVariant: Color(0xff3f4945),
      outline: Color(0xff6f7975),
      outlineVariant: Color(0xffbfc9c4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b322f),
      inversePrimary: Color(0xff85d6c0),
      primaryFixed: Color(0xffa1f2dc),
      onPrimaryFixed: Color(0xff00201a),
      primaryFixedDim: Color(0xff85d6c0),
      onPrimaryFixedVariant: Color(0xff005143),
      secondaryFixed: Color(0xff9cf1f3),
      onSecondaryFixed: Color(0xff002021),
      secondaryFixedDim: Color(0xff80d4d6),
      onSecondaryFixedVariant: Color(0xff004f51),
      tertiaryFixed: Color(0xffffdcbf),
      onTertiaryFixed: Color(0xff2d1600),
      tertiaryFixedDim: Color(0xfffeb876),
      onTertiaryFixedVariant: Color(0xff6a3b02),
      surfaceDim: Color(0xffd5dbd8),
      surfaceBright: Color(0xfff5fbf7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5f1),
      surfaceContainer: Color(0xffe9efeb),
      surfaceContainerHigh: Color(0xffe3eae6),
      surfaceContainerHighest: Color(0xffdee4e0),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003e33),
      surfaceTint: Color(0xff0a6b5a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff247a68),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff003d3e),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff16797b),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff532d00),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff986127),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff5fbf7),
      onSurface: Color(0xff0c1211),
      onSurfaceVariant: Color(0xff2f3835),
      outline: Color(0xff4b5551),
      outlineVariant: Color(0xff656f6b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b322f),
      inversePrimary: Color(0xff85d6c0),
      primaryFixed: Color(0xff247a68),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff006050),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff16797b),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff005f61),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff986127),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff7b4910),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc2c8c4),
      surfaceBright: Color(0xfff5fbf7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5f1),
      surfaceContainer: Color(0xffe3eae6),
      surfaceContainerHigh: Color(0xffd8dedb),
      surfaceContainerHighest: Color(0xffcdd3cf),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff00332a),
      surfaceTint: Color(0xff0a6b5a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff005345),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff003233),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff005254),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff452400),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff6d3e04),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff5fbf7),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff252e2b),
      outlineVariant: Color(0xff424b48),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b322f),
      inversePrimary: Color(0xff85d6c0),
      primaryFixed: Color(0xff005345),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff003a30),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff005254),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff00393b),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff6d3e04),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff4e2a00),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb4bab7),
      surfaceBright: Color(0xfff5fbf7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffecf2ee),
      surfaceContainer: Color(0xffdee4e0),
      surfaceContainerHigh: Color(0xffcfd6d2),
      surfaceContainerHighest: Color(0xffc2c8c4),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff85d6c0),
      surfaceTint: Color(0xff85d6c0),
      onPrimary: Color(0xff00382e),
      primaryContainer: Color(0xff005143),
      onPrimaryContainer: Color(0xffa1f2dc),
      secondary: Color(0xff80d4d6),
      onSecondary: Color(0xff003738),
      secondaryContainer: Color(0xff004f51),
      onSecondaryContainer: Color(0xff9cf1f3),
      tertiary: Color(0xfffeb876),
      onTertiary: Color(0xff4b2800),
      tertiaryContainer: Color(0xff6a3b02),
      onTertiaryContainer: Color(0xffffdcbf),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff0e1513),
      onSurface: Color(0xffdee4e0),
      onSurfaceVariant: Color(0xffbfc9c4),
      outline: Color(0xff89938f),
      outlineVariant: Color(0xff3f4945),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee4e0),
      inversePrimary: Color(0xff0a6b5a),
      primaryFixed: Color(0xffa1f2dc),
      onPrimaryFixed: Color(0xff00201a),
      primaryFixedDim: Color(0xff85d6c0),
      onPrimaryFixedVariant: Color(0xff005143),
      secondaryFixed: Color(0xff9cf1f3),
      onSecondaryFixed: Color(0xff002021),
      secondaryFixedDim: Color(0xff80d4d6),
      onSecondaryFixedVariant: Color(0xff004f51),
      tertiaryFixed: Color(0xffffdcbf),
      onTertiaryFixed: Color(0xff2d1600),
      tertiaryFixedDim: Color(0xfffeb876),
      onTertiaryFixedVariant: Color(0xff6a3b02),
      surfaceDim: Color(0xff0e1513),
      surfaceBright: Color(0xff343b38),
      surfaceContainerLowest: Color(0xff090f0e),
      surfaceContainerLow: Color(0xff171d1b),
      surfaceContainer: Color(0xff1b211f),
      surfaceContainerHigh: Color(0xff252b29),
      surfaceContainerHighest: Color(0xff303634),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff9becd6),
      surfaceTint: Color(0xff85d6c0),
      onPrimary: Color(0xff002c23),
      primaryContainer: Color(0xff4e9f8b),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xff96eaed),
      onSecondary: Color(0xff002b2c),
      secondaryContainer: Color(0xff479da0),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffd4b0),
      onTertiary: Color(0xff3b1f00),
      tertiaryContainer: Color(0xffc18447),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff0e1513),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd4dfda),
      outline: Color(0xffaab4b0),
      outlineVariant: Color(0xff88938e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee4e0),
      inversePrimary: Color(0xff005244),
      primaryFixed: Color(0xffa1f2dc),
      onPrimaryFixed: Color(0xff001510),
      primaryFixedDim: Color(0xff85d6c0),
      onPrimaryFixedVariant: Color(0xff003e33),
      secondaryFixed: Color(0xff9cf1f3),
      onSecondaryFixed: Color(0xff001415),
      secondaryFixedDim: Color(0xff80d4d6),
      onSecondaryFixedVariant: Color(0xff003d3e),
      tertiaryFixed: Color(0xffffdcbf),
      onTertiaryFixed: Color(0xff1e0d00),
      tertiaryFixedDim: Color(0xfffeb876),
      onTertiaryFixedVariant: Color(0xff532d00),
      surfaceDim: Color(0xff0e1513),
      surfaceBright: Color(0xff3f4643),
      surfaceContainerLowest: Color(0xff040807),
      surfaceContainerLow: Color(0xff191f1d),
      surfaceContainer: Color(0xff232927),
      surfaceContainerHigh: Color(0xff2e3432),
      surfaceContainerHighest: Color(0xff393f3d),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffb3ffea),
      surfaceTint: Color(0xff85d6c0),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff81d2bd),
      onPrimaryContainer: Color(0xff000e0a),
      secondary: Color(0xffb1fdff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xff7cd0d2),
      onSecondaryContainer: Color(0xff000e0e),
      tertiary: Color(0xffffeddf),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xfff9b473),
      onTertiaryContainer: Color(0xff160800),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff0e1513),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffe8f2ed),
      outlineVariant: Color(0xffbbc5c0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee4e0),
      inversePrimary: Color(0xff005244),
      primaryFixed: Color(0xffa1f2dc),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff85d6c0),
      onPrimaryFixedVariant: Color(0xff001510),
      secondaryFixed: Color(0xff9cf1f3),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xff80d4d6),
      onSecondaryFixedVariant: Color(0xff001415),
      tertiaryFixed: Color(0xffffdcbf),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xfffeb876),
      onTertiaryFixedVariant: Color(0xff1e0d00),
      surfaceDim: Color(0xff0e1513),
      surfaceBright: Color(0xff4b514f),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1b211f),
      surfaceContainer: Color(0xff2b322f),
      surfaceContainerHigh: Color(0xff363d3a),
      surfaceContainerHighest: Color(0xff424846),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.background,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
