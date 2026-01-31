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

  /// Optional title displayed at the top of the menu
  final String? title;

  /// Whether to show a close button in the header
  final bool showCloseButton;

  /// Callback when the close button is tapped
  final VoidCallback? onClose;

  /// Padding for the actions content area.
  /// Defaults to `EdgeInsets.all(16)` for grid layout and `EdgeInsets.symmetric(vertical: 8)` for list layout.
  final EdgeInsetsGeometry? contentPadding;

  /// Spacing between grid items. Only used when useGridLayout is true. Defaults to 8.
  final double gridSpacing;

  /// Aspect ratio (width / height) for grid items. Only used when useGridLayout is true.
  /// Defaults to 1.0 (square items).
  final double gridChildAspectRatio;

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
    this.title,
    this.showCloseButton = false,
    this.onClose,
    this.contentPadding,
    this.gridSpacing = 8.0,
    this.gridChildAspectRatio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveStyle = style ?? const VooQuickActionsStyle();
    final hasHeader = title != null || showCloseButton;

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasHeader)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
                child: Row(
                  children: [
                    if (title != null)
                      Expanded(
                        child: Text(
                          title!,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    else
                      const Spacer(),
                    if (showCloseButton)
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: onClose,
                        iconSize: 20,
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
                ),
              ),
            Flexible(
              child: useGridLayout
                  ? VooQuickActionsGridLayout(
                      style: effectiveStyle,
                      width: width,
                      gridColumns: gridColumns,
                      showLabelsInGrid: showLabelsInGrid,
                      actions: actions,
                      onActionTap: onActionTap,
                      onReorderActions: onReorderActions,
                      padding: contentPadding,
                      spacing: gridSpacing,
                      childAspectRatio: gridChildAspectRatio,
                    )
                  : VooQuickActionsListLayout(
                      style: effectiveStyle,
                      actions: actions,
                      actionBuilder: actionBuilder,
                      onActionTap: onActionTap,
                      onReorderActions: onReorderActions,
                      padding: contentPadding,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
