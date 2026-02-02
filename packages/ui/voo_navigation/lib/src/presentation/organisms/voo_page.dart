import 'package:flutter/material.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';

/// A widget that provides page-level scaffold customization.
///
/// When [config.appBarConfig] is provided, VooPage builds a Scaffold
/// with an AppBar containing the configured title, actions, etc.
///
/// ## Usage with App Bar
///
/// ```dart
/// VooPage(
///   config: VooPageConfig(
///     appBarConfig: VooAppBarConfig(
///       title: Text('My Page'),
///       additionalActions: [IconButton(...)],
///     ),
///   ),
///   child: MyPageContent(),
/// )
/// ```
///
/// ## Simple Scaffold Wrapper
///
/// ```dart
/// VooPage(
///   config: VooPageConfig(wrapInScaffold: true),
///   child: MyPageContent(),
/// )
/// ```
class VooPage extends StatelessWidget {
  /// The page configuration.
  final VooPageConfig config;

  /// The page content.
  final Widget child;

  const VooPage({super.key, required this.config, required this.child});

  /// Creates a page wrapped in a basic Scaffold.
  factory VooPage.withScaffold({Key? key, required Widget child}) {
    return VooPage(
      key: key,
      config: const VooPageConfig(wrapInScaffold: true),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    // If using custom scaffold builder, delegate to it
    if (config.useCustomScaffold && config.scaffoldBuilder != null) {
      return config.scaffoldBuilder!(context, child);
    }

    // If appBarConfig is provided, build a scaffold with app bar
    final appBarConfig = config.appBarConfig;
    if (appBarConfig != null && appBarConfig.show != false) {
      return Scaffold(
        appBar: _buildAppBar(context, appBarConfig),
        body: child,
        backgroundColor: config.backgroundColor,
        floatingActionButton: config.floatingActionButton,
        floatingActionButtonLocation: config.floatingActionButtonLocation,
        floatingActionButtonAnimator: config.floatingActionButtonAnimator,
        bottomSheet: config.bottomSheet,
        persistentFooterButtons: config.persistentFooterButtons,
        endDrawer: config.endDrawer,
        resizeToAvoidBottomInset: config.resizeToAvoidBottomInset,
        extendBody: config.extendBody ?? false,
        extendBodyBehindAppBar: config.extendBodyBehindAppBar ?? false,
      );
    }

    // If wrapInScaffold is true, wrap in a basic Scaffold
    if (config.wrapInScaffold) {
      return Scaffold(
        body: child,
        backgroundColor: config.backgroundColor,
        floatingActionButton: config.floatingActionButton,
        floatingActionButtonLocation: config.floatingActionButtonLocation,
        floatingActionButtonAnimator: config.floatingActionButtonAnimator,
        bottomSheet: config.bottomSheet,
        persistentFooterButtons: config.persistentFooterButtons,
        endDrawer: config.endDrawer,
        resizeToAvoidBottomInset: config.resizeToAvoidBottomInset,
        extendBody: config.extendBody ?? false,
        extendBodyBehindAppBar: config.extendBodyBehindAppBar ?? false,
      );
    }

    return child;
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, VooAppBarConfig appBarConfig) {
    // If a custom appBar widget is provided, use it directly
    if (appBarConfig.appBar != null) {
      return appBarConfig.appBar!;
    }

    final theme = Theme.of(context);

    return AppBar(
      title: appBarConfig.title,
      leading: appBarConfig.leading,
      actions: appBarConfig.additionalActions,
      centerTitle: appBarConfig.centerTitle,
      backgroundColor: appBarConfig.backgroundColor,
      foregroundColor: appBarConfig.foregroundColor,
      elevation: appBarConfig.elevation,
      toolbarHeight: appBarConfig.toolbarHeight,
      bottom: appBarConfig.bottom,
      automaticallyImplyLeading: appBarConfig.showBackButton ?? true,
      titleTextStyle: theme.textTheme.titleLarge?.copyWith(
        color: appBarConfig.foregroundColor ?? theme.colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
