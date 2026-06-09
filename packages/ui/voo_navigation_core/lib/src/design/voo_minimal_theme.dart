import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/design/voo_minimal.dart';

/// Brightness-resolved minimal design tokens exposed via [ThemeExtension].
///
/// Widgets read this via `Theme.of(context).extension<VooMinimalTheme>()`
/// or the `context.vooMinimal` extension. When the extension is not present
/// (consumer didn't opt in), [VooMinimalTheme.fallback] is returned, derived
/// from the ambient `ColorScheme`.
@immutable
class VooMinimalTheme extends ThemeExtension<VooMinimalTheme> {
  const VooMinimalTheme({
    required this.background,
    required this.surface,
    required this.surfaceElevated,
    required this.surfaceMuted,
    required this.border,
    required this.borderStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.accent,
    required this.textOnAccent,
    required this.hoverOverlay,
    required this.pressedOverlay,
    required this.selectedOverlay,
    required this.focusOverlay,
    this.dropdownShadow = VooMinimal.dropdownShadow,
    this.cardShadow = VooMinimal.cardShadow,
  });

  /// Light defaults.
  factory VooMinimalTheme.light({Color accent = VooMinimal.accent}) {
    return VooMinimalTheme(
      background: VooMinimal.lightBackground,
      surface: VooMinimal.lightSurface,
      surfaceElevated: VooMinimal.lightSurfaceElevated,
      surfaceMuted: VooMinimal.lightSurfaceMuted,
      border: VooMinimal.lightBorder,
      borderStrong: VooMinimal.lightBorderStrong,
      textPrimary: VooMinimal.lightTextPrimary,
      textSecondary: VooMinimal.lightTextSecondary,
      textTertiary: VooMinimal.lightTextTertiary,
      accent: accent,
      textOnAccent: VooMinimal.lightTextOnAccent,
      hoverOverlay: const Color(0x0A000000), // ~4% black
      pressedOverlay: const Color(0x14000000), // ~8%
      selectedOverlay: const Color(0x0F000000), // ~6%
      focusOverlay: const Color(0x1F000000), // ~12%
    );
  }

  /// Dark defaults.
  factory VooMinimalTheme.dark({Color accent = VooMinimal.accent}) {
    return VooMinimalTheme(
      background: VooMinimal.darkBackground,
      surface: VooMinimal.darkSurface,
      surfaceElevated: VooMinimal.darkSurfaceElevated,
      surfaceMuted: VooMinimal.darkSurfaceMuted,
      border: VooMinimal.darkBorder,
      borderStrong: VooMinimal.darkBorderStrong,
      textPrimary: VooMinimal.darkTextPrimary,
      textSecondary: VooMinimal.darkTextSecondary,
      textTertiary: VooMinimal.darkTextTertiary,
      accent: accent,
      textOnAccent: VooMinimal.darkTextOnAccent,
      hoverOverlay: const Color(0x14FFFFFF), // ~8% white
      pressedOverlay: const Color(0x29FFFFFF), // ~16%
      selectedOverlay: const Color(0x1FFFFFFF), // ~12%
      focusOverlay: const Color(0x3DFFFFFF), // ~24%
    );
  }

  /// Returns a fallback derived **entirely from the ambient [ColorScheme]**
  /// when the consumer hasn't opted into the minimal theme.
  ///
  /// This is the path that respects the consumer's own brand theme — every
  /// color (surfaces, borders, text, accent) is sourced from their
  /// `ColorScheme` rather than the curated Linear/Vercel palette. Widgets
  /// call this so they remain theme-conformant even without
  /// [VooMinimalTheme.light] / [VooMinimalTheme.dark] installed.
  factory VooMinimalTheme.fallback(ColorScheme scheme) {
    final dark = scheme.brightness == Brightness.dark;
    return VooMinimalTheme(
      background: scheme.surface,
      surface: scheme.surfaceContainerLow,
      surfaceElevated: scheme.surfaceContainerHighest,
      surfaceMuted: scheme.surfaceContainerHigh,
      border: scheme.outlineVariant,
      borderStrong: scheme.outline,
      textPrimary: scheme.onSurface,
      textSecondary: scheme.onSurfaceVariant,
      textTertiary: scheme.onSurfaceVariant.withValues(alpha: 0.65),
      accent: scheme.primary,
      textOnAccent: scheme.onPrimary,
      hoverOverlay: dark
          ? const Color(0x14FFFFFF)
          : const Color(0x0A000000),
      pressedOverlay: dark
          ? const Color(0x29FFFFFF)
          : const Color(0x14000000),
      selectedOverlay: scheme.primary.withValues(alpha: 0.08),
      focusOverlay: scheme.primary.withValues(alpha: 0.12),
    );
  }

