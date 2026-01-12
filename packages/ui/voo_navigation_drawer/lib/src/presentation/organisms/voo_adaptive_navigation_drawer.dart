import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation_core/src/domain/entities/organization.dart';
import 'package:voo_navigation_core/src/domain/entities/search_action.dart';
import 'package:voo_navigation_core/src/presentation/utils/voo_collapse_state.dart';
import 'package:voo_navigation_drawer/src/presentation/molecules/drawer_footer_items.dart';
import 'package:voo_navigation_drawer/src/presentation/molecules/drawer_header.dart';
import 'package:voo_navigation_drawer/src/presentation/molecules/drawer_navigation_items.dart';
import 'package:voo_navigation_drawer/src/presentation/molecules/drawer_organization_switcher.dart';
import 'package:voo_navigation_drawer/src/presentation/molecules/drawer_search_bar.dart';
import 'package:voo_navigation_drawer/src/presentation/molecules/drawer_user_profile.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Modern adaptive navigation drawer for desktop layouts
class VooAdaptiveNavigationDrawer extends StatefulWidget {
  /// Navigation configuration
  final VooNavigationConfig config;

  /// Currently selected item ID
  final String selectedId;

  /// Callback when an item is selected
  final void Function(String itemId) onNavigationItemSelected;

  /// Custom width for the drawer
  final double? width;

  /// Custom background color
  final Color? backgroundColor;

  /// Callback when collapse is toggled (provided by VooDesktopScaffold)
  final VoidCallback? onToggleCollapse;

  /// Custom elevation
  final double? elevation;

  /// Whether drawer is permanent (always visible)
  final bool permanent;

  const VooAdaptiveNavigationDrawer({
    super.key,
    required this.config,
    required this.selectedId,
    required this.onNavigationItemSelected,
    this.width,
    this.backgroundColor,
    this.onToggleCollapse,
    this.elevation,
    this.permanent = true,
  });

  @override
  State<VooAdaptiveNavigationDrawer> createState() => _VooAdaptiveNavigationDrawerState();
}

