import 'package:flutter/material.dart';

/// Avatar initials or placeholder icon widget
class VooAvatarInitialsPlaceholder extends StatelessWidget {
  /// Initials to display
  final String? initials;

  /// Background color
  final Color bgColor;

  /// Foreground/text color
  final Color fgColor;

  /// Border radius
  final BorderRadius borderRadius;

  /// Size of the avatar
  final double size;

  /// Placeholder icon when no initials
  final IconData? placeholderIcon;

  const VooAvatarInitialsPlaceholder({
    super.key,
    required this.initials,
    required this.bgColor,
    required this.fgColor,
    required this.borderRadius,
    required this.size,
    this.placeholderIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: borderRadius,
      ),
      alignment: Alignment.center,
      child: initials != null && initials!.isNotEmpty
          ? Text(
              initials!,
              style: TextStyle(
                color: fgColor,
                fontSize: size * 0.4,
                fontWeight: FontWeight.w600,
              ),
            )
          : Icon(
              placeholderIcon ?? Icons.person,
              size: size * 0.5,
              color: fgColor,
            ),
    );
  }
}
