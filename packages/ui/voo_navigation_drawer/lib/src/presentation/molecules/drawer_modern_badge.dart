import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_destination.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Modern badge widget for drawer navigation items with animations
class VooDrawerModernBadge extends StatefulWidget {
  /// The navigation item
  final VooNavigationDestination item;

  /// Whether the parent item is selected
  final bool isSelected;

  const VooDrawerModernBadge({
    super.key,
    required this.item,
    required this.isSelected,
  });

  @override
  State<VooDrawerModernBadge> createState() => _VooDrawerModernBadgeState();
}

class _VooDrawerModernBadgeState extends State<VooDrawerModernBadge>
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
  void didUpdateWidget(VooDrawerModernBadge oldWidget) {
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: context.vooSpacing.sm,
          vertical: context.vooSpacing.xxs,
        ),
        decoration: BoxDecoration(
          color: widget.isSelected
              ? (widget.item.badgeColor ?? theme.colorScheme.primary)
              : theme.colorScheme.onSurface.withValues(alpha: 0.2),
          borderRadius: context.vooRadius.card,
        ),
        child: Text(
          badgeText,
          style: theme.textTheme.labelSmall?.copyWith(
            color: widget.isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface.withValues(alpha: 0.9),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
