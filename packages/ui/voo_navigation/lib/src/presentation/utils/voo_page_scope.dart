import 'package:flutter/material.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';

/// A controller that manages the current page configuration.
///
/// Used internally by [VooPageScope] to track the active page's
/// configuration and notify the scaffold when it changes.
///
/// Supports route-based config tracking for StatefulShellRoute/IndexedStack
/// scenarios where multiple pages are mounted simultaneously.
class VooPageController extends ChangeNotifier {
  VoidCallback? _onConfigChanged;

  /// Map of route path to page config (for IndexedStack/StatefulShell support)
  final Map<String, VooPageConfig> _configsByRoute = {};

  /// The currently active route path
  String? _activeRoute;

  /// The current page configuration for the active route.
  VooPageConfig? get currentConfig {
    if (_activeRoute != null && _configsByRoute.containsKey(_activeRoute)) {
      return _configsByRoute[_activeRoute];
    }
    // Fallback: return the most recently set config if no active route
    return _configsByRoute.values.lastOrNull;
  }

  /// Sets a callback to be invoked when the config changes.
  /// Used by VooAdaptiveScaffold to trigger a rebuild.
  void setOnConfigChanged(VoidCallback? callback) {
    _onConfigChanged = callback;
  }

  /// Sets the currently active route.
  ///
  /// Call this when navigation changes to ensure the correct page's
  /// config is used. This is essential for StatefulShellRoute/IndexedStack
  /// where multiple pages stay mounted.
  void setActiveRoute(String? route) {
    if (_activeRoute != route) {
      _activeRoute = route;
      _notifyChange();
    }
  }

  /// Updates the page configuration for a specific route.
  ///
  /// The [route] identifies which page this config belongs to.
  /// This allows multiple pages to register their configs simultaneously
  /// (as happens with StatefulShellRoute/IndexedStack).
  void setConfigForRoute(String route, VooPageConfig? config) {
    if (config == null) {
      _configsByRoute.remove(route);
    } else {
      _configsByRoute[route] = config;
    }
    // Only notify if this is the active route
    if (_activeRoute == route || _activeRoute == null) {
      _notifyChange();
    }
  }

  /// Clears the config for a specific route.
  void clearConfigForRoute(String route) {
    if (_configsByRoute.remove(route) != null) {
      if (_activeRoute == route || _activeRoute == null) {
        _notifyChange();
      }
    }
  }

  void _notifyChange() {
    if (_onConfigChanged != null) {
      // Use scheduleMicrotask for faster notification than postFrameCallback.
      // This ensures config changes are reflected in the same frame when possible.
      Future.microtask(() {
        _onConfigChanged?.call();
      });
    }
  }
}

/// Provides page configuration to descendant widgets.
///
/// This widget should wrap your navigation scaffold to enable
/// page-level customization. Child [VooPage] widgets will
/// automatically register their configuration with this scope.
///
/// Typically, you don't need to use this directly - [VooAdaptiveScaffold]
/// creates one automatically.
class VooPageScope extends InheritedNotifier<VooPageController> {
  /// Creates a page scope with the given controller.
  const VooPageScope({
    super.key,
    required VooPageController controller,
    required super.child,
  }) : super(notifier: controller);

  /// Gets the [VooPageController] from the nearest [VooPageScope] ancestor.
  ///
  /// Returns null if no [VooPageScope] is found.
  static VooPageController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<VooPageScope>()
        ?.notifier;
  }

  /// Gets the [VooPageController] from the nearest [VooPageScope] ancestor.
  ///
  /// Throws if no [VooPageScope] is found.
  static VooPageController of(BuildContext context) {
    final controller = maybeOf(context);
    assert(controller != null, 'No VooPageScope found in context');
    return controller!;
  }

  /// Gets the current [VooPageConfig] from the nearest [VooPageScope].
  ///
  /// Returns null if no scope is found or no page config is set.
  static VooPageConfig? configOf(BuildContext context) {
    return maybeOf(context)?.currentConfig;
  }
}
