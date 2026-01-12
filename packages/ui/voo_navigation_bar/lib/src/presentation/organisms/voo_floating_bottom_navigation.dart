import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_item.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Floating bottom navigation bar with pill shape design
class VooFloatingBottomNavigation extends StatelessWidget {
  final VooNavigationConfig config;
  final String selectedId;
  final void Function(String itemId) onNavigationItemSelected;
  final double? bottomMargin;
  final Color? backgroundColor;
  final bool enableHapticFeedback;

  const VooFloatingBottomNavigation({
    super.key,
    required this.config,
    required this.selectedId,
    required this.onNavigationItemSelected,
    this.bottomMargin,
    this.backgroundColor,
    this.enableHapticFeedback = true,
  });

  @override
  Widget build(BuildContext context) {
    final items = config.mobilePriorityItems;
    final spacing = context.vooSpacing;

    if (items.isEmpty) return const SizedBox.shrink();

    final bgColor = backgroundColor ?? Colors.black;
    final margin = bottomMargin ?? (spacing.lg > 0 ? spacing.lg : 24.0);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, 0, 24, margin),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: items.map((item) {
              final isSelected = item.id == selectedId;
              return _NavItem(
                item: item,
                isSelected: isSelected,
                onTap: () {
                  if (enableHapticFeedback) {
                    HapticFeedback.selectionClick();
                  }
                  onNavigationItemSelected(item.id);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final VooNavigationItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 56,
        height: 56,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? item.effectiveSelectedIcon : item.icon,
              color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.5),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
