import 'package:flutter/material.dart';
import 'package:voo_navigation_rail/voo_navigation_rail.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Adaptive navigation rail for tablet and desktop layouts with Material 3 design
/// Features smooth animations, hover effects, and beautiful visual transitions
class VooAdaptiveNavigationRail extends StatefulWidget {
  /// Navigation configuration
  final VooNavigationConfig config;

  /// Currently selected item ID
  final String selectedId;

  /// Callback when an item is selected
  final void Function(String itemId) onNavigationItemSelected;

  /// Whether to show extended rail with labels
  final bool extended;

  /// Custom width for the rail
  final double? width;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom elevation
  final double? elevation;

  /// Callback when collapse is toggled (provided by VooDesktopScaffold)
  final VoidCallback? onToggleCollapse;

  const VooAdaptiveNavigationRail({
    super.key,
    required this.config,
    required this.selectedId,
    required this.onNavigationItemSelected,
    this.extended = false,
    this.width,
    this.backgroundColor,
    this.elevation,
    this.onToggleCollapse,
  });

  @override
  State<VooAdaptiveNavigationRail> createState() =>
      _VooAdaptiveNavigationRailState();
}

class _VooAdaptiveNavigationRailState extends State<VooAdaptiveNavigationRail>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _hoverController;
  final Map<String, AnimationController> _itemAnimationControllers = {};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.config.animationDuration,
      vsync: this,
    );

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 113),
      vsync: this,
    );

    if (widget.extended) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(VooAdaptiveNavigationRail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.extended != oldWidget.extended) {
      if (widget.extended) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _hoverController.dispose();
    for (final controller in _itemAnimationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navTheme = widget.config.effectiveTheme;

    final effectiveWidth =
        widget.width ??
        (widget.extended
            ? (widget.config.extendedNavigationRailWidth ?? 256)
            : (widget.config.navigationRailWidth ?? 80));

    // Use theme-based surface color
    final effectiveBackgroundColor =
        widget.backgroundColor ??
        widget.config.navigationBackgroundColor ??
        navTheme.resolveSurfaceColor(context);

    return AnimatedContainer(
      duration: navTheme.animationDuration,
      curve: navTheme.animationCurve,
      width: effectiveWidth,
      margin: EdgeInsets.all(widget.config.navigationRailMargin),
      child: _ThemedRailContainer(
        config: widget.config,
        navTheme: navTheme,
        backgroundColor: effectiveBackgroundColor,
        extended: widget.extended,
        selectedId: widget.selectedId,
        onNavigationItemSelected: widget.onNavigationItemSelected,
        itemAnimationControllers: _itemAnimationControllers,
        onToggleCollapse: widget.onToggleCollapse,
      ),
    );
  }
}

class _ThemedRailContainer extends StatelessWidget {
  final VooNavigationConfig config;
  final VooNavigationTheme navTheme;
  final Color backgroundColor;
  final bool extended;
  final String selectedId;
  final void Function(String itemId) onNavigationItemSelected;
  final Map<String, AnimationController> itemAnimationControllers;
  final VoidCallback? onToggleCollapse;

  const _ThemedRailContainer({
    required this.config,
    required this.navTheme,
    required this.backgroundColor,
    required this.extended,
    required this.selectedId,
    required this.onNavigationItemSelected,
    required this.itemAnimationControllers,
    this.onToggleCollapse,
  });

