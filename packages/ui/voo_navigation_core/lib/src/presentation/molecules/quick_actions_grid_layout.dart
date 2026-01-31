import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/src/domain/entities/quick_action.dart';

/// Grid layout for quick actions with optional reordering support.
/// Uses GridView for proper column handling and scrolling.
class VooQuickActionsGridLayout extends StatefulWidget {
  /// Style configuration
  final VooQuickActionsStyle style;

  /// Width of the grid container (used for calculations)
  final double width;

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

  /// Padding for the grid content. Defaults to `EdgeInsets.all(16)`.
  final EdgeInsetsGeometry? padding;

  /// Spacing between grid items. Defaults to 8.
  final double spacing;

  /// Aspect ratio (width / height) for grid items. Defaults to 1.0 (square).
  final double childAspectRatio;

  const VooQuickActionsGridLayout({
    super.key,
    required this.style,
    required this.width,
    required this.gridColumns,
    required this.showLabelsInGrid,
    required this.actions,
    required this.onActionTap,
    this.onReorderActions,
    this.padding,
    this.spacing = 8.0,
    this.childAspectRatio = 1.0,
  });

  @override
  State<VooQuickActionsGridLayout> createState() =>
      _VooQuickActionsGridLayoutState();
}

class _VooQuickActionsGridLayoutState extends State<VooQuickActionsGridLayout> {
  String? _draggingId;
  String? _dragOverId;

  EdgeInsets get _effectivePadding =>
      (widget.padding ?? const EdgeInsets.all(16)).resolve(TextDirection.ltr);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final visibleActions = widget.actions.where((a) => !a.isDivider).toList();

    return GridView.builder(
      shrinkWrap: true,
      padding: _effectivePadding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.gridColumns,
        crossAxisSpacing: widget.spacing,
        mainAxisSpacing: widget.spacing,
        childAspectRatio: widget.childAspectRatio,
      ),
      itemCount: visibleActions.length,
      itemBuilder: (context, index) {
        final action = visibleActions[index];
        return _buildActionItem(action, theme, colorScheme);
      },
    );
  }

  Widget _buildActionItem(
    VooQuickAction action,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final canReorder = widget.onReorderActions != null;

    final child = _buildGridItem(
      action: action,
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
            child: SizedBox(
              width: 100,
              height: 100,
              child: _buildGridItem(
                action: action,
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
    required ThemeData theme,
    required ColorScheme colorScheme,
    required bool isDragging,
    required bool isDragOver,
    bool isFeedback = false,
  }) {
    // Determine icon background color
    final iconBgColor = action.gridIconBackgroundColor ??
        (action.isDangerous
            ? (widget.style.dangerColor ?? colorScheme.error).withValues(alpha: 0.1)
            : colorScheme.surfaceContainerHighest);

    // Determine item background color (default to subtle surface color)
    final itemBgColor = action.gridBackgroundColor ?? colorScheme.surfaceContainerLow;

    // Per-action showLabel overrides global showLabelsInGrid
    final shouldShowLabel = action.showLabel ?? widget.showLabelsInGrid;

    return Material(
      color: itemBgColor,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: iconBgColor,
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
                  if (shouldShowLabel) ...[
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
      ),
    );
  }
}
