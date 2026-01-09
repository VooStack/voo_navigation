import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_theme.dart';
import 'package:voo_navigation_core/src/presentation/atoms/voo_line_indicator.dart';

/// A themed indicator widget that adapts to different visual styles
///
/// Renders the appropriate indicator based on the theme preset:
/// - Pill: Material 3 style rounded background
/// - Glow: Glassmorphism style with shadow glow
/// - Line: Minimal style thin underline
/// - Embossed: Neomorphism style pressed-in indicator
/// - Background: Full background highlight
///
/// ```dart
/// VooThemedIndicator(
///   theme: config.effectiveTheme,
///   isSelected: isCurrentItem,
///   child: Icon(Icons.home),
/// )
/// ```
class VooThemedIndicator extends StatelessWidget {
  /// The navigation theme configuration
  final VooNavigationTheme theme;

  /// Whether the indicator is active/selected
  final bool isSelected;

  /// The content to display (usually icon + label)
  final Widget child;

  /// Custom indicator color (overrides theme)
  final Color? color;

  /// Width of the indicator (for background types)
  final double? width;

  /// Height of the indicator (for background types)
  final double? height;

  /// Position of line indicator
  final VooLineIndicatorPosition linePosition;

  const VooThemedIndicator({
    super.key,
    required this.theme,
    required this.isSelected,
    required this.child,
    this.color,
    this.width,
    this.height,
    this.linePosition = VooLineIndicatorPosition.bottom,
  });

  @override
  Widget build(BuildContext context) {
    if (!isSelected && theme.indicatorStyle != VooThemeIndicatorStyle.background) {
      return child;
    }

    final indicatorColor = color ?? theme.resolveIndicatorColor(context);

    return switch (theme.indicatorStyle) {
      VooThemeIndicatorStyle.pill => _PillIndicator(
          theme: theme,
          isSelected: isSelected,
          indicatorColor: indicatorColor,
          child: child,
        ),
      VooThemeIndicatorStyle.glow => _GlowIndicator(
          theme: theme,
          isSelected: isSelected,
          indicatorColor: indicatorColor,
          child: child,
        ),
      VooThemeIndicatorStyle.line => _LineIndicator(
          theme: theme,
          isSelected: isSelected,
          indicatorColor: indicatorColor,
          linePosition: linePosition,
          child: child,
        ),
      VooThemeIndicatorStyle.embossed => _EmbossedIndicator(
          theme: theme,
          isSelected: isSelected,
          indicatorColor: indicatorColor,
          child: child,
        ),
      VooThemeIndicatorStyle.background => _BackgroundIndicator(
          theme: theme,
          isSelected: isSelected,
          indicatorColor: indicatorColor,
          width: width,
          height: height,
          child: child,
        ),
      VooThemeIndicatorStyle.none => child,
    };
  }
}

class _PillIndicator extends StatelessWidget {
  final VooNavigationTheme theme;
  final bool isSelected;
  final Color indicatorColor;
  final Widget child;

  const _PillIndicator({
    required this.theme,
    required this.isSelected,
    required this.indicatorColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: theme.animationDuration,
      curve: theme.animationCurve,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? indicatorColor.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(theme.indicatorBorderRadius),
      ),
      child: child,
    );
  }
}

class _GlowIndicator extends StatelessWidget {
  final VooNavigationTheme theme;
  final bool isSelected;
  final Color indicatorColor;
  final Widget child;

  const _GlowIndicator({
    required this.theme,
    required this.isSelected,
    required this.indicatorColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: theme.animationDuration,
      curve: theme.animationCurve,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? indicatorColor.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(theme.indicatorBorderRadius),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: indicatorColor.withValues(alpha: 0.25),
                  blurRadius: theme.indicatorGlowBlur,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: indicatorColor.withValues(alpha: 0.1),
                  blurRadius: theme.indicatorGlowBlur * 0.5,
                  spreadRadius: -2,
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}

class _LineIndicator extends StatelessWidget {
  final VooNavigationTheme theme;
  final bool isSelected;
  final Color indicatorColor;
  final VooLineIndicatorPosition linePosition;
  final Widget child;

  const _LineIndicator({
    required this.theme,
    required this.isSelected,
    required this.indicatorColor,
    required this.linePosition,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isHorizontal = linePosition == VooLineIndicatorPosition.bottom ||
        linePosition == VooLineIndicatorPosition.top;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: child,
        ),
        Positioned(
          left: linePosition == VooLineIndicatorPosition.left ? 0 : null,
          right: linePosition == VooLineIndicatorPosition.right ? 0 : null,
          top: linePosition == VooLineIndicatorPosition.top ? 0 : null,
          bottom: linePosition == VooLineIndicatorPosition.bottom ? 0 : null,
          child: AnimatedContainer(
            duration: theme.animationDuration,
            curve: theme.animationCurve,
            width: isHorizontal ? (isSelected ? 24 : 0) : 3,
            height: isHorizontal ? 3 : (isSelected ? 24 : 0),
            decoration: BoxDecoration(
              color: indicatorColor,
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmbossedIndicator extends StatelessWidget {
  final VooNavigationTheme theme;
  final bool isSelected;
  final Color indicatorColor;
  final Widget child;

  const _EmbossedIndicator({
    required this.theme,
    required this.isSelected,
    required this.indicatorColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isDark = themeData.brightness == Brightness.dark;
    final shadowOpacity = isDark ? 0.3 : 0.12;

    return AnimatedContainer(
      duration: theme.animationDuration,
      curve: theme.animationCurve,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? indicatorColor.withValues(alpha: 0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(theme.indicatorBorderRadius),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: shadowOpacity),
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                  spreadRadius: -2,
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: shadowOpacity * 0.5),
                  blurRadius: 4,
                  offset: const Offset(-1, -1),
                  spreadRadius: -2,
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}

class _BackgroundIndicator extends StatelessWidget {
  final VooNavigationTheme theme;
  final bool isSelected;
  final Color indicatorColor;
  final double? width;
  final double? height;
  final Widget child;

  const _BackgroundIndicator({
    required this.theme,
    required this.isSelected,
    required this.indicatorColor,
    required this.child,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: theme.animationDuration,
      curve: theme.animationCurve,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isSelected
            ? indicatorColor.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(theme.indicatorBorderRadius),
      ),
      child: child,
    );
  }
}
