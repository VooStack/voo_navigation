import 'package:flutter/material.dart';

/// Style configuration for the context switcher component.
///
/// This class allows customization of the card (closed state) and
/// modal (open state) appearance, including colors, spacing, and animations.
class VooContextSwitcherStyle {
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
  // ITEM STYLING
  // ============================================================================

  /// Size of avatars/icons in the list
  final double avatarSize;

  /// Size of avatars/icons in compact mode
  final double compactAvatarSize;

  /// Text style for item names
  final TextStyle? titleStyle;

  /// Text style for item subtitles
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

  const VooContextSwitcherStyle({
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
    // Items
    this.avatarSize = 32,
    this.compactAvatarSize = 28,
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
  VooContextSwitcherStyle copyWith({
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
    // Items
    double? avatarSize,
    double? compactAvatarSize,
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
      VooContextSwitcherStyle(
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
        // Items
        avatarSize: avatarSize ?? this.avatarSize,
        compactAvatarSize: compactAvatarSize ?? this.compactAvatarSize,
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
  static const double defaultModalMaxHeight = 320;

  /// Default slide distance for the modal animation
  static const double defaultSlideDistance = 200;
}

/// Position of the context switcher in the navigation
enum VooContextSwitcherPosition {
  /// Before the navigation items (after header/search)
  beforeItems,

  /// After the header section
  afterHeader,
}
