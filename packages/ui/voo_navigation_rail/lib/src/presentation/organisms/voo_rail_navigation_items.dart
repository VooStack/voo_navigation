import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_rail/src/presentation/molecules/voo_rail_navigation_item.dart';
import 'package:voo_navigation_rail/src/presentation/molecules/voo_rail_section_header.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Navigation items list for rail layout
class VooRailNavigationItems extends StatelessWidget {
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

  const VooRailNavigationItems({
    super.key,
    required this.config,
    required this.selectedId,
    required this.extended,
    required this.onItemSelected,
    required this.itemAnimationControllers,
  });

  @override
  Widget build(BuildContext context) {
    final visibleItems = config.visibleItems;

    // Show loading widget if provided and config indicates loading
    if (config.loadingWidget != null && visibleItems.isEmpty) {
      return config.loadingWidget!;
    }

    // Show empty state if no items
    if (visibleItems.isEmpty) {
      return config.emptyStateWidget ?? _RailDefaultEmptyState(extended: extended);
    }

    final widgets = <Widget>[];

    for (int i = 0; i < visibleItems.length; i++) {
      final item = visibleItems[i];

      // Handle section headers
      if (item.hasChildren && config.groupItemsBySections) {
        final childWidgets = <Widget>[];
        if (item.isExpanded && item.children != null) {
          for (final child in item.children!) {
            childWidgets.add(
              VooRailNavigationItem(
                item: child,
                isSelected: child.id == selectedId,
                extended: extended,
                onTap: () => onItemSelected(child.id),
                animationController: itemAnimationControllers[child.id],
                selectedItemColor: config.selectedItemColor,
                unselectedItemColor: config.unselectedItemColor,
              ),
            );
          }
        }

        widgets.add(VooRailSectionHeader(
          item: item,
          extended: extended,
          children: childWidgets,
        ));
      } else {
        widgets.add(
          VooRailNavigationItem(
            item: item,
            isSelected: item.id == selectedId,
            extended: extended,
            onTap: () => onItemSelected(item.id),
            animationController: itemAnimationControllers[item.id],
            selectedItemColor: config.selectedItemColor,
            unselectedItemColor: config.unselectedItemColor,
          ),
        );
      }

      // Add minimal spacing between items
      if (i < visibleItems.length - 1) {
        widgets.add(SizedBox(height: context.vooSpacing.xxs / 2));
      }
    }

    return Column(children: widgets);
  }
}

class _RailDefaultEmptyState extends StatelessWidget {
  final bool extended;

  const _RailDefaultEmptyState({required this.extended});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(context.vooSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.folder_open_outlined,
            size: extended ? 48 : 24,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          if (extended) ...[
            SizedBox(height: context.vooSpacing.sm),
            Text(
              'No items',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