class _VooAdaptiveNavigationDrawerState extends State<VooAdaptiveNavigationDrawer> with TickerProviderStateMixin {
  final Map<String, AnimationController> _expansionControllers = {};
  final Map<String, Animation<double>> _expansionAnimations = {};
  final Map<String, bool> _hoveredItems = {};
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.config.drawerScrollController ?? ScrollController();
    _initializeExpansionAnimations();
  }

  void _initializeExpansionAnimations() {
    for (final item in widget.config.items) {
      if (item.hasChildren) {
        _expansionControllers[item.id] = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
        _expansionAnimations[item.id] = CurvedAnimation(parent: _expansionControllers[item.id]!, curve: Curves.easeInOutCubic);

        if (item.isExpanded) {
          _expansionControllers[item.id]!.value = 1.0;
        }
      }
    }
  }

  @override
  void dispose() {
    if (widget.config.drawerScrollController == null) {
      _scrollController.dispose();
    }
    for (final controller in _expansionControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleItemTap(VooNavigationItem item) {
    if (widget.config.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }

    // Handle expansion for items with children
    if (item.hasChildren) {
      final controller = _expansionControllers[item.id];
      if (controller != null) {
        if (controller.value == 0) {
          controller.forward();
        } else {
          controller.reverse();
        }
      }
      return;
    }

    // Handle navigation
    if (item.isEnabled) {
      widget.onNavigationItemSelected(item.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navTheme = widget.config.effectiveTheme;
    final isDark = theme.brightness == Brightness.dark;

    final effectiveWidth = widget.width ?? widget.config.navigationDrawerWidth ?? 220;

    // Use pure white/dark surface for drawer (no tinted colors)
    final effectiveBackgroundColor = widget.backgroundColor ?? widget.config.navigationBackgroundColor ?? (isDark ? const Color(0xFF1A1A1A) : Colors.white);

    // Determine drawer margin - use drawerMargin if set, otherwise use navigationRailMargin
    final effectiveDrawerMargin = widget.config.drawerMargin ?? EdgeInsets.all(widget.config.navigationRailMargin);

    // If drawer has no margin (full-height), only round the right side
    // Check all sides explicitly to handle different EdgeInsets instances
    final isFullHeight = effectiveDrawerMargin.left == 0 && effectiveDrawerMargin.top == 0 && effectiveDrawerMargin.right == 0 && effectiveDrawerMargin.bottom == 0;
    final borderRadius = isFullHeight
        ? BorderRadius.only(topRight: Radius.circular(navTheme.containerBorderRadius), bottomRight: Radius.circular(navTheme.containerBorderRadius))
        : BorderRadius.circular(navTheme.containerBorderRadius);

    // Build optional components based on position
    final searchBarInHeader = VooDrawerSearchBar.forPosition(context: context, config: widget.config, position: VooSearchBarPosition.header);
    final searchBarBeforeItems = VooDrawerSearchBar.forPosition(context: context, config: widget.config, position: VooSearchBarPosition.beforeItems);
    final orgSwitcherBeforeItems = VooDrawerOrganizationSwitcher.forPosition(config: widget.config, position: VooOrganizationSwitcherPosition.beforeItems);
    final orgSwitcherInFooter = VooDrawerOrganizationSwitcher.forPosition(config: widget.config, position: VooOrganizationSwitcherPosition.footer);

    // Wrap content with VooCollapseState so children can auto-detect collapse mode
    // Drawer is always expanded (not collapsed)
    Widget content = VooCollapseState(
      isCollapsed: false,
      onToggleCollapse: widget.onToggleCollapse,
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom header or default modern header with optional trailing widget
            VooDrawerHeader(config: widget.config),

            // Search bar in header position
            if (searchBarInHeader != null) searchBarInHeader,

            // Organization switcher before items
            if (orgSwitcherBeforeItems != null) orgSwitcherBeforeItems,

            // Search bar before items
            if (searchBarBeforeItems != null) searchBarBeforeItems,

            // Navigation items
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: context.vooSpacing.sm, vertical: context.vooSpacing.xs),
                children: [
                  VooDrawerNavigationItems(
                    config: widget.config,
                    selectedId: widget.selectedId,
                    onItemTap: _handleItemTap,
                    hoveredItems: _hoveredItems,
                    expansionControllers: _expansionControllers,
                    expansionAnimations: _expansionAnimations,
                    onHoverChanged: (itemId, isHovered) {
                      setState(() => _hoveredItems[itemId] = isHovered);
                    },
                  ),
                ],
              ),
            ),

            // Footer items (Settings, Integrations, Help, etc.)
            if (widget.config.visibleFooterItems.isNotEmpty)
              VooDrawerFooterItems(
                config: widget.config,
                selectedId: widget.selectedId,
                onItemTap: _handleItemTap,
                hoveredItems: _hoveredItems,
                onHoverChanged: (itemId, isHovered) {
                  setState(() => _hoveredItems[itemId] = isHovered);
                },
              ),

            // Organization switcher in footer position
            if (orgSwitcherInFooter != null) orgSwitcherInFooter,

            // User profile footer when enabled
            if (widget.config.showUserProfile) VooDrawerUserProfile(config: widget.config),

            // Custom footer
            if (widget.config.drawerFooter != null) Padding(padding: EdgeInsets.all(context.vooSpacing.sm + context.vooSpacing.xs), child: widget.config.drawerFooter!),
          ],
        ),
      ),
    );

    // Use unified clean container - simple flat design
    final themedContainer = Container(
      decoration: BoxDecoration(color: effectiveBackgroundColor, borderRadius: borderRadius),
      child: ClipRRect(borderRadius: borderRadius, child: content),
    );

    // Build the container
    return AnimatedContainer(duration: navTheme.animationDuration, curve: navTheme.animationCurve, width: effectiveWidth, margin: effectiveDrawerMargin, child: themedContainer);
  }
}
