import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_drawer/voo_navigation_drawer.dart';
import 'package:voo_navigation_rail/voo_navigation_rail.dart';
import 'package:voo_navigation/src/presentation/organisms/voo_adaptive_app_bar.dart';

/// Desktop scaffold with navigation drawer that can collapse to a rail
class VooDesktopScaffold extends StatefulWidget {
  /// Navigation configuration
  final VooNavigationConfig config;

  /// Body widget to display
  final Widget body;

  /// Background color
  final Color backgroundColor;

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

  /// Navigation type - used to determine initial collapsed state
  final VooNavigationType navigationType;

  const VooDesktopScaffold({
    super.key,
    required this.config,
    required this.body,
    required this.backgroundColor,
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
    this.navigationType = VooNavigationType.navigationDrawer,
  });

  @override
  State<VooDesktopScaffold> createState() => _VooDesktopScaffoldState();
}

class _VooDesktopScaffoldState extends State<VooDesktopScaffold> {
  late bool _isCollapsed;

  @override
  void initState() {
    super.initState();
    // Start collapsed (rail mode) for navigationRail type (medium screens)
    // Start expanded (drawer mode) for other types
    _isCollapsed = widget.navigationType == VooNavigationType.navigationRail;
  }

  @override
  void didUpdateWidget(VooDesktopScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Auto-collapse/expand when navigation type changes due to screen resize
    if (oldWidget.navigationType != widget.navigationType) {
      setState(() {
        _isCollapsed = widget.navigationType == VooNavigationType.navigationRail;
      });
    }
  }

  void _toggleCollapse() {
    if (widget.config.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }

    setState(() {
      _isCollapsed = !_isCollapsed;
    });

    widget.config.onCollapseChanged?.call(_isCollapsed);
  }

  Widget _getCollapseToggle() {
    if (widget.config.collapseToggleBuilder != null) {
      return widget.config.collapseToggleBuilder!(!_isCollapsed, _toggleCollapse);
    }

    return VooCollapseToggle(isExpanded: !_isCollapsed, onToggle: _toggleCollapse, iconColor: widget.config.unselectedItemColor, hoverColor: widget.config.selectedItemColor);
  }

  Widget _getNavigation() {
    final collapseToggle = _getCollapseToggle();

    // If collapsible rail is not enabled, just show the drawer
    if (!widget.config.enableCollapsibleRail) {
      return VooAdaptiveNavigationDrawer(config: widget.config, selectedId: widget.selectedId, onNavigationItemSelected: widget.onNavigationItemSelected);
    }

    // Instant switch - each widget handles its own internal animations
    if (_isCollapsed) {
      return VooAdaptiveNavigationRail(
        config: widget.config.copyWith(
          // Collapse toggle in header for rail too
          drawerHeaderTrailing: collapseToggle,
        ),
        selectedId: widget.selectedId,
        onNavigationItemSelected: widget.onNavigationItemSelected,
        extended: false,
        onToggleCollapse: _toggleCollapse,
      );
    }

    return VooAdaptiveNavigationDrawer(
      config: widget.config.copyWith(
        // Collapse toggle in header (top right)
        drawerHeaderTrailing: collapseToggle,
      ),
      selectedId: widget.selectedId,
      onNavigationItemSelected: widget.onNavigationItemSelected,
      onToggleCollapse: _toggleCollapse,
    );
  }

  Widget? _buildQuickActionsFab() {
    final quickActionsConfig = widget.config.quickActions;
    if (quickActionsConfig == null || widget.config.quickActionsPosition != VooQuickActionsPosition.fab) {
      return null;
    }

    return VooQuickActions(
      actions: quickActionsConfig.actions,
      triggerIcon: quickActionsConfig.triggerIcon,
      triggerWidget: quickActionsConfig.triggerWidget,
      tooltip: quickActionsConfig.tooltip,
      showLabelsInGrid: quickActionsConfig.showLabelsInGrid,
      style: quickActionsConfig.style,
      compact: quickActionsConfig.compact,
      useGridLayout: quickActionsConfig.useGridLayout,
      gridColumns: quickActionsConfig.gridColumns,
    );
  }

