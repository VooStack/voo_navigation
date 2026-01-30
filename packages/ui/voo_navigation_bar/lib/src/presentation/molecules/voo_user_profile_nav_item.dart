import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';
import 'package:voo_navigation_bar/src/presentation/molecules/voo_expandable_nav_item.dart';
import 'package:voo_navigation_bar/src/presentation/molecules/voo_expandable_nav_modal.dart';

/// A user profile navigation item that matches the expandable nav bar design.
///
/// Displays the user's avatar (image or initials) in a circle, and expands
/// to show a label when selected. Can open an overlay modal when tapped
/// (if modalBuilder is provided) or call onTap.
class VooUserProfileNavItem extends StatefulWidget {
  /// Configuration for the user profile
  final VooUserProfileConfig config;

  /// Whether haptic feedback is enabled
  final bool enableHapticFeedback;

  /// Custom color for the avatar background when showing initials
  final Color? avatarColor;

  /// Whether this item is selected (controls expand/collapse state)
  final bool isSelected;

  /// Direction of label expansion
  final VooExpandableLabelPosition labelPosition;

  /// Duration of the expand/collapse animation
  final Duration animationDuration;

  /// Curve for the expand/collapse animation
  final Curve animationCurve;

  /// Maximum width for the label. Defaults to 60dp.
  final double maxLabelWidth;

  /// Navigation item ID for this profile item
  static const String navItemId = '_user_profile_nav';

  const VooUserProfileNavItem({
    super.key,
    required this.config,
    this.enableHapticFeedback = true,
    this.avatarColor,
    this.isSelected = false,
    this.labelPosition = VooExpandableLabelPosition.start,
    this.animationDuration = const Duration(
      milliseconds: VooNavigationTokens.expandableNavAnimationDurationMs,
    ),
    this.animationCurve = Curves.easeOutCubic,
    this.maxLabelWidth = 60.0,
  });

  @override
  State<VooUserProfileNavItem> createState() => _VooUserProfileNavItemState();
}

