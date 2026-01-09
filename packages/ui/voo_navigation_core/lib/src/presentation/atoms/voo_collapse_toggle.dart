import 'package:flutter/material.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Animated collapse/expand toggle button for navigation drawer/rail.
///
/// Shows `<<` when expanded (click to collapse) and `>>` when collapsed (click to expand).
class VooCollapseToggle extends StatefulWidget {
  /// Whether the navigation is currently expanded (showing drawer)
  final bool isExpanded;

  /// Callback when toggle is pressed
  final VoidCallback onToggle;

  /// Custom icon for expanded state (default: left arrows to indicate "collapse")
  final IconData? expandedIcon;

  /// Custom icon for collapsed state (default: right arrows to indicate "expand")
  final IconData? collapsedIcon;

  /// Tooltip for expanded state
  final String? expandedTooltip;

  /// Tooltip for collapsed state
  final String? collapsedTooltip;

  const VooCollapseToggle({
    super.key,
    required this.isExpanded,
    required this.onToggle,
    this.expandedIcon,
    this.collapsedIcon,
    this.expandedTooltip,
    this.collapsedTooltip,
  });

  @override
  State<VooCollapseToggle> createState() => _VooCollapseToggleState();
}

class _VooCollapseToggleState extends State<VooCollapseToggle> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.vooSpacing;
    final radius = context.vooRadius;

    final tooltip = widget.isExpanded
        ? (widget.expandedTooltip ?? 'Collapse sidebar')
        : (widget.collapsedTooltip ?? 'Expand sidebar');

    // Expanded = show left arrows (<<) meaning "click to collapse"
    // Collapsed = show right arrows (>>) meaning "click to expand"
    final icon = widget.isExpanded
        ? (widget.expandedIcon ?? Icons.keyboard_double_arrow_left_rounded)
        : (widget.collapsedIcon ?? Icons.keyboard_double_arrow_right_rounded);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Subtle divider above the toggle
        Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing.md),
          child: Divider(
            height: 1,
            thickness: 1,
            color: theme.dividerColor.withValues(alpha: 0.1),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(spacing.sm),
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: Tooltip(
              message: tooltip,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onToggle,
                  borderRadius: BorderRadius.circular(radius.md),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _isHovered
                          ? theme.colorScheme.primary.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(radius.md),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        icon,
                        key: ValueKey(widget.isExpanded),
                        color: _isHovered
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
