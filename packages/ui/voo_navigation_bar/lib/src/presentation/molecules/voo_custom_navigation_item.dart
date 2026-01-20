import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation_core/src/domain/tokens/voo_navigation_tokens.dart';
import 'package:voo_navigation_core/src/presentation/atoms/voo_modern_icon.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Custom navigation item widget for bottom navigation
class VooCustomNavigationItem extends StatelessWidget {
  /// Navigation item data
  final VooNavigationItem item;

  /// Whether this item is selected
  final bool isSelected;

  /// Index of this item
  final int index;

  /// Navigation configuration
  final VooNavigationConfig config;

  /// Scale animation for the icon
  final Animation<double> scaleAnimation;

  /// Rotation animation for the icon
  final Animation<double> rotationAnimation;

  /// Whether to show labels
  final bool showLabels;

  /// Whether to show selected labels only
  final bool showSelectedLabels;

  /// Whether to enable feedback
  final bool enableFeedback;

  /// Callback when item is selected
  final VoidCallback? onTap;

  /// Callback when item is long-pressed
  final VoidCallback? onLongPress;

  /// Total number of items in the navigation bar
  final int itemCount;

  const VooCustomNavigationItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.index,
    required this.config,
    required this.scaleAnimation,
    required this.rotationAnimation,
    required this.showLabels,
    required this.showSelectedLabels,
    required this.enableFeedback,
    required this.onTap,
    this.onLongPress,
    this.itemCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = config.selectedItemColor ?? theme.colorScheme.primary;
    final spacing = context.vooSpacing;

    // Responsive sizing based on item count
    final isCompact = itemCount >= 5;
    final verticalPadding = isCompact ? spacing.xxs : spacing.xs;
    final horizontalPadding = isCompact ? spacing.sm : (spacing.sm + spacing.xxs);
    final horizontalMargin = isCompact ? spacing.xxs : (spacing.xs - spacing.xxs);
    final labelFontSize = isCompact ? 10.0 : context.vooTypography.bodySmall.fontSize;

    return InkWell(
      onTap: item.isEnabled
          ? () {
              if (enableFeedback) {
                HapticFeedback.lightImpact();
              }
              onTap?.call();
            }
          : null,
      onLongPress: item.isEnabled && onLongPress != null
          ? () {
              if (enableFeedback) {
                HapticFeedback.mediumImpact();
              }
              onLongPress?.call();
            }
          : null,
      borderRadius: BorderRadius.circular(context.vooRadius.lg),
      child: AnimatedContainer(
        duration: config.animationDuration,
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: horizontalMargin,
          vertical: isCompact ? spacing.xxs : spacing.xs,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(VooNavigationTokens.itemBorderRadius),
          // Simplified selection state to match drawer/rail
          color: isSelected
              ? context.navSelectedBackground(primaryColor)
              : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated icon
            AnimatedBuilder(
              animation: Listenable.merge([scaleAnimation, rotationAnimation]),
              builder: (context, child) => Transform.scale(
                scale: scaleAnimation.value,
                child: Transform.rotate(
                  angle: rotationAnimation.value,
                  child: VooModernIcon(
                    item: item,
                    isSelected: isSelected,
                    primaryColor: primaryColor,
                    iconSize: isCompact ? 22.0 : null,
                  ),
                ),
              ),
            ),

            // Animated label
            if (showLabels && (!showSelectedLabels || isSelected))
              AnimatedDefaultTextStyle(
                duration: context.vooAnimation.durationFast,
                curve: Curves.easeOutCubic,
                style: theme.textTheme.labelSmall!.copyWith(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.85),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: labelFontSize,
                  letterSpacing: isCompact ? -0.2 : 0,
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: isCompact ? 2 : spacing.xxs),
                  child: Text(
                    item.label,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
