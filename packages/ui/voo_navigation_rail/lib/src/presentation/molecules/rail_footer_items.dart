import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_rail/src/presentation/molecules/voo_rail_navigation_item.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Footer items widget for the navigation rail (Settings, Integrations, Help, etc.)
class VooRailFooterItems extends StatelessWidget {
  /// Navigation configuration
  final VooNavigationConfig config;

  /// Currently selected item ID
  final String selectedId;

  /// Whether the rail is extended
  final bool extended;

  /// Callback when an item is selected
  final void Function(String itemId) onItemSelected;

  /// Animation controllers for items
  final Map<String, AnimationController> itemAnimationControllers;

  const VooRailFooterItems({
    super.key,
    required this.config,
    required this.selectedId,
    required this.extended,
    required this.onItemSelected,
    required this.itemAnimationControllers,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final footerItems = config.visibleFooterItems;

    if (footerItems.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.vooSpacing.xs,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Divider above footer items
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: context.vooSpacing.sm,
              horizontal: context.vooSpacing.xs,
            ),
            child: Divider(
              height: 1,
              thickness: 1,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          // Footer navigation items
          ...footerItems.map(
            (item) => VooRailNavigationItem(
              item: item,
              isSelected: item.id == selectedId,
              extended: extended,
              onTap: () => onItemSelected(item.id),
              animationController: itemAnimationControllers[item.id],
              selectedItemColor: config.selectedItemColor,
              unselectedItemColor: config.unselectedItemColor,
            ),
          ),
        ],
      ),
    );
  }
}
