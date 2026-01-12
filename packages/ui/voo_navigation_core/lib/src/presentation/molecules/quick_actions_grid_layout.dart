import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/quick_action.dart';

/// Grid layout for quick actions
class VooQuickActionsGridLayout extends StatelessWidget {
  /// Style configuration
  final VooQuickActionsStyle style;

  /// Number of columns in grid layout
  final int gridColumns;

  /// Whether to show labels in grid layout
  final bool showLabelsInGrid;

  /// List of quick actions
  final List<VooQuickAction> actions;

  /// Callback when an action is tapped
  final void Function(VooQuickAction) onActionTap;

  const VooQuickActionsGridLayout({
    super.key,
    required this.style,
    required this.gridColumns,
    required this.showLabelsInGrid,
    required this.actions,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final visibleActions = actions.where((a) => !a.isDivider).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: visibleActions.map((action) {
          return SizedBox(
            width: (style.dropdownWidth ?? (gridColumns * 80.0)) / gridColumns - 16,
            child: InkWell(
              onTap: action.isEnabled ? () => onActionTap(action) : null,
              borderRadius: BorderRadius.circular(12),
              child: Opacity(
                opacity: action.isEnabled ? 1.0 : 0.5,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: action.isDangerous
                              ? (style.dangerColor ?? colorScheme.error).withValues(alpha: 0.1)
                              : colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: action.iconWidget ??
                            Icon(
                              action.icon ?? Icons.star,
                              size: style.iconSize ?? 24,
                              color: action.isDangerous
                                  ? (style.dangerColor ?? colorScheme.error)
                                  : (action.iconColor ?? colorScheme.onSurfaceVariant),
                            ),
                      ),
                      if (showLabelsInGrid) ...[
                        const SizedBox(height: 8),
                        Text(
                          action.label,
                          style: style.labelStyle ??
                              theme.textTheme.labelSmall?.copyWith(
                                color: action.isDangerous
                                    ? (style.dangerColor ?? colorScheme.error)
                                    : colorScheme.onSurface,
                              ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
