import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_item.dart';
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
    final isDark = theme.brightness == Brightness.dark;
    final VooSpacingTokens spacing = context.vooSpacing;
    final VooRadiusTokens radius = context.vooRadius;

    // Resolve icon color from item, widget (config), or theme
    final iconColor = widget.isSelected
        ? (widget.item.selectedIconColor ?? widget.selectedItemColor ?? theme.colorScheme.primary)
        : (widget.item.iconColor ?? widget.unselectedItemColor ?? theme.colorScheme.onSurfaceVariant);

    Widget itemContent = AnimatedContainer(
      duration: context.vooAnimation.durationFast,
      height: 48,
      width: widget.extended ? null : 48,
      padding: widget.extended
          ? EdgeInsets.symmetric(
              horizontal: spacing.md,
              vertical: spacing.sm,
            )
          : EdgeInsets.all(spacing.xs),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          widget.extended ? radius.md : radius.md,
        ),
        gradient: widget.isSelected
            ? LinearGradient(
                colors: [
                  theme.colorScheme.primary.withValues(
                    alpha: isDark ? 0.2 : 0.12,
                  ),
                  theme.colorScheme.primary.withValues(
                    alpha: isDark ? 0.15 : 0.08,
                  ),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: !widget.isSelected
            ? (_isHovered
                  ? theme.colorScheme.onSurface.withValues(
                      alpha: isDark ? 0.08 : 0.04,
                    )
                  : Colors.transparent)
            : null,
        boxShadow: widget.isSelected
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(
                    alpha: 0.1,
                  ),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
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

    // Wrap with tooltip
    itemContent = Tooltip(
      message: widget.item.effectiveTooltip,
      child: itemContent,
    );

    // Wrap with semantics for accessibility
    return Semantics(
      label: widget.item.effectiveSemanticLabel,
      button: true,
      enabled: widget.item.isEnabled,
      selected: widget.isSelected,
      child: Padding(
        key: widget.item.key,
        padding: EdgeInsets.symmetric(
          horizontal: spacing.sm,
          vertical: spacing.xxs / 2,
        ),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: widget.item.isEnabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          child: InkWell(
            onTap: widget.item.isEnabled ? widget.onTap : null,
            borderRadius: BorderRadius.circular(radius.md),
            child: AnimatedScale(
              scale: _isHovered ? 1.02 : 1.0,
              duration: Duration(
                milliseconds:
                    (context.vooAnimation.durationFast.inMilliseconds * 0.75)
                        .round(),
              ),
              child: itemContent,
            ),
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
    final spacing = context.vooSpacing;

    // Resolve label color from config or theme
    final selectedLabelColor = selectedItemColor ?? theme.colorScheme.primary;
    final unselectedLabelColor = unselectedItemColor ?? theme.colorScheme.onSurface;

    // Resolve label style from item or theme
    final defaultLabelStyle = theme.textTheme.bodyMedium?.copyWith(
      color: isSelected ? selectedLabelColor : unselectedLabelColor,
      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      fontSize: 14,
    );
    final labelStyle = isSelected
        ? (item.selectedLabelStyle ?? defaultLabelStyle)
        : (item.labelStyle ?? defaultLabelStyle);

    return Row(
      children: [
        // Leading widget or Icon
        if (item.leadingWidget != null)
          item.leadingWidget!
        else
          AnimatedSwitcher(
            duration: context.vooAnimation.durationFast,
            child: Icon(
              isSelected
                  ? item.effectiveSelectedIcon
                  : item.icon,
              key: ValueKey(isSelected),
              color: iconColor,
              size: 22,
            ),
          ),
        SizedBox(width: spacing.sm),
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  item.label,
                  style: labelStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (item.hasBadge) ...[
                SizedBox(width: spacing.xs),
                VooRailModernBadge(
                  item: item,
                  isSelected: isSelected,
                  extended: true,
                ),
              ],
              // Trailing widget
              if (item.trailingWidget != null) ...[
                SizedBox(width: spacing.xs),
                item.trailingWidget!,
              ],
            ],
          ),
        ),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Leading widget or Icon
              if (item.leadingWidget != null)
                item.leadingWidget!
              else
                AnimatedSwitcher(
                  duration: context.vooAnimation.durationFast,
                  child: Icon(
                    isSelected
                        ? item.effectiveSelectedIcon
                        : item.icon,
                    key: ValueKey(isSelected),
                    color: iconColor,
                    size: 24,
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
        ],
      ),
    );
  }
}
