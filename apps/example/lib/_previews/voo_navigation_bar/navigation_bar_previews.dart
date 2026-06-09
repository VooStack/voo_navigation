import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_navigation_bar/voo_navigation_bar.dart';

import '../fixtures.dart';
import '../preview_chrome.dart';

Widget _wrap(Widget child) {
  return Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Align(alignment: Alignment.bottomCenter, child: child),
      ),
    ),
  );
}

@BrightnessPreview(group: 'NavigationBar')
Widget navigationBarDefault() => _wrap(
      VooNavigationBar(
        config: Fixtures.simpleNavConfig(),
        selectedId: 'dashboard',
        onNavigationItemSelected: (_) {},
      ),
    );

@Preview(
  name: 'Selected: messages',
  size: Size(390, 200),
  theme: previewTheme,
)
Widget navigationBarSelectedMessages() => _wrap(
      VooNavigationBar(
        config: Fixtures.simpleNavConfig(),
        selectedId: 'messages',
        onNavigationItemSelected: (_) {},
      ),
    );

@Preview(
  name: 'With action button',
  size: Size(390, 200),
  theme: previewTheme,
)
Widget navigationBarWithAction() => _wrap(
      VooNavigationBar(
        config: Fixtures.simpleNavConfig(),
        selectedId: 'dashboard',
        onNavigationItemSelected: (_) {},
        actionItem: Fixtures.composeActionItem(),
      ),
    );

@Preview(
  name: 'Badge on notifications',
  size: Size(390, 200),
  theme: previewTheme,
)
Widget navigationBarWithBadge() => _wrap(
      VooNavigationBar(
        config: Fixtures.simpleNavConfig(),
        selectedId: 'notifications',
        onNavigationItemSelected: (_) {},
      ),
    );
