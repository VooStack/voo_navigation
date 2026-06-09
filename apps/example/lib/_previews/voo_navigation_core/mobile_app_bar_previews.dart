import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';

import '../fixtures.dart';
import '../preview_chrome.dart';

@BrightnessPreview(group: 'MobileAppBar')
Widget mobileAppBarDefault() => Scaffold(
      appBar: VooMobileAppBar(
        config: Fixtures.fullNavConfig(),
        selectedId: 'dashboard',
        title: const Text('Dashboard'),
      ),
      body: const SizedBox.shrink(),
    );

@Preview(
  name: 'With menu button',
  size: Size(390, 200),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget mobileAppBarMenu() => Scaffold(
      appBar: VooMobileAppBar(
        config: Fixtures.fullNavConfig().copyWith(showHamburgerMenu: true),
        selectedId: 'dashboard',
        title: const Text('Dashboard'),
        showMenuButton: true,
      ),
      body: const SizedBox.shrink(),
    );

@Preview(
  name: 'Custom actions',
  size: Size(390, 200),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget mobileAppBarActions() => Scaffold(
      appBar: VooMobileAppBar(
        config: Fixtures.fullNavConfig(),
        selectedId: 'dashboard',
        title: const Text('Inbox'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: const SizedBox.shrink(),
    );
