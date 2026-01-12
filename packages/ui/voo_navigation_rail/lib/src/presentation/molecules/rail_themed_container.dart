import 'package:flutter/material.dart';
import 'package:voo_navigation_rail/src/presentation/molecules/rail_compact_header.dart';
import 'package:voo_navigation_rail/src/presentation/molecules/rail_footer_items.dart';
import 'package:voo_navigation_rail/src/presentation/molecules/rail_organization_switcher.dart';
import 'package:voo_navigation_rail/src/presentation/molecules/rail_search_bar.dart';
import 'package:voo_navigation_rail/src/presentation/molecules/rail_user_profile.dart';
import 'package:voo_navigation_rail/voo_navigation_rail.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Themed container for the navigation rail
class VooRailThemedContainer extends StatelessWidget {
  /// Navigation configuration
  final VooNavigationConfig config;

  /// Navigation theme
  final VooNavigationTheme navTheme;

  /// Background color
  final Color backgroundColor;

  /// Whether the rail is extended
  final bool extended;

  /// Currently selected item ID
  final String selectedId;

  /// Callback when an item is selected
  final void Function(String itemId) onNavigationItemSelected;

  /// Animation controllers for items
  final Map<String, AnimationController> itemAnimationControllers;

  /// Callback when collapse is toggled
  final VoidCallback? onToggleCollapse;

  const VooRailThemedContainer({
    super.key,
    required this.config,
    required this.navTheme,
    required this.backgroundColor,
    required this.extended,
    required this.selectedId,
    required this.onNavigationItemSelected,
    required this.itemAnimationControllers,
    this.onToggleCollapse,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(navTheme.borderRadius);

    // Build optional components based on position
    final searchBarInHeader = VooRailSearchBar.forPosition(context: context, config: config, extended: extended, position: VooSearchBarPosition.header);
    final searchBarBeforeItems = VooRailSearchBar.forPosition(context: context, config: config, extended: extended, position: VooSearchBarPosition.beforeItems);
    final orgSwitcherInHeader = VooRailOrganizationSwitcher.forPosition(context: context, config: config, extended: extended, position: VooOrganizationSwitcherPosition.header);
    final orgSwitcherBeforeItems = VooRailOrganizationSwitcher.forPosition(
      context: context,
      config: config,
      extended: extended,
      position: VooOrganizationSwitcherPosition.beforeItems,
    );
    final orgSwitcherInFooter = VooRailOrganizationSwitcher.forPosition(context: context, config: config, extended: extended, position: VooOrganizationSwitcherPosition.footer);

    // Wrap content with VooCollapseState so children can auto-detect collapse mode
    // Rail is collapsed when not extended
    Widget content = VooCollapseState(
      isCollapsed: !extended,
      onToggleCollapse: onToggleCollapse,
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            // Header - full when extended, compact with branding when collapsed
            if (extended)
              config.drawerHeader ??
                  (config.headerConfig != null ? VooRailDefaultHeader.fromConfig(config: config.headerConfig!, showTitle: true) : const VooRailDefaultHeader(showTitle: true))
            else
              VooRailCompactHeader(trailing: config.drawerHeaderTrailing, headerConfig: config.headerConfig),

            // Organization switcher in header position
            if (orgSwitcherInHeader != null) orgSwitcherInHeader,

            // Search bar in header position
            if (searchBarInHeader != null) searchBarInHeader,

            // Organization switcher before items
            if (orgSwitcherBeforeItems != null) orgSwitcherBeforeItems,

            // Search bar before items
            if (searchBarBeforeItems != null) searchBarBeforeItems,

            // Main navigation items - only main items scroll
            Expanded(
              child: ListView(
                controller: config.drawerScrollController,
                padding: EdgeInsets.symmetric(vertical: context.vooSpacing.sm, horizontal: context.vooSpacing.xs),
                physics: const ClampingScrollPhysics(),
                children: [
                  VooRailNavigationItems(
                    config: config,
                    selectedId: selectedId,
                    extended: extended,
                    onItemSelected: onNavigationItemSelected,
                    itemAnimationControllers: itemAnimationControllers,
                  ),
                ],
              ),
            ),

            // Leading widget for FAB or other actions
            if (config.floatingActionButton != null && config.showFloatingActionButton) Padding(padding: EdgeInsets.all(context.vooSpacing.md), child: config.floatingActionButton),

            // Footer items ALWAYS pinned at bottom (both collapsed and expanded)
            if (config.visibleFooterItems.isNotEmpty)
              VooRailFooterItems(
                config: config,
                selectedId: selectedId,
                extended: extended,
                onItemSelected: onNavigationItemSelected,
                itemAnimationControllers: itemAnimationControllers,
              ),

            // Organization switcher in footer position
            if (orgSwitcherInFooter != null) orgSwitcherInFooter,

            // User profile footer when enabled
            if (config.showUserProfile) VooRailUserProfile(config: config, extended: extended),

            // Custom footer if provided
            if (config.drawerFooter != null) config.drawerFooter!,
          ],
        ),
      ),
    );

    // Use unified clean container - simple flat design
    return Container(
      decoration: BoxDecoration(color: backgroundColor, borderRadius: borderRadius),
      child: ClipRRect(borderRadius: borderRadius, child: content),
    );
  }
}
