import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/presentation/atoms/voo_avatar_initials_placeholder.dart';

/// A reusable avatar widget that displays an image, initials, or custom widget
class VooAvatar extends StatelessWidget {
  /// URL for the avatar image
  final String? imageUrl;

  /// Custom widget to display (takes precedence over imageUrl and initials)
  final Widget? child;

  /// Text to generate initials from (typically a name)
  final String? name;

  /// Direct initials to display (takes precedence over name-generated initials)
  final String? initials;

  /// Size of the avatar
  final double size;

  /// Background color for initials/placeholder
  final Color? backgroundColor;

  /// Text color for initials
  final Color? foregroundColor;

  /// Border radius (defaults to circular)
  final BorderRadius? borderRadius;

  /// Border to display around the avatar
  final BoxBorder? border;

  /// Shadow for the avatar
  final List<BoxShadow>? boxShadow;

  /// Icon to show when no image/initials available
  final IconData? placeholderIcon;

  /// Callback when avatar is tapped
  final VoidCallback? onTap;

  /// Whether to show a loading indicator when image is loading
  final bool showLoadingIndicator;

  /// Error widget to show when image fails to load
  final Widget? errorWidget;

  const VooAvatar({
    super.key,
    this.imageUrl,
    this.child,
    this.name,
    this.initials,
    this.size = 40,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.placeholderIcon,
    this.onTap,
    this.showLoadingIndicator = false,
    this.errorWidget,
  });

  /// Generates initials from a name
  String _generateInitials(String name) {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '';
    if (words.length == 1) {
      return words.first.substring(0, words.first.length.clamp(0, 2)).toUpperCase();
    }
    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }

  /// Gets a color based on the name for consistent coloring
  Color _getColorFromName(String name, ColorScheme colorScheme) {
    final colors = [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
      Colors.teal,
      Colors.indigo,
      Colors.orange,
      Colors.pink,
      Colors.cyan,
    ];
    final hash = name.hashCode.abs();
    return colors[hash % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveInitials = initials ?? (name != null ? _generateInitials(name!) : null);
    final effectiveBgColor = backgroundColor ??
        (name != null ? _getColorFromName(name!, colorScheme) : colorScheme.primaryContainer);
    final effectiveFgColor = foregroundColor ?? colorScheme.onPrimaryContainer;
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(size / 2);

    Widget avatarContent;

    if (child != null) {
      avatarContent = child!;
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      avatarContent = ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: Image.network(
          imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          loadingBuilder: showLoadingIndicator
              ? (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: SizedBox(
                      width: size * 0.4,
                      height: size * 0.4,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                }
              : null,
          errorBuilder: (context, error, stackTrace) {
            return errorWidget ??
                VooAvatarInitialsPlaceholder(
                  initials: effectiveInitials,
                  bgColor: effectiveBgColor,
                  fgColor: effectiveFgColor,
                  borderRadius: effectiveBorderRadius,
                  size: size,
                  placeholderIcon: placeholderIcon,
                );
          },
        ),
      );
    } else {
      avatarContent = VooAvatarInitialsPlaceholder(
        initials: effectiveInitials,
        bgColor: effectiveBgColor,
        fgColor: effectiveFgColor,
        borderRadius: effectiveBorderRadius,
        size: size,
        placeholderIcon: placeholderIcon,
      );
    }

    Widget avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: effectiveBorderRadius,
        border: border,
        boxShadow: boxShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: avatarContent,
    );

    if (onTap != null) {
      avatar = InkWell(
        onTap: onTap,
        borderRadius: effectiveBorderRadius,
        child: avatar,
      );
    }

    return avatar;
  }
}

/// A group of overlapping avatars
class VooAvatarGroup extends StatelessWidget {
  /// List of avatar configurations
  final List<VooAvatarData> avatars;

  /// Maximum number of avatars to show
  final int maxAvatars;

  /// Size of each avatar
  final double avatarSize;

  /// Overlap amount between avatars
  final double overlap;

  /// Border around each avatar
  final BoxBorder? avatarBorder;

  /// Callback when the overflow indicator is tapped
  final VoidCallback? onOverflowTap;

  const VooAvatarGroup({
    super.key,
    required this.avatars,
    this.maxAvatars = 4,
    this.avatarSize = 32,
    this.overlap = 8,
    this.avatarBorder,
    this.onOverflowTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayAvatars = avatars.take(maxAvatars).toList();
    final overflowCount = avatars.length - maxAvatars;

    final effectiveBorder = avatarBorder ?? Border.all(
      color: theme.colorScheme.surface,
      width: 2,
    );

    return SizedBox(
      height: avatarSize,
      child: Stack(
        children: [
          for (int i = 0; i < displayAvatars.length; i++)
            Positioned(
              left: i * (avatarSize - overlap),
              child: VooAvatar(
                imageUrl: displayAvatars[i].imageUrl,
                name: displayAvatars[i].name,
                initials: displayAvatars[i].initials,
                backgroundColor: displayAvatars[i].backgroundColor,
                size: avatarSize,
                border: effectiveBorder,
              ),
            ),
          if (overflowCount > 0)
            Positioned(
              left: displayAvatars.length * (avatarSize - overlap),
              child: GestureDetector(
                onTap: onOverflowTap,
                child: Container(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                    border: effectiveBorder,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '+$overflowCount',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Data class for avatar configuration
class VooAvatarData {
  final String? imageUrl;
  final String? name;
  final String? initials;
  final Color? backgroundColor;

  const VooAvatarData({
    this.imageUrl,
    this.name,
    this.initials,
    this.backgroundColor,
  });
}
