import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/presentation/atoms/voo_badge_dot.dart';
import 'package:voo_navigation_core/src/presentation/atoms/voo_badge_text.dart';
import 'package:voo_navigation_core/src/presentation/atoms/voo_pulsing_status_badge.dart';

/// A versatile badge widget for displaying counts, status indicators, and labels
class VooBadge extends StatelessWidget {
  /// The count to display (will show "99+" for values > 99)
  final int? count;

  /// Text to display (alternative to count)
  final String? text;

  /// Whether to show as a dot indicator
  final bool showDot;

  /// Background color of the badge
  final Color? backgroundColor;

  /// Text/icon color
  final Color? foregroundColor;

  /// Size of the badge (for dot mode)
  final double dotSize;

  /// Minimum width for text/count badges
  final double minWidth;

  /// Border radius
  final BorderRadius? borderRadius;

  /// Border
  final BoxBorder? border;

  /// Shadow
  final List<BoxShadow>? boxShadow;

  /// Padding inside the badge
  final EdgeInsets? padding;

  /// Text style for the badge text
  final TextStyle? textStyle;

  /// Whether the badge is visible
  final bool isVisible;

  /// Animation duration for visibility changes
  final Duration animationDuration;

  /// Position offset when used as an overlay
  final Offset? offset;

  const VooBadge({
    super.key,
    this.count,
    this.text,
    this.showDot = false,
    this.backgroundColor,
    this.foregroundColor,
    this.dotSize = 8,
    this.minWidth = 18,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.padding,
    this.textStyle,
    this.isVisible = true,
    this.animationDuration = const Duration(milliseconds: 200),
    this.offset,
  });

  /// Creates a dot badge
  factory VooBadge.dot({
    Key? key,
    Color? color,
    double size = 8,
    bool isVisible = true,
    Offset? offset,
  }) => VooBadge(
    key: key,
    showDot: true,
    backgroundColor: color,
    dotSize: size,
    isVisible: isVisible,
    offset: offset,
  );

  /// Creates a count badge
  factory VooBadge.count({
    Key? key,
    required int count,
    Color? backgroundColor,
    Color? foregroundColor,
    bool isVisible = true,
    Offset? offset,
  }) => VooBadge(
    key: key,
    count: count,
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    isVisible: count > 0 && isVisible,
    offset: offset,
  );

  /// Creates a text badge
  factory VooBadge.text({
    Key? key,
    required String text,
    Color? backgroundColor,
    Color? foregroundColor,
    bool isVisible = true,
    Offset? offset,
  }) => VooBadge(
    key: key,
    text: text,
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    isVisible: text.isNotEmpty && isVisible,
    offset: offset,
  );

  String? get _displayText {
    if (showDot) return null;
    if (count != null) {
      return count! > 99 ? '99+' : count.toString();
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveBgColor = backgroundColor ?? colorScheme.error;
    final effectiveFgColor = foregroundColor ?? colorScheme.onError;

    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: animationDuration,
      child: AnimatedScale(
        scale: isVisible ? 1.0 : 0.0,
        duration: animationDuration,
        curve: Curves.easeOutBack,
        child: showDot
            ? VooBadgeDot(
                bgColor: effectiveBgColor,
                dotSize: dotSize,
                border: border,
                boxShadow: boxShadow,
              )
            : VooBadgeText(
                bgColor: effectiveBgColor,
                fgColor: effectiveFgColor,
                displayText: _displayText,
                padding: padding,
                minWidth: minWidth,
                borderRadius: borderRadius,
                border: border,
                boxShadow: boxShadow,
                textStyle: textStyle,
              ),
      ),
    );
  }
}

/// A widget that positions a badge on top of its child
class VooBadgeWrapper extends StatelessWidget {
  /// The child widget to wrap
  final Widget child;

  /// The badge to display
  final VooBadge badge;

  /// Alignment of the badge
  final AlignmentGeometry alignment;

  const VooBadgeWrapper({
    super.key,
    required this.child,
    required this.badge,
    this.alignment = Alignment.topRight,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: badge.offset?.dy ?? -4,
          right: badge.offset?.dx ?? -4,
          child: badge,
        ),
      ],
    );
  }
}

/// A status badge for showing online/offline/busy states
class VooStatusBadge extends StatelessWidget {
  /// The status to display
  final VooStatus status;

  /// Size of the status indicator
  final double size;

  /// Whether to show a pulse animation for online status
  final bool showPulse;

  const VooStatusBadge({
    super.key,
    required this.status,
    this.size = 12,
    this.showPulse = true,
  });

  Color _getStatusColor(ColorScheme colorScheme) {
    return switch (status) {
      VooStatus.online => Colors.green,
      VooStatus.away => Colors.orange,
      VooStatus.busy => colorScheme.error,
      VooStatus.offline => colorScheme.outline,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getStatusColor(theme.colorScheme);

    Widget indicator = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.colorScheme.surface,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 4,
          ),
        ],
      ),
    );

    if (showPulse && status == VooStatus.online) {
      indicator = VooPulsingStatusBadge(
        color: color,
        size: size,
        borderColor: theme.colorScheme.surface,
      );
    }

    return indicator;
  }
}

/// Status states for the status badge
enum VooStatus {
  online,
  away,
  busy,
  offline,
}
