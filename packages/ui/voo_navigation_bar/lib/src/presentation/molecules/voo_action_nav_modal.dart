import 'package:flutter/material.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';

/// An animated modal that appears above the action navigation item.
///
/// The modal slides and scales up from the action button with a bounce effect,
/// and includes an arrow indicator pointing to the button.
class VooActionNavModal extends StatelessWidget {
  /// The content to display inside the modal
  final Widget child;

  /// Maximum height of the modal
  final double maxHeight;

  /// Animation value (0.0 to 1.0) for the modal animations
  final Animation<double> animation;

  /// Position offset from the bottom of the screen
  final double bottomOffset;

  /// Width of the modal
  final double? width;

  /// Background color of the modal
  final Color? backgroundColor;

  /// Border radius of the modal
  final BorderRadius? borderRadius;

  const VooActionNavModal({
    super.key,
    required this.child,
    required this.animation,
    this.maxHeight = 300.0,
    this.bottomOffset = 0,
    this.width,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? context.expandableNavBackground;
    final radius = borderRadius ?? BorderRadius.circular(16);

    // Create curved animations
    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutBack,
    ));

    final scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutBack,
    ));

    final fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    return SlideTransition(
      position: slideAnimation,
      child: ScaleTransition(
        scale: scaleAnimation,
        alignment: Alignment.bottomCenter,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Modal content
              Container(
                width: width,
                constraints: BoxConstraints(
                  maxHeight: maxHeight,
                ),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: radius,
                  border: Border.all(
                    color: context.expandableNavBorder,
                    width: VooNavigationTokens.expandableNavBorderWidth,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withValues(alpha: 0.25),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: radius,
                  child: Material(
                    color: Colors.transparent,
                    child: child,
                  ),
                ),
              ),

              // Arrow indicator
              CustomPaint(
                size: const Size(16, 8),
                painter: _ArrowPainter(
                  color: bgColor,
                  borderColor: context.expandableNavBorder,
                  borderWidth: VooNavigationTokens.expandableNavBorderWidth,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom painter for the arrow indicator pointing down from the modal
class _ArrowPainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  final double borderWidth;

  _ArrowPainter({
    required this.color,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    // Draw fill
    canvas.drawPath(path, paint);

    // Draw border (only the two angled lines, not the top)
    final borderPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0);

    canvas.drawPath(borderPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _ArrowPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth;
  }
}
