import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_theme.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Modern floating bottom navigation bar with clean minimal design
class VooFloatingBottomNavigation extends StatefulWidget {
  /// Navigation configuration
  final VooNavigationConfig config;

  /// Currently selected item ID
  final String selectedId;

  /// Callback when an item is selected
  final void Function(String itemId) onNavigationItemSelected;

  /// Custom height for the navigation bar
  final double? height;

  /// Whether to show labels
  final bool showLabels;

  /// Horizontal margin from screen edges
  final double? horizontalMargin;

  /// Bottom margin from screen edge
  final double? bottomMargin;

  /// Custom background color
  final Color? backgroundColor;

  /// Border radius for the floating bar
  final double? borderRadius;

  /// Whether to enable haptic feedback
  final bool enableHapticFeedback;

  const VooFloatingBottomNavigation({
    super.key,
    required this.config,
    required this.selectedId,
    required this.onNavigationItemSelected,
    this.height,
    this.showLabels = true,
    this.horizontalMargin,
    this.bottomMargin,
    this.backgroundColor,
    this.borderRadius,
    this.enableHapticFeedback = true,
  });

  @override
  State<VooFloatingBottomNavigation> createState() =>
      _VooFloatingBottomNavigationState();
}

class _VooFloatingBottomNavigationState
    extends State<VooFloatingBottomNavigation> with TickerProviderStateMixin {
  int _getSelectedIndex() {
    final items = widget.config.mobilePriorityItems;
    for (int i = 0; i < items.length; i++) {
      if (items[i].id == widget.selectedId) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navTheme = widget.config.effectiveTheme;
    final items = widget.config.mobilePriorityItems;
    final spacing = context.vooSpacing;

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final selectedIndex = _getSelectedIndex();
    final isCompact = items.length >= 5;
    final effectiveHeight = widget.height ?? (isCompact ? 64.0 : 68.0);
    final effectiveMargin =
        widget.horizontalMargin ?? (spacing.md > 0 ? spacing.md : 16.0);
    final effectiveBottomMargin =
        widget.bottomMargin ?? (spacing.lg > 0 ? spacing.lg : 24.0);
    final effectiveBorderRadius =
        widget.borderRadius ?? navTheme.containerBorderRadius;

    final isDark = theme.brightness == Brightness.dark;
    final effectiveBackgroundColor =
        widget.backgroundColor ??
        widget.config.navigationBackgroundColor ??
        navTheme.resolveSurfaceColor(context);

    final borderRadius = BorderRadius.circular(effectiveBorderRadius);
    final shadows = navTheme.resolveShadows(context);

    Widget navContent = Row(
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final isSelected = index == selectedIndex;

        return Expanded(
          child: _MinimalNavItem(
            item: item,
            isSelected: isSelected,
            showLabel: widget.showLabels,
            isCompact: isCompact,
            primaryColor:
                widget.config.selectedItemColor ?? theme.colorScheme.primary,
            onTap: () {
              if (widget.enableHapticFeedback) {
                HapticFeedback.selectionClick();
              }
              widget.onNavigationItemSelected(item.id);
            },
          ),
        );
      }).toList(),
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(
        effectiveMargin,
        0,
        effectiveMargin,
        effectiveBottomMargin,
      ),
      child: _buildThemedContainer(
        context,
        navTheme,
        isDark,
        effectiveBackgroundColor,
        borderRadius,
        shadows,
        effectiveHeight,
        navContent,
      ),
    );
  }

  Widget _buildThemedContainer(
    BuildContext context,
    VooNavigationTheme navTheme,
    bool isDark,
    Color backgroundColor,
    BorderRadius borderRadius,
    List<BoxShadow> shadows,
    double height,
    Widget content,
  ) {
    final theme = Theme.of(context);

    switch (navTheme.preset) {
      case VooNavigationPreset.glassmorphism:
        // Enhanced Glassmorphism: premium frosted glass effect
        final primaryColor = theme.colorScheme.primary;
        // Use provided backgroundColor
        final surfaceColor = backgroundColor.withValues(alpha: 1.0);

        return Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            boxShadow: [
              // Outer glow with primary color
              BoxShadow(
                color: primaryColor.withValues(alpha: isDark ? 0.3 : 0.2),
                blurRadius: 32,
                spreadRadius: 0,
              ),
              // Soft ambient shadow
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.15),
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
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.5, 1.0],
                    colors: isDark
                        ? [
                            surfaceColor.withValues(alpha: 0.9),
                            surfaceColor.withValues(alpha: 0.8),
                            surfaceColor.withValues(alpha: 0.7),
                          ]
                        : [
                            surfaceColor.withValues(alpha: 0.95),
                            surfaceColor.withValues(alpha: 0.85),
                            surfaceColor.withValues(alpha: 0.75),
                          ],
                  ),
                  // Gradient border effect
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.7),
                    width: 1.5,
                  ),
                ),
                child: Stack(
                  children: [
                    // Top highlight shine
                    Positioned(
                      top: 0,
                      left: 20,
                      right: 20,
                      height: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0.0),
                              Colors.white.withValues(alpha: isDark ? 0.2 : 0.5),
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
        // Use provided backgroundColor
        final surfaceColor = backgroundColor.withValues(alpha: 1.0);

        // Apply tint if specified
        final tintedSurface = navTheme.tintIntensity > 0
            ? Color.lerp(surfaceColor, primaryColor, navTheme.tintIntensity * 0.3)!
            : surfaceColor;

        return Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            boxShadow: [
              // Primary ambient glow
              BoxShadow(
                color: primaryColor.withValues(alpha: isDark ? 0.25 : 0.15),
                blurRadius: 40,
                spreadRadius: 0,
              ),
              // Deep shadow for depth
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.55 : 0.2),
                blurRadius: 36,
                offset: const Offset(0, 12),
              ),
              // Soft close shadow
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
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
                        stops: const [0.0, 0.3, 0.7, 1.0],
                        colors: isDark
                            ? [
                                tintedSurface.withValues(alpha: navTheme.surfaceOpacity + 0.12),
                                tintedSurface.withValues(alpha: navTheme.surfaceOpacity + 0.02),
                                tintedSurface.withValues(alpha: navTheme.surfaceOpacity - 0.03),
                                tintedSurface.withValues(alpha: navTheme.surfaceOpacity - 0.08),
                              ]
                            : [
                                tintedSurface.withValues(alpha: navTheme.surfaceOpacity + 0.2),
                                tintedSurface.withValues(alpha: navTheme.surfaceOpacity + 0.08),
                                tintedSurface.withValues(alpha: navTheme.surfaceOpacity),
                                tintedSurface.withValues(alpha: navTheme.surfaceOpacity - 0.1),
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
                          center: Alignment.center,
                          radius: 1.5,
                          colors: [
                            primaryColor.withValues(alpha: navTheme.innerGlowIntensity * 0.1),
                            primaryColor.withValues(alpha: navTheme.innerGlowIntensity * 0.03),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.4, 1.0],
                        ),
                      ),
                    ),
                  ),

                // Layer 5: Top edge highlight (refraction)
                if (navTheme.edgeHighlightIntensity > 0)
                  Positioned(
                    top: 0,
                    left: 16,
                    right: 16,
                    height: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: borderRadius.topLeft,
                          topRight: borderRadius.topRight,
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.0),
                            Colors.white.withValues(
                              alpha: isDark
                                  ? navTheme.edgeHighlightIntensity * 0.5
                                  : navTheme.edgeHighlightIntensity * 0.9,
                            ),
                            Colors.white.withValues(alpha: 0.0),
                          ],
                          stops: const [0.05, 0.5, 0.95],
                        ),
                      ),
                    ),
                  ),

                // Layer 6: Left edge highlight
                if (navTheme.edgeHighlightIntensity > 0)
                  Positioned(
                    top: 12,
                    left: 0,
                    bottom: 12,
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
                                  ? navTheme.edgeHighlightIntensity * 0.25
                                  : navTheme.edgeHighlightIntensity * 0.5,
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
                            : Colors.white.withValues(alpha: navTheme.borderOpacity * 2.5),
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
        // Use provided backgroundColor
        final surfaceColor = backgroundColor.withValues(alpha: 1.0);

        return SizedBox(
          height: height,
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
          ),
        );

      case VooNavigationPreset.neomorphism:
        // Neomorphism: embossed with pronounced dual shadows
        // Use provided backgroundColor
        return Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius,
            boxShadow: [
              // Light shadow (top) - more pronounced
              BoxShadow(
                color: (isDark ? Colors.white : Colors.white)
                    .withValues(alpha: isDark ? 0.05 : 0.8),
                blurRadius: navTheme.shadowBlur * 1.5,
                offset: Offset(0, -navTheme.shadowBlur * 0.3),
                spreadRadius: isDark ? 0 : 2,
              ),
              // Dark shadow (bottom) - more pronounced
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.2),
                blurRadius: navTheme.shadowBlur * 1.5,
                offset: Offset(0, navTheme.shadowBlur * 0.4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: content,
          ),
        );

      case VooNavigationPreset.material3Enhanced:
        // Material 3: polished with elevation
        return Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius,
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: isDark ? 0.4 : 0.15),
                blurRadius: 20,
                offset: const Offset(0, 6),
                spreadRadius: 2,
              ),
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: isDark ? 0.2 : 0.08),
                blurRadius: 10,
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
        // Minimal: completely flat with thin visible border, smaller radius
        // Use provided backgroundColor
        final smallerRadius = BorderRadius.circular(
          navTheme.containerBorderRadius * 0.5,
        );
        return Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: smallerRadius,
            border: Border.all(
              color: theme.colorScheme.outlineVariant,
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: smallerRadius,
            child: content,
          ),
        );
    }
  }
}

