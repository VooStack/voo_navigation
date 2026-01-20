import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation_core/src/domain/tokens/voo_navigation_tokens.dart';
import 'package:voo_navigation_rail/src/presentation/atoms/voo_rail_modern_badge.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Navigation item widget for rail layout
class VooRailNavigationItem extends StatefulWidget {
  /// Navigation item data
  final VooNavigationItem item;

  /// Whether this item is selected
  final bool isSelected;

  /// Whether the rail is extended
  final bool extended;

  /// Callback when item is tapped
  final VoidCallback? onTap;

  /// Callback when item is long-pressed
  final VoidCallback? onLongPress;

  /// Optional animation controller
  final AnimationController? animationController;

  /// Optional selected item color (from config)
  final Color? selectedItemColor;

  /// Optional unselected item color (from config)
  final Color? unselectedItemColor;

  const VooRailNavigationItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.extended,
    this.onTap,
    this.onLongPress,
    this.animationController,
    this.selectedItemColor,
    this.unselectedItemColor,
  });

  @override
  State<VooRailNavigationItem> createState() => _VooRailNavigationItemState();
}

class _VooRailNavigationItemState extends State<VooRailNavigationItem>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        widget.animationController ??
        AnimationController(
          duration: const Duration(milliseconds: 300),
          vsync: this,
        );

    if (widget.isSelected) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(VooRailNavigationItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    if (widget.animationController == null) {
      _animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final VooSpacingTokens spacing = context.vooSpacing;

    // Use config colors if provided, otherwise fall back to theme
    final unselectedColor = widget.unselectedItemColor ?? theme.colorScheme.onSurface;
    final selectedColor = widget.selectedItemColor ?? theme.colorScheme.primary;

    // Resolve icon color from item, widget (config), or theme
    final iconColor = widget.isSelected
        ? (widget.item.selectedIconColor ?? selectedColor)
        : (widget.item.iconColor ?? unselectedColor.withValues(alpha: VooNavigationTokens.opacityMutedIcon));

    Widget itemContent = AnimatedContainer(
      duration: context.vooAnimation.durationFast,
      padding: widget.extended
          ? const EdgeInsets.symmetric(
              horizontal: VooNavigationTokens.itemPaddingHorizontal,
              vertical: VooNavigationTokens.itemPaddingVertical,
            )
          : const EdgeInsets.all(VooNavigationTokens.itemPaddingVertical),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(VooNavigationTokens.itemBorderRadius),
        color: widget.isSelected
            ? context.navSelectedBackground(selectedColor)
            : _isHovered
                ? context.navHoverBackground
                : Colors.transparent,
      ),
      child: widget.extended
          ? _ExtendedItemContent(
              item: widget.item,
              isSelected: widget.isSelected,
              iconColor: iconColor,
              selectedItemColor: widget.selectedItemColor,
              unselectedItemColor: widget.unselectedItemColor,
            )
          : _CompactItemContent(
              item: widget.item,
              isSelected: widget.isSelected,
              iconColor: iconColor,
            ),
    );

    // Wrap with tooltip for compact mode
    if (!widget.extended) {
      itemContent = Tooltip(
        message: widget.item.effectiveTooltip,
        child: itemContent,
      );
    }

    // Wrap with semantics for accessibility
    return Semantics(
      label: widget.item.effectiveSemanticLabel,
      button: true,
      enabled: widget.item.isEnabled,
      selected: widget.isSelected,
      child: Padding(
        key: widget.item.key,
        padding: EdgeInsets.symmetric(
          // Less horizontal padding in compact mode for better centering
          horizontal: widget.extended ? spacing.sm : spacing.xs,
          vertical: spacing.xxs,
        ),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: widget.item.isEnabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          child: InkWell(
            onTap: widget.item.isEnabled ? widget.onTap : null,
            onLongPress: widget.item.isEnabled ? widget.onLongPress : null,
            borderRadius: BorderRadius.circular(VooNavigationTokens.itemBorderRadius),
            child: itemContent,
          ),
        ),
      ),
    );
  }

}

class _ExtendedItemContent extends StatelessWidget {
  final VooNavigationItem item;
  final bool isSelected;
  final Color iconColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;

  const _ExtendedItemContent({
    required this.item,
    required this.isSelected,
    required this.iconColor,
    this.selectedItemColor,
    this.unselectedItemColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Resolve label color - match drawer styling
    final unselectedLabelColor = unselectedItemColor ?? theme.colorScheme.onSurface;

    // Resolve label style from item or theme - match drawer
    final labelStyle = theme.textTheme.bodyMedium?.copyWith(
      color: unselectedLabelColor,
      fontWeight: isSelected ? VooNavigationTokens.labelFontWeightSelected : VooNavigationTokens.labelFontWeight,
      fontSize: VooNavigationTokens.labelFontSize,
    );

    return Row(
      children: [
        // Leading widget or Icon
        if (item.leadingWidget != null)
          item.leadingWidget!
        else
          AnimatedSwitcher(
            duration: context.vooAnimation.durationFast,
            child: Icon(
              isSelected ? item.effectiveSelectedIcon : item.icon,
              key: ValueKey(isSelected),
              color: iconColor,
              size: VooNavigationTokens.iconSizeDefault,
            ),
          ),
        const SizedBox(width: VooNavigationTokens.iconLabelSpacing),
        Expanded(
          child: Text(
            item.label,
            style: labelStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (item.hasBadge) ...[
          const SizedBox(width: 8),
          VooRailModernBadge(
            item: item,
            isSelected: isSelected,
            extended: true,
          ),
        ],
        // Trailing widget
        if (item.trailingWidget != null) ...[
          const SizedBox(width: 8),
          item.trailingWidget!,
        ],
      ],
    );
  }
}

class _CompactItemContent extends StatelessWidget {
  final VooNavigationItem item;
  final bool isSelected;
  final Color iconColor;

  const _CompactItemContent({
    required this.item,
    required this.isSelected,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Leading widget or Icon
          if (item.leadingWidget != null)
            item.leadingWidget!
          else
            AnimatedSwitcher(
              duration: context.vooAnimation.durationFast,
              child: Icon(
                isSelected ? item.effectiveSelectedIcon : item.icon,
                key: ValueKey(isSelected),
                color: iconColor,
                size: VooNavigationTokens.iconSizeCompact,
              ),
            ),
          if (item.hasBadge)
            Positioned(
              top: -4,
              right: -8,
              child: VooRailModernBadge(
                item: item,
                isSelected: isSelected,
                extended: false,
              ),
            ),
        ],
      ),
    );
  }
}