  // Surfaces
  final Color background;
  final Color surface;
  final Color surfaceElevated;
  final Color surfaceMuted;

  // Borders
  final Color border;
  final Color borderStrong;

  // Text
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;

  // Accent
  final Color accent;
  final Color textOnAccent;

  // Interactive state overlays (applied on top of base surfaces)
  final Color hoverOverlay;
  final Color pressedOverlay;
  final Color selectedOverlay;
  final Color focusOverlay;

  // Elevation
  final List<BoxShadow> dropdownShadow;
  final List<BoxShadow> cardShadow;

  @override
  VooMinimalTheme copyWith({
    Color? background,
    Color? surface,
    Color? surfaceElevated,
    Color? surfaceMuted,
    Color? border,
    Color? borderStrong,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? accent,
    Color? textOnAccent,
    Color? hoverOverlay,
    Color? pressedOverlay,
    Color? selectedOverlay,
    Color? focusOverlay,
    List<BoxShadow>? dropdownShadow,
    List<BoxShadow>? cardShadow,
  }) {
    return VooMinimalTheme(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      accent: accent ?? this.accent,
      textOnAccent: textOnAccent ?? this.textOnAccent,
      hoverOverlay: hoverOverlay ?? this.hoverOverlay,
      pressedOverlay: pressedOverlay ?? this.pressedOverlay,
      selectedOverlay: selectedOverlay ?? this.selectedOverlay,
      focusOverlay: focusOverlay ?? this.focusOverlay,
      dropdownShadow: dropdownShadow ?? this.dropdownShadow,
      cardShadow: cardShadow ?? this.cardShadow,
    );
  }

  @override
  VooMinimalTheme lerp(ThemeExtension<VooMinimalTheme>? other, double t) {
    if (other is! VooMinimalTheme) return this;
    return VooMinimalTheme(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      textOnAccent: Color.lerp(textOnAccent, other.textOnAccent, t)!,
      hoverOverlay: Color.lerp(hoverOverlay, other.hoverOverlay, t)!,
      pressedOverlay: Color.lerp(pressedOverlay, other.pressedOverlay, t)!,
      selectedOverlay: Color.lerp(selectedOverlay, other.selectedOverlay, t)!,
      focusOverlay: Color.lerp(focusOverlay, other.focusOverlay, t)!,
      dropdownShadow: t < 0.5 ? dropdownShadow : other.dropdownShadow,
      cardShadow: t < 0.5 ? cardShadow : other.cardShadow,
    );
  }

  // ---------------------------------------------------------------------------
  // ThemeData builders
  // ---------------------------------------------------------------------------

  /// Builds a fully-configured light [ThemeData] applying the minimal aesthetic.
  static ThemeData lightThemeData({Color accent = VooMinimal.accent}) {
    return _buildThemeData(VooMinimalTheme.light(accent: accent), Brightness.light);
  }

  /// Builds a fully-configured dark [ThemeData] applying the minimal aesthetic.
  static ThemeData darkThemeData({Color accent = VooMinimal.accent}) {
    return _buildThemeData(VooMinimalTheme.dark(accent: accent), Brightness.dark);
  }
}