/// Clean minimal navigation item
class _MinimalNavItem extends StatefulWidget {
  final VooNavigationItem item;
  final bool isSelected;
  final bool showLabel;
  final bool isCompact;
  final Color primaryColor;
  final VoidCallback onTap;

  const _MinimalNavItem({
    required this.item,
    required this.isSelected,
    required this.showLabel,
    required this.isCompact,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  State<_MinimalNavItem> createState() => _MinimalNavItemState();
}

class _MinimalNavItemState extends State<_MinimalNavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    if (widget.isSelected) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_MinimalNavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward();
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final iconSize = widget.isCompact ? 22.0 : 24.0;
    final labelSize = widget.isCompact ? 10.0 : 11.0;
    final unselectedColor = theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _isPressed ? 0.95 : 1.0,
            child: Opacity(
              opacity: widget.item.isEnabled ? 1.0 : 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon with badge
                  AnimatedScale(
                    scale: widget.isSelected ? _scaleAnimation.value : 1.0,
                    duration: const Duration(milliseconds: 150),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            widget.isSelected
                                ? widget.item.effectiveSelectedIcon
                                : widget.item.icon,
                            key: ValueKey(widget.isSelected),
                            color: widget.isSelected
                                ? widget.primaryColor
                                : unselectedColor,
                            size: iconSize,
                          ),
                        ),
                        if (widget.item.hasBadge) _buildBadge(),
                      ],
                    ),
                  ),

                  // Label
                  if (widget.showLabel)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          color: widget.isSelected
                              ? widget.primaryColor
                              : unselectedColor,
                          fontSize: labelSize,
                          fontWeight: widget.isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          letterSpacing: -0.2,
                        ),
                        child: Text(
                          widget.item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBadge() {
    final theme = Theme.of(context);
    final badgeColor = widget.item.badgeColor ?? theme.colorScheme.error;

    // Dot badge
    if (widget.item.showDot) {
      return Positioned(
        top: -2,
        right: -2,
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: badgeColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: theme.colorScheme.surface,
              width: 1.5,
            ),
          ),
        ),
      );
    }

    // Count or text badge
    final badgeText = widget.item.badgeText ??
        (widget.item.badgeCount != null
            ? (widget.item.badgeCount! > 99
                ? '99+'
                : widget.item.badgeCount.toString())
            : null);

    if (badgeText == null) return const SizedBox.shrink();

    return Positioned(
      top: -6,
      right: -12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        constraints: const BoxConstraints(minWidth: 16),
        decoration: BoxDecoration(
          color: badgeColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: theme.colorScheme.surface,
            width: 1.5,
          ),
        ),
        child: Text(
          badgeText,
          style: TextStyle(
            color: theme.colorScheme.onError,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
