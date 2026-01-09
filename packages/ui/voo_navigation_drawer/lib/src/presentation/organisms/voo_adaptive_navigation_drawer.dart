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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navTheme = widget.config.effectiveTheme;
    final isDark = theme.brightness == Brightness.dark;

    final effectiveWidth =
        widget.width ?? widget.config.navigationDrawerWidth ?? 300;

    // Use theme-based surface color
    final effectiveBackgroundColor =
        widget.backgroundColor ??
        widget.config.navigationBackgroundColor ??
        navTheme.resolveSurfaceColor(context);

    // Build the container based on theme preset
    return AnimatedContainer(
      duration: navTheme.animationDuration,
      curve: navTheme.animationCurve,
      width: effectiveWidth,
      margin: EdgeInsets.all(widget.config.navigationRailMargin),
      child: _buildThemedContainer(
        context,
        theme,
        navTheme,
        isDark,
        effectiveBackgroundColor,
      ),
    );
  }

  Widget _buildThemedContainer(
    BuildContext context,
    ThemeData theme,
    VooNavigationTheme navTheme,
    bool isDark,
    Color backgroundColor,
  ) {
    final borderRadius = BorderRadius.circular(navTheme.containerBorderRadius);

    Widget content = Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Custom header or default modern header
          widget.config.drawerHeader ?? const VooDrawerDefaultHeader(),

          // Navigation items
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(
                horizontal: context.vooSpacing.sm + context.vooSpacing.xs,
                vertical: context.vooSpacing.sm,
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
                    // Inner border highlight (left edge)
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
                blurRadius: 44,
                spreadRadius: 0,
              ),
              // Deep shadow for depth
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.18),
                blurRadius: 36,
                offset: const Offset(6, 10),
              ),
              // Soft close shadow
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
                                tintedSurface.withValues(alpha: navTheme.surfaceOpacity + 0.2),
                                tintedSurface.withValues(alpha: navTheme.surfaceOpacity + 0.08),
                                tintedSurface.withValues(alpha: navTheme.surfaceOpacity),
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

                // Layer 5: Top edge highlight (refraction)
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

                // Layer 6: Left edge highlight
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
