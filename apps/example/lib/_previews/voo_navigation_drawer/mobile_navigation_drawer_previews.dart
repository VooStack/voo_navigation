import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_navigation_drawer/voo_navigation_drawer.dart';

import '../fixtures.dart';
import '../preview_chrome.dart';

@BrightnessPreview(group: 'MobileDrawer')
Widget mobileDrawer() => VooMobileNavigationDrawer(
      config: Fixtures.fullNavConfig(),
      selectedId: 'dashboard',
      onNavigationItemSelected: (_) {},
      title: 'ACME Corp',
      subtitle: 'john@example.com',
    );

@Preview(
  name: 'With footer',
  size: Size(320, 720),
  theme: previewTheme,
  brightness: Brightness.light,
  wrapper: scaffoldWrapper,
)
Widget mobileDrawerWithFooter() => VooMobileNavigationDrawer(
      config: Fixtures.fullNavConfig(),
      selectedId: 'team_members',
      onNavigationItemSelected: (_) {},
      title: 'ACME Corp',
      subtitle: 'john@example.com',
      footer: ListTile(
        leading: const Icon(Icons.logout),
        title: const Text('Sign out'),
        onTap: () {},
      ),
    );
