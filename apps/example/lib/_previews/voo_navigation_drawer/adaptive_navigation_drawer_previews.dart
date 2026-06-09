import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_navigation_drawer/voo_navigation_drawer.dart';

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
  name: 'Expanded',
  size: Size(680, 800),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget drawerExpanded() => _wrap(
      VooAdaptiveNavigationDrawer(
        config: Fixtures.fullNavConfig(),
        selectedId: 'dashboard',
        onNavigationItemSelected: (_) {},
      ),
    );

@Preview(
  name: 'Selected nested item',
  size: Size(680, 800),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget drawerSelectedChild() => _wrap(
      VooAdaptiveNavigationDrawer(
        config: Fixtures.fullNavConfig(),
        selectedId: 'team_members',
        onNavigationItemSelected: (_) {},
      ),
    );

@Preview(
  name: 'Dark',
  size: Size(680, 800),
  theme: previewTheme,
  brightness: Brightness.dark,
)
Widget drawerDark() => _wrap(
      VooAdaptiveNavigationDrawer(
        config: Fixtures.fullNavConfig(),
        selectedId: 'attendance',
        onNavigationItemSelected: (_) {},
      ),
    );
