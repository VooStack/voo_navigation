import 'package:flutter/material.dart';

/// Animated pulsing status badge for online indicators
class VooPulsingStatusBadge extends StatefulWidget {
  /// Color of the badge
  final Color color;

  /// Size of the badge
  final double size;

  /// Border color
  final Color borderColor;

  const VooPulsingStatusBadge({
    super.key,
    required this.color,
    required this.size,
    required this.borderColor,
  });

  @override
  State<VooPulsingStatusBadge> createState() => _VooPulsingStatusBadgeState();
}

class _VooPulsingStatusBadgeState extends State<VooPulsingStatusBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 1.0, end: 1.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size * 2,
      height: widget.size * 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _animation.value,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withValues(
                      alpha: (1.0 - _controller.value) * 0.4,
                    ),
                  ),
                ),
              );
            },
          ),
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.borderColor,
                width: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
