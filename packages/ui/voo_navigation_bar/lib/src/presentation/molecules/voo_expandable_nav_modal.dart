import 'package:flutter/material.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';

/// A modal overlay that appears above the navigation bar.
///
/// Used by context switcher and multi-switcher nav items to display
/// their content in a consistent style with the action item modal.
class VooExpandableNavModal extends StatelessWidget {
  /// The content to display in the modal
  final Widget child;

  /// Animation controller for the modal
  final Animation<double> animation;

  /// Callback when the modal should close
  final VoidCallback onClose;

  /// Width of the modal
  final double width;

  /// X position of the arrow indicator
  final double arrowPosition;

  /// Maximum height of the modal content
  final double maxHeight;

  /// Whether to close when tapping outside
  final bool closeOnTapOutside;

  const VooExpandableNavModal({
    super.key,
    required this.child,
    required this.animation,
    required this.onClose,
    required this.width,
    required this.arrowPosition,
    this.maxHeight = 400,
    this.closeOnTapOutside = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = context.expandableNavBackground;

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
                  borderRadius: BorderRadius.circular(16),
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
                  borderRadius: BorderRadius.circular(16),
                  child: Material(
                    color: Colors.transparent,
                    child: Theme(
                      data: theme.copyWith(
                        listTileTheme: ListTileThemeData(
                          textColor: Colors.white,
                          iconColor: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                      child: child,
                    ),
                  ),
                ),
              ),

              // Arrow indicator positioned at button location
              SizedBox(
                width: width,
                height: 8,
                child: CustomPaint(
                  painter: _PositionedArrowPainter(
                    color: bgColor,
                    borderColor: context.expandableNavBorder,
                    borderWidth: VooNavigationTokens.expandableNavBorderWidth,
                    arrowCenterX: arrowPosition,
                  ),
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
class _PositionedArrowPainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final double arrowCenterX;

  _PositionedArrowPainter({
    required this.color,
    required this.borderColor,
    required this.borderWidth,
    required this.arrowCenterX,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const arrowWidth = 16.0;
    const arrowHeight = 8.0;

    // Clamp arrow position to stay within bounds
    final clampedX = arrowCenterX.clamp(arrowWidth / 2, size.width - arrowWidth / 2);
    final left = clampedX - arrowWidth / 2;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final path = Path()
      ..moveTo(left, 0)
      ..lineTo(left + arrowWidth / 2, arrowHeight)
      ..lineTo(left + arrowWidth, 0)
      ..close();

    // Draw fill
    canvas.drawPath(path, paint);

    // Draw border (only the two angled lines, not the top)
    final borderPath = Path()
      ..moveTo(left, 0)
      ..lineTo(left + arrowWidth / 2, arrowHeight)
      ..lineTo(left + arrowWidth, 0);

    canvas.drawPath(borderPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _PositionedArrowPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.arrowCenterX != arrowCenterX;
  }
}

/// Helper mixin for nav items that show overlay modals
mixin ExpandableNavModalMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  late AnimationController modalAnimationController;
  OverlayEntry? overlayEntry;
  bool isModalOpen = false;
  final GlobalKey buttonKey = GlobalKey();

  void initModalAnimation({Duration? duration}) {
    modalAnimationController = AnimationController(
      duration: duration ?? const Duration(
        milliseconds: VooNavigationTokens.expandableNavAnimationDurationMs,
      ),
      vsync: this,
    );
  }

  void disposeModalAnimation() {
    closeModal();
    modalAnimationController.dispose();
  }

  void openModal(WidgetBuilder modalBuilder) {
    setState(() {
      isModalOpen = true;
    });

    modalAnimationController.forward();

    overlayEntry = OverlayEntry(
      builder: (context) => _buildModalOverlay(context, modalBuilder),
    );

    Overlay.of(context).insert(overlayEntry!);
  }

  void closeModal() {
    if (!isModalOpen) return;

    modalAnimationController.reverse().then((_) {
      overlayEntry?.remove();
      overlayEntry = null;
    });

    setState(() {
      isModalOpen = false;
    });
  }

  Widget _buildModalOverlay(BuildContext context, WidgetBuilder modalBuilder) {
    final screenSize = MediaQuery.of(context).size;

    // Calculate modal position (centered)
    final modalWidth = screenSize.width * 0.9;
    final modalLeft = (screenSize.width - modalWidth) / 2;

    // Get button position for arrow
    double arrowX = modalWidth / 2; // Default to center
    try {
      final RenderBox? buttonBox = buttonKey.currentContext?.findRenderObject() as RenderBox?;
      if (buttonBox != null && buttonBox.hasSize) {
        final buttonPosition = buttonBox.localToGlobal(Offset.zero);
        final buttonCenterX = buttonPosition.dx + buttonBox.size.width / 2;
        arrowX = buttonCenterX - modalLeft;
      }
    } catch (_) {
      // Use default center position
    }

    // Position modal above the nav bar
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final navBarHeight = VooNavigationTokens.expandableNavBarHeight + 8 + bottomPadding;
    final modalBottom = navBarHeight + 8;

    return AnimatedBuilder(
      animation: modalAnimationController,
      builder: (context, child) {
        return Stack(
          children: [
            // Backdrop
            Positioned.fill(
              child: GestureDetector(
                onTap: closeModal,
                child: AnimatedOpacity(
                  opacity: modalAnimationController.value * 0.5,
                  duration: Duration.zero,
                  child: Container(
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            // Modal
            Positioned(
              left: modalLeft,
              right: modalLeft,
              bottom: modalBottom,
              child: VooExpandableNavModal(
                animation: modalAnimationController,
                onClose: closeModal,
                width: modalWidth,
                arrowPosition: arrowX,
                child: modalBuilder(context),
              ),
            ),
          ],
        );
      },
    );
  }
}
