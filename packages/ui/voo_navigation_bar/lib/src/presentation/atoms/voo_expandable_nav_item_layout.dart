import 'package:flutter/material.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';
import 'package:voo_navigation_bar/src/presentation/molecules/voo_expandable_nav_item.dart';

/// Shared layout constants for expandable nav items.
/// Using atomic design to ensure consistency across all nav item types.
class VooExpandableNavItemLayout {
  VooExpandableNavItemLayout._();

  /// Circle size for nav items
  static double get circleSize => VooNavigationTokens.expandableNavSelectedCircleSize;

  /// Padding around the circle
  static const double circlePadding = 2.0;

  /// Spacing between circle and label
  static const double spacing = 6.0;

  /// Padding at the text edge of the expanded item
  static const double textPadding = 10.0;

  /// Container height based on circle size and padding
  static double get containerHeight => circleSize + (circlePadding * 2);

  /// Measures the width needed for a label
  static double measureLabelWidth(String label, double maxWidth) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(fontSize: VooNavigationTokens.expandableNavLabelFontSize, fontWeight: VooNavigationTokens.expandableNavLabelFontWeight),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    return (textPainter.width.ceilToDouble() + 2).clamp(0.0, maxWidth);
  }

  /// Builds the circle container that holds the icon or avatar
  static Widget buildCircle({required Widget child, required Color color}) {
    return Container(
      width: circleSize,
      height: circleSize,
      margin: const EdgeInsets.all(circlePadding),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Center(child: child),
    );
  }

  /// Builds the label widget with proper styling
  static Widget buildLabel({required String text, required double opacity, required Color color}) {
    return Opacity(
      opacity: opacity,
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: VooNavigationTokens.expandableNavLabelFontSize, fontWeight: VooNavigationTokens.expandableNavLabelFontWeight),
        maxLines: 1,
        overflow: TextOverflow.clip,
      ),
    );
  }

  /// Builds the row children based on label position.
  /// This is the single source of truth for nav item layout.
  static List<Widget> buildRowChildren({
    required Widget circle,
    required Widget label,
    required double animatedLabelWidth,
    required double animatedSpacing,
    required double animatedTextPadding,
    required VooExpandableLabelPosition labelPosition,
  }) {
    final isLabelStart = labelPosition == VooExpandableLabelPosition.start;

    if (isLabelStart) {
      // Label on left, circle on right (items to the RIGHT of action button)
      return [
        SizedBox(width: animatedTextPadding),
        SizedBox(
          width: animatedLabelWidth,
          child: Align(alignment: Alignment.centerRight, child: label),
        ),
        SizedBox(width: animatedSpacing),
        circle,
      ];
    } else {
      // Circle on left, label on right (items to the LEFT of action button)
      return [
        circle,
        SizedBox(width: animatedSpacing),
        SizedBox(
          width: animatedLabelWidth,
          child: Align(alignment: Alignment.centerLeft, child: label),
        ),
        SizedBox(width: animatedTextPadding),
      ];
    }
  }

  /// Builds the outer container with background decoration
  static Widget buildContainer({required List<Widget> rowChildren, required double progress, required Color selectedBackgroundColor}) {
    return Container(
      height: containerHeight,
      decoration: BoxDecoration(
        color: progress > 0 ? selectedBackgroundColor.withValues(alpha: progress) : Colors.transparent,
        borderRadius: BorderRadius.circular(containerHeight / 2),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: rowChildren),
    );
  }
}
