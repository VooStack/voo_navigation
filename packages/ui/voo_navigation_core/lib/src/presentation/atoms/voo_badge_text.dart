import 'package:flutter/material.dart';

/// Text badge widget for displaying counts or labels
class VooBadgeText extends StatelessWidget {
  /// Background color
  final Color bgColor;

  /// Foreground/text color
  final Color fgColor;

  /// Text to display
  final String? displayText;

  /// Internal padding
  final EdgeInsets? padding;

  /// Minimum width
  final double minWidth;

  /// Border radius
  final BorderRadius? borderRadius;

  /// Optional border
  final BoxBorder? border;

  /// Optional shadow
  final List<BoxShadow>? boxShadow;

  /// Text style
  final TextStyle? textStyle;

  const VooBadgeText({
    super.key,
    required this.bgColor,
    required this.fgColor,
    required this.displayText,
    required this.minWidth,
    this.padding,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (displayText == null || displayText!.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      constraints: BoxConstraints(minWidth: minWidth, minHeight: minWidth),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: borderRadius ?? BorderRadius.circular(minWidth / 2),
        border: border,
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: bgColor.withValues(alpha: 0.4),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
      ),
      alignment: Alignment.center,
      child: Text(
        displayText!,
        style: textStyle ??
            theme.textTheme.labelSmall?.copyWith(
              color: fgColor,
              fontWeight: FontWeight.w600,
              fontSize: 10,
              height: 1.2,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
