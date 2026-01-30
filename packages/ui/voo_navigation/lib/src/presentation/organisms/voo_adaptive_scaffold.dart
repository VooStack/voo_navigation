import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_bar/voo_navigation_bar.dart';
import 'package:voo_navigation/src/presentation/organisms/voo_scaffold_builder.dart';
import 'package:voo_navigation/src/presentation/utils/voo_page_scope.dart';
import 'package:voo_responsive/voo_responsive.dart';

/// Adaptive scaffold that automatically adjusts navigation based on screen size
class VooAdaptiveScaffold extends StatefulWidget {
  /// Configuration for the navigation system
  final VooNavigationConfig config;

  /// Main content body (can be a StatefulNavigationShell from go_router)
  final Widget body;

  /// Optional custom app bar (overrides config.appBarTitle)
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

  /// Scaffold key for external control
  final GlobalKey<ScaffoldState>? scaffoldKey;

  /// Background color
  final Color? backgroundColor;

  /// Whether to resize to avoid bottom inset
  final bool resizeToAvoidBottomInset;

  /// Whether to extend body behind app bar
  final bool extendBody;

  /// Whether to extend body behind app bar
  final bool extendBodyBehindAppBar;

  /// Custom bottom sheet
  final Widget? bottomSheet;

  /// Persistent footer buttons
  final List<Widget>? persistentFooterButtons;

  /// Restoration ID for state restoration
  final String? restorationId;

  /// Padding to apply to the body content
  final EdgeInsetsGeometry? bodyPadding;

  /// Whether to wrap body in a card with elevation
  final bool useBodyCard;

  /// Elevation for body card (if useBodyCard is true)
  final double bodyCardElevation;

  /// Border radius for body card (if useBodyCard is true)
  final BorderRadius? bodyCardBorderRadius;

  /// Color for body card (if useBodyCard is true)
  final Color? bodyCardColor;

  const VooAdaptiveScaffold({
    super.key,
    required this.config,
    required this.body,
    this.appBar,
    bool? showAppBar,
    this.endDrawer,
    this.drawerEdgeDragWidth = 20.0,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.scaffoldKey,
    this.backgroundColor,
    bool? resizeToAvoidBottomInset,
    bool? extendBody,
    bool? extendBodyBehindAppBar,
    this.bottomSheet,
    this.persistentFooterButtons,
    this.restorationId,
    this.bodyPadding,
    bool? useBodyCard,
    double? bodyCardElevation,
    this.bodyCardBorderRadius,
    this.bodyCardColor,
  }) : showAppBar = showAppBar ?? true,
       resizeToAvoidBottomInset = resizeToAvoidBottomInset ?? true,
       extendBody = extendBody ?? false,
       extendBodyBehindAppBar = extendBodyBehindAppBar ?? false,
       useBodyCard = useBodyCard ?? false,
       bodyCardElevation = bodyCardElevation ?? 0;

  @override
  State<VooAdaptiveScaffold> createState() => _VooAdaptiveScaffoldState();
}

class _VooAdaptiveScaffoldState extends State<VooAdaptiveScaffold> with SingleTickerProviderStateMixin {
  late String _selectedId;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  VooNavigationType? _previousNavigationType;
  late VooPageController _pageController;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.config.selectedId ?? widget.config.items.firstWhere((item) => item.isEnabled).id;

    _pageController = VooPageController();
    _pageController.setOnConfigChanged(_onPageConfigChanged);

