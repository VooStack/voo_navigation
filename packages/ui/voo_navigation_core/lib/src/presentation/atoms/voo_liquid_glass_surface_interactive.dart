import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_theme.dart';

/// An interactive liquid glass surface with hover and selection states
class VooLiquidGlassSurfaceInteractive extends StatefulWidget {
  /// The navigation theme configuration
  final VooNavigationTheme theme;

  /// The content to display
  final Widget child;

  /// Border radius for the surface
  final BorderRadius borderRadius;

  /// Padding inside the surface
  final EdgeInsetsGeometry? padding;

  /// Whether the surface is currently selected
  final bool isSelected;

  /// Callback when the surface is tapped
  final VoidCallback? onTap;

  /// Whether to show a glow effect when selected
  final bool showGlowOnSelected;

  /// Custom glow color (uses theme primary if null)
  final Color? glowColor;

  const VooLiquidGlassSurfaceInteractive({
    super.key,
    required this.theme,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.padding,
    this.isSelected = false,
    this.onTap,
    this.showGlowOnSelected = true,
    this.glowColor,
  });

  @override
  State<VooLiquidGlassSurfaceInteractive> createState() =>
      _VooLiquidGlassSurfaceInteractiveState();
}

class _VooLiquidGlassSurfaceInteractiveState
    extends State<VooLiquidGlassSurfaceInteractive>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _shimmerAnimation = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    if (widget.theme.showShimmer) {
      _shimmerController.repeat();
    }
  }

  @override
  void didUpdateWidget(VooLiquidGlassSurfaceInteractive oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.theme.showShimmer && !_shimmerController.isAnimating) {
      _shimmerController.repeat();
    } else if (!widget.theme.showShimmer && _shimmerController.isAnimating) {
      _shimmerController.stop();
    }
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = colorScheme.primary;

    // Calculate opacity based on state
    final baseOpacity = widget.theme.surfaceOpacity;
    final effectiveOpacity = _isHovered
        ? (baseOpacity + 0.12).clamp(0.0, 1.0)
        : widget.isSelected
            ? (baseOpacity + 0.08).clamp(0.0, 1.0)
            : baseOpacity;

    final surfaceColor = widget.theme.surfaceTintColor ??
        (isDark
            ? colorScheme.surfaceContainerHighest
            : colorScheme.surface);

    final glowColor = widget.glowColor ?? primaryColor;
    final borderColor = widget.theme.borderColor ?? (isDark ? Colors.white : Colors.black);

    // Tinted surface
    final tintedSurface = widget.theme.tintIntensity > 0
        ? Color.lerp(surfaceColor, primaryColor, widget.theme.tintIntensity * 0.3)!
        : surfaceColor;

    // Build shadows with optional selection glow
    final shadows = <BoxShadow>[
      ...widget.theme.resolveShadows(context),
      if (widget.isSelected && widget.showGlowOnSelected)
        BoxShadow(
          color: glowColor.withValues(alpha: 0.35),
          blurRadius: widget.theme.indicatorGlowBlur * 1.5,
          spreadRadius: 2,
        ),
    ];

    Widget content = AnimatedContainer(
      duration: widget.theme.animationDuration,
      curve: widget.theme.animationCurve,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius,
        boxShadow: shadows,
      ),
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: Stack(
          children: [
            // Blur layers
            if (widget.theme.blurSigma > 0)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: widget.theme.blurSigma,
                    sigmaY: widget.theme.blurSigma,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),

            if (widget.theme.secondaryBlurSigma > 0)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: widget.theme.secondaryBlurSigma,
                    sigmaY: widget.theme.secondaryBlurSigma,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),

            // Glass surface
            Positioned.fill(
              child: AnimatedContainer(
                duration: widget.theme.animationDuration,
                curve: widget.theme.animationCurve,
                decoration: BoxDecoration(
                  borderRadius: widget.borderRadius,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.0, 0.3, 0.7, 1.0],
                    colors: isDark
                        ? [
                            tintedSurface.withValues(alpha: effectiveOpacity + 0.1),
                            tintedSurface.withValues(alpha: effectiveOpacity),
                            tintedSurface.withValues(alpha: effectiveOpacity - 0.05),
                            tintedSurface.withValues(alpha: effectiveOpacity - 0.1),
                          ]
                        : [
                            Colors.white.withValues(alpha: effectiveOpacity + 0.15),
                            tintedSurface.withValues(alpha: effectiveOpacity + 0.05),
                            tintedSurface.withValues(alpha: effectiveOpacity),
                            tintedSurface.withValues(alpha: effectiveOpacity - 0.1),
                          ],
                  ),
                ),
              ),
            ),

            // Inner glow
            if (widget.theme.innerGlowIntensity > 0)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: widget.borderRadius,
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.2,
                      colors: [
                        (widget.isSelected ? glowColor : primaryColor)
                            .withValues(alpha: widget.theme.innerGlowIntensity * 0.12),
                        (widget.isSelected ? glowColor : primaryColor)
                            .withValues(alpha: widget.theme.innerGlowIntensity * 0.04),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),

            // Edge highlights
            if (widget.theme.edgeHighlightIntensity > 0) ...[
              // Top edge
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: widget.borderRadius.topLeft,
                      topRight: widget.borderRadius.topRight,
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.0),
                        Colors.white.withValues(
                          alpha: isDark
                              ? widget.theme.edgeHighlightIntensity * 0.5
                              : widget.theme.edgeHighlightIntensity * 0.9,
                        ),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                      stops: const [0.1, 0.5, 0.9],
                    ),
                  ),
                ),
              ),
            ],

            // Shimmer effect
            if (widget.theme.showShimmer)
              AnimatedBuilder(
                animation: _shimmerAnimation,
                builder: (context, child) {
                  return Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: widget.borderRadius,
                        gradient: LinearGradient(
                          begin: Alignment(_shimmerAnimation.value - 1, 0),
                          end: Alignment(_shimmerAnimation.value, 0),
                          colors: [
                            Colors.transparent,
                            Colors.white.withValues(alpha: isDark ? 0.08 : 0.15),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

            // Border
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: widget.borderRadius,
                  border: widget.theme.borderWidth > 0
                      ? Border.all(
                          color: borderColor.withValues(
                            alpha: widget.isSelected
                                ? widget.theme.borderOpacity * 1.8
                                : _isHovered
                                    ? widget.theme.borderOpacity * 1.4
                                    : widget.theme.borderOpacity,
                          ),
                          width: widget.theme.borderWidth,
                        )
                      : null,
                ),
              ),
            ),

            // Content
            Positioned.fill(
              child: Padding(
                padding: widget.padding ?? EdgeInsets.zero,
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      ),
    );
  }
}
