import 'package:flutter/material.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';
import 'package:voo_navigation/src/presentation/utils/voo_page_scope.dart';

/// A widget that provides page-level scaffold customization.
///
/// Wrap your page content with [VooPage] to override scaffold elements
/// like app bar, floating action button, bottom sheet, etc. on a
/// per-page basis.
///
/// This works with [VooAdaptiveScaffold] to allow different pages
/// to have different scaffold configurations while maintaining
/// the adaptive navigation behavior.
///
/// ## Basic Usage
///
/// ```dart
/// VooPage(
///   config: VooPageConfig(
///     floatingActionButton: FloatingActionButton(
///       onPressed: () => print('Custom FAB'),
///       child: Icon(Icons.add),
///     ),
///     floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
///   ),
///   child: MyPageContent(),
/// )
/// ```
///
/// ## Custom App Bar
///
/// ```dart
/// VooPage(
///   config: VooPageConfig(
///     appBar: AppBar(
///       title: Text('Custom Title'),
///       actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
///     ),
///   ),
///   child: MyPageContent(),
/// )
/// ```
///
/// ## Full-screen Page (No App Bar)
///
/// ```dart
/// VooPage(
///   config: VooPageConfig.fullscreen(),
///   child: MyFullscreenContent(),
/// )
/// ```
///
/// ## Custom Scaffold
///
/// For complete control, use [useCustomScaffold]:
///
/// ```dart
/// VooPage(
///   config: VooPageConfig(
///     useCustomScaffold: true,
///     scaffoldBuilder: (context, child) {
///       return Scaffold(
///         body: Stack(
///           children: [
///             child,
///             Positioned(
///               bottom: 100,
///               right: 20,
///               child: FloatingActionButton(...),
///             ),
///           ],
///         ),
///       );
///     },
///   ),
///   child: MyPageContent(),
/// )
/// ```
class VooPage extends StatefulWidget {
  /// The page configuration with scaffold overrides.
  final VooPageConfig config;

  /// The page content.
  final Widget child;

  /// Creates a page with custom scaffold configuration.
  const VooPage({super.key, required this.config, required this.child});

  /// Creates a page with a custom floating action button.
  factory VooPage.withFab({Key? key, required Widget fab, FloatingActionButtonLocation? fabLocation, required Widget child}) {
    return VooPage(
      key: key,
      config: VooPageConfig(floatingActionButton: fab, floatingActionButtonLocation: fabLocation),
      child: child,
    );
  }

  /// Creates a page with a custom app bar.
  factory VooPage.withAppBar({Key? key, required PreferredSizeWidget appBar, required Widget child}) {
    return VooPage(
      key: key,
      config: VooPageConfig(appBar: appBar),
      child: child,
    );
  }

  /// Creates a full-screen page without app bar.
  factory VooPage.fullscreen({Key? key, required Widget child}) {
    return VooPage(key: key, config: const VooPageConfig.fullscreen(), child: child);
  }

  /// Creates a clean page without any scaffold elements.
  factory VooPage.clean({Key? key, required Widget child}) {
    return VooPage(key: key, config: const VooPageConfig.clean(), child: child);
  }

  @override
  State<VooPage> createState() => _VooPageState();
}

class _VooPageState extends State<VooPage> {
  VooPageController? _controller;
  String? _routePath;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = VooPageScope.maybeOf(context);
    _updateRoutePath();
    _registerConfig();
  }

  @override
  void didUpdateWidget(VooPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config != widget.config) {
      _registerConfig();
    }
  }

  @override
  void dispose() {
    // Clear the config for this route when disposed
    final controller = _controller;
    final route = _routePath;
    if (controller != null && route != null) {
      Future.microtask(() {
        controller.clearConfigForRoute(route);
      });
    }
    super.dispose();
  }

  /// Get the current route path for this page
  void _updateRoutePath() {
    // Use ModalRoute name or generate a unique path
    final modalRoute = ModalRoute.of(context);
    _routePath = modalRoute?.settings.name ?? 'page_${identityHashCode(this)}';
  }

  void _registerConfig() {
    if (_routePath == null) return;

    // Register config immediately so it's available for the current build cycle.
    // The controller will handle async notification to trigger scaffold rebuild.
    _controller?.setConfigForRoute(_routePath!, widget.config);
  }

  @override
  Widget build(BuildContext context) {
    // If using custom scaffold, delegate to the builder
    if (widget.config.useCustomScaffold && widget.config.scaffoldBuilder != null) {
      return widget.config.scaffoldBuilder!(context, widget.child);
    }

    // If wrapInScaffold is true, wrap in a basic Scaffold
    if (widget.config.wrapInScaffold) {
      return Scaffold(body: widget.child);
    }

    return widget.child;
  }
}

/// Extension to easily get page configuration from context.
extension VooPageContext on BuildContext {
  /// Gets the current [VooPageConfig] from the nearest [VooPageScope].
  ///
  /// Returns null if no page config is set.
  VooPageConfig? get vooPageConfig => VooPageScope.configOf(this);

  /// Gets the [VooPageController] from the nearest [VooPageScope].
  ///
  /// Returns null if no scope is found.
  VooPageController? get vooPageController => VooPageScope.maybeOf(this);
}