    // Start animation at completed state (value: 1.0) so body is visible immediately
    // Animations will play on navigation changes, not on initial load
    _animationController = AnimationController(
      duration: widget.config.animationDuration,
      vsync: this,
      value: 1.0,
    );

    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: widget.config.animationCurve);

    _slideAnimation = Tween<Offset>(begin: const Offset(0.0, 0.05), end: Offset.zero).animate(CurvedAnimation(parent: _animationController, curve: widget.config.animationCurve));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(VooAdaptiveScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync selectedId when config changes from parent
    if (widget.config.selectedId != null &&
        widget.config.selectedId != oldWidget.config.selectedId) {
      _selectedId = widget.config.selectedId!;
    }
  }

  void _onPageConfigChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  /// Recursively finds an item by ID, including items nested in sections
  VooNavigationDestination? _findItemById(List<VooNavigationDestination> items, String itemId) {
    for (final item in items) {
      if (item.id == itemId) return item;
      if (item.children != null) {
        final found = _findItemById(item.children!, itemId);
        if (found != null) return found;
      }
    }
    return null;
  }

  void _onNavigationItemSelected(String itemId) {
    // Check if this is a special nav item (user profile, etc.)
    final isSpecialItem = itemId == VooUserProfileNavItem.navItemId;

    final item = _findItemById(widget.config.items, itemId);

    // For regular items, validate the item exists and is enabled
    if (!isSpecialItem && (item == null || !item.isEnabled)) return;

    if (widget.config.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }

    setState(() {
      _selectedId = itemId;
    });

    // Handle navigation for regular items
    if (item?.route != null && context.mounted) {
      Navigator.of(context).pushNamed(item!.route!);
    }

    // Call custom callback for regular items
    item?.onTap?.call();

    // Always call the config callback (handles both regular and special items)
    widget.config.onNavigationItemSelected?.call(itemId);

    // Animate content change if enabled
    if (widget.config.enableAnimations) {
      _animationController.forward(from: 0);
    }
  }

  /// Updates the active route on the page controller
  void _updateActiveRoute(BuildContext context) {
    final route = ModalRoute.of(context);
    _pageController.setActiveRoute(route?.settings.name);
  }

  @override
  Widget build(BuildContext context) {
    // Update the active route for proper page config resolution
    // This is critical for StatefulShellRoute/IndexedStack where multiple pages are mounted
    _updateActiveRoute(context);

    return VooPageScope(
      controller: _pageController,
      child: VooNavigationInherited(
        config: widget.config,
        selectedId: _selectedId,
        onNavigationItemSelected: _onNavigationItemSelected,
        child: VooResponsiveBuilder(
          builder: (context, screenInfo) {
            final screenWidth = screenInfo.width;
            final navigationType = widget.config.getNavigationType(screenWidth);

            // Animate navigation type changes - defer to post-frame to avoid layout during build
            if (_previousNavigationType != null && _previousNavigationType != navigationType && widget.config.enableAnimations) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _animationController.forward(from: 0);
                }
              });
            }
            _previousNavigationType = navigationType;

            // Get page-level overrides if any
            // Note: Page config is applied on next rebuild cycle after VooPage sets it
            final pageConfig = _pageController.currentConfig;

            // Effective values with priority: pageConfig > widget > config
            final effectiveShowAppBar = pageConfig?.showAppBar ?? widget.showAppBar;
            final effectiveResizeToAvoidBottomInset = pageConfig?.resizeToAvoidBottomInset ?? widget.resizeToAvoidBottomInset;
            final effectiveExtendBody = pageConfig?.extendBody ?? widget.extendBody;
            final effectiveExtendBodyBehindAppBar = pageConfig?.extendBodyBehindAppBar ?? widget.extendBodyBehindAppBar;
            final effectiveBodyPadding = pageConfig?.bodyPadding ?? widget.bodyPadding ?? widget.config.bodyPadding;
            final effectiveUseBodyCard = pageConfig?.useBodyCard ?? widget.useBodyCard;
            final effectiveBodyCardElevation = pageConfig?.bodyCardElevation ?? widget.bodyCardElevation;
            final effectiveBodyCardBorderRadius = pageConfig?.bodyCardBorderRadius ?? widget.bodyCardBorderRadius ?? widget.config.bodyCardBorderRadius;
            final effectiveBodyCardColor = pageConfig?.bodyCardColor ?? widget.bodyCardColor ?? widget.config.bodyCardColor;

            // Build appropriate scaffold based on navigation type
            return VooScaffoldBuilder(
              config: widget.config,
              navigationType: navigationType,
              screenInfo: screenInfo,
              body: widget.body,
              selectedId: _selectedId,
              onNavigationItemSelected: _onNavigationItemSelected,
              animationController: _animationController,
              fadeAnimation: _fadeAnimation,
              slideAnimation: _slideAnimation,
              appBar: pageConfig?.appBar ?? widget.appBar,
              showAppBar: effectiveShowAppBar,
              endDrawer: pageConfig?.endDrawer ?? widget.endDrawer,
              drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
              drawerEnableOpenDragGesture: widget.drawerEnableOpenDragGesture,
              endDrawerEnableOpenDragGesture: widget.endDrawerEnableOpenDragGesture,
              scaffoldKey: widget.scaffoldKey,
              backgroundColor: pageConfig?.backgroundColor ?? widget.backgroundColor,
              resizeToAvoidBottomInset: effectiveResizeToAvoidBottomInset,
              extendBody: effectiveExtendBody,
              extendBodyBehindAppBar: effectiveExtendBodyBehindAppBar,
              bottomSheet: pageConfig?.bottomSheet ?? widget.bottomSheet,
              persistentFooterButtons: pageConfig?.persistentFooterButtons ?? widget.persistentFooterButtons,
              restorationId: widget.restorationId,
              bodyPadding: effectiveBodyPadding,
              useBodyCard: effectiveUseBodyCard,
              bodyCardElevation: effectiveBodyCardElevation,
              bodyCardBorderRadius: effectiveBodyCardBorderRadius,
              bodyCardColor: effectiveBodyCardColor,
              pageConfig: pageConfig,
            );
          },
        ),
      ),
    );
  }
}
