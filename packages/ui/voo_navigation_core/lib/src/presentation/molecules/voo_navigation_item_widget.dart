import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_destination.dart';

/// Reusable navigation item widget
class VooNavigationDestinationWidget extends StatelessWidget {
  final VooNavigationDestination item;
  final bool isSelected;
  final VoidCallback? onTap;

  const VooNavigationDestinationWidget({
    super.key,
    required this.item,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => ListTile(
    leading: isSelected ? item.effectiveSelectedIcon : item.icon,
    title: Text(item.label),
    selected: isSelected,
    onTap: item.isEnabled ? onTap : null,
  );
}
