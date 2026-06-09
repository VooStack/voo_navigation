import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_navigation_rail/voo_navigation_rail.dart';

import '../fixtures.dart';
import '../preview_chrome.dart';

Widget _wrap(Widget child) => Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            child,
            const Expanded(child: ColoredBox(color: Color(0x08000000))),
          ],
        ),
      ),
    );

@Preview(
  name: 'Collapsed',
  size: Size(320, 720),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget railCollapsed() => _wrap(
      VooAdaptiveNavigationRail(
        config: Fixtures.fullNavConfig(),
        selectedId: 'dashboard',
        onNavigationItemSelected: (_) {},
        extended: false,
      ),
    );

@Preview(
  name: 'Extended',
  size: Size(480, 720),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget railExtended() => _wrap(
      VooAdaptiveNavigationRail(
        config: Fixtures.fullNavConfig(),
        selectedId: 'dashboard',
        onNavigationItemSelected: (_) {},
        extended: true,
      ),
    );

@Preview(
  name: 'Dark extended',
  size: Size(480, 720),
  theme: previewTheme,
  brightness: Brightness.dark,
)
Widget railDarkExtended() => _wrap(
      VooAdaptiveNavigationRail(
        config: Fixtures.fullNavConfig(),
        selectedId: 'team_members',
        onNavigationItemSelected: (_) {},
        extended: true,
      ),
    );
