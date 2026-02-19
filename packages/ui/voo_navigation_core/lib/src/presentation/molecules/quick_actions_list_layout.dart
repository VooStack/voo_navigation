import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/quick_action.dart';
import 'package:voo_navigation_core/src/presentation/molecules/quick_action_tile.dart';

/// List layout for quick actions
class VooQuickActionsListLayout extends StatelessWidget {
  /// Style configuration
  final VooQuickActionsStyle style;

  /// List of quick actions
  final List<VooQuickAction> actions;

  /// Custom action builder
  final Widget Function(VooQuickAction, VoidCallback onTap)? actionBuilder;

  /// Callback when an action is tapped
  final void Function(VooQuickAction) onActionTap;

  /// Callback when actions are reordered. If provided, enables drag-to-reorder.
  final void Function(List<VooQuickAction> reorderedActions)? onReorderActions;

  /// Padding for the list content. Defaults to `EdgeInsets.symmetric(vertical: 8)`.
  final EdgeInsetsGeometry? padding;

  /// Whether items should expand to fill available space.
  /// When true, the list will not shrink wrap and items can expand.
  /// Defaults to false.
  final bool expandItems;

  const VooQuickActionsListLayout({
    super.key,
    required this.style,
    required this.actions,
    this.actionBuilder,
    required this.onActionTap,
    this.onReorderActions,
    this.padding,
    this.expandItems = false,
  });

  Widget _buildItem(VooQuickAction action, int index) {
    if (action.isDivider) {
      return Divider(key: ValueKey('divider_$index'), height: 8);
    }

    if (actionBuilder != null) {
      return KeyedSubtree(
        key: ValueKey(action.id),
        child: actionBuilder!(
          action,
          () {
            action.onTap?.call();
            onActionTap(action);
          },
        ),
      );
    }

    return VooQuickActionTile(
      key: ValueKey(action.id),
      action: action,
      style: style,
      onTap: () {
        action.onTap?.call();
        onActionTap(action);
      },
    );
  }

  EdgeInsets get _effectivePadding {
    final p = padding ?? const EdgeInsets.symmetric(vertical: 8);
    return p.resolve(TextDirection.ltr);
  }

  @override
  Widget build(BuildContext context) {
    if (onReorderActions != null) {
      return ReorderableListView.builder(
        shrinkWrap: !expandItems,
        padding: _effectivePadding,
        itemCount: actions.length,
        onReorder: (oldIndex, newIndex) {
          final reordered = List<VooQuickAction>.from(actions);
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final item = reordered.removeAt(oldIndex);
          reordered.insert(newIndex, item);
          onReorderActions!(reordered);
        },
        itemBuilder: (context, index) => _buildItem(actions[index], index),
      );
    }

    return ListView.builder(
      shrinkWrap: !expandItems,
      padding: _effectivePadding,
      itemCount: actions.length,
      itemBuilder: (context, index) => _buildItem(actions[index], index),
    );
  }
}