  Widget? _buildSearchBar(BuildContext context, VooSearchBarPosition position) {
    final searchConfig = config.searchBar;
    if (searchConfig == null || config.searchBarPosition != position) {
      return null;
    }

    // In compact mode, show search icon button that expands
    if (!extended) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: IconButton(
          icon: const Icon(Icons.search, size: 20),
          tooltip: searchConfig.hintText ?? 'Search...',
          onPressed: () {
            // Show search overlay/dialog when in compact mode
            _showSearchOverlay(context, searchConfig);
          },
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: VooSearchBar(
        navigationItems: searchConfig.navigationItems ?? config.items,
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

  void _showSearchOverlay(BuildContext context, VooSearchBarConfig searchConfig) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 400),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: VooSearchBar(
              navigationItems: searchConfig.navigationItems ?? config.items,
              onFilteredItemsChanged: searchConfig.onFilteredItemsChanged,
              onSearch: searchConfig.onSearch,
              onSearchSubmit: searchConfig.onSearchSubmit,
              searchActions: searchConfig.searchActions,
              hintText: searchConfig.hintText ?? 'Search...',
              showFilteredResults: searchConfig.showFilteredResults,
              enableKeyboardShortcut: false,
              style: searchConfig.style,
              expanded: true,
              onNavigationItemSelected: (item) {
                Navigator.of(context).pop();
                searchConfig.onNavigationItemSelected?.call(item);
              },
              onSearchActionSelected: (action) {
                Navigator.of(context).pop();
                searchConfig.onSearchActionSelected?.call(action);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildOrganizationSwitcherForPosition(
      BuildContext context, VooOrganizationSwitcherPosition position) {
    final orgSwitcher = config.organizationSwitcher;
    if (orgSwitcher == null ||
        config.organizationSwitcherPosition != position) {
      return null;
    }

    // Rail must always use compact mode when collapsed to prevent overflow
    final isCompact = !extended;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 12,
        vertical: 8,
      ),
      child: Center(
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
          // Force compact mode when rail is collapsed to prevent overflow
          compact: isCompact ? true : orgSwitcher.compact,
          tooltip: orgSwitcher.tooltip,
        ),
      ),
    );
  }

  /// Builds the user profile widget, preferring userProfileConfig if available
  Widget _buildUserProfile() {
    // Rail must always use compact mode when collapsed to prevent overflow
    final isCompact = !extended;

    // If userProfileWidget is explicitly provided, use it (legacy API)
    // WARNING: Legacy widgets don't respect collapse state - wrap in Center for alignment
    if (config.userProfileWidget != null) {
      return Center(child: config.userProfileWidget!);
    }

    // If userProfileConfig is provided, create the widget with forced compact when collapsed
    final profileConfig = config.userProfileConfig;
    if (profileConfig != null) {
      return Center(
        child: VooUserProfileFooter(
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
          // Force compact mode when rail is collapsed to prevent overflow
          compact: isCompact ? true : null,
        ),
      );
    }

    // Default fallback - force compact when rail is collapsed
    return Center(
      child: VooUserProfileFooter(
        compact: isCompact ? true : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderRadius = BorderRadius.circular(navTheme.containerBorderRadius);

    // Build optional components based on position
    final searchBarInHeader =
        _buildSearchBar(context, VooSearchBarPosition.header);
    final searchBarBeforeItems =
        _buildSearchBar(context, VooSearchBarPosition.beforeItems);
    final orgSwitcherInHeader = _buildOrganizationSwitcherForPosition(
        context, VooOrganizationSwitcherPosition.header);
    final orgSwitcherBeforeItems = _buildOrganizationSwitcherForPosition(
        context, VooOrganizationSwitcherPosition.beforeItems);
    final orgSwitcherInFooter = _buildOrganizationSwitcherForPosition(
        context, VooOrganizationSwitcherPosition.footer);

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
                  (config.headerConfig != null
                      ? VooRailDefaultHeader.fromConfig(
                          config: config.headerConfig!,
                          showTitle: true,
                        )
                      : const VooRailDefaultHeader(showTitle: true))
            else
              _CompactRailHeader(
                trailing: config.drawerHeaderTrailing,
                headerConfig: config.headerConfig,
              ),

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
                padding: EdgeInsets.symmetric(
                  vertical: context.vooSpacing.sm,
                  horizontal: context.vooSpacing.xs,
                ),
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
            if (config.floatingActionButton != null &&
                config.showFloatingActionButton)
              Padding(
                padding: EdgeInsets.all(context.vooSpacing.md),
                child: config.floatingActionButton,
              ),

            // Footer items ALWAYS pinned at bottom (both collapsed and expanded)
            if (config.visibleFooterItems.isNotEmpty)
              _FooterItems(
                config: config,
                selectedId: selectedId,
                extended: extended,
                onItemSelected: onNavigationItemSelected,
                itemAnimationControllers: itemAnimationControllers,
              ),

            // Organization switcher in footer position
            if (orgSwitcherInFooter != null) orgSwitcherInFooter,

            // User profile footer when enabled
            if (config.showUserProfile)
              _buildUserProfile(),

            // Custom footer if provided
            if (config.drawerFooter != null) config.drawerFooter!,
          ],
        ),
      ),
    );

