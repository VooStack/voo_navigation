import 'package:flutter/material.dart';

/// Minimal collapse/expand toggle button for navigation drawer/rail.
///
/// A small bordered square button with a sidebar panel icon.
class VooCollapseToggle extends StatefulWidget {
  /// Whether the navigation is currently expanded (showing drawer)
  final bool isExpanded;

  /// Callback when toggle is pressed
  final VoidCallback onToggle;

  /// Custom icon for expanded state
  final IconData? expandedIcon;

  /// Custom icon for collapsed state
  final IconData? collapsedIcon;

  /// Tooltip for expanded state
  final String? expandedTooltip;

  /// Tooltip for collapsed state
  final String? collapsedTooltip;

  /// Custom icon color (uses theme if null)
  final Color? iconColor;

  /// Custom icon color when hovered (uses theme primary if null)
  final Color? hoverColor;

  const VooCollapseToggle({
    super.key,
    required this.isExpanded,
    required this.onToggle,
    this.expandedIcon,
    this.collapsedIcon,
    this.expandedTooltip,
    this.collapsedTooltip,
    this.iconColor,
    this.hoverColor,
  });

  @override
  State<VooCollapseToggle> createState() => _VooCollapseToggleState();
}

class _VooCollapseToggleState extends State<VooCollapseToggle> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final tooltip = widget.isExpanded
        ? (widget.expandedTooltip ?? 'Collapse sidebar')
        : (widget.collapsedTooltip ?? 'Expand sidebar');

    // Use sidebar panel icon - same icon for both states
    final icon = widget.isExpanded
        ? (widget.expandedIcon ?? Icons.view_sidebar_outlined)
        : (widget.collapsedIcon ?? Icons.view_sidebar_outlined);

    final borderColor = _isHovered
        ? theme.colorScheme.outline.withValues(alpha: 0.3)
        : theme.colorScheme.outline.withValues(alpha: 0.2);

    final iconColor = _isHovered
        ? (widget.hoverColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.7))
        : (widget.iconColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.4));

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onToggle,
            borderRadius: BorderRadius.circular(6),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: 1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
