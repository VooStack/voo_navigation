import 'package:flutter/material.dart';

/// Style configuration for the multi-switcher component.
///
/// This class allows customization of the card (closed state) and
/// modal (open state) appearance, including colors, spacing, and animations.
class VooMultiSwitcherStyle {
  // ============================================================================
  // CARD STYLING (closed state)
  // ============================================================================

  /// Border radius of the card
  final BorderRadius? cardBorderRadius;

  /// Background color of the card
  final Color? cardBackgroundColor;

  /// Background color when hovering over the card
  final Color? cardHoverColor;

  /// Padding inside the card
  final EdgeInsets? cardPadding;

  /// Custom decoration for the card (overrides other card properties)
  final BoxDecoration? cardDecoration;

  // ============================================================================
  // MODAL STYLING (open state)
  // ============================================================================

  /// Border radius of the modal
  final BorderRadius? modalBorderRadius;

  /// Background color of the modal
  final Color? modalBackgroundColor;

  /// Maximum height of the modal
  final double? modalMaxHeight;

  /// Padding inside the modal
  final EdgeInsets? modalPadding;

  /// Custom decoration for the modal (overrides other modal properties)
  final BoxDecoration? modalDecoration;

  // ============================================================================
  // SECTION STYLING
  // ============================================================================

  /// Text style for section titles (e.g., "Organizations", "Account")
  final TextStyle? sectionTitleStyle;

  /// Color for dividers between sections
  final Color? sectionDividerColor;

  /// Padding around section content
  final EdgeInsets? sectionPadding;

  // ============================================================================
  // ITEM STYLING
  // ============================================================================

  /// Size of avatars in the expanded/full view
  final double avatarSize;

  /// Size of avatars in compact mode
  final double compactAvatarSize;

  /// Size of the stacked user avatar in the card
  final double stackedUserAvatarSize;

  /// Size of the stacked org avatar in the card
  final double stackedOrgAvatarSize;

  /// Text style for item titles (org name, user name)
  final TextStyle? titleStyle;

  /// Text style for item subtitles (org subtitle, user email)
  final TextStyle? subtitleStyle;

  /// Background color for selected items
  final Color? selectedColor;

  /// Background color when hovering over items
  final Color? hoverColor;

  /// Padding inside list items
  final EdgeInsets? itemPadding;

  /// Border radius for list items
  final BorderRadius? itemBorderRadius;

  // ============================================================================
  // ANIMATION
  // ============================================================================

  /// Duration of the modal slide animation
  final Duration? animationDuration;

  /// Curve for the modal animation
  final Curve? animationCurve;

  const VooMultiSwitcherStyle({
    // Card
    this.cardBorderRadius,
    this.cardBackgroundColor,
    this.cardHoverColor,
    this.cardPadding,
    this.cardDecoration,
    // Modal
    this.modalBorderRadius,
    this.modalBackgroundColor,
    this.modalMaxHeight,
    this.modalPadding,
    this.modalDecoration,
    // Sections
    this.sectionTitleStyle,
    this.sectionDividerColor,
    this.sectionPadding,
    // Items
    this.avatarSize = 36,
    this.compactAvatarSize = 32,
    this.stackedUserAvatarSize = 24,
    this.stackedOrgAvatarSize = 32,
    this.titleStyle,
    this.subtitleStyle,
    this.selectedColor,
    this.hoverColor,
    this.itemPadding,
    this.itemBorderRadius,
    // Animation
    this.animationDuration,
    this.animationCurve,
  });

  /// Creates a copy with the given fields replaced
  VooMultiSwitcherStyle copyWith({
    // Card
    BorderRadius? cardBorderRadius,
    Color? cardBackgroundColor,
    Color? cardHoverColor,
    EdgeInsets? cardPadding,
    BoxDecoration? cardDecoration,
    // Modal
    BorderRadius? modalBorderRadius,
    Color? modalBackgroundColor,
    double? modalMaxHeight,
    EdgeInsets? modalPadding,
    BoxDecoration? modalDecoration,
    // Sections
    TextStyle? sectionTitleStyle,
    Color? sectionDividerColor,
    EdgeInsets? sectionPadding,
    // Items
    double? avatarSize,
    double? compactAvatarSize,
    double? stackedUserAvatarSize,
    double? stackedOrgAvatarSize,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    Color? selectedColor,
    Color? hoverColor,
    EdgeInsets? itemPadding,
    BorderRadius? itemBorderRadius,
    // Animation
    Duration? animationDuration,
    Curve? animationCurve,
  }) =>
      VooMultiSwitcherStyle(
        // Card
        cardBorderRadius: cardBorderRadius ?? this.cardBorderRadius,
        cardBackgroundColor: cardBackgroundColor ?? this.cardBackgroundColor,
        cardHoverColor: cardHoverColor ?? this.cardHoverColor,
        cardPadding: cardPadding ?? this.cardPadding,
        cardDecoration: cardDecoration ?? this.cardDecoration,
        // Modal
        modalBorderRadius: modalBorderRadius ?? this.modalBorderRadius,
        modalBackgroundColor: modalBackgroundColor ?? this.modalBackgroundColor,
        modalMaxHeight: modalMaxHeight ?? this.modalMaxHeight,
        modalPadding: modalPadding ?? this.modalPadding,
        modalDecoration: modalDecoration ?? this.modalDecoration,
        // Sections
        sectionTitleStyle: sectionTitleStyle ?? this.sectionTitleStyle,
        sectionDividerColor: sectionDividerColor ?? this.sectionDividerColor,
        sectionPadding: sectionPadding ?? this.sectionPadding,
        // Items
        avatarSize: avatarSize ?? this.avatarSize,
        compactAvatarSize: compactAvatarSize ?? this.compactAvatarSize,
        stackedUserAvatarSize:
            stackedUserAvatarSize ?? this.stackedUserAvatarSize,
        stackedOrgAvatarSize:
            stackedOrgAvatarSize ?? this.stackedOrgAvatarSize,
        titleStyle: titleStyle ?? this.titleStyle,
        subtitleStyle: subtitleStyle ?? this.subtitleStyle,
        selectedColor: selectedColor ?? this.selectedColor,
        hoverColor: hoverColor ?? this.hoverColor,
        itemPadding: itemPadding ?? this.itemPadding,
        itemBorderRadius: itemBorderRadius ?? this.itemBorderRadius,
        // Animation
        animationDuration: animationDuration ?? this.animationDuration,
        animationCurve: animationCurve ?? this.animationCurve,
      );

  /// Default animation duration for the modal
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  /// Default animation curve for the modal (slight overshoot for bouncy feel)
  static const Curve defaultAnimationCurve = Curves.easeOutBack;

  /// Default maximum height for the modal
  static const double defaultModalMaxHeight = 400;

  /// Default slide distance for the modal animation
  static const double defaultSlideDistance = 300;
}

/// Position of the multi-switcher in the navigation
enum VooMultiSwitcherPosition {
  /// In the header area
  header,

  /// In the footer area (default, recommended)
  footer,

  /// Render as a navigation item in rail/bottom nav.
  asNavItem,
}
