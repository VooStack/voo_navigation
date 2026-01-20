import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/src/domain/entities/context_switcher_config.dart';
import 'package:voo_navigation_core/src/domain/entities/context_switcher_item.dart';
import 'package:voo_navigation_core/src/domain/tokens/voo_navigation_tokens.dart';
import 'package:voo_navigation_core/src/presentation/molecules/context_switcher_bottom_sheet.dart';

/// A navigation item widget that displays the context switcher.
///
/// This widget shows an icon representing the context switcher and opens
/// a bottom sheet modal on tap or long-press. Designed to blend seamlessly
/// with other navigation items in the rail and bottom navigation bar.
class VooContextSwitcherNavItem extends StatefulWidget {
  /// Configuration for the context switcher
  final VooContextSwitcherConfig config;

  /// Whether the item is currently selected (active)
  final bool isSelected;

  /// Whether to show in compact mode (icon only, no label)
  final bool isCompact;

  /// Size of the icon (defaults to 24)
  final double avatarSize;

  /// Whether haptic feedback is enabled
  final bool enableHapticFeedback;

  /// Custom callback when tapped (overrides default bottom sheet)
  final VoidCallback? onTap;

  /// Custom callback when long-pressed (overrides default bottom sheet)
  final VoidCallback? onLongPress;

  /// Whether to use floating nav style (icon only, no backgrounds)
  final bool useFloatingStyle;

  const VooContextSwitcherNavItem({
    super.key,
    required this.config,
    this.isSelected = false,
    this.isCompact = true,
    this.avatarSize = 24,
    this.enableHapticFeedback = true,
    this.onTap,
    this.onLongPress,
    this.useFloatingStyle = true,
  });

  /// The special ID used to identify context switcher nav items
  static const String navItemId = '_context_switcher_nav';

  @override
  State<VooContextSwitcherNavItem> createState() =>
      _VooContextSwitcherNavItemState();
}

class _VooContextSwitcherNavItemState extends State<VooContextSwitcherNavItem> {
  bool _isHovered = false;

  void _showContextSwitcher() {
    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }

    showContextSwitcherBottomSheet(
      context: context,
      config: widget.config,
      onContextSelected: (item) {
        widget.config.onContextChanged?.call(item);
      },
    );
  }

  void _handleTap() {
    if (widget.onTap != null) {
      widget.onTap!();
    } else {
      _showContextSwitcher();
    }
  }

  void _handleLongPress() {
    if (widget.onLongPress != null) {
      widget.onLongPress!();
    } else {
      _showContextSwitcher();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selected = widget.config.selectedItem;
    final label = widget.config.navItemLabel ??
        selected?.name ??
        widget.config.placeholder ??
        'Context';

    if (widget.isCompact) {
      return _buildCompactItem(context, theme, selected, label);
    }

    return _buildExpandedItem(context, theme, selected, label);
  }

  Widget _buildCompactItem(
    BuildContext context,
    ThemeData theme,
    VooContextItem? selected,
    String label,
  ) {
    // Use floating style for bottom nav - clean icon-only design
    if (widget.useFloatingStyle) {
      return _buildFloatingStyleItem(context, theme, selected, label);
    }

    // Rail style with subtle background on hover
    return Tooltip(
      message: label,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: _handleTap,
          onLongPress: _handleLongPress,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: 52,
            height: 52,
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.isSelected || _isHovered
                      ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _buildAvatar(context, selected, widget.avatarSize),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a floating nav style item - clean icon with optional color indicator
  Widget _buildFloatingStyleItem(
    BuildContext context,
    ThemeData theme,
    VooContextItem? selected,
    String label,
  ) {
    // Get colors that match the floating nav bar style
    final foregroundColor = theme.colorScheme.onSurface;
    final selectedColor = selected?.color ?? theme.colorScheme.primary;
    final hasSelection = selected != null;

    return Tooltip(
      message: label,
      child: GestureDetector(
        onTap: _handleTap,
        onLongPress: _handleLongPress,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 52,
          height: 52,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Main icon - matches other nav items
              Icon(
                selected?.icon ?? Icons.grid_view_rounded,
                color: hasSelection
                    ? selectedColor
                    : foregroundColor.withValues(alpha: VooNavigationTokens.opacityDisabled),
                size: VooNavigationTokens.iconSizeCompact,
              ),
              // Color indicator dot when a project is selected
              if (hasSelection)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: selectedColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.surface,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: selectedColor.withValues(alpha: 0.4),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedItem(
    BuildContext context,
    ThemeData theme,
    VooContextItem? selected,
    String label,
  ) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handleTap,
          onLongPress: _handleLongPress,
          borderRadius: BorderRadius.circular(VooNavigationTokens.itemBorderRadius),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                  : _isHovered
                      ? theme.colorScheme.onSurface.withValues(alpha: 0.05)
                      : Colors.transparent,
              borderRadius:
                  BorderRadius.circular(VooNavigationTokens.itemBorderRadius),
            ),
            child: Row(
              children: [
                _buildAvatar(context, selected, widget.avatarSize),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight:
                          widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: widget.isSelected
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.unfold_more_rounded,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(
    BuildContext context,
    VooContextItem? item,
    double size,
  ) {
    final theme = Theme.of(context);

    // Custom avatar widget takes precedence
    if (item?.avatarWidget != null) {
      return SizedBox(
        width: size,
        height: size,
        child: item!.avatarWidget,
      );
    }

    // Avatar URL
    if (item?.avatarUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(size / 4),
        child: Image.network(
          item!.avatarUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildFallbackAvatar(
            context,
            item,
            size,
          ),
        ),
      );
    }

    // Icon
    if (item?.icon != null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: item?.color ?? theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(size / 4),
        ),
        child: Icon(
          item!.icon,
          size: size * 0.55,
          color: item.color != null
              ? _getContrastColor(item.color!)
              : theme.colorScheme.onPrimaryContainer,
        ),
      );
    }

    // Fallback - initials or generic icon
    return _buildFallbackAvatar(context, item, size);
  }

  Widget _buildFallbackAvatar(
    BuildContext context,
    VooContextItem? item,
    double size,
  ) {
    final theme = Theme.of(context);

    // If no item selected, show generic context icon
    if (item == null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(size / 4),
        ),
        child: Icon(
          Icons.layers_outlined,
          size: size * 0.55,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
    }

    final initials = item.initials;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: item.color ?? theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(size / 4),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: size * 0.4,
            fontWeight: FontWeight.w600,
            color: item.color != null
                ? _getContrastColor(item.color!)
                : theme.colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }

  Color _getContrastColor(Color background) {
    return background.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;
  }
}
