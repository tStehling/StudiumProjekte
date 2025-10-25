import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define a simple provider without code generation first
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

// This class will be implemented later when code generation is working
class ThemePreferences {
  static const _themePreferenceKey = 'theme_preference';

  static Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themePreferenceKey, mode.index);
  }

  static Future<ThemeMode> loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themePreferenceKey);

    if (themeIndex != null) {
      return ThemeMode.values[themeIndex];
    }
    return ThemeMode.system;
  }
}
