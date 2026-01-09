import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_theme.dart';
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

    // If using custom header, place toggle at top-right aligned with title
    if (customHeader != null) {
      if (trailing == null) {
        return customHeader;
      }

      // Wrap custom header with trailing toggle at top-right
      // Use Stack so toggle aligns with first row (title) of custom header
      return Stack(
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

    // Default header handling
    final headerContent = const VooDrawerDefaultHeader();

    if (trailing == null) {
      return headerContent;
    }

    // Wrap default header with trailing widget
    return Padding(
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

    Widget content = Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Custom header or default modern header with optional trailing widget
          _buildHeader(context),

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

          // User profile footer when enabled
          if (widget.config.showUserProfile)
            widget.config.userProfileWidget ?? const VooUserProfileFooter(),

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
    );

    // Apply theme-specific styling based on preset
    final themedContainer = switch (navTheme.preset) {
      VooNavigationPreset.glassmorphism => _GlassmorphismDrawerContainer(
          navTheme: navTheme,
          isDark: isDark,
          backgroundColor: effectiveBackgroundColor,
          borderRadius: borderRadius,
          child: content,
        ),
      VooNavigationPreset.liquidGlass => _LiquidGlassDrawerContainer(
          navTheme: navTheme,
          isDark: isDark,
          backgroundColor: effectiveBackgroundColor,
          borderRadius: borderRadius,
          child: content,
        ),
      VooNavigationPreset.blurry => _BlurryDrawerContainer(
          navTheme: navTheme,
          isDark: isDark,
          backgroundColor: effectiveBackgroundColor,
          borderRadius: borderRadius,
          child: content,
        ),
      VooNavigationPreset.neomorphism => _NeomorphismDrawerContainer(
          navTheme: navTheme,
          isDark: isDark,
          backgroundColor: effectiveBackgroundColor,
          borderRadius: borderRadius,
          child: content,
        ),
      VooNavigationPreset.material3Enhanced => _Material3DrawerContainer(
          isDark: isDark,
          backgroundColor: effectiveBackgroundColor,
          borderRadius: borderRadius,
          child: content,
        ),
      VooNavigationPreset.minimalModern => _MinimalDrawerContainer(
          navTheme: navTheme,
          backgroundColor: effectiveBackgroundColor,
          borderRadius: borderRadius,
          child: content,
        ),
    };

    // Build the container based on theme preset
    return AnimatedContainer(
      duration: navTheme.animationDuration,
      curve: navTheme.animationCurve,
      width: effectiveWidth,
      margin: effectiveDrawerMargin,
      child: themedContainer,
    );
  }
}

class _GlassmorphismDrawerContainer extends StatelessWidget {
  final VooNavigationTheme navTheme;
  final bool isDark;
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final Widget child;

