import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_bar/voo_navigation_bar.dart';
import 'package:voo_navigation/src/presentation/organisms/voo_scaffold_builder.dart';
import 'package:voo_responsive/voo_responsive.dart';

/// Adaptive scaffold that automatically adjusts navigation based on screen size
class VooAdaptiveScaffold extends StatefulWidget {
  /// Configuration for the navigation system
  final VooNavigationConfig config;

  /// Main content body (can be a StatefulNavigationShell from go_router)
  final Widget body;

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
  })  : resizeToAvoidBottomInset = resizeToAvoidBottomInset ?? true,
        extendBody = extendBody ?? false,
        extendBodyBehindAppBar = extendBodyBehindAppBar ?? false,
        useBodyCard = useBodyCard ?? false,
        bodyCardElevation = bodyCardElevation ?? 0;

  @override
  State<VooAdaptiveScaffold> createState() => _VooAdaptiveScaffoldState();
}

class _VooAdaptiveScaffoldState extends State<VooAdaptiveScaffold> {
  late String _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.config.selectedId ??
        widget.config.items.firstWhere((item) => item.isEnabled).id;
  }

  @override
  void didUpdateWidget(VooAdaptiveScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.config.selectedId != null &&
        widget.config.selectedId != oldWidget.config.selectedId) {
      _selectedId = widget.config.selectedId!;
    }
  }

  VooNavigationDestination? _findItemById(
      List<VooNavigationDestination> items, String itemId) {
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
    final userProfileEffectiveId = widget.config.userProfileConfig?.effectiveId;
    final isSpecialItem = itemId == userProfileEffectiveId;
    final item = _findItemById(widget.config.items, itemId);

    if (!isSpecialItem && (item == null || !item.isEnabled)) return;

    if (widget.config.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }

    setState(() {
      _selectedId = itemId;
    });

    if (item?.route != null && context.mounted) {
      Navigator.of(context).pushNamed(item!.route!);
    }

    item?.onTap?.call();
    widget.config.onNavigationItemSelected?.call(itemId);
  }

  @override
  Widget build(BuildContext context) {
    return VooNavigationInherited(
      config: widget.config,
      selectedId: _selectedId,
      onNavigationItemSelected: _onNavigationItemSelected,
      child: VooResponsiveBuilder(
        builder: (context, screenInfo) {
          final navigationType = widget.config.getNavigationType(screenInfo.width);

          return VooScaffoldBuilder(
            config: widget.config,
            navigationType: navigationType,
            screenInfo: screenInfo,
            body: widget.body,
            selectedId: _selectedId,
            onNavigationItemSelected: _onNavigationItemSelected,
            appBar: null,
            showAppBar: false,
            endDrawer: widget.endDrawer,
            drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
            drawerEnableOpenDragGesture: widget.drawerEnableOpenDragGesture,
            endDrawerEnableOpenDragGesture: widget.endDrawerEnableOpenDragGesture,
            scaffoldKey: widget.scaffoldKey,
            backgroundColor: widget.backgroundColor,
            resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
            extendBody: widget.extendBody,
            extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
            bottomSheet: widget.bottomSheet,
            persistentFooterButtons: widget.persistentFooterButtons,
            restorationId: widget.restorationId,
            bodyPadding: widget.bodyPadding ?? widget.config.bodyPadding,
            useBodyCard: widget.useBodyCard,
            bodyCardElevation: widget.bodyCardElevation,
            bodyCardBorderRadius: widget.bodyCardBorderRadius ?? widget.config.bodyCardBorderRadius,
            bodyCardColor: widget.bodyCardColor ?? widget.config.bodyCardColor,
            pageConfig: null,
          );
        },
      ),
    );
  }
}
