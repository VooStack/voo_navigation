import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation_core/src/domain/entities/organization.dart';
import 'package:voo_navigation_core/src/domain/entities/search_action.dart';
import 'package:voo_navigation_core/src/presentation/molecules/voo_organization_switcher.dart';
import 'package:voo_navigation_core/src/presentation/molecules/voo_search_bar.dart';
import 'package:voo_navigation_core/src/presentation/utils/voo_collapse_state.dart';
import 'package:voo_navigation_drawer/src/presentation/molecules/drawer_default_header.dart';
import 'package:voo_navigation_drawer/src/presentation/molecules/drawer_navigation_items.dart';
import 'package:voo_navigation_core/src/presentation/molecules/voo_user_profile_footer.dart';
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
  State<VooAdaptiveNavigationDrawer> createState() =>
      _VooAdaptiveNavigationDrawerState();
}

class _VooAdaptiveNavigationDrawerState
    extends State<VooAdaptiveNavigationDrawer>
    with TickerProviderStateMixin {
  final Map<String, AnimationController> _expansionControllers = {};
  final Map<String, Animation<double>> _expansionAnimations = {};
  final Map<String, bool> _hoveredItems = {};
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController =
        widget.config.drawerScrollController ?? ScrollController();
    _initializeExpansionAnimations();
  }

  void _initializeExpansionAnimations() {
    for (final item in widget.config.items) {
      if (item.hasChildren) {
        _expansionControllers[item.id] = AnimationController(
          duration: const Duration(milliseconds: 300),
          vsync: this,
        );
        _expansionAnimations[item.id] = CurvedAnimation(
          parent: _expansionControllers[item.id]!,
          curve: Curves.easeInOutCubic,
        );

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

  Widget _buildHeader(BuildContext context) {
    final customHeader = widget.config.drawerHeader;
    final trailing = widget.config.drawerHeaderTrailing;
    final orgSwitcher = widget.config.organizationSwitcher;
    final showOrgSwitcherInHeader = orgSwitcher != null &&
        widget.config.organizationSwitcherPosition == VooOrganizationSwitcherPosition.header;

    // Build organization switcher if configured for header
    Widget? orgSwitcherWidget;
    if (showOrgSwitcherInHeader) {
      orgSwitcherWidget = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: VooOrganizationSwitcher(
          organizations: orgSwitcher.organizations,
          selectedOrganization: orgSwitcher.selectedOrganization,
          onOrganizationChanged: orgSwitcher.onOrganizationChanged,
          onCreateOrganization: orgSwitcher.onCreateOrganization,
          showSearch: orgSwitcher.showSearch,
          showCreateButton: orgSwitcher.showCreateButton,
          createButtonLabel: orgSwitcher.createButtonLabel,
          searchHint: orgSwitcher.searchHint,
          style: orgSwitcher.style,
          compact: orgSwitcher.compact,
          tooltip: orgSwitcher.tooltip,
        ),
      );
    }

    // If using custom header, place toggle at top-right aligned with title
    if (customHeader != null) {
      Widget header = customHeader;

      if (trailing != null) {
        // Wrap custom header with trailing toggle at top-right
        // Use Stack so toggle aligns with first row (title) of custom header
        header = Stack(
          children: [
            customHeader,
            Positioned(
              top: 24, // Vertically center with logo (logo center at 38px, toggle 28px)
              right: 12,
              child: trailing,
            ),
          ],
        );
      }

      // Add org switcher below custom header if in header position
      if (orgSwitcherWidget != null) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            header,
            orgSwitcherWidget,
          ],
        );
      }

      return header;
    }

    // Default header handling
    final headerContent = const VooDrawerDefaultHeader();

    Widget result;
    if (trailing == null) {
      result = headerContent;
    } else {
      // Wrap default header with trailing widget
      result = Padding(
        padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: headerContent),
            const SizedBox(width: 4),
            trailing,
          ],
        ),
      );
    }

    // Add org switcher below header if in header position
    if (orgSwitcherWidget != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          result,
          orgSwitcherWidget,
        ],
      );
    }

    return result;
  }

  Widget? _buildSearchBar(BuildContext context, VooSearchBarPosition position) {
    final searchConfig = widget.config.searchBar;
    if (searchConfig == null || widget.config.searchBarPosition != position) {
      return null;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: VooSearchBar(
        navigationItems: searchConfig.navigationItems ?? widget.config.items,
        onFilteredItemsChanged: searchConfig.onFilteredItemsChanged,
        onSearch: searchConfig.onSearch,
        onSearchSubmit: searchConfig.onSearchSubmit,
        searchActions: searchConfig.searchActions,
        hintText: searchConfig.hintText ?? 'Search...',
        showFilteredResults: searchConfig.showFilteredResults,
        enableKeyboardShortcut: searchConfig.enableKeyboardShortcut,
        keyboardShortcutHint: searchConfig.keyboardShortcutHint,
        style: searchConfig.style,
        expanded: true,
        onNavigationItemSelected: searchConfig.onNavigationItemSelected,
        onSearchActionSelected: searchConfig.onSearchActionSelected,
      ),
    );
  }

  Widget? _buildOrganizationSwitcherForPosition(VooOrganizationSwitcherPosition position) {
    final orgSwitcher = widget.config.organizationSwitcher;
    if (orgSwitcher == null || widget.config.organizationSwitcherPosition != position) {
      return null;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: VooOrganizationSwitcher(
        organizations: orgSwitcher.organizations,
        selectedOrganization: orgSwitcher.selectedOrganization,
        onOrganizationChanged: orgSwitcher.onOrganizationChanged,
        onCreateOrganization: orgSwitcher.onCreateOrganization,
        showSearch: orgSwitcher.showSearch,
        showCreateButton: orgSwitcher.showCreateButton,
        createButtonLabel: orgSwitcher.createButtonLabel,
        searchHint: orgSwitcher.searchHint,
        style: orgSwitcher.style,
        compact: orgSwitcher.compact,
        tooltip: orgSwitcher.tooltip,
      ),
    );
  }

  /// Builds the user profile widget, preferring userProfileConfig if available
  Widget _buildUserProfile() {
    // If userProfileWidget is explicitly provided, use it (legacy API)
    if (widget.config.userProfileWidget != null) {
      return widget.config.userProfileWidget!;
    }

    // If userProfileConfig is provided, create the widget with auto-compact
    final profileConfig = widget.config.userProfileConfig;
    if (profileConfig != null) {
      return VooUserProfileFooter(
        userName: profileConfig.userName,
        userEmail: profileConfig.userEmail,
        avatarUrl: profileConfig.avatarUrl,
        avatarWidget: profileConfig.avatarWidget,
        initials: profileConfig.initials,
        status: profileConfig.status,
        onTap: profileConfig.onTap,
        onSettingsTap: profileConfig.onSettingsTap,
        onLogout: profileConfig.onLogout,
        menuItems: profileConfig.menuItems,
        showDropdownIndicator: profileConfig.showDropdownIndicator,
        // compact is intentionally not set - will auto-detect from VooCollapseState
      );
    }

    // Default fallback
    return const VooUserProfileFooter();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navTheme = widget.config.effectiveTheme;
    final isDark = theme.brightness == Brightness.dark;

    final effectiveWidth =
        widget.width ?? widget.config.navigationDrawerWidth ?? 220;

    // Use theme-based surface color
    final effectiveBackgroundColor =
        widget.backgroundColor ??
        widget.config.navigationBackgroundColor ??
        navTheme.resolveSurfaceColor(context);

    // Determine drawer margin - use drawerMargin if set, otherwise use navigationRailMargin
    final effectiveDrawerMargin = widget.config.drawerMargin ??
        EdgeInsets.all(widget.config.navigationRailMargin);

    // If drawer has no margin (full-height), only round the right side
    // Check all sides explicitly to handle different EdgeInsets instances
    final isFullHeight = effectiveDrawerMargin.left == 0 &&
        effectiveDrawerMargin.top == 0 &&
        effectiveDrawerMargin.right == 0 &&
        effectiveDrawerMargin.bottom == 0;
    final borderRadius = isFullHeight
        ? BorderRadius.only(
            topRight: Radius.circular(navTheme.containerBorderRadius),
            bottomRight: Radius.circular(navTheme.containerBorderRadius),
          )
        : BorderRadius.circular(navTheme.containerBorderRadius);

    // Build optional components based on position
    final searchBarInHeader = _buildSearchBar(context, VooSearchBarPosition.header);
    final searchBarBeforeItems = _buildSearchBar(context, VooSearchBarPosition.beforeItems);
    final orgSwitcherBeforeItems = _buildOrganizationSwitcherForPosition(
        VooOrganizationSwitcherPosition.beforeItems);
    final orgSwitcherInFooter = _buildOrganizationSwitcherForPosition(
        VooOrganizationSwitcherPosition.footer);

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
          _buildHeader(context),

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
              padding: EdgeInsets.symmetric(
                horizontal: context.vooSpacing.sm,
                vertical: context.vooSpacing.xs,
              ),
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
            _DrawerFooterItems(
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
          if (widget.config.showUserProfile)
            _buildUserProfile(),

          // Custom footer
          if (widget.config.drawerFooter != null)
            Padding(
              padding: EdgeInsets.all(
                context.vooSpacing.sm + context.vooSpacing.xs,
              ),
              child: widget.config.drawerFooter!,
            ),
        ],
        ),
      ),
    );

    // Use unified clean container - simple flat design
    final themedContainer = Container(
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: borderRadius,
        // Subtle border for visual separation
        border: navTheme.borderWidth > 0
            ? Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.06),
                width: navTheme.borderWidth,
              )
            : null,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: content,
      ),
    );

    // Build the container
    return AnimatedContainer(
      duration: navTheme.animationDuration,
      curve: navTheme.animationCurve,
      width: effectiveWidth,
      margin: effectiveDrawerMargin,
      child: themedContainer,
    );
  }
}

