import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/src/domain/entities/quick_action.dart';

/// A single action tile in the quick actions list
class VooQuickActionTile extends StatefulWidget {
  /// The quick action data
  final VooQuickAction action;

  /// Style configuration
  final VooQuickActionsStyle style;

  /// Callback when tapped
  final VoidCallback onTap;

  const VooQuickActionTile({
    super.key,
    required this.action,
    required this.style,
    required this.onTap,
  });

  @override
  State<VooQuickActionTile> createState() => _VooQuickActionTileState();
}

class _VooQuickActionTileState extends State<VooQuickActionTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final action = widget.action;
    final style = widget.style;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Opacity(
        opacity: action.isEnabled ? 1.0 : 0.5,
        child: InkWell(
          onTap: action.isEnabled
              ? () {
                  HapticFeedback.lightImpact();
                  widget.onTap();
                }
              : null,
          child: Container(
            padding: style.itemPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: _isHovered
                ? (style.hoverColor ?? colorScheme.surfaceContainerHighest)
                : null,
            child: Row(
              children: [
                // Icon
                action.iconWidget ??
                    Icon(
                      action.icon ?? Icons.star,
                      size: style.iconSize ?? 20,
                      color: action.isDangerous
                          ? (style.dangerColor ?? colorScheme.error)
                          : (action.iconColor ?? colorScheme.onSurfaceVariant),
                    ),
                const SizedBox(width: 12),

                // Label and description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        action.label,
                        style: style.labelStyle ?? theme.textTheme.bodyMedium?.copyWith(
                          color: action.isDangerous
                              ? (style.dangerColor ?? colorScheme.error)
                              : colorScheme.onSurface,
                        ),
                      ),
                      if (action.description != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          action.description!,
                          style: style.descriptionStyle ??
                              theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Shortcut
                if (action.shortcut != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      action.shortcut!,
                      style: style.shortcutStyle ?? theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),

                // Arrow for nested menus
                if (action.hasChildren)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