  @override
  Widget build(BuildContext context) {
    final navigation = _getNavigation();

    // Determine FAB visibility and widget based on page config overrides
    final showFab = widget.pageConfig?.showFloatingActionButton ?? widget.config.showFloatingActionButton;
    // Use quick actions FAB if configured, otherwise fall back to custom FAB
    final quickActionsFab = _buildQuickActionsFab();
    final fabWidget = quickActionsFab ?? widget.pageConfig?.floatingActionButton ?? widget.config.floatingActionButton;
    final fabLocation = widget.pageConfig?.floatingActionButtonLocation ?? widget.config.floatingActionButtonLocation;
    final fabAnimator = widget.pageConfig?.floatingActionButtonAnimator ?? widget.config.floatingActionButtonAnimator;

    final navTheme = widget.config.effectiveTheme;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Calculate content area margin - only top margin for visual separation
    final effectiveContentMargin = widget.config.contentAreaMargin ?? const EdgeInsets.only(top: 8);

    // Calculate content area border radius - only top-left corner rounded
    final effectiveContentBorderRadius = widget.config.contentAreaBorderRadius ?? const BorderRadius.only(topLeft: Radius.circular(12));

    // Content area background - use surfaceContainerLow for visible distinction from navigation
    final effectiveContentBackgroundColor = widget.config.contentAreaBackgroundColor ?? colorScheme.surfaceContainerLow;

    // When app bar is alongside drawer/rail, wrap the content area with its own scaffold
    if (widget.config.appBarAlongsideRail) {
      // Build the app bar with proper margin styling
      PreferredSizeWidget? effectiveAppBar;
      if (widget.showAppBar) {
        if (widget.appBar != null) {
          effectiveAppBar = widget.appBar;
        } else {
          effectiveAppBar = VooAdaptiveAppBar(
            config: widget.config,
            selectedId: widget.selectedId,
            showMenuButton: false,
            title: widget.pageConfig?.appBarTitle,
            leading: widget.pageConfig?.appBarLeading,
            additionalActions: widget.pageConfig?.additionalAppBarActions,
            bottom: widget.pageConfig?.appBarBottom,
            showBottomBorder: widget.pageConfig?.showAppBarBottomDivider,
            backgroundColor: widget.pageConfig?.appBarBackgroundColor,
            foregroundColor: widget.pageConfig?.appBarForegroundColor,
            centerTitle: widget.pageConfig?.centerAppBarTitle,
            elevation: widget.pageConfig?.appBarElevation,
            toolbarHeight: widget.pageConfig?.appBarToolbarHeight,
          );
        }
      }

      return Scaffold(
        key: widget.scaffoldKey,
        backgroundColor: widget.backgroundColor,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Apply same top margin to navigation for header alignment
            Padding(
              padding: EdgeInsets.only(top: effectiveContentMargin.top),
              child: navigation,
            ),
            Expanded(
              child: Container(
                margin: effectiveContentMargin,
                decoration: BoxDecoration(
                  borderRadius: effectiveContentBorderRadius,
                  border: Border(
                    left: BorderSide(color: theme.dividerColor.withValues(alpha: 0.15), width: 1),
                    top: BorderSide(color: theme.dividerColor.withValues(alpha: 0.15), width: 1),
                  ),
                ),
                child: VooThemedNavContainer(
                  theme: navTheme,
                  expand: true,
                  borderRadius: effectiveContentBorderRadius,
                  clipContent: true,
                  backgroundColor: effectiveContentBackgroundColor,
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: effectiveAppBar,
                    body: widget.body,
                    floatingActionButton: showFab ? fabWidget : null,
                    floatingActionButtonLocation: fabLocation,
                    floatingActionButtonAnimator: fabAnimator,
                  ),
                ),
              ),
            ),
          ],
        ),
        endDrawer: widget.endDrawer,
        drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
        drawerEnableOpenDragGesture: widget.drawerEnableOpenDragGesture,
        endDrawerEnableOpenDragGesture: widget.endDrawerEnableOpenDragGesture,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        extendBody: widget.extendBody,
        extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
        bottomSheet: widget.bottomSheet,
        persistentFooterButtons: widget.persistentFooterButtons,
        restorationId: widget.restorationId,
      );
    }

    // All themes use Row layout - navigation beside content
    // Apply consistent body margins and themed styling for visual alignment with drawer
    return Scaffold(
      key: widget.scaffoldKey,
      backgroundColor: widget.backgroundColor,
      appBar: widget.showAppBar
          ? (widget.appBar ??
                VooAdaptiveAppBar(
                  config: widget.config,
                  selectedId: widget.selectedId,
                  showMenuButton: false,
                  title: widget.pageConfig?.appBarTitle,
                  leading: widget.pageConfig?.appBarLeading,
                  additionalActions: widget.pageConfig?.additionalAppBarActions,
                  bottom: widget.pageConfig?.appBarBottom,
                  showBottomBorder: widget.pageConfig?.showAppBarBottomDivider,
                  backgroundColor: widget.pageConfig?.appBarBackgroundColor,
                  foregroundColor: widget.pageConfig?.appBarForegroundColor,
                  centerTitle: widget.pageConfig?.centerAppBarTitle,
                  elevation: widget.pageConfig?.appBarElevation,
                  toolbarHeight: widget.pageConfig?.appBarToolbarHeight,
                ))
          : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Apply same top margin to navigation for header alignment
          Padding(
            padding: EdgeInsets.only(top: effectiveContentMargin.top),
            child: navigation,
          ),
          Expanded(
            child: Container(
              margin: effectiveContentMargin,
              decoration: BoxDecoration(
                borderRadius: effectiveContentBorderRadius,
                border: Border(
                  left: BorderSide(color: theme.dividerColor.withValues(alpha: 0.15), width: 1),
                  top: BorderSide(color: theme.dividerColor.withValues(alpha: 0.15), width: 1),
                ),
              ),
              child: VooThemedNavContainer(
                theme: navTheme,
                expand: true,
                borderRadius: effectiveContentBorderRadius,
                clipContent: true,
                backgroundColor: effectiveContentBackgroundColor,
                child: widget.body,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: showFab ? fabWidget : null,
      floatingActionButtonLocation: fabLocation,
      floatingActionButtonAnimator: fabAnimator,
      endDrawer: widget.endDrawer,
      drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: widget.drawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture: widget.endDrawerEnableOpenDragGesture,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      extendBody: widget.extendBody,
      extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
      bottomSheet: widget.bottomSheet,
      persistentFooterButtons: widget.persistentFooterButtons,
      restorationId: widget.restorationId,
    );
  }
}
