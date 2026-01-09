import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_theme.dart';

/// An interactive neomorphism surface with press animation
///
/// Animates between raised and pressed states on tap
class VooNeomorphSurfaceInteractive extends StatefulWidget {
  /// The navigation theme configuration
  final VooNavigationTheme theme;

  /// The content to display
  final Widget child;

  /// Border radius for the surface
  final BorderRadius borderRadius;

  /// Padding inside the surface
  final EdgeInsetsGeometry? padding;

  /// Whether the surface is currently selected (pressed in)
  final bool isSelected;

  /// Callback when the surface is tapped
  final VoidCallback? onTap;

  const VooNeomorphSurfaceInteractive({
    super.key,
    required this.theme,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.padding,
    this.isSelected = false,
    this.onTap,
  });

  @override
  State<VooNeomorphSurfaceInteractive> createState() =>
      _VooNeomorphSurfaceInteractiveState();
}

class _VooNeomorphSurfaceInteractiveState
    extends State<VooNeomorphSurfaceInteractive> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isDark = themeData.brightness == Brightness.dark;

    final surfaceColor = widget.theme.surfaceTintColor ??
        themeData.colorScheme.surface;

    // Determine if we should show pressed state
    final showPressedState = _isPressed || widget.isSelected;

    // Calculate shadow colors
    final lightShadowOpacity = isDark ? 0.05 : widget.theme.shadowLightOpacity;
    final darkShadowOpacity = isDark ? 0.4 : widget.theme.shadowDarkOpacity;

    // Build animated shadows
    List<BoxShadow> shadows;
    if (showPressedState) {
      shadows = [
        BoxShadow(
          color: Colors.black.withValues(alpha: darkShadowOpacity * 0.6),
          blurRadius: widget.theme.shadowBlur * 0.4,
          offset: widget.theme.shadowLightOffset * 0.3,
          spreadRadius: -1,
        ),
        BoxShadow(
          color: Colors.white.withValues(alpha: lightShadowOpacity * 0.3),
          blurRadius: widget.theme.shadowBlur * 0.4,
          offset: widget.theme.shadowDarkOffset * 0.3,
          spreadRadius: -1,
        ),
      ];
    } else {
      shadows = [
        BoxShadow(
          color: Colors.white.withValues(alpha: lightShadowOpacity),
          blurRadius: widget.theme.shadowBlur,
          offset: widget.theme.shadowLightOffset,
          spreadRadius: isDark ? 0 : 1,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: darkShadowOpacity),
          blurRadius: widget.theme.shadowBlur,
          offset: widget.theme.shadowDarkOffset,
        ),
      ];
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: widget.theme.animationDuration,
        curve: widget.theme.animationCurve,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: widget.borderRadius,
          boxShadow: shadows,
        ),
        child: widget.child,
      ),
    );
  }
}