ThemeData _buildThemeData(VooMinimalTheme ext, Brightness brightness) {
  final dark = brightness == Brightness.dark;

  final scheme = ColorScheme(
    brightness: brightness,
    primary: ext.accent,
    onPrimary: ext.textOnAccent,
    secondary: ext.textSecondary,
    onSecondary: ext.textOnAccent,
    error: const Color(0xFFDC2626),
    onError: const Color(0xFFFFFFFF),
    surface: ext.background,
    onSurface: ext.textPrimary,
    surfaceContainerLowest: ext.background,
    surfaceContainerLow: ext.surface,
    surfaceContainer: ext.surface,
    surfaceContainerHigh: ext.surfaceMuted,
    surfaceContainerHighest: ext.surfaceElevated,
    onSurfaceVariant: ext.textSecondary,
    outline: ext.borderStrong,
    outlineVariant: ext.border,
  );

  final base = ThemeData(
    brightness: brightness,
    colorScheme: scheme,
    useMaterial3: true,
    scaffoldBackgroundColor: ext.background,
    canvasColor: ext.background,
    extensions: [ext],
    visualDensity: VisualDensity.compact,
    splashFactory: InkSparkle.splashFactory,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  return base.copyWith(
    cardTheme: CardThemeData(
      color: ext.surfaceElevated,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: VooMinimal.brMd,
        side: BorderSide(color: ext.border),
      ),
      margin: EdgeInsets.zero,
    ),
    dividerTheme: DividerThemeData(
      color: ext.border,
      thickness: 1,
      space: 1,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: ext.background,
      foregroundColor: ext.textPrimary,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: ext.textPrimary,
        fontSize: VooMinimal.fontSizeLg,
        fontWeight: FontWeight.w600,
        letterSpacing: VooMinimal.letterSpacingTight,
      ),
      iconTheme: IconThemeData(color: ext.textPrimary, size: VooMinimal.iconSizeLg),
      shape: Border(bottom: BorderSide(color: ext.border)),
    ),
    iconTheme: IconThemeData(color: ext.textPrimary, size: VooMinimal.iconSize),
    listTileTheme: ListTileThemeData(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      iconColor: ext.textSecondary,
      textColor: ext.textPrimary,
      shape: const RoundedRectangleBorder(borderRadius: VooMinimal.brSm),
      visualDensity: VisualDensity.compact,
      minVerticalPadding: 4,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: ext.surfaceElevated,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: VooMinimal.brMd,
        side: BorderSide(color: ext.border),
      ),
      textStyle: TextStyle(
        color: ext.textPrimary,
        fontSize: VooMinimal.fontSizeMd,
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: ext.surfaceElevated,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: VooMinimal.brXl,
        side: BorderSide(color: ext.border),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ext.surface,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      hintStyle: TextStyle(color: ext.textTertiary, fontSize: VooMinimal.fontSizeMd),
      border: OutlineInputBorder(
        borderRadius: VooMinimal.brSm,
        borderSide: BorderSide(color: ext.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: VooMinimal.brSm,
        borderSide: BorderSide(color: ext.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: VooMinimal.brSm,
        borderSide: BorderSide(color: ext.accent, width: 1.5),
      ),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: dark ? const Color(0xFFFAFAFA) : const Color(0xFF18181B),
        borderRadius: VooMinimal.brXs,
      ),
      textStyle: TextStyle(
        color: dark ? const Color(0xFF18181B) : const Color(0xFFFAFAFA),
        fontSize: VooMinimal.fontSizeSm,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      waitDuration: const Duration(milliseconds: 400),
    ),
    textTheme: base.textTheme.copyWith(
      bodySmall: TextStyle(fontSize: VooMinimal.fontSizeSm, color: ext.textSecondary),
      bodyMedium: TextStyle(fontSize: VooMinimal.fontSizeMd, color: ext.textPrimary, height: 1.45),
      bodyLarge: TextStyle(fontSize: VooMinimal.fontSizeLg, color: ext.textPrimary, height: 1.45),
      labelSmall: TextStyle(fontSize: VooMinimal.fontSizeXs, color: ext.textTertiary, letterSpacing: 0.2),
      labelMedium: TextStyle(fontSize: VooMinimal.fontSizeSm, color: ext.textSecondary, fontWeight: FontWeight.w500),
      labelLarge: TextStyle(fontSize: VooMinimal.fontSizeMd, color: ext.textPrimary, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(fontSize: VooMinimal.fontSizeMd, color: ext.textPrimary, fontWeight: FontWeight.w600, letterSpacing: VooMinimal.letterSpacingTight),
      titleMedium: TextStyle(fontSize: VooMinimal.fontSizeLg, color: ext.textPrimary, fontWeight: FontWeight.w600, letterSpacing: VooMinimal.letterSpacingTight),
      titleLarge: TextStyle(fontSize: VooMinimal.fontSizeXl, color: ext.textPrimary, fontWeight: FontWeight.w600, letterSpacing: VooMinimal.letterSpacingTight),
      headlineSmall: TextStyle(fontSize: VooMinimal.fontSize2xl, color: ext.textPrimary, fontWeight: FontWeight.w600, letterSpacing: VooMinimal.letterSpacingTight),
    ),
  );
}

/// Convenience access on [BuildContext].
extension VooMinimalContext on BuildContext {
  /// Returns the [VooMinimalTheme] from the ambient theme, or a sensible
  /// fallback derived from the active [ColorScheme] when not configured.
  ///
  /// This means widgets are safe to use even when the consumer hasn't opted
  /// into the minimal theme — they just won't get the curated palette.
  VooMinimalTheme get vooMinimal {
    final theme = Theme.of(this);
    return theme.extension<VooMinimalTheme>() ??
        VooMinimalTheme.fallback(theme.colorScheme);
  }
}