class _VooUserProfileNavItemState extends State<VooUserProfileNavItem>
    with SingleTickerProviderStateMixin, ExpandableNavModalMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _labelOpacity;

  @override
  void initState() {
    super.initState();
    initModalAnimation();

    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    // Use different curves for expand vs collapse to sync animations:
    // - Expand (forward): easeOutCubic - slow start, fast finish
    // - Collapse (reverse): easeInCubic - fast start, slow finish
    // This ensures collapsing item frees up space as expanding item grows
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve,
      reverseCurve: Curves.easeInCubic,
    );

    _labelOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      reverseCurve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    );

    // Only expand if selected AND no modal builder (modal takes priority)
    if (widget.isSelected && widget.config.modalBuilder == null) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(VooUserProfileNavItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only animate expand/collapse if no modal builder
    if (widget.config.modalBuilder == null) {
      if (widget.isSelected != oldWidget.isSelected) {
        if (widget.isSelected) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    disposeModalAnimation();
    super.dispose();
  }

  void _handleTap() {
    if (widget.enableHapticFeedback) {
      HapticFeedback.mediumImpact();
    }

    // If modalBuilder is provided, show modal (no expand animation)
    if (widget.config.modalBuilder != null) {
      if (isModalOpen) {
        closeModal();
      } else {
        openModal(_buildModalContent);
      }
    } else {
      // Otherwise call onTap (consumer controls selection state)
      widget.config.onTap?.call();
    }
  }

  Widget _buildModalContent(BuildContext context) {
    return widget.config.modalBuilder!(
      context,
      VooUserProfileModalData(
        userName: widget.config.userName,
        userEmail: widget.config.userEmail,
        avatarUrl: widget.config.avatarUrl,
        avatarWidget: widget.config.avatarWidget,
        initials: widget.config.effectiveInitials,
        status: widget.config.status,
        onClose: closeModal,
        onSettingsTap: widget.config.onSettingsTap,
        onLogout: widget.config.onLogout,
        menuItems: widget.config.menuItems,
      ),
    );
  }

  double _measureLabelWidth() {
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.config.effectiveNavItemLabel,
        style: TextStyle(
          fontSize: VooNavigationTokens.expandableNavLabelFontSize,
          fontWeight: VooNavigationTokens.expandableNavLabelFontWeight,
        ),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    return (textPainter.width.ceilToDouble() + 2).clamp(0.0, widget.maxLabelWidth);
  }

  @override
  Widget build(BuildContext context) {
    final circleSize = VooNavigationTokens.expandableNavSelectedCircleSize;
    const circlePadding = 4.0; // Constant padding around circle (both sides)
    final containerHeight = circleSize + (circlePadding * 2);
    final theme = Theme.of(context);

    final labelWidth = _measureLabelWidth();
    const spacing = 8.0; // Space between circle and text
    const textPadding = 12.0; // Space from text to edge of pill

    final isLabelStart =
        widget.labelPosition == VooExpandableLabelPosition.start;

    return GestureDetector(
      key: buttonKey,
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final progress = _expandAnimation.value.clamp(0.0, 1.0);
          final labelProgress = _labelOpacity.value.clamp(0.0, 1.0);

          // Calculate animated values (circlePadding stays constant for symmetry)
          final animatedLabelWidth = labelWidth * progress;
          final animatedSpacing = spacing * progress;
          final animatedTextPadding = textPadding * progress;

          // Build label widget
          final label = Opacity(
            opacity: labelProgress,
            child: Text(
              widget.config.effectiveNavItemLabel,
              style: TextStyle(
                color: context.expandableNavSelectedLabel,
                fontSize: VooNavigationTokens.expandableNavLabelFontSize,
                fontWeight: VooNavigationTokens.expandableNavLabelFontWeight,
              ),
              maxLines: 1,
              overflow: TextOverflow.clip,
            ),
          );

          // Build row contents based on label position
          // Avatar always has consistent padding on both sides
          List<Widget> rowChildren;
          if (isLabelStart) {
            // Label on left, avatar on right
            rowChildren = [
              SizedBox(width: animatedTextPadding),
              SizedBox(
                width: animatedLabelWidth,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: label,
                ),
              ),
              SizedBox(width: animatedSpacing),
              const SizedBox(width: circlePadding),
              _buildAvatar(context, circleSize, theme),
              const SizedBox(width: circlePadding),
            ];
          } else {
            // Avatar on left, label on right
            rowChildren = [
              const SizedBox(width: circlePadding),
              _buildAvatar(context, circleSize, theme),
              const SizedBox(width: circlePadding),
              SizedBox(width: animatedSpacing),
              SizedBox(
                width: animatedLabelWidth,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: label,
                ),
              ),
              SizedBox(width: animatedTextPadding),
            ];
          }

          return Tooltip(
            message: widget.config.effectiveNavItemLabel,
            child: Container(
              height: containerHeight,
              decoration: BoxDecoration(
                color: progress > 0
                    ? context.expandableNavSelectedBackground
                        .withValues(alpha: progress)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(containerHeight / 2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: rowChildren,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, double size, ThemeData theme) {
    // If custom avatar widget provided, use it
    if (widget.config.avatarWidget != null) {
      return SizedBox(
        width: size,
        height: size,
        child: ClipOval(child: widget.config.avatarWidget),
      );
    }

    // If avatar URL provided, show image
    if (widget.config.avatarUrl != null &&
        widget.config.avatarUrl!.isNotEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: _getImageProvider(widget.config.avatarUrl!),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    // Otherwise show initials
    final initials = widget.config.effectiveInitials ?? '?';
    final bgColor = widget.avatarColor ?? theme.colorScheme.primary;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontSize: size * 0.4,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  ImageProvider _getImageProvider(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return NetworkImage(url);
    }
    return AssetImage(url);
  }
}
