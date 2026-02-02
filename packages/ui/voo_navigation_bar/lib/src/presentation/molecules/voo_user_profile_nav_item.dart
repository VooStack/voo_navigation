import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';
import 'package:voo_navigation_bar/src/presentation/atoms/voo_expandable_nav_item_layout.dart';
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

  /// Callback when this item is selected as a navigation item.
  /// Called alongside config.onTap when no modalBuilder is provided.
  /// This is used by VooNavigationBar to update the selection state.
  final VoidCallback? onNavigationSelected;

  /// Navigation item ID for this profile item
  static const String navItemId = '_user_profile_nav';

  const VooUserProfileNavItem({
    super.key,
    required this.config,
    this.enableHapticFeedback = true,
    this.avatarColor,
    this.isSelected = false,
    this.labelPosition = VooExpandableLabelPosition.start,
    this.animationDuration = const Duration(milliseconds: VooNavigationTokens.expandableNavAnimationDurationMs),
    this.animationCurve = Curves.easeOutCubic,
    this.maxLabelWidth = 60.0,
    this.onNavigationSelected,
  });

  @override
  State<VooUserProfileNavItem> createState() => _VooUserProfileNavItemState();
}

class _VooUserProfileNavItemState extends State<VooUserProfileNavItem> with TickerProviderStateMixin, ExpandableNavModalMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _labelOpacity;

  @override
  void initState() {
    super.initState();
    initModalAnimation();

    _controller = AnimationController(duration: widget.animationDuration, vsync: this);

    _expandAnimation = CurvedAnimation(parent: _controller, curve: widget.animationCurve, reverseCurve: Curves.easeInCubic);

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
      // Notify navigation bar of selection (for selection state/animation)
      widget.onNavigationSelected?.call();
      // Also call user's custom onTap
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Use the same circle colors as VooExpandableNavItem
    final circleColor = widget.isSelected ? context.expandableNavSelectedCircle(widget.avatarColor) : context.expandableNavUnselectedCircle;

    // Measure label width using shared layout
    final labelWidth = VooExpandableNavItemLayout.measureLabelWidth(widget.config.effectiveNavItemLabel, widget.maxLabelWidth);

    // Build avatar circle using shared layout
    final circle = VooExpandableNavItemLayout.buildCircle(color: circleColor, child: _buildAvatarContent(context, theme));

    return GestureDetector(
      key: buttonKey,
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final progress = _expandAnimation.value.clamp(0.0, 1.0);
          final labelProgress = _labelOpacity.value.clamp(0.0, 1.0);

          // Calculate animated values
          final animatedLabelWidth = labelWidth * progress;
          final animatedSpacing = VooExpandableNavItemLayout.spacing * progress;
          final animatedTextPadding = VooExpandableNavItemLayout.textPadding * progress;

          // Build label using shared layout
          final label = VooExpandableNavItemLayout.buildLabel(text: widget.config.effectiveNavItemLabel, opacity: labelProgress, color: context.expandableNavSelectedLabel);

          // Build row children using shared layout (single source of truth)
          final rowChildren = VooExpandableNavItemLayout.buildRowChildren(
            circle: circle,
            label: label,
            animatedLabelWidth: animatedLabelWidth,
            animatedSpacing: animatedSpacing,
            animatedTextPadding: animatedTextPadding,
            labelPosition: widget.labelPosition,
          );

          // Build container using shared layout, wrapped in Tooltip
          return Tooltip(
            message: widget.config.effectiveNavItemLabel,
            child: VooExpandableNavItemLayout.buildContainer(rowChildren: rowChildren, progress: progress, selectedBackgroundColor: context.expandableNavSelectedBackground),
          );
        },
      ),
    );
  }

  /// Builds the avatar content that sits inside the circle.
  /// The content is sized to fit within the circle with some padding.
  Widget _buildAvatarContent(BuildContext context, ThemeData theme) {
    final circleSize = VooExpandableNavItemLayout.circleSize;
    // Inner content size (smaller than circle to show background ring)
    final contentSize = circleSize * 0.9;

    // If custom avatar widget provided, use it
    if (widget.config.avatarWidget != null) {
      return SizedBox(
        width: contentSize,
        height: contentSize,
        child: ClipOval(child: widget.config.avatarWidget),
      );
    }

    // If avatar URL provided, show image with loading animation
    if (widget.config.avatarUrl != null && widget.config.avatarUrl!.isNotEmpty) {
      return ClipOval(
        child: SizedBox(
          width: contentSize,
          height: contentSize,
          child: Image(
            image: _getImageProvider(widget.config.avatarUrl!),
            fit: BoxFit.cover,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded || frame != null) {
                return child;
              }
              // Show loading animation while image loads
              return _AvatarLoadingIndicator(size: contentSize);
            },
            errorBuilder: (context, error, stackTrace) {
              // Show initials on error
              return _buildInitials(context, circleSize);
            },
          ),
        ),
      );
    }

    // Otherwise show initials (text only, background is the circle)
    return _buildInitials(context, circleSize);
  }

  /// Builds initials text widget
  Widget _buildInitials(BuildContext context, double circleSize) {
    final initials = widget.config.effectiveInitials ?? '?';
    // Use icon color to match how regular nav items style their icons
    final textColor = widget.isSelected ? context.expandableNavSelectedIcon : context.expandableNavUnselectedIcon;

    return Text(
      initials,
      style: TextStyle(color: textColor, fontSize: circleSize * 0.36, fontWeight: FontWeight.w600),
    );
  }

  ImageProvider _getImageProvider(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return NetworkImage(url);
    }
    return AssetImage(url);
  }
}

/// A pulsing loading indicator for avatar images
class _AvatarLoadingIndicator extends StatefulWidget {
  final double size;

  const _AvatarLoadingIndicator({required this.size});

  @override
  State<_AvatarLoadingIndicator> createState() => _AvatarLoadingIndicatorState();
}

class _AvatarLoadingIndicatorState extends State<_AvatarLoadingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this)..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.expandableNavUnselectedIcon.withValues(alpha: _animation.value),
          ),
          child: Center(
            child: Icon(Icons.person_outline, size: widget.size * 0.5, color: context.expandableNavUnselectedCircle),
          ),
        );
      },
    );
  }
}
