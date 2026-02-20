import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/src/domain/entities/context_switcher_config.dart';
import 'package:voo_navigation_core/src/domain/entities/context_switcher_item.dart';
import 'package:voo_navigation_core/src/domain/entities/context_switcher_style.dart';
import 'package:voo_navigation_core/src/presentation/molecules/context_switcher_card.dart';
import 'package:voo_navigation_core/src/presentation/molecules/context_switcher_modal.dart';
import 'package:voo_navigation_core/src/presentation/utils/voo_collapse_state.dart';

/// Context switcher widget for switching between contexts (projects, workspaces, etc).
///
/// This widget displays a card (closed state) that expands to show
/// a dropdown modal (open state) with available contexts.
/// When a context is selected, the navigation items can dynamically change
/// based on the `itemsBuilder` callback in the config.
///
/// Example usage:
/// ```dart
/// VooContextSwitcher(
///   config: VooContextSwitcherConfig(
///     items: projects,
///     selectedItem: currentProject,
///     onContextChanged: (project) => setState(() => currentProject = project),
///     itemsBuilder: (project) => getItemsForProject(project),
///     sectionTitle: 'Projects',
///     showSearch: true,
///   ),
/// )
/// ```
class VooContextSwitcher extends StatefulWidget {
  /// Configuration for the context switcher
  final VooContextSwitcherConfig config;

  /// Whether to show in compact mode (icon/avatar only).
  /// When null, auto-detects from [VooCollapseState] in widget tree.
  final bool? compact;

  const VooContextSwitcher({
    super.key,
    required this.config,
    this.compact,
  });

  @override
  State<VooContextSwitcher> createState() => _VooContextSwitcherState();
}

class _VooContextSwitcherState extends State<VooContextSwitcher>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _cardKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();

    final style = widget.config.style ?? const VooContextSwitcherStyle();
    final duration = style.animationDuration ??
        VooContextSwitcherStyle.defaultAnimationDuration;
    final curve =
        style.animationCurve ?? VooContextSwitcherStyle.defaultAnimationCurve;

    _animationController = AnimationController(
      vsync: this,
      duration: duration,
    );

    _slideAnimation = CurvedAnimation(
      parent: _animationController,
      curve: curve,
    );

    _animationController.addStatusListener(_handleAnimationStatus);
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      _removeOverlay();
    }
  }

  @override
  void dispose() {
    _animationController.removeStatusListener(_handleAnimationStatus);
    _removeOverlay();
    _animationController.dispose();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  double _getCardWidth() {
    final renderBox =
        _cardKey.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.size.width ?? 200;
  }

  void _showOverlay() {
    _removeOverlay();

    final style = widget.config.style ?? const VooContextSwitcherStyle();
    final modalMaxHeight =
        style.modalMaxHeight ?? VooContextSwitcherStyle.defaultModalMaxHeight;
    final cardWidth = _getCardWidth();

    // Capture the theme from the widget's context to pass to the overlay
    final theme = Theme.of(context);

    _overlayEntry = OverlayEntry(
      builder: (overlayContext) => Theme(
        data: theme,
        child: _ContextSwitcherOverlay(
          link: _layerLink,
          animation: _slideAnimation,
          modalMaxHeight: modalMaxHeight,
          modalWidth: cardWidth,
          config: widget.config,
          onClose: _toggleExpanded,
          onContextSelected: _handleContextSelected,
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _toggleExpanded() {
    HapticFeedback.lightImpact();

    if (!_isExpanded) {
      // Opening
      setState(() => _isExpanded = true);
      _showOverlay();
      _animationController.forward();
    } else {
      // Closing
      setState(() => _isExpanded = false);
      _animationController.reverse();
      // Overlay removed by animation status listener
    }
  }

  void _handleContextSelected(VooContextItem context) {
    widget.config.onContextChanged?.call(context);
  }

  @override
  Widget build(BuildContext context) {
    final effectiveCompact =
        widget.compact ?? VooCollapseState.isCollapsedOf(context);

    return CompositedTransformTarget(
      link: _layerLink,
      child: VooContextSwitcherCard(
        key: _cardKey,
        config: widget.config,
        isExpanded: _isExpanded,
        compact: effectiveCompact,
        onTap: _toggleExpanded,
      ),
    );
  }
}

/// Overlay widget for the dropdown modal
class _ContextSwitcherOverlay extends StatelessWidget {
  final LayerLink link;
  final Animation<double> animation;
  final double modalMaxHeight;
  final double modalWidth;
  final VooContextSwitcherConfig config;
  final VoidCallback onClose;
  final ValueChanged<VooContextItem> onContextSelected;

  const _ContextSwitcherOverlay({
    required this.link,
    required this.animation,
    required this.modalMaxHeight,
    required this.modalWidth,
    required this.config,
    required this.onClose,
    required this.onContextSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        if (animation.value == 0) return const SizedBox.shrink();

        return Stack(
          children: [
            // Tap outside to close
            Positioned.fill(
              child: GestureDetector(
                onTap: onClose,
                behavior: HitTestBehavior.opaque,
                child: Container(color: Colors.transparent),
              ),
            ),
            // Modal positioned BELOW the card (dropdown style)
            CompositedTransformFollower(
              link: link,
              targetAnchor: Alignment.bottomCenter,
              followerAnchor: Alignment.topCenter,
              offset: const Offset(0, 8),
              child: Transform.translate(
                offset: Offset(0, (1 - animation.value) * -30),
                child: Opacity(
                  opacity: animation.value.clamp(0.0, 1.0),
                  child: child,
                ),
              ),
            ),
          ],
        );
      },
      child: SizedBox(
        width: modalWidth,
        child: Material(
          type: MaterialType.transparency,
          child: VooContextSwitcherModal(
            config: config,
            animation: animation,
            onClose: onClose,
            onContextSelected: onContextSelected,
          ),
        ),
      ),
    );
  }
}
