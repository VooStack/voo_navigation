import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/src/domain/entities/quick_action.dart';

/// Grid layout for quick actions with optional reordering support
class VooQuickActionsGridLayout extends StatefulWidget {
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

  /// Callback when actions are reordered. If provided, enables drag-to-reorder.
  final void Function(List<VooQuickAction> reorderedActions)? onReorderActions;

  const VooQuickActionsGridLayout({
    super.key,
    required this.style,
    required this.gridColumns,
    required this.showLabelsInGrid,
    required this.actions,
    required this.onActionTap,
    this.onReorderActions,
  });

  @override
  State<VooQuickActionsGridLayout> createState() =>
      _VooQuickActionsGridLayoutState();
}

class _VooQuickActionsGridLayoutState extends State<VooQuickActionsGridLayout> {
  String? _draggingId;
  String? _dragOverId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final visibleActions = widget.actions.where((a) => !a.isDivider).toList();
    final canReorder = widget.onReorderActions != null;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: visibleActions.map((action) {
          final itemWidth =
              (widget.style.dropdownWidth ?? (widget.gridColumns * 80.0)) /
                      widget.gridColumns -
                  16;

          final child = _buildGridItem(
            action: action,
            itemWidth: itemWidth,
            theme: theme,
            colorScheme: colorScheme,
            isDragging: _draggingId == action.id,
            isDragOver: _dragOverId == action.id,
          );

          if (!canReorder) {
            return child;
          }

          return DragTarget<VooQuickAction>(
            onWillAcceptWithDetails: (details) {
              if (details.data.id != action.id) {
                setState(() => _dragOverId = action.id);
                return true;
              }
              return false;
            },
            onLeave: (_) {
              setState(() => _dragOverId = null);
            },
            onAcceptWithDetails: (details) {
              setState(() => _dragOverId = null);
              _handleReorder(details.data, action);
            },
            builder: (context, candidateData, rejectedData) {
              return LongPressDraggable<VooQuickAction>(
                data: action,
                delay: const Duration(milliseconds: 150),
                hapticFeedbackOnStart: true,
                onDragStarted: () {
                  HapticFeedback.mediumImpact();
                  setState(() => _draggingId = action.id);
                },
                onDragEnd: (_) {
                  setState(() {
                    _draggingId = null;
                    _dragOverId = null;
                  });
                },
                feedback: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  child: Opacity(
                    opacity: 0.9,
                    child: _buildGridItem(
                      action: action,
                      itemWidth: itemWidth,
                      theme: theme,
                      colorScheme: colorScheme,
                      isDragging: false,
                      isDragOver: false,
                      isFeedback: true,
                    ),
                  ),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.3,
                  child: child,
                ),
                child: child,
              );
            },
          );
        }).toList(),
      ),
    );
  }

  void _handleReorder(VooQuickAction dragged, VooQuickAction target) {
    final reordered = List<VooQuickAction>.from(widget.actions);
    final draggedIndex = reordered.indexWhere((a) => a.id == dragged.id);
    final targetIndex = reordered.indexWhere((a) => a.id == target.id);

    if (draggedIndex == -1 || targetIndex == -1) return;

    reordered.removeAt(draggedIndex);
    reordered.insert(targetIndex, dragged);
    widget.onReorderActions!(reordered);
  }

  Widget _buildGridItem({
    required VooQuickAction action,
    required double itemWidth,
    required ThemeData theme,
    required ColorScheme colorScheme,
    required bool isDragging,
    required bool isDragOver,
    bool isFeedback = false,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: itemWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: isDragOver
            ? Border.all(color: colorScheme.primary, width: 2)
            : null,
      ),
      child: InkWell(
        onTap: action.isEnabled ? () => widget.onActionTap(action) : null,
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
                        ? (widget.style.dangerColor ?? colorScheme.error)
                            .withValues(alpha: 0.1)
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: action.iconWidget ??
                      Icon(
                        action.icon ?? Icons.star,
                        size: widget.style.iconSize ?? 24,
                        color: action.isDangerous
                            ? (widget.style.dangerColor ?? colorScheme.error)
                            : (action.iconColor ?? colorScheme.onSurfaceVariant),
                      ),
                ),
                if (widget.showLabelsInGrid) ...[
                  const SizedBox(height: 8),
                  Text(
                    action.label,
                    style: widget.style.labelStyle ??
                        theme.textTheme.labelSmall?.copyWith(
                          color: action.isDangerous
                              ? (widget.style.dangerColor ?? colorScheme.error)
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
  }
}
