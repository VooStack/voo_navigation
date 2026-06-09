import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';

/// Material theme to apply behind every preview, regardless of brightness.
///
/// Uses the minimal Voo aesthetic (Linear/Vercel inspired) so previews show
/// the redesigned look. Referenced from `@Preview(theme: previewTheme)` —
/// must be a top-level function so it satisfies the const-callback restriction.
PreviewThemeData previewTheme() {
  return PreviewThemeData(
    materialLight: VooMinimalTheme.lightThemeData(),
    materialDark: VooMinimalTheme.darkThemeData(),
  );
}

/// Wraps a preview in a `Scaffold` so widgets that expect a Material ancestor
/// (overlays, Inkwell ripples, etc.) render cleanly.
///
/// Referenced from `@Preview(wrapper: scaffoldWrapper)`.
Widget scaffoldWrapper(Widget child) => Scaffold(body: SafeArea(child: child));

/// Like [scaffoldWrapper] but adds outer padding for atom/molecule galleries.
Widget paddedWrapper(Widget child) => Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: child,
        ),
      ),
    );

/// MultiPreview that emits a Light + Dark variant from a single function.
///
/// Usage:
/// ```dart
/// @BrightnessPreview()
/// Widget myPreview() => const MyWidget();
/// ```
final class BrightnessPreview extends MultiPreview {
  const BrightnessPreview({this.group = 'Default'});

  final String group;

  @override
  List<Preview> get previews => <Preview>[
        Preview(
          group: group,
          name: 'Light',
          brightness: Brightness.light,
          theme: previewTheme,
          wrapper: scaffoldWrapper,
        ),
        Preview(
          group: group,
          name: 'Dark',
          brightness: Brightness.dark,
          theme: previewTheme,
          wrapper: scaffoldWrapper,
        ),
      ];
}

/// MultiPreview that emits Mobile / Tablet / Desktop variants at the
/// canonical Material 3 breakpoints. Useful for adaptive widgets.
final class BreakpointPreview extends MultiPreview {
  const BreakpointPreview({this.group = 'Breakpoints'});

  final String group;

  @override
  List<Preview> get previews => <Preview>[
        Preview(
          group: group,
          name: 'Mobile (360×800)',
          size: Size(360, 800),
          theme: previewTheme,
          brightness: Brightness.light,
        ),
        Preview(
          group: group,
          name: 'Tablet (834×1112)',
          size: Size(834, 1112),
          theme: previewTheme,
          brightness: Brightness.light,
        ),
        Preview(
          group: group,
          name: 'Desktop (1440×900)',
          size: Size(1440, 900),
          theme: previewTheme,
          brightness: Brightness.light,
        ),
      ];
}