// NOTE: Legacy themed container code (glassmorphism, liquidGlass, blurry,
// neomorphism, material3Enhanced, minimalModern) has been removed in favor
// of unified clean design. All navigation now uses a simple flat container.

/// Footer items widget for static routes like Settings, Integrations, Help
class _DrawerFooterItems extends StatelessWidget {
  final VooNavigationConfig config;
  final String selectedId;
  final void Function(VooNavigationItem item) onItemTap;
  final Map<String, bool> hoveredItems;
  final void Function(String itemId, bool isHovered) onHoverChanged;

  const _DrawerFooterItems({
    required this.config,
    required this.selectedId,
    required this.onItemTap,
    required this.hoveredItems,
    required this.onHoverChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final footerItems = config.visibleFooterItems;

    if (footerItems.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Divider above footer items
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(
              height: 1,
              thickness: 1,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          // Footer navigation items
          ...footerItems.map((item) => _DrawerFooterItem(
            item: item,
            config: config,
            selectedId: selectedId,
            onItemTap: onItemTap,
            isHovered: hoveredItems[item.id] ?? false,
            onHoverChanged: (isHovered) => onHoverChanged(item.id, isHovered),
          )),
        ],
      ),
    );
  }
}

/// Single footer item widget
class _DrawerFooterItem extends StatelessWidget {
  final VooNavigationItem item;
  final VooNavigationConfig config;
  final String selectedId;
  final void Function(VooNavigationItem item) onItemTap;
  final bool isHovered;
  final void Function(bool isHovered) onHoverChanged;

