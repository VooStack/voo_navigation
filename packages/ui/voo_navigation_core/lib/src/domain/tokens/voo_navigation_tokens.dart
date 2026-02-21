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

  // === Expandable Bottom Navigation ===
  /// Height of the expandable nav bar
  static const double expandableNavBarHeight = 64.0;

  /// Height/width for unselected expandable nav items (the circle container)
  static const double expandableNavItemSize = 48.0;

  /// Horizontal padding inside the nav bar
  static const double expandableNavBarPaddingHorizontal = 8.0;

  /// Vertical padding inside the nav bar
  static const double expandableNavBarPaddingVertical = 8.0;

  /// Horizontal padding inside expanded selected item container
  static const double expandableNavSelectedPaddingHorizontal = 4.0;

  /// Vertical padding inside expanded selected item container
  static const double expandableNavSelectedPaddingVertical = 4.0;

  /// Border radius for expandable nav container (fully rounded)
  static const double expandableNavBorderRadius = 100.0;

  /// Border radius for selected item background
  static const double expandableNavSelectedBorderRadius = 28.0;

  /// Border width for expandable nav container
  static const double expandableNavBorderWidth = 1.0;

  /// Border opacity for expandable nav container
  static const double expandableNavBorderOpacity = 0.1;

  /// Spacing between icon circle and label in expanded state
  static const double expandableNavIconLabelSpacing = 10.0;

  /// Label font size for expandable nav items
  static const double expandableNavLabelFontSize = 14.0;

  /// Label font weight for expandable nav items
  static const FontWeight expandableNavLabelFontWeight = FontWeight.w500;

  /// Animation duration for expandable nav in milliseconds
  static const int expandableNavAnimationDurationMs = 300;

  /// Icon size for expandable nav action item
  static const double expandableNavActionIconSize = 24.0;

  /// Size of the colored circle containing the icon in selected state
  static const double expandableNavSelectedCircleSize = 44.0;

  /// Minimum spacing between nav items
  static const double expandableNavItemSpacing = 8.0;
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

  /// Divider color with proper opacity.
  Color get navDividerColor {
    return Theme.of(this).dividerColor.withValues(alpha: VooNavigationTokens.opacityDivider);
  }

  /// Subtle border color.
  Color get navBorderSubtle {
    return Theme.of(this).dividerColor.withValues(alpha: VooNavigationTokens.opacityBorderSubtle);
  }

  // === Expandable Bottom Navigation Theme Extensions ===

  /// Background color for expandable nav container.
  Color get expandableNavBackground {
    return Theme.of(this).colorScheme.surfaceContainer;
  }

  /// Border color for expandable nav container.
  Color get expandableNavBorder {
    final onSurface = Theme.of(this).colorScheme.onSurface;
    return onSurface.withValues(alpha: VooNavigationTokens.expandableNavBorderOpacity);
  }

  /// Background color for selected item circle in expandable nav.
  Color expandableNavSelectedCircle([Color? customColor]) {
    return customColor ?? Theme.of(this).colorScheme.primary;
  }

  /// Background color for unselected item circles in expandable nav.
  Color get expandableNavUnselectedCircle {
    return Theme.of(this).colorScheme.surfaceContainerHighest;
  }

  /// Background color for the selected item container (rounded rectangle).
  Color get expandableNavSelectedBackground {
    return Theme.of(this).colorScheme.surfaceContainerHigh;
  }

  /// Icon color for unselected items in expandable nav.
  Color get expandableNavUnselectedIcon {
    return Theme.of(this).colorScheme.onSurfaceVariant;
  }

  /// Icon color for selected items in expandable nav (on colored circle).
  Color get expandableNavSelectedIcon {
    return Theme.of(this).colorScheme.onPrimary;
  }

  /// Label color for selected items in expandable nav.
  Color get expandableNavSelectedLabel {
    return Theme.of(this).colorScheme.onSurface;
  }
}
