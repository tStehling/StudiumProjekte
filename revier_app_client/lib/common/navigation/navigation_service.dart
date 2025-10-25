import 'package:flutter/material.dart';
import 'page_transitions.dart';

/// Navigation service for consistent navigation throughout the app
class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  static NavigationService get instance => _instance;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Route observer to track navigation events
  final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

  NavigatorState? get navigator => navigatorKey.currentState;

  /// Navigate to a new page with a beautiful slide transition
  Future<T?> navigateTo<T>(Widget page, {String? routeName}) {
    return navigator!.push<T>(
      AppPageTransitions.slide<T>(
        page: page,
        settings: routeName != null ? RouteSettings(name: routeName) : null,
      ),
    );
  }

  /// Navigate to a new page with a beautiful fade transition
  Future<T?> navigateWithFade<T>(Widget page, {String? routeName}) {
    return navigator!.push<T>(
      AppPageTransitions.fade<T>(
        page: page,
        settings: routeName != null ? RouteSettings(name: routeName) : null,
      ),
    );
  }

  /// Navigate to a new page with a beautiful scale transition
  Future<T?> navigateWithScale<T>(Widget page, {String? routeName}) {
    return navigator!.push<T>(
      AppPageTransitions.scale<T>(
        page: page,
        settings: routeName != null ? RouteSettings(name: routeName) : null,
      ),
    );
  }

  /// Navigate to a new page with a beautiful slide up transition
  Future<T?> navigateWithSlideUp<T>(Widget page, {String? routeName}) {
    return navigator!.push<T>(
      AppPageTransitions.slideUp<T>(
        page: page,
        settings: routeName != null ? RouteSettings(name: routeName) : null,
      ),
    );
  }

  /// Navigate to a named route with a beautiful slide transition
  Future<T?> navigateToNamed<T>(String routeName, {Object? arguments}) {
    return navigator!.pushNamed<T>(routeName, arguments: arguments);
  }

  /// Go back to previous screen
  void goBack<T>([T? result]) {
    if (navigator!.canPop()) {
      return navigator!.pop<T>(result);
    }
  }

  /// Replace the current page with a new one (slide transition)
  Future<T?> replaceTo<T>(Widget page, {String? routeName}) {
    return navigator!.pushReplacement<T, dynamic>(
      AppPageTransitions.slide<T>(
        page: page,
        settings: routeName != null ? RouteSettings(name: routeName) : null,
      ),
    );
  }

  /// Clear stack and navigate to a new page
  Future<T?> navigateAndClearStack<T>(Widget page, {String? routeName}) {
    return navigator!.pushAndRemoveUntil<T>(
      AppPageTransitions.slide<T>(
        page: page,
        settings: routeName != null ? RouteSettings(name: routeName) : null,
      ),
      (route) => false,
    );
  }
}
