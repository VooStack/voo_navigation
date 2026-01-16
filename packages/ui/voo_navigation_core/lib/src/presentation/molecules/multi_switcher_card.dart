import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/multi_switcher_config.dart';
import 'package:voo_navigation_core/src/domain/entities/multi_switcher_style.dart';
import 'package:voo_navigation_core/src/domain/tokens/voo_navigation_tokens.dart';
import 'package:voo_navigation_core/src/presentation/molecules/multi_switcher_tiles.dart';

/// Card component for the multi-switcher (closed state).
///
/// This widget displays a compact view showing the current organization
/// and user with stacked avatars. Tapping expands to show the modal.
class VooMultiSwitcherCard extends StatefulWidget {
  /// Configuration for the multi-switcher
  final VooMultiSwitcherConfig config;

  /// Whether the modal is currently expanded
  final bool isExpanded;

  /// Whether to show in compact mode (avatar only)
  final bool compact;

  /// Callback when the card is tapped
  final VoidCallback onTap;

  const VooMultiSwitcherCard({
    super.key,
    required this.config,
    required this.isExpanded,
    required this.compact,
    required this.onTap,
  });

  @override
  State<VooMultiSwitcherCard> createState() => _VooMultiSwitcherCardState();
}

class _VooMultiSwitcherCardState extends State<VooMultiSwitcherCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = widget.config.style ?? const VooMultiSwitcherStyle();

    // Allow custom card builder
    if (widget.config.cardBuilder != null) {
      return widget.config.cardBuilder!(
        context,
        VooMultiSwitcherCardData(
          selectedOrganization: widget.config.selectedOrganization,
          userName: widget.config.userName,
          userEmail: widget.config.userEmail,
          avatarUrl: widget.config.avatarUrl,
          avatarWidget: widget.config.avatarWidget,
          initials: widget.config.initials,
          status: widget.config.status,
          isExpanded: widget.isExpanded,
          onTap: widget.onTap,
        ),
      );
    }

    // Compact mode - just stacked avatars
    if (widget.compact) {
      final tooltipMessage = [
        widget.config.selectedOrganization?.name ?? 'Organization',
        widget.config.userName ?? 'User',
      ].join('\n');

      return Tooltip(
        message: tooltipMessage,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: _isHovered || widget.isExpanded
                    ? theme.colorScheme.onSurface.withValues(alpha: 0.05)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: VooStackedAvatars(
                organization: widget.config.selectedOrganization,
                userAvatarUrl: widget.config.avatarUrl,
                userName: widget.config.userName,
                status: widget.config.status,
                orgAvatarSize: style.compactAvatarSize,
                userAvatarSize: style.compactAvatarSize * 0.65,
              ),
            ),
          ),
        ),
      );
    }

    // Default full card layout
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: style.cardBorderRadius ??
              BorderRadius.circular(VooNavigationTokens.itemBorderRadius),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: style.cardPadding ??
                const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: style.cardDecoration ??
                BoxDecoration(
                  color: _isHovered || widget.isExpanded
                      ? theme.colorScheme.onSurface.withValues(alpha: 0.05)
                      : Colors.transparent,
                  borderRadius: style.cardBorderRadius ??
                      BorderRadius.circular(VooNavigationTokens.itemBorderRadius),
                  border: _isHovered || widget.isExpanded
                      ? Border.all(
                          color: theme.colorScheme.outline.withValues(alpha: 0.1),
                        )
                      : Border.all(color: Colors.transparent),
                ),
            child: Row(
              children: [
                // Stacked avatars (org + user)
                VooStackedAvatars(
                  organization: widget.config.selectedOrganization,
                  userAvatarUrl: widget.config.avatarUrl,
                  userName: widget.config.userName,
                  status: widget.config.status,
                  orgAvatarSize: style.stackedOrgAvatarSize,
                  userAvatarSize: style.stackedUserAvatarSize,
                ),
                const SizedBox(width: 10),
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.config.selectedOrganization?.name ??
                            'Select Organization',
                        style: style.titleStyle ??
                            theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.config.userName ?? 'Select User',
                        style: style.subtitleStyle ??
                            theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 12,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Chevron indicator
                AnimatedRotation(
                  turns: widget.isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: VooNavigationTokens.chevronSize,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
