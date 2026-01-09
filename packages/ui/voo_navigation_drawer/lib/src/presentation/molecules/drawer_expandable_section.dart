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

    // Use config colors if provided, otherwise fall back to theme
    final sectionColor = config.unselectedItemColor ?? theme.colorScheme.onSurface;

    return Column(
      children: [
        MouseRegion(
          onEnter: (_) => onHoverChanged(item.id, true),
          onExit: (_) => onHoverChanged(item.id, false),
          child: InkWell(
            onTap: () => onItemTap(item),
            borderRadius: BorderRadius.circular(context.vooRadius.md),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: EdgeInsets.only(bottom: 1),
              padding: EdgeInsets.symmetric(
                horizontal: context.vooSpacing.xs + 2,
                vertical: context.vooSpacing.xxs + 2,
              ),
              decoration: BoxDecoration(
                color: isHovered
                    ? sectionColor.withValues(alpha: 0.04)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(context.vooRadius.md),
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
                          color: sectionColor,
                          size: 18,
                        );
                      },
                    )
                  else
                    Icon(
                      item.icon,
                      color: sectionColor,
                      size: 18,
                    ),
                  SizedBox(width: context.vooSpacing.xs),
                  Expanded(
                    child: Text(
                      item.label,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: sectionColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
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
                            Icons.keyboard_arrow_down,
                            color: sectionColor.withValues(alpha: 0.5),
                            size: 16,
                          ),
                        );
                      },
                    )
                  else
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: sectionColor.withValues(alpha: 0.5),
                      size: 16,
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
