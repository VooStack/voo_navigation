import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/quick_action.dart';
import 'package:voo_navigation_core/src/presentation/molecules/quick_actions_grid_layout.dart';
import 'package:voo_navigation_core/src/presentation/molecules/quick_actions_list_layout.dart';

/// Menu content for quick actions dropdown
class VooQuickActionsMenuContent extends StatelessWidget {
  /// Style configuration
  final VooQuickActionsStyle style;

  /// Width of the dropdown
  final double width;

  /// Whether to use grid layout
  final bool useGridLayout;

  /// Number of columns in grid layout
  final int gridColumns;

  /// Whether to show labels in grid layout
  final bool showLabelsInGrid;

  /// List of quick actions
  final List<VooQuickAction> actions;

  /// Custom action builder
  final Widget Function(VooQuickAction, VoidCallback onTap)? actionBuilder;

  /// Callback when an action is tapped
  final void Function(VooQuickAction) onActionTap;

  const VooQuickActionsMenuContent({
    super.key,
    required this.style,
    required this.width,
    required this.useGridLayout,
    required this.gridColumns,
    required this.showLabelsInGrid,
    required this.actions,
    this.actionBuilder,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      elevation: 8,
      borderRadius: style.borderRadius ?? BorderRadius.circular(16),
      color: style.backgroundColor ?? colorScheme.surface,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: style.borderRadius ?? BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: useGridLayout
            ? VooQuickActionsGridLayout(
                style: style,
                gridColumns: gridColumns,
                showLabelsInGrid: showLabelsInGrid,
                actions: actions,
                onActionTap: onActionTap,
              )
            : VooQuickActionsListLayout(
                style: style,
                actions: actions,
                actionBuilder: actionBuilder,
                onActionTap: onActionTap,
              ),
      ),
    );
  }
}
