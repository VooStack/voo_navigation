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

  const VooQuickActionsListLayout({
    super.key,
    required this.style,
    required this.actions,
    this.actionBuilder,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];

        if (action.isDivider) {
          return const Divider(height: 8);
        }

        if (actionBuilder != null) {
          return actionBuilder!(
            action,
            () => onActionTap(action),
          );
        }

        return VooQuickActionTile(
          action: action,
          style: style,
          onTap: () => onActionTap(action),
        );
      },
    );
  }
}