  const _DrawerFooterItem({
    required this.item,
    required this.config,
    required this.selectedId,
    required this.onItemTap,
    required this.isHovered,
    required this.onHoverChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = item.id == selectedId;

    final unselectedColor = config.unselectedItemColor ?? theme.colorScheme.onSurface;
    final selectedColor = config.selectedItemColor ?? theme.colorScheme.primary;

    final iconColor = isSelected
        ? (item.selectedIconColor ?? selectedColor)
        : (item.iconColor ?? unselectedColor.withValues(alpha: 0.7));

    final labelStyle = theme.textTheme.bodyMedium?.copyWith(
      color: unselectedColor,
      fontWeight: FontWeight.w500,
      fontSize: 13,
    );

    return Semantics(
      label: item.effectiveSemanticLabel,
      button: true,
      enabled: item.isEnabled,
      selected: isSelected,
      child: MouseRegion(
        onEnter: (_) => onHoverChanged(true),
        onExit: (_) => onHoverChanged(false),
        child: InkWell(
          key: item.key,
          onTap: item.isEnabled ? () => onItemTap(item) : null,
          borderRadius: BorderRadius.circular(6),
          child: AnimatedContainer(
            duration: context.vooAnimation.durationFast,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? selectedColor.withValues(alpha: 0.1)
                  : isHovered
                      ? unselectedColor.withValues(alpha: 0.04)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? item.effectiveSelectedIcon : item.icon,
                  color: iconColor,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.label,
                    style: labelStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
