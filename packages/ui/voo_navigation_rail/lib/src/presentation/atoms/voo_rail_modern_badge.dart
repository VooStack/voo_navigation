import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_item.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Modern badge display for navigation rail items with animations
class VooRailModernBadge extends StatefulWidget {
  /// Navigation item containing badge data
  final VooNavigationItem item;

  /// Whether the item is selected
  final bool isSelected;

  /// Whether this is for extended rail
  final bool extended;

  const VooRailModernBadge({
    super.key,
    required this.item,
    required this.isSelected,
    required this.extended,
  });

  @override
  State<VooRailModernBadge> createState() => _VooRailModernBadgeState();
}

class _VooRailModernBadgeState extends State<VooRailModernBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    // Animate in on first build
    _controller.forward();
  }

  @override
  void didUpdateWidget(VooRailModernBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Pulse animation when badge count changes
    if (oldWidget.item.badgeCount != widget.item.badgeCount ||
        oldWidget.item.badgeText != widget.item.badgeText) {
      _controller.forward(from: 0.5);
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

    String badgeText;
    if (widget.item.badgeCount != null) {
      badgeText =
          widget.item.badgeCount! > 99 ? '99+' : widget.item.badgeCount.toString();
    } else if (widget.item.badgeText != null) {
      badgeText = widget.item.badgeText!;
    } else if (widget.item.showDot) {
      return ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: context.vooSize.badgeMedium,
          height: context.vooSize.badgeMedium,
          decoration: BoxDecoration(
            color: widget.item.badgeColor ?? theme.colorScheme.error,
            shape: BoxShape.circle,
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: widget.extended
              ? context.vooSpacing.sm
              : context.vooSpacing.sm - context.vooSpacing.xxs,
          vertical: context.vooSpacing.xxs,
        ),
        decoration: BoxDecoration(
          color: widget.item.badgeColor ?? theme.colorScheme.error,
          borderRadius: BorderRadius.circular(context.vooRadius.lg),
        ),
        child: Text(
          badgeText,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onError,
            fontWeight: FontWeight.w600,
            fontSize: widget.extended ? 11 : 10,
          ),
        ),
      ),
    );
  }
}
