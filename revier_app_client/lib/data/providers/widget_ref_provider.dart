import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A globally accessible WidgetRef using a static reference
class GlobalRef {
  /// The singleton instance
  static final GlobalRef _instance = GlobalRef._internal();

  /// Factory constructor to return the singleton instance
  factory GlobalRef() => _instance;

  /// Private constructor for singleton
  GlobalRef._internal();

  /// The stored widget ref
  WidgetRef? _ref;

  /// Set the widget ref
  void setRef(WidgetRef ref) {
    debugPrint('GlobalRef: WidgetRef set');
    _ref = ref;
  }

  /// Get the widget ref
  WidgetRef get ref {
    if (_ref == null) {
      throw Exception(
          'GlobalRef: WidgetRef not set. Make sure to call setRef() first.');
    }
    return _ref!;
  }

  /// Check if the ref is available
  bool get hasRef => _ref != null;
}

/// Provider for accessing the ref in a Riverpod context
final widgetRefProvider = Provider<WidgetRef>((ref) {
  try {
    return GlobalRef().ref;
  } catch (e) {
    throw UnimplementedError(
        'widgetRefProvider must be initialized by calling GlobalRef().setRef(ref)');
  }
});
