import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_navigation/voo_navigation.dart';

import 'fixtures.dart';

/// Shows the same widget under three different `ThemeData` configurations to
/// prove the widgets follow the consumer theme:
///
///  1. **Curated minimal** — `VooMinimalTheme.lightThemeData()` (opt-in).
///  2. **User accent override** — same minimal theme but with a teal accent.
///  3. **Plain Material 3** — the consumer's own `ThemeData`, no opt-in.
///     The widgets read from the ambient `ColorScheme` via
///     `VooMinimalTheme.fallback(scheme)` — surfaces, borders, text, accent
///     all derive from the user theme.
///
/// All three previews show the same `VooNavigationBar` so the visual
/// differences come from the theme alone.

Widget _bar() => Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: VooNavigationBar(
          config: Fixtures.simpleNavConfig(),
          selectedId: 'dashboard',
          onNavigationItemSelected: (_) {},
        ),
      ),
    );

PreviewThemeData curatedMinimalTheme() => PreviewThemeData(
      materialLight: VooMinimalTheme.lightThemeData(),
      materialDark: VooMinimalTheme.darkThemeData(),
    );

PreviewThemeData tealAccentTheme() => PreviewThemeData(
      materialLight: VooMinimalTheme.lightThemeData(accent: Colors.teal),
      materialDark: VooMinimalTheme.darkThemeData(accent: Colors.teal),
    );

PreviewThemeData plainMaterial3Theme() => PreviewThemeData(
      materialLight: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      materialDark: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
    );

@Preview(
  name: 'Curated minimal (blue accent)',
  size: Size(390, 220),
  theme: curatedMinimalTheme,
)
Widget themeCuratedMinimal() => _bar();

@Preview(
  name: 'Curated minimal — teal accent',
  size: Size(390, 220),
  theme: tealAccentTheme,
)
Widget themeCustomAccent() => _bar();

@Preview(
  name: 'Plain Material 3 (deep purple)',
  size: Size(390, 220),
  theme: plainMaterial3Theme,
)
Widget themePlainMaterial3() => _bar();
