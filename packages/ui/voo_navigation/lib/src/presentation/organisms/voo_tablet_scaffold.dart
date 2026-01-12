import 'package:flutter/material.dart';
import 'package:voo_navigation_rail/voo_navigation_rail.dart';
import 'package:voo_navigation/src/presentation/organisms/voo_adaptive_app_bar.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Tablet scaffold with navigation rail
class VooTabletScaffold extends StatelessWidget {
  /// Navigation configuration
  final VooNavigationConfig config;

  /// Body widget to display
  final Widget body;

  /// Background color
  final Color backgroundColor;

  /// Whether to show extended navigation rail
  final bool extended;

  /// Currently selected navigation item ID
  final String selectedId;

  /// Callback when a navigation item is selected
  final void Function(String itemId) onNavigationItemSelected;

  /// Scaffold key for external control
  final GlobalKey<ScaffoldState>? scaffoldKey;

  /// Optional custom app bar
  final PreferredSizeWidget? appBar;

  /// Whether to show the app bar
  final bool showAppBar;

  /// Custom end drawer
  final Widget? endDrawer;

  /// Drawer edge drag width
  final double drawerEdgeDragWidth;

  /// Whether drawer is open initially
  final bool drawerEnableOpenDragGesture;

  /// Whether end drawer is open initially
  final bool endDrawerEnableOpenDragGesture;

  /// Whether to resize to avoid bottom inset
  final bool resizeToAvoidBottomInset;

  /// Whether to extend body
  final bool extendBody;

  /// Whether to extend body behind app bar
  final bool extendBodyBehindAppBar;

  /// Custom bottom sheet
  final Widget? bottomSheet;

  /// Persistent footer buttons
  final List<Widget>? persistentFooterButtons;

  /// Restoration ID for state restoration
  final String? restorationId;

  /// Page-level configuration overrides
  final VooPageConfig? pageConfig;

  const VooTabletScaffold({
    super.key,
    required this.config,
    required this.body,
    required this.backgroundColor,
    required this.extended,
    required this.selectedId,
    required this.onNavigationItemSelected,
    this.scaffoldKey,
    this.appBar,
    required this.showAppBar,
    this.endDrawer,
    required this.drawerEdgeDragWidth,
    required this.drawerEnableOpenDragGesture,
    required this.endDrawerEnableOpenDragGesture,
    required this.resizeToAvoidBottomInset,
    required this.extendBody,
    required this.extendBodyBehindAppBar,
    this.bottomSheet,
    this.persistentFooterButtons,
    this.restorationId,
    this.pageConfig,
  });

  @override
  Widget build(BuildContext context) {
    final navigationRail = VooAdaptiveNavigationRail(
      config: config,
      selectedId: selectedId,
      onNavigationItemSelected: onNavigationItemSelected,
      extended: extended,
    );

    // Determine FAB visibility and widget based on page config overrides
    final showFab = pageConfig?.showFloatingActionButton ??
        config.showFloatingActionButton;
    final fabWidget = pageConfig?.floatingActionButton ??
        config.floatingActionButton;
    final fabLocation = pageConfig?.floatingActionButtonLocation ??
        config.floatingActionButtonLocation;
    final fabAnimator = pageConfig?.floatingActionButtonAnimator ??
        config.floatingActionButtonAnimator;

    // When app bar is alongside rail, wrap the content area with its own scaffold
    if (config.appBarAlongsideRail) {
      // Build the app bar with proper margin styling
      PreferredSizeWidget? effectiveAppBar;
      if (showAppBar) {
        if (appBar != null) {
          // Wrap custom app bar in a container with margin to match VooAdaptiveAppBar styling
          effectiveAppBar = PreferredSize(
            preferredSize: appBar!.preferredSize,
            child: Padding(
              padding: EdgeInsets.only(
                top: context.vooTokens.spacing.sm,
                left: context.vooTokens.spacing.sm,
                right: context.vooTokens.spacing.sm,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(context.vooRadius.md),
                child: appBar,
              ),
            ),
          );
        } else {
          effectiveAppBar = VooAdaptiveAppBar(
            config: config,
            selectedId: selectedId,
            showMenuButton: false,
            margin: EdgeInsets.only(
              right: context.vooRadius.sm,
              top: context.vooTokens.spacing.sm,
            ),
          );
        }
      }

      final navTheme = config.effectiveTheme;
      final colorScheme = Theme.of(context).colorScheme;
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final effectiveContentBackgroundColor = config.contentAreaBackgroundColor ??
          (isDark ? colorScheme.surfaceContainerLow : const Color(0xFFF5F5F5));

      return Scaffold(
        key: scaffoldKey,
        backgroundColor: backgroundColor,
        body: Row(
          children: [
            navigationRail,
            Expanded(
              child: VooThemedNavContainer(
                theme: navTheme,
                expand: true,
                margin: const EdgeInsets.only(top: 8),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12)),
                clipContent: true,
                backgroundColor: effectiveContentBackgroundColor,
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: effectiveAppBar,
                  body: body,
                  floatingActionButton: showFab ? fabWidget : null,
                  floatingActionButtonLocation: fabLocation,
                  floatingActionButtonAnimator: fabAnimator,
                ),
              ),
            ),
          ],
        ),
        endDrawer: endDrawer,
        drawerEdgeDragWidth: drawerEdgeDragWidth,
        drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
        endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        extendBody: extendBody,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        bottomSheet: bottomSheet,
        persistentFooterButtons: persistentFooterButtons,
        restorationId: restorationId,
      );
    }

    // All themes use Row layout - navigation beside content
    // Apply consistent body margins and themed styling for visual alignment with rail
    // Body always gets margins on top, bottom, right to match navigation styling (default behavior)
    final navTheme = config.effectiveTheme;
    final colorScheme2 = Theme.of(context).colorScheme;
    final isDark2 = Theme.of(context).brightness == Brightness.dark;
    final effectiveContentBackgroundColor2 = config.contentAreaBackgroundColor ??
        (isDark2 ? colorScheme2.surfaceContainerLow : const Color(0xFFF5F5F5));

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: showAppBar
          ? (appBar ?? VooAdaptiveAppBar(config: config, selectedId: selectedId, showMenuButton: false))
          : null,
      body: Row(
        children: [
          navigationRail,
          Expanded(
            child: VooThemedNavContainer(
              theme: navTheme,
              expand: true,
              margin: const EdgeInsets.only(top: 8),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12)),
              clipContent: true,
              backgroundColor: effectiveContentBackgroundColor2,
              child: body,
            ),
          ),
        ],
      ),
      floatingActionButton: showFab ? fabWidget : null,
      floatingActionButtonLocation: fabLocation,
      floatingActionButtonAnimator: fabAnimator,
      endDrawer: endDrawer,
      drawerEdgeDragWidth: drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      bottomSheet: bottomSheet,
      persistentFooterButtons: persistentFooterButtons,
      restorationId: restorationId,
    );
  }
}