    // Use unified clean container - simple flat design
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
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
  }
}

// NOTE: Legacy themed container code (glassmorphism, liquidGlass, neomorphism,
// material3Enhanced, minimalModern variants) has been removed in favor of
// unified clean design. All navigation now uses a simple flat container.

/// Footer items widget for static routes like Settings, Integrations, Help
class _FooterItems extends StatelessWidget {
  final VooNavigationConfig config;
  final String selectedId;
  final bool extended;
  final void Function(String itemId) onItemSelected;
  final Map<String, AnimationController> itemAnimationControllers;

  const _FooterItems({
    required this.config,
    required this.selectedId,
    required this.extended,
    required this.onItemSelected,
    required this.itemAnimationControllers,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final footerItems = config.visibleFooterItems;

    if (footerItems.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.vooSpacing.xs,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Divider above footer items
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: context.vooSpacing.sm,
              horizontal: context.vooSpacing.xs,
            ),
            child: Divider(
              height: 1,
              thickness: 1,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          // Footer navigation items
          ...footerItems.map((item) => VooRailNavigationItem(
            item: item,
            isSelected: item.id == selectedId,
            extended: extended,
            onTap: () => onItemSelected(item.id),
            animationController: itemAnimationControllers[item.id],
            selectedItemColor: config.selectedItemColor,
            unselectedItemColor: config.unselectedItemColor,
          )),
        ],
      ),
    );
  }
}

/// Compact header for collapsed rail showing branding and expand toggle
class _CompactRailHeader extends StatelessWidget {
  /// Trailing widget (expand toggle)
  final Widget? trailing;

  /// Header configuration for customizing the logo
  final VooHeaderConfig? headerConfig;

  const _CompactRailHeader({
    this.trailing,
    this.headerConfig,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.vooSpacing;
    final radius = context.vooRadius;
    final size = context.vooSize;

    // Use headerConfig values if provided
    final effectiveIcon = headerConfig?.logoIcon ?? Icons.dashboard;
    final effectiveLogo = headerConfig?.logo;
    final effectiveLogoBackground = headerConfig?.logoBackgroundColor ??
        theme.colorScheme.onSurface.withValues(alpha: 0.12);

    // Build the logo widget
    Widget logoWidget;
    if (effectiveLogo != null) {
      logoWidget = SizedBox(
        width: size.avatarMedium,
        height: size.avatarMedium,
        child: effectiveLogo,
      );
    } else {
      logoWidget = Container(
        width: size.avatarMedium,
        height: size.avatarMedium,
        decoration: BoxDecoration(
          color: effectiveLogoBackground,
          borderRadius: BorderRadius.circular(radius.md),
        ),
        child: Icon(
          effectiveIcon,
          color: theme.colorScheme.onSurface,
          size: size.iconMedium,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(0, spacing.xl, 0, spacing.sm),
      child: Column(
        children: [
          // Compact branding - just the logo
          GestureDetector(
            onTap: headerConfig?.onTap,
            child: logoWidget,
          ),
          SizedBox(height: spacing.md),
          // Expand toggle
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
