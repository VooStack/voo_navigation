import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/src/domain/entities/multi_switcher_config.dart';
import 'package:voo_navigation_core/src/domain/entities/multi_switcher_style.dart';
import 'package:voo_navigation_core/src/domain/entities/organization.dart';
import 'package:voo_navigation_core/src/presentation/molecules/multi_switcher_card.dart';
import 'package:voo_navigation_core/src/presentation/molecules/multi_switcher_modal.dart';
import 'package:voo_navigation_core/src/presentation/utils/voo_collapse_state.dart';

/// Multi-switcher widget combining organization and user switching.
///
/// This widget displays a card (closed state) that expands to show
/// a modal (open state) with organization and user selection sections.
/// The modal slides up from the bottom with smooth spring animation.
///
/// Example usage:
/// ```dart
/// VooMultiSwitcher(
///   config: VooMultiSwitcherConfig(
///     organizations: myOrganizations,
///     selectedOrganization: currentOrg,
///     onOrganizationChanged: (org) => setState(() => currentOrg = org),
///     userName: 'John Doe',
///     userEmail: 'john@example.com',
///     status: VooUserStatus.online,
///     onSettingsTap: () => openSettings(),
///     onLogout: () => logout(),
///   ),
/// )
/// ```
class VooMultiSwitcher extends StatefulWidget {
  /// Configuration for the multi-switcher
  final VooMultiSwitcherConfig config;

  /// Whether to show in compact mode (avatar only).
  /// When null, auto-detects from [VooCollapseState] in widget tree.
  final bool? compact;

  const VooMultiSwitcher({
    super.key,
    required this.config,
    this.compact,
  });

  @override
  State<VooMultiSwitcher> createState() => _VooMultiSwitcherState();
}

class _VooMultiSwitcherState extends State<VooMultiSwitcher>
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

    final style = widget.config.style ?? const VooMultiSwitcherStyle();
    final duration = style.animationDuration ??
        VooMultiSwitcherStyle.defaultAnimationDuration;
    final curve =
        style.animationCurve ?? VooMultiSwitcherStyle.defaultAnimationCurve;

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

    final style = widget.config.style ?? const VooMultiSwitcherStyle();
    final modalMaxHeight =
        style.modalMaxHeight ?? VooMultiSwitcherStyle.defaultModalMaxHeight;
    final cardWidth = _getCardWidth();

    // Capture the theme from the widget's context to pass to the overlay
    final theme = Theme.of(context);

    _overlayEntry = OverlayEntry(
      builder: (overlayContext) => Theme(
        data: theme,
        child: _MultiSwitcherOverlay(
          link: _layerLink,
          animation: _slideAnimation,
          modalMaxHeight: modalMaxHeight,
          modalWidth: cardWidth,
          config: widget.config,
          onClose: _toggleExpanded,
          onOrganizationSelected: _handleOrganizationSelected,
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

  void _handleOrganizationSelected(VooOrganization org) {
    widget.config.onOrganizationChanged?.call(org);
  }

  @override
  Widget build(BuildContext context) {
    final effectiveCompact =
        widget.compact ?? VooCollapseState.isCollapsedOf(context);

    return CompositedTransformTarget(
      link: _layerLink,
      child: AnimatedCrossFade(
        key: _cardKey,
        duration: const Duration(milliseconds: 200),
        crossFadeState:
            _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        firstChild: VooMultiSwitcherCard(
          config: widget.config,
          isExpanded: false,
          compact: effectiveCompact,
          onTap: _toggleExpanded,
        ),
        secondChild: _CloseBar(onTap: _toggleExpanded),
      ),
    );
  }
}

/// Overlay widget for the modal
class _MultiSwitcherOverlay extends StatelessWidget {
  final LayerLink link;
  final Animation<double> animation;
  final double modalMaxHeight;
  final double modalWidth;
  final VooMultiSwitcherConfig config;
  final VoidCallback onClose;
  final ValueChanged<VooOrganization> onOrganizationSelected;

  const _MultiSwitcherOverlay({
    required this.link,
    required this.animation,
    required this.modalMaxHeight,
    required this.modalWidth,
    required this.config,
    required this.onClose,
    required this.onOrganizationSelected,
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
            // Modal positioned above the card
            CompositedTransformFollower(
              link: link,
              targetAnchor: Alignment.topCenter,
              followerAnchor: Alignment.bottomCenter,
              offset: const Offset(0, -8),
              child: Transform.translate(
                offset: Offset(0, (1 - animation.value) * 50),
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
          child: VooMultiSwitcherModal(
            config: config,
            animation: animation,
            onClose: onClose,
            onOrganizationSelected: onOrganizationSelected,
            onUserSelected: config.onUserChanged != null
                ? (user) => config.onUserChanged!(user)
                : null,
          ),
        ),
      ),
    );
  }
}

/// Close bar shown at bottom when modal is expanded
class _CloseBar extends StatelessWidget {
  final VoidCallback onTap;

  const _CloseBar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              'Close',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
