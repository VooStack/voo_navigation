import 'package:flutter/material.dart';
import 'package:voo_navigation_rail/src/presentation/molecules/rail_themed_container.dart';
import 'package:voo_navigation_rail/voo_navigation_rail.dart';

/// Adaptive navigation rail for tablet and desktop layouts with Material 3 design
/// Features smooth animations, hover effects, and beautiful visual transitions
class VooAdaptiveNavigationRail extends StatefulWidget {
  /// Navigation configuration
  final VooNavigationConfig config;

  /// Currently selected item ID
  final String selectedId;

  /// Callback when an item is selected
  final void Function(String itemId) onNavigationItemSelected;

  /// Whether to show extended rail with labels
  final bool extended;

  /// Custom width for the rail
  final double? width;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom elevation
  final double? elevation;

  /// Callback when collapse is toggled (provided by VooDesktopScaffold)
  final VoidCallback? onToggleCollapse;

  const VooAdaptiveNavigationRail({
    super.key,
    required this.config,
    required this.selectedId,
    required this.onNavigationItemSelected,
    this.extended = false,
    this.width,
    this.backgroundColor,
    this.elevation,
    this.onToggleCollapse,
  });

  @override
  State<VooAdaptiveNavigationRail> createState() =>
      _VooAdaptiveNavigationRailState();
}

class _VooAdaptiveNavigationRailState extends State<VooAdaptiveNavigationRail>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _hoverController;
  final Map<String, AnimationController> _itemAnimationControllers = {};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.config.animationDuration,
      vsync: this,
    );

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 113),
      vsync: this,
    );

    if (widget.extended) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(VooAdaptiveNavigationRail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.extended != oldWidget.extended) {
      if (widget.extended) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _hoverController.dispose();
    for (final controller in _itemAnimationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navTheme = widget.config.effectiveTheme;

    final effectiveWidth =
        widget.width ??
        (widget.extended
            ? (widget.config.extendedNavigationRailWidth ?? 256)
            : (widget.config.navigationRailWidth ?? 80));

    // Use theme-based surface color
    final effectiveBackgroundColor =
        widget.backgroundColor ??
        widget.config.navigationBackgroundColor ??
        navTheme.resolveSurfaceColor(context);

    return AnimatedContainer(
      duration: navTheme.animationDuration,
      curve: navTheme.animationCurve,
      width: effectiveWidth,
      margin: EdgeInsets.all(widget.config.navigationRailMargin),
      child: VooRailThemedContainer(
        config: widget.config,
        navTheme: navTheme,
        backgroundColor: effectiveBackgroundColor,
        extended: widget.extended,
        selectedId: widget.selectedId,
        onNavigationItemSelected: widget.onNavigationItemSelected,
        itemAnimationControllers: _itemAnimationControllers,
        onToggleCollapse: widget.onToggleCollapse,
      ),
    );
  }
}

