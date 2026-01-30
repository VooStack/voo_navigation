import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation_core/src/domain/tokens/voo_navigation_tokens.dart';
import 'package:voo_navigation_core/src/presentation/atoms/voo_modern_icon.dart';
import 'package:voo_tokens/voo_tokens.dart';

class VooCustomNavigationItem extends StatelessWidget {
  final VooNavigationItem item;

  final bool isSelected;

  final int index;

  final VooNavigationConfig config;

  final Animation<double> scaleAnimation;

  final bool showLabels;

  final bool showSelectedLabels;

  final bool enableFeedback;

  final VoidCallback? onTap;

  final VoidCallback? onLongPress;

  final int itemCount;

  const VooCustomNavigationItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.index,
    required this.config,
    required this.scaleAnimation,
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

    final isCompact = itemCount >= 5;
    final verticalPadding = isCompact ? spacing.xxs : spacing.xs;
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
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(VooNavigationTokens.itemBorderRadius),
          color: isSelected ? context.navSelectedBackground(primaryColor) : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: scaleAnimation,
              builder: (context, child) => Transform.translate(
                offset: Offset(0, -2 * (scaleAnimation.value - 1.0) / 0.08),
                child: Transform.scale(
                  scale: scaleAnimation.value,
                  child: VooModernIcon(item: item, isSelected: isSelected, primaryColor: primaryColor, iconSize: isCompact ? 22.0 : null),
                ),
              ),
            ),

            if (showLabels && (!showSelectedLabels || isSelected))
              AnimatedDefaultTextStyle(
                duration: context.vooAnimation.durationFast,
                curve: Curves.easeOutCubic,
                style: theme.textTheme.labelSmall!.copyWith(
                  color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.85),
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
                    style: theme.textTheme.labelSmall!.copyWith(
                      color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.85),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      fontSize: labelFontSize,
                      letterSpacing: isCompact ? -0.2 : 0,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
