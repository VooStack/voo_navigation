import 'package:flutter/material.dart';

/// Design constants for the **minimal** Voo navigation aesthetic.
///
/// Inspired by Linear and Vercel: neutral palette, hairline borders, very
/// subtle elevation, restrained motion, tight radii. These constants are the
/// raw values; widgets should prefer reading the brightness-resolved values
/// from [VooMinimalTheme] when inside a [BuildContext].
class VooMinimal {
  VooMinimal._();

  // ---------------------------------------------------------------------------
  // Light palette
  // ---------------------------------------------------------------------------

  static const Color lightBackground = Color(0xFFFFFFFF);

  /// Default page surface — sits one tier below content cards.
  static const Color lightSurface = Color(0xFFFAFAFA);

  /// Elevated surface (cards, dropdowns, modals).
  static const Color lightSurfaceElevated = Color(0xFFFFFFFF);

  /// Subtle background tint (selected items, secondary surfaces).
  static const Color lightSurfaceMuted = Color(0xFFF4F4F5);

  /// Hairline border — barely visible, used to separate surfaces.
  static const Color lightBorder = Color(0x0F000000); // 6% black

  /// Stronger border — used for inputs and focus rings.
  static const Color lightBorderStrong = Color(0x1F000000); // 12% black

  static const Color lightTextPrimary = Color(0xFF09090B);
  static const Color lightTextSecondary = Color(0xFF52525B);
  static const Color lightTextTertiary = Color(0xFFA1A1AA);
  static const Color lightTextOnAccent = Color(0xFFFFFFFF);

  // ---------------------------------------------------------------------------
  // Dark palette
  // ---------------------------------------------------------------------------

  // Progression goes darkest → lightest:
  //   background < surface < surfaceMuted < surfaceElevated
  // so M3's `surfaceContainerHighest` (used for popups/dropdowns) lands on
  // the brightest tone, matching how Linear / Vercel surface dropdowns.
  static const Color darkBackground = Color(0xFF0A0A0A);
  static const Color darkSurface = Color(0xFF0F0F10);
  static const Color darkSurfaceMuted = Color(0xFF161618);
  static const Color darkSurfaceElevated = Color(0xFF1C1C1F);

  static const Color darkBorder = Color(0x14FFFFFF); // 8% white
  static const Color darkBorderStrong = Color(0x29FFFFFF); // 16% white

  static const Color darkTextPrimary = Color(0xFFFAFAFA);
  static const Color darkTextSecondary = Color(0xFFA1A1AA);
  static const Color darkTextTertiary = Color(0xFF71717A);
  static const Color darkTextOnAccent = Color(0xFFFFFFFF);

  // ---------------------------------------------------------------------------
  // Accent
  // ---------------------------------------------------------------------------

  /// Default accent — a neutral, slightly cool blue. Consumers can override
  /// via [VooMinimalTheme.light] / [VooMinimalTheme.dark].
  static const Color accent = Color(0xFF3B82F6);

  // ---------------------------------------------------------------------------
  // State-layer opacities
  // ---------------------------------------------------------------------------

  /// Opacity applied to the foreground color when hovering.
  static const double stateHoverOpacity = 0.05;

  /// Opacity applied to the foreground color when pressed.
  static const double statePressedOpacity = 0.10;

  /// Opacity applied to the foreground color for selected items.
  static const double stateSelectedOpacity = 0.07;

  /// Opacity applied to the foreground color for focused items.
  static const double stateFocusOpacity = 0.12;

  /// Opacity applied to the foreground color for disabled items.
  static const double stateDisabledOpacity = 0.38;

  // ---------------------------------------------------------------------------
  // Radii
  // ---------------------------------------------------------------------------

  /// Tight radii for the minimal aesthetic. Note: these are slightly smaller
  /// than the defaults in `voo_tokens`.
  static const double radiusXs = 4;
  static const double radiusSm = 6;
  static const double radiusMd = 8;
  static const double radiusLg = 10;
  static const double radiusXl = 14;
  static const double radiusFull = 9999;

  static const BorderRadius brXs = BorderRadius.all(Radius.circular(radiusXs));
  static const BorderRadius brSm = BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius brMd = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius brLg = BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius brXl = BorderRadius.all(Radius.circular(radiusXl));

  // ---------------------------------------------------------------------------
  // Motion
  // ---------------------------------------------------------------------------

  static const Duration motionFast = Duration(milliseconds: 120);
  static const Duration motionNormal = Duration(milliseconds: 180);
  static const Duration motionSlow = Duration(milliseconds: 240);

  /// Standard Material easing — close to what Linear / Vercel use.
  static const Cubic motionCurve = Cubic(0.4, 0.0, 0.2, 1.0);
  static const Cubic motionCurveOut = Cubic(0.0, 0.0, 0.2, 1.0);
  static const Cubic motionCurveIn = Cubic(0.4, 0.0, 1.0, 1.0);

  // ---------------------------------------------------------------------------
  // Strokes / elevation
  // ---------------------------------------------------------------------------

  static const double strokeWidth = 1.0;

  /// Subtle pop for dropdowns and overlays — never heavy.
  static const List<BoxShadow> dropdownShadow = [
    BoxShadow(
      blurRadius: 20,
      offset: Offset(0, 8),
      color: Color(0x14000000), // 8% black
    ),
    BoxShadow(
      blurRadius: 2,
      offset: Offset(0, 1),
      color: Color(0x0A000000), // 4% black
    ),
  ];

  /// Very subtle card lift on hover. Avoid otherwise.
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      blurRadius: 2,
      offset: Offset(0, 1),
      color: Color(0x0A000000),
    ),
  ];

  // ---------------------------------------------------------------------------
  // Typography sizes (font family stays on Theme.textTheme)
  // ---------------------------------------------------------------------------

  static const double fontSizeXs = 11;
  static const double fontSizeSm = 12;
  static const double fontSizeBase = 13;
  static const double fontSizeMd = 14;
  static const double fontSizeLg = 16;
  static const double fontSizeXl = 20;
  static const double fontSize2xl = 24;

  /// Slightly negative tracking for headings reads as "designed".
  static const double letterSpacingTight = -0.18;
  static const double letterSpacingNormal = 0.0;

  // ---------------------------------------------------------------------------
  // Sizes
  // ---------------------------------------------------------------------------

  /// Default icon size for inline icons (buttons, list items).
  static const double iconSize = 16;

  /// Smaller icon size (badges, status indicators).
  static const double iconSizeSm = 14;

  /// Larger icon (empty states, big buttons).
  static const double iconSizeLg = 20;

  /// Height of a single-line list row.
  static const double rowHeight = 36;

  /// Height of a control (button, input).
  static const double controlHeight = 32;

  /// Height of a tap-targetable list item (slightly larger for mobile).
  static const double rowHeightLg = 44;
}
