import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_navigation/voo_navigation.dart';

import '../fixtures.dart';
import '../preview_chrome.dart';

Widget _body() => Center(
      child: Builder(
        builder: (context) => Text(
          'Page content',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );

@BrightnessPreview()
Widget adaptiveScaffoldDefault() => VooAdaptiveScaffold(
      config: Fixtures.fullNavConfig(),
      body: _body(),
    );

@Preview(name: 'Mobile (360×800)', size: Size(360, 800), theme: previewTheme)
Widget adaptiveScaffoldMobile() => VooAdaptiveScaffold(
      config: Fixtures.fullNavConfig(),
      body: _body(),
    );

@Preview(name: 'Tablet (834×1112)', size: Size(834, 1112), theme: previewTheme)
Widget adaptiveScaffoldTablet() => VooAdaptiveScaffold(
      config: Fixtures.fullNavConfig(),
      body: _body(),
    );

@Preview(name: 'Desktop (1440×900)', size: Size(1440, 900), theme: previewTheme)
Widget adaptiveScaffoldDesktop() => VooAdaptiveScaffold(
      config: Fixtures.fullNavConfig(),
      body: _body(),
    );

@Preview(
  name: 'Mobile + hamburger drawer',
  size: Size(360, 800),
  theme: previewTheme,
)
Widget adaptiveScaffoldMobileWithDrawer() {
  final base = Fixtures.fullNavConfig();
  return VooAdaptiveScaffold(
    config: base.copyWith(showHamburgerMenu: true),
    body: _body(),
  );
}
