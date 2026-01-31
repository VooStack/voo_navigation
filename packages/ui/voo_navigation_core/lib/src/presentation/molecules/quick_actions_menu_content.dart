import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/quick_action.dart';
import 'package:voo_navigation_core/src/presentation/molecules/quick_actions_grid_layout.dart';
import 'package:voo_navigation_core/src/presentation/molecules/quick_actions_list_layout.dart';

/// Menu content for quick actions dropdown
class VooQuickActionsMenuContent extends StatelessWidget {
  /// Style configuration
  final VooQuickActionsStyle? style;

  /// Width of the dropdown
  final double width;

  /// Whether to use grid layout (default: false)
  final bool useGridLayout;

  /// Number of columns in grid layout (default: 4, only used when useGridLayout is true)
  final int gridColumns;

  /// Whether to show labels in grid layout (default: true, only used when useGridLayout is true)
  final bool showLabelsInGrid;

  /// List of quick actions
  final List<VooQuickAction> actions;

  /// Custom action builder
  final Widget Function(VooQuickAction, VoidCallback onTap)? actionBuilder;

  /// Callback when an action is tapped
  final void Function(VooQuickAction) onActionTap;

  /// Callback when actions are reordered. If provided, enables drag-to-reorder.
  final void Function(List<VooQuickAction> reorderedActions)? onReorderActions;

  const VooQuickActionsMenuContent({
    super.key,
    this.style,
    required this.width,
    this.useGridLayout = false,
    this.gridColumns = 4,
    this.showLabelsInGrid = true,
    required this.actions,
    this.actionBuilder,
    required this.onActionTap,
    this.onReorderActions,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveStyle = style ?? const VooQuickActionsStyle();

    return Material(
      elevation: 8,
      borderRadius: effectiveStyle.borderRadius ?? BorderRadius.circular(16),
      color: effectiveStyle.backgroundColor ?? colorScheme.surface,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: effectiveStyle.borderRadius ?? BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: useGridLayout
            ? VooQuickActionsGridLayout(
                style: effectiveStyle,
                width: width,
                gridColumns: gridColumns,
                showLabelsInGrid: showLabelsInGrid,
                actions: actions,
                onActionTap: onActionTap,
                onReorderActions: onReorderActions,
              )
            : VooQuickActionsListLayout(
                style: effectiveStyle,
                actions: actions,
                actionBuilder: actionBuilder,
                onActionTap: onActionTap,
                onReorderActions: onReorderActions,
              ),
      ),
    );
  }
}
