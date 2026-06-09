import 'package:flutter/material.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';
import 'package:voo_navigation_drawer/src/presentation/molecules/drawer_modern_badge.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Navigation item widget for drawer
class VooDrawerNavigationItem extends StatelessWidget {
  /// The navigation item
  final VooNavigationDestination item;

  /// Navigation configuration
  final VooNavigationConfig config;

  /// Currently selected item ID
  final String selectedId;

  /// Callback when an item is tapped
  final void Function(VooNavigationDestination item) onItemTap;

  /// Whether this item is hovered
  final bool isHovered;

  /// Callback to set hover state
  final void Function(bool isHovered) onHoverChanged;

  const VooDrawerNavigationItem({
    super.key,
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
    final m = context.vooMinimal;
    final isSelected = item.id == selectedId;

    // Selected: accent icon + full-contrast text + subtle bg tint.
    // Unselected: muted text + muted icon, no chrome.
    final iconColor = isSelected
        ? (item.selectedIconColor ?? config.effectiveTheme.selectedItemColor ?? m.accent)
        : (item.iconColor ?? m.textTertiary);

    final labelStyle = theme.textTheme.bodyMedium?.copyWith(
      color: isSelected ? m.textPrimary : m.textSecondary,
      fontWeight: isSelected
          ? VooNavigationTokens.labelFontWeightSelected
          : VooNavigationTokens.labelFontWeight,
      fontSize: VooNavigationTokens.labelFontSize,
      letterSpacing: -0.1,
    );

    // Backgrounds are neutral — the accent leading bar carries the
    // "selected" signal, not a primary-tinted background.
    final bgColor = isSelected
        ? m.selectedOverlay
        : isHovered
            ? m.hoverOverlay
            : Colors.transparent;

    Widget itemContent = AnimatedContainer(
      duration: VooMinimal.motionFast,
      curve: VooMinimal.motionCurve,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: VooMinimal.brSm,
      ),
      // Selected signal comes from the icon color (accent) + bolder
      // higher-contrast text + subtle bg tint. No leading bar — it
      // didn't read clearly at typical row heights.
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: VooNavigationTokens.itemPaddingHorizontal,
          vertical: 7,
        ),
        child: Row(
              children: [
                if (item.leadingWidget != null)
                  item.leadingWidget!
                else
                  AnimatedSwitcher(
                    duration: VooMinimal.motionFast,
                    child: IconTheme(
                      key: ValueKey(isSelected),
                      data: IconThemeData(
                        color: iconColor,
                        size: VooNavigationTokens.iconSizeDefault,
                      ),
                      child: isSelected ? item.effectiveSelectedIcon : item.icon,
                    ),
                  ),
                const SizedBox(width: VooNavigationTokens.iconLabelSpacing),
                Expanded(
                  child: Text(
                    item.label ?? '',
                    style: labelStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (item.hasBadge) ...[
                  SizedBox(width: context.vooSpacing.xs),
                  VooDrawerModernBadge(item: item, isSelected: isSelected),
                ],
                if (item.trailingWidget != null) ...[
                  SizedBox(width: context.vooSpacing.xs),
                  item.trailingWidget!,
                ],
              ],
            ),
          ),
    );

    if (item.tooltip != null) {
      itemContent = Tooltip(
        message: item.effectiveTooltip,
        child: itemContent,
      );
    }

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
          borderRadius: VooMinimal.brSm,
          child: itemContent,
        ),
      ),
    );
  }
}
