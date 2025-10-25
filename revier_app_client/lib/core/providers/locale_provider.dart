import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for managing the application locale
final localeProvider = StateProvider<Locale>((ref) {
  // Default to English
  return const Locale('en');
});
