import 'dart:ui';

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

  const VooAdaptiveNavigationRail({
    super.key,
    required this.config,
    required this.selectedId,
    required this.onNavigationItemSelected,
    this.extended = false,
    this.width,
    this.backgroundColor,
    this.elevation,
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

  const _ThemedRailContainer({
    required this.config,
    required this.navTheme,
    required this.backgroundColor,
    required this.extended,
    required this.selectedId,
    required this.onNavigationItemSelected,
    required this.itemAnimationControllers,
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

    // In compact mode, use compact version of switcher
    final isCompact = !extended || orgSwitcher.compact;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 12,
        vertical: 8,
      ),
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
        compact: isCompact,
        tooltip: orgSwitcher.tooltip,
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

    Widget content = Material(
      color: Colors.transparent,
      child: Column(
        children: [
          // Header - full when extended, compact with branding when collapsed
          if (extended)
            config.drawerHeader ??
                const VooRailDefaultHeader(showTitle: true)
          else
            _CompactRailHeader(
              trailing: config.drawerHeaderTrailing,
            ),

          // Organization switcher in header position
          if (orgSwitcherInHeader != null) orgSwitcherInHeader,

          // Search bar in header position
          if (searchBarInHeader != null) searchBarInHeader,

          // Organization switcher before items
          if (orgSwitcherBeforeItems != null) orgSwitcherBeforeItems,

          // Search bar before items
          if (searchBarBeforeItems != null) searchBarBeforeItems,

          // Navigation items
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

          // Footer items (Settings, Integrations, Help, etc.)
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
            config.userProfileWidget ??
                VooUserProfileFooter(compact: !extended),

          // Custom footer if provided
          if (config.drawerFooter != null) config.drawerFooter!,
        ],
      ),
    );

    // Apply theme-specific styling based on preset
    switch (navTheme.preset) {
      case VooNavigationPreset.glassmorphism:
        // Enhanced Glassmorphism: premium frosted glass effect
        final primaryColor = theme.colorScheme.primary;
        // Use provided backgroundColor or fall back to theme surface
        final surfaceColor = backgroundColor.withValues(alpha: 1.0);

        return Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            boxShadow: [
              // Outer glow with primary color
              BoxShadow(
                color: primaryColor.withValues(alpha: isDark ? 0.25 : 0.15),
                blurRadius: 32,
                spreadRadius: 0,
              ),
              // Soft ambient shadow
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: navTheme.blurSigma,
                sigmaY: navTheme.blurSigma,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  // Multi-stop gradient for depth
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.0, 0.3, 1.0],
                    colors: isDark
                        ? [
                            surfaceColor.withValues(alpha: 0.85),
                            surfaceColor.withValues(alpha: 0.75),
                            surfaceColor.withValues(alpha: 0.65),
                          ]
                        : [
                            surfaceColor.withValues(alpha: 0.9),
                            surfaceColor.withValues(alpha: 0.8),
                            surfaceColor.withValues(alpha: 0.7),
                          ],
                  ),
                  // Gradient border effect
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.12)
                        : Colors.white.withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                ),
                child: Stack(
                  children: [
                    // Top highlight shine
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 60,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(navTheme.containerBorderRadius),
                            topRight: Radius.circular(navTheme.containerBorderRadius),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withValues(alpha: isDark ? 0.08 : 0.3),
                              Colors.white.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Content
                    content,
                  ],
                ),
              ),
            ),
          ),
        );

      case VooNavigationPreset.liquidGlass:
        // Liquid Glass: deep blur with layered effects and refraction
        final primaryColor = theme.colorScheme.primary;
        // Use provided backgroundColor or fall back to theme surface
        final surfaceColor = backgroundColor.withValues(alpha: 1.0);

        // Apply tint if specified
        final tintedSurface = navTheme.tintIntensity > 0
            ? Color.lerp(surfaceColor, primaryColor, navTheme.tintIntensity * 0.3)!
            : surfaceColor;

        return Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            boxShadow: [
              // Primary ambient glow
              BoxShadow(
                color: primaryColor.withValues(alpha: isDark ? 0.2 : 0.12),
                blurRadius: 40,
                spreadRadius: 0,
              ),
              // Deep shadow for depth
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.18),
                blurRadius: 32,
                offset: const Offset(4, 8),
              ),
              // Soft close shadow
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.08),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: Stack(
              children: [
                // Layer 1: Primary deep blur
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: navTheme.blurSigma,
                      sigmaY: navTheme.blurSigma,
                    ),
                    child: const SizedBox.expand(),
                  ),
                ),

                // Layer 2: Secondary blur for extra depth
                if (navTheme.secondaryBlurSigma > 0)
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: navTheme.secondaryBlurSigma,
                        sigmaY: navTheme.secondaryBlurSigma,
                      ),
                      child: const SizedBox.expand(),
                    ),
                  ),

                // Layer 3: Glass surface with gradient
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: const [0.0, 0.25, 0.75, 1.0],
                        colors: isDark
                            ? [
                                tintedSurface.withValues(alpha: navTheme.surfaceOpacity + 0.1),
                                tintedSurface.withValues(alpha: navTheme.surfaceOpacity),
                                tintedSurface.withValues(alpha: navTheme.surfaceOpacity - 0.05),
                                tintedSurface.withValues(alpha: navTheme.surfaceOpacity - 0.1),
                              ]
                            : [
                                tintedSurface.withValues(alpha: navTheme.surfaceOpacity + 0.18),
                                tintedSurface.withValues(alpha: navTheme.surfaceOpacity + 0.05),
                                tintedSurface.withValues(alpha: navTheme.surfaceOpacity - 0.02),
                                tintedSurface.withValues(alpha: navTheme.surfaceOpacity - 0.12),
                              ],
                      ),
                    ),
                  ),
                ),

                // Layer 4: Inner glow effect
                if (navTheme.innerGlowIntensity > 0)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: borderRadius,
                        gradient: RadialGradient(
                          center: const Alignment(0, -0.5),
                          radius: 1.8,
                          colors: [
                            primaryColor.withValues(alpha: navTheme.innerGlowIntensity * 0.08),
                            primaryColor.withValues(alpha: navTheme.innerGlowIntensity * 0.02),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.35, 1.0],
                        ),
                      ),
                    ),
                  ),

                // Layer 5: Top edge highlight (refraction)
                if (navTheme.edgeHighlightIntensity > 0)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 80,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(navTheme.containerBorderRadius),
                          topRight: Radius.circular(navTheme.containerBorderRadius),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withValues(
                              alpha: isDark
                                  ? navTheme.edgeHighlightIntensity * 0.12
                                  : navTheme.edgeHighlightIntensity * 0.35,
                            ),
                            Colors.white.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),

                // Layer 6: Left edge highlight
                if (navTheme.edgeHighlightIntensity > 0)
                  Positioned(
                    top: 16,
                    left: 0,
                    bottom: 16,
                    width: 1.5,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withValues(alpha: 0.0),
                            Colors.white.withValues(
                              alpha: isDark
                                  ? navTheme.edgeHighlightIntensity * 0.15
                                  : navTheme.edgeHighlightIntensity * 0.4,
                            ),
                            Colors.white.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),

                // Layer 7: Border
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: navTheme.borderOpacity)
                            : Colors.white.withValues(alpha: navTheme.borderOpacity * 2.2),
                        width: navTheme.borderWidth,
                      ),
                    ),
                  ),
                ),

                // Layer 8: Content
                content,
              ],
            ),
          ),
        );

      case VooNavigationPreset.blurry:
        // Blurry: clean frosted blur with minimal styling
        // Use provided backgroundColor or fall back to theme surface
        final surfaceColor = backgroundColor.withValues(alpha: 1.0);

        return ClipRRect(
          borderRadius: borderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: navTheme.blurSigma,
              sigmaY: navTheme.blurSigma,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: surfaceColor.withValues(alpha: navTheme.surfaceOpacity),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: navTheme.borderOpacity)
                      : Colors.black.withValues(alpha: navTheme.borderOpacity * 0.5),
                  width: navTheme.borderWidth,
                ),
              ),
              child: content,
            ),
          ),
        );

      case VooNavigationPreset.neomorphism:
        // Neomorphism: embossed with pronounced dual shadows
        // Use provided backgroundColor
        return Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius,
            boxShadow: [
              // Light shadow (top-left) - more pronounced
              BoxShadow(
                color: (isDark ? Colors.white : Colors.white)
                    .withValues(alpha: isDark ? 0.05 : 0.8),
                blurRadius: navTheme.shadowBlur * 1.5,
                offset: navTheme.shadowLightOffset * 1.2,
                spreadRadius: isDark ? 0 : 2,
              ),
              // Dark shadow (bottom-right) - more pronounced
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.2),
                blurRadius: navTheme.shadowBlur * 1.5,
                offset: navTheme.shadowDarkOffset * 1.2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: content,
          ),
        );

      case VooNavigationPreset.material3Enhanced:
        // Material 3: polished with elevation and subtle surface tint
        return Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius,
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: isDark ? 0.4 : 0.15),
                blurRadius: 16,
                offset: const Offset(0, 4),
                spreadRadius: 1,
              ),
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: isDark ? 0.2 : 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: content,
          ),
        );

      case VooNavigationPreset.minimalModern:
        // Minimal: completely flat with thin visible border
        // Use provided backgroundColor
        return Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(navTheme.containerBorderRadius * 0.5),
            border: Border.all(
              color: theme.colorScheme.outlineVariant,
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(navTheme.containerBorderRadius * 0.5),
            child: content,
          ),
        );
    }
  }
}

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

  const _CompactRailHeader({
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
      child: Column(
        children: [
          // Compact branding - just the logo icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF1F2937),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.person_outline,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(height: 12),
          // Expand toggle
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
