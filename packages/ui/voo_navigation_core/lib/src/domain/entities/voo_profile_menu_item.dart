import 'package:flutter/material.dart';

/// Menu item for profile dropdown
class VooProfileMenuItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isDestructive;

  const VooProfileMenuItem({
    required this.icon,
    required this.label,
    this.onTap,
    this.isDestructive = false,
  });
}
