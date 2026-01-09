import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation_drawer/src/presentation/molecules/drawer_child_navigation_item.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Expandable section widget for drawer navigation with children
class VooDrawerExpandableSection extends StatelessWidget {
  /// The navigation item with children
  final VooNavigationItem item;

  /// Navigation configuration
  final VooNavigationConfig config;

  /// Currently selected item ID
  final String selectedId;

  /// Callback when an item is tapped
  final void Function(VooNavigationItem item) onItemTap;

  /// Map of hovered item states
  final Map<String, bool> hoveredItems;

  /// Callback to set hover state
  final void Function(String itemId, bool isHovered) onHoverChanged;

  /// Expansion animation controller
  final AnimationController? expansionController;

  /// Expansion animation
  final Animation<double>? expansionAnimation;

  const VooDrawerExpandableSection({
    super.key,
    required this.item,
    required this.config,
    required this.selectedId,
    required this.onItemTap,
    required this.hoveredItems,
    required this.onHoverChanged,
    this.expansionController,
    this.expansionAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isHovered = hoveredItems[item.id] == true;

    return Column(
      children: [
        MouseRegion(
          onEnter: (_) => onHoverChanged(item.id, true),
          onExit: (_) => onHoverChanged(item.id, false),
          child: InkWell(
            onTap: () => onItemTap(item),
            borderRadius: BorderRadius.circular(context.vooRadius.lg),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(bottom: context.vooSpacing.xs),
              padding: EdgeInsets.symmetric(
                horizontal: context.vooSpacing.md,
                vertical: context.vooSpacing.sm + context.vooSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: isHovered
                    ? theme.colorScheme.onSurface.withValues(alpha: 0.05)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(context.vooRadius.lg),
              ),
              child: Row(
                children: [
                  // Animate icon change with the expansion
                  if (expansionController != null)
                    AnimatedBuilder(
                      animation: expansionController!,
                      builder: (context, child) {
                        final isExpanded = expansionController!.value > 0.5;
                        return Icon(
                          isExpanded
                              ? item.selectedIcon ?? item.icon
                              : item.icon,
                          color: theme.colorScheme.onSurface,
                          size: context.vooSize.checkboxSize,
                        );
                      },
                    )
                  else
                    Icon(
                      item.icon,
                      color: theme.colorScheme.onSurface,
                      size: context.vooSize.checkboxSize,
                    ),
                  SizedBox(
                    width: context.vooSpacing.sm + context.vooSpacing.xs,
                  ),
                  Expanded(
                    child: Text(
                      item.label,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  // Smoothly animate the chevron rotation with expansion
                  if (expansionController != null)
                    AnimatedBuilder(
                      animation: expansionController!,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: expansionController!.value * 1.5708, // 90 degrees in radians
                          child: Icon(
                            Icons.chevron_right,
                            color: theme.colorScheme.onSurface,
                            size: context.vooSize.checkboxSize,
                          ),
                        );
                      },
                    )
                  else
                    Icon(
                      Icons.chevron_right,
                      color: theme.colorScheme.onSurface,
                      size: context.vooSize.checkboxSize,
                    ),
                ],
              ),
            ),
          ),
        ),

        // Animated expansion for children
        if (expansionController != null && expansionAnimation != null)
          SizeTransition(
            sizeFactor: expansionAnimation!,
            child: Column(
              children: item.children!
                  .map(
                    (child) => VooDrawerChildNavigationItem(
                      item: child,
                      config: config,
                      selectedId: selectedId,
                      onItemTap: onItemTap,
                      isHovered: hoveredItems[child.id] == true,
                      onHoverChanged: (isHovered) =>
                          onHoverChanged(child.id, isHovered),
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }
}
