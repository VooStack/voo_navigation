import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/quick_action.dart';
import 'package:voo_navigation_core/src/presentation/molecules/quick_actions_menu_content.dart';

/// A quick actions menu with customizable trigger
class VooQuickActions extends StatefulWidget {
  /// List of quick actions
  final List<VooQuickAction> actions;

  /// Icon for the trigger button
  final IconData? triggerIcon;

  /// Custom trigger widget
  final Widget? triggerWidget;

  /// Tooltip for the trigger
  final String? tooltip;

  /// Whether to show labels in grid layout
  final bool showLabelsInGrid;

  /// Style configuration
  final VooQuickActionsStyle? style;

  /// Whether to show in compact mode
  final bool compact;

  /// Custom action builder
  final Widget Function(VooQuickAction, VoidCallback onTap)? actionBuilder;

  /// Callback when an action is selected
  final ValueChanged<VooQuickAction>? onActionSelected;

  /// Whether to use grid layout
  final bool useGridLayout;

  /// Number of columns in grid layout
  final int gridColumns;

  const VooQuickActions({
    super.key,
    required this.actions,
    this.triggerIcon,
    this.triggerWidget,
    this.tooltip,
    this.showLabelsInGrid = true,
    this.style,
    this.compact = false,
    this.actionBuilder,
    this.onActionSelected,
    this.useGridLayout = false,
    this.gridColumns = 4,
  });

  @override
  State<VooQuickActions> createState() => _VooQuickActionsState();
}

class _VooQuickActionsState extends State<VooQuickActions>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 0.125).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    // Remove overlay synchronously without animation (controller may be disposed)
    _overlayEntry?.remove();
    _overlayEntry = null;
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    if (_isOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward();
    setState(() {
      _isOpen = true;
    });
  }

  void _removeOverlay() {
    _animationController.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
    setState(() {
      _isOpen = false;
    });
  }

  void _handleActionTap(VooQuickAction action) {
    _removeOverlay();
    widget.onActionSelected?.call(action);
    action.onTap?.call();
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final screenSize = MediaQuery.of(context).size;

    final style = widget.style ?? const VooQuickActionsStyle();
    final dropdownWidth = style.dropdownWidth ??
        (widget.useGridLayout ? widget.gridColumns * 80.0 + 32 : 220);

    // Calculate position
    double left = offset.dx + size.width / 2 - dropdownWidth / 2;
    if (left + dropdownWidth > screenSize.width - 16) {
      left = screenSize.width - dropdownWidth - 16;
    }
    if (left < 16) left = 16;

    // Position above if near bottom of screen
    final spaceBelow = screenSize.height - offset.dy - size.height;
    final showAbove = spaceBelow < 300;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Backdrop
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              behavior: HitTestBehavior.opaque,
              child: Container(color: Colors.transparent),
            ),
          ),
          // Menu
          Positioned(
            left: left,
            top: showAbove ? null : offset.dy + size.height + 8,
            bottom: showAbove ? screenSize.height - offset.dy + 8 : null,
            child: ScaleTransition(
              scale: _scaleAnimation,
              alignment: showAbove ? Alignment.bottomCenter : Alignment.topCenter,
              child: VooQuickActionsMenuContent(
                style: style,
                width: dropdownWidth,
                useGridLayout: widget.useGridLayout,
                gridColumns: widget.gridColumns,
                showLabelsInGrid: widget.showLabelsInGrid,
                actions: widget.actions,
                actionBuilder: widget.actionBuilder,
                onActionTap: _handleActionTap,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final style = widget.style ?? const VooQuickActionsStyle();

    if (widget.triggerWidget != null) {
      return Tooltip(
        message: widget.tooltip ?? 'Quick actions',
        child: InkWell(
          onTap: _toggleMenu,
          borderRadius: BorderRadius.circular(8),
          child: widget.triggerWidget,
        ),
      );
    }

    final triggerSize = style.triggerSize ?? (widget.compact ? 40.0 : 56.0);

    return Tooltip(
      message: widget.tooltip ?? 'Quick actions',
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimation.value * 3.14159 * 2,
            child: Material(
              elevation: _isOpen ? 8 : 4,
              borderRadius: BorderRadius.circular(triggerSize / 2),
              color: style.triggerBackgroundColor ?? colorScheme.primary,
              child: InkWell(
                onTap: _toggleMenu,
                borderRadius: BorderRadius.circular(triggerSize / 2),
                child: SizedBox(
                  width: triggerSize,
                  height: triggerSize,
                  child: Icon(
                    _isOpen ? Icons.close : (widget.triggerIcon ?? Icons.add),
                    size: widget.compact ? 20 : 28,
                    color: style.triggerColor ?? colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
