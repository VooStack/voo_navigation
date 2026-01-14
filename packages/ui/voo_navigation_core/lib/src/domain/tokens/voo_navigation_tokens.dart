import 'package:flutter/material.dart';

/// Navigation-specific design tokens for consistent styling
/// across drawer, rail, and bottom navigation components.
///
/// These tokens ensure visual consistency and make it easy to
/// update the design system in one place.
abstract final class VooNavigationTokens {
  // === Icon Sizes ===
  /// Default icon size for navigation items (extended/drawer mode)
  static const double iconSizeDefault = 18.0;

  /// Icon size for compact/collapsed navigation items
  static const double iconSizeCompact = 20.0;

  // === Border Radius ===
  /// Border radius for navigation item containers
  static const double itemBorderRadius = 8.0;

  /// Border radius for floating bottom navigation pill
  static const double floatingNavBorderRadius = 28.0;

  // === Spacing ===
  /// Horizontal padding inside navigation items
  static const double itemPaddingHorizontal = 10.0;

  /// Vertical padding inside navigation items
  static const double itemPaddingVertical = 10.0;

  /// Vertical padding for child navigation items (slightly less)
  static const double itemChildPaddingVertical = 7.0;

  /// Spacing between icon and label
  static const double iconLabelSpacing = 10.0;

  // === Typography ===
  /// Font size for navigation item labels
  static const double labelFontSize = 13.0;

  /// Font weight for navigation item labels
  static const FontWeight labelFontWeight = FontWeight.w500;

  /// Font weight for selected navigation item labels
  static const FontWeight labelFontWeightSelected = FontWeight.w600;

  // === Opacity Tokens (Semantic) ===
  /// Background opacity for selected items
  static const double opacitySelectedBackground = 0.10;

  /// Background opacity for hovered items
  static const double opacityHoverBackground = 0.04;

  /// Opacity for muted/unselected icons
  static const double opacityMutedIcon = 0.7;

  /// Opacity for muted/secondary text
  static const double opacityMutedText = 0.85;

  /// Opacity for disabled elements
  static const double opacityDisabled = 0.5;

  /// Opacity for dividers and subtle borders
  static const double opacityDivider = 0.1;

  /// Opacity for very subtle borders
  static const double opacityBorderSubtle = 0.08;

  // === Chevron/Dropdown ===
  /// Size for dropdown chevron icons
  static const double chevronSize = 18.0;

  // === Badge ===
  /// Badge font size in extended mode
  static const double badgeFontSizeExtended = 11.0;

  /// Badge font size in compact mode
  static const double badgeFontSizeCompact = 10.0;
}

/// Extension methods for applying navigation tokens with theme awareness.
///
/// These methods generate colors based on the current theme, ensuring
/// proper light/dark mode support.
extension VooNavigationTokensTheme on BuildContext {
  /// Selected item background color with proper opacity.
  ///
  /// Uses the primary color with [VooNavigationTokens.opacitySelectedBackground].
  Color navSelectedBackground([Color? customColor]) {
    final color = customColor ?? Theme.of(this).colorScheme.primary;
    return color.withValues(alpha: VooNavigationTokens.opacitySelectedBackground);
  }

  /// Hover item background color with proper opacity.
  ///
  /// Uses onSurface color with [VooNavigationTokens.opacityHoverBackground].
  Color get navHoverBackground {
    final onSurface = Theme.of(this).colorScheme.onSurface;
    return onSurface.withValues(alpha: VooNavigationTokens.opacityHoverBackground);
  }

  /// Muted icon color for unselected navigation items.
  ///
  /// Uses onSurface color with [VooNavigationTokens.opacityMutedIcon].
  Color get navMutedIconColor {
    final onSurface = Theme.of(this).colorScheme.onSurface;
    return onSurface.withValues(alpha: VooNavigationTokens.opacityMutedIcon);
  }

  /// Theme-aware floating navigation background color.
  ///
  /// Uses surfaceContainerHighest for a slightly elevated surface appearance
  /// that works in both light and dark modes.
  Color get floatingNavBackground {
    return Theme.of(this).colorScheme.surfaceContainerHighest;
  }

  /// Theme-aware floating navigation foreground color.
  ///
  /// Returns the appropriate text/icon color for floating nav.
  Color get floatingNavForeground {
    return Theme.of(this).colorScheme.onSurface;
  }

  /// Theme-aware floating navigation selected color.
  ///
  /// Returns the primary color for selected items in floating nav.
  Color get floatingNavSelectedColor {
    return Theme.of(this).colorScheme.primary;
  }

  /// Divider color with proper opacity.
  Color get navDividerColor {
    return Theme.of(this).dividerColor.withValues(alpha: VooNavigationTokens.opacityDivider);
  }

  /// Subtle border color.
  Color get navBorderSubtle {
    return Theme.of(this).dividerColor.withValues(alpha: VooNavigationTokens.opacityBorderSubtle);
  }
}