  const _GlassmorphismDrawerContainer({
    required this.navTheme,
    required this.isDark,
    required this.backgroundColor,
    required this.borderRadius,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final surfaceColor = backgroundColor.withValues(alpha: 1.0);

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: isDark ? 0.25 : 0.15),
            blurRadius: 32,
            spreadRadius: 0,
          ),
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
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.12)
                    : Colors.white.withValues(alpha: 0.6),
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
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
                          Colors.white.withValues(alpha: isDark ? 0.08 : 0.3),
                          Colors.white.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 0,
                  bottom: 20,
                  width: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0.0),
                          Colors.white.withValues(alpha: isDark ? 0.1 : 0.4),
                          Colors.white.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LiquidGlassDrawerContainer extends StatelessWidget {
  final VooNavigationTheme navTheme;
  final bool isDark;
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final Widget child;

  const _LiquidGlassDrawerContainer({
    required this.navTheme,
    required this.isDark,
    required this.backgroundColor,
    required this.borderRadius,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final surfaceColor = backgroundColor.withValues(alpha: 1.0);
    final tintedSurface = navTheme.tintIntensity > 0
        ? Color.lerp(surfaceColor, primaryColor, navTheme.tintIntensity * 0.3)!
        : surfaceColor;

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: isDark ? 0.2 : 0.12),
            blurRadius: 44,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.18),
            blurRadius: 36,
            offset: const Offset(6, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: navTheme.blurSigma,
                  sigmaY: navTheme.blurSigma,
                ),
                child: const SizedBox.expand(),
              ),
            ),
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
                            tintedSurface.withValues(alpha: navTheme.surfaceOpacity + 0.2),
                            tintedSurface.withValues(alpha: navTheme.surfaceOpacity + 0.08),
                            tintedSurface.withValues(alpha: navTheme.surfaceOpacity),
                            tintedSurface.withValues(alpha: navTheme.surfaceOpacity - 0.12),
                          ],
                  ),
                ),
              ),
            ),
            if (navTheme.innerGlowIntensity > 0)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    gradient: RadialGradient(
                      center: const Alignment(-0.3, -0.6),
                      radius: 2.0,
                      colors: [
                        primaryColor.withValues(alpha: navTheme.innerGlowIntensity * 0.08),
                        primaryColor.withValues(alpha: navTheme.innerGlowIntensity * 0.02),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.3, 1.0],
                    ),
                  ),
                ),
              ),
            if (navTheme.edgeHighlightIntensity > 0)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 100,
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
                              ? navTheme.edgeHighlightIntensity * 0.1
                              : navTheme.edgeHighlightIntensity * 0.35,
                        ),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
            if (navTheme.edgeHighlightIntensity > 0)
              Positioned(
                top: 20,
                left: 0,
                bottom: 20,
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
                              : navTheme.edgeHighlightIntensity * 0.45,
                        ),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
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
            child,
          ],
        ),
      ),
    );
  }
}

class _BlurryDrawerContainer extends StatelessWidget {
  final VooNavigationTheme navTheme;
  final bool isDark;
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final Widget child;

  const _BlurryDrawerContainer({
    required this.navTheme,
    required this.isDark,
    required this.backgroundColor,
    required this.borderRadius,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
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
          child: child,
        ),
      ),
    );
  }
}

class _NeomorphismDrawerContainer extends StatelessWidget {
  final VooNavigationTheme navTheme;
  final bool isDark;
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final Widget child;

  const _NeomorphismDrawerContainer({
    required this.navTheme,
    required this.isDark,
    required this.backgroundColor,
    required this.borderRadius,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.white : Colors.white)
                .withValues(alpha: isDark ? 0.05 : 0.8),
            blurRadius: navTheme.shadowBlur * 1.5,
            offset: navTheme.shadowLightOffset * 1.2,
            spreadRadius: isDark ? 0 : 2,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.2),
            blurRadius: navTheme.shadowBlur * 1.5,
            offset: navTheme.shadowDarkOffset * 1.2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: child,
      ),
    );
  }
}

class _Material3DrawerContainer extends StatelessWidget {
  final bool isDark;
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final Widget child;

  const _Material3DrawerContainer({
    required this.isDark,
    required this.backgroundColor,
    required this.borderRadius,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
        child: child,
      ),
    );
  }
}

class _MinimalDrawerContainer extends StatelessWidget {
  final VooNavigationTheme navTheme;
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final Widget child;

  const _MinimalDrawerContainer({
    required this.navTheme,
    required this.backgroundColor,
    required this.borderRadius,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = theme.colorScheme.outlineVariant.withValues(alpha: 0.3);

    // Check if this is full-height mode (no left rounding = flush to edge)
    final isFullHeight = borderRadius.topLeft == Radius.zero &&
        borderRadius.bottomLeft == Radius.zero;

    // Use right-only border for full-height mode (HRISELINK style)
    final border = isFullHeight
        ? Border(right: BorderSide(color: borderColor, width: 1))
        : Border.all(color: borderColor, width: 1);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        border: border,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: child,
      ),
    );
  }
}

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
