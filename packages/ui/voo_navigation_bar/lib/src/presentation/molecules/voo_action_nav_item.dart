import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';

/// A navigation item that displays an action button with a modal popup.
///
/// When tapped, the button opens a modal above it with custom content.
/// The icon rotates when the modal opens (+ to x effect).
class VooActionNavItem extends StatefulWidget {
  /// The action item configuration
  final VooActionNavigationItem actionItem;

  /// Whether to enable haptic feedback on tap
  final bool enableHapticFeedback;

  /// Animation duration
  final Duration animationDuration;

  /// Custom color for the button circle
  final Color? circleColor;

  const VooActionNavItem({
    super.key,
    required this.actionItem,
    this.enableHapticFeedback = true,
    this.animationDuration = const Duration(
      milliseconds: VooNavigationTokens.expandableNavAnimationDurationMs,
    ),
    this.circleColor,
  });

  @override
  State<VooActionNavItem> createState() => _VooActionNavItemState();
}

class _VooActionNavItemState extends State<VooActionNavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  OverlayEntry? _overlayEntry;
  bool _isModalOpen = false;
  final GlobalKey _buttonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _closeModal();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleModal() {
    if (widget.enableHapticFeedback) {
      HapticFeedback.mediumImpact();
    }

    if (_isModalOpen) {
      _closeModal();
    } else {
      _openModal();
    }
  }

  void _openModal() {
    setState(() {
      _isModalOpen = true;
    });

    _animationController.forward();

    _overlayEntry = OverlayEntry(
      builder: (context) => _buildModalOverlay(context),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeModal() {
    if (!_isModalOpen) return;

    _animationController.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });

    setState(() {
      _isModalOpen = false;
    });
  }

  Widget _buildModalOverlay(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // Calculate modal position (centered)
    final modalWidth = screenSize.width * 0.9;
    final modalLeft = (screenSize.width - modalWidth) / 2;

    // Get button position for arrow
    double arrowX = modalWidth / 2; // Default to center
    try {
      final RenderBox? buttonBox = _buttonKey.currentContext?.findRenderObject() as RenderBox?;
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
    final navBarHeight = VooNavigationTokens.expandableNavBarHeight + 24 + bottomPadding;
    final modalBottom = navBarHeight + 8;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          children: [
            // Backdrop
            if (widget.actionItem.closeOnTapOutside)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _closeModal,
                  child: AnimatedOpacity(
                    opacity: _animationController.value * 0.5,
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
              child: _ActionNavModalContent(
                actionItem: widget.actionItem,
                animation: _animationController,
                onClose: _closeModal,
                width: modalWidth,
                arrowPosition: arrowX,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final circleColor = widget.circleColor ??
        widget.actionItem.backgroundColor ??
        context.expandableNavSelectedCircle();

    final iconColor = widget.actionItem.iconColor ??
        context.expandableNavSelectedIcon;

    return GestureDetector(
      key: _buttonKey,
      onTap: _toggleModal,
      behavior: HitTestBehavior.opaque,
      child: Tooltip(
        message: widget.actionItem.tooltip ?? '',
        child: Container(
          height: VooNavigationTokens.expandableNavSelectedCircleSize + 4,
          padding: const EdgeInsets.symmetric(horizontal: 3.0),
          child: Center(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Container(
                  width: VooNavigationTokens.expandableNavSelectedCircleSize,
                  height: VooNavigationTokens.expandableNavSelectedCircleSize,
                  decoration: BoxDecoration(
                    color: circleColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Transform.rotate(
                      angle: _animationController.value * math.pi / 4, // 45 degrees
                      child: Icon(
                        _isModalOpen
                            ? widget.actionItem.effectiveActiveIcon
                            : widget.actionItem.icon,
                        color: iconColor,
                        size: VooNavigationTokens.expandableNavActionIconSize,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Internal widget for the modal content
class _ActionNavModalContent extends StatelessWidget {
  final VooActionNavigationItem actionItem;
  final Animation<double> animation;
  final VoidCallback onClose;
  final double width;
  final double arrowPosition;

  const _ActionNavModalContent({
    required this.actionItem,
    required this.animation,
    required this.onClose,
    required this.width,
    required this.arrowPosition,
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
                  maxHeight: actionItem.modalMaxHeight,
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
                      child: actionItem.modalBuilder(context, onClose),
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
