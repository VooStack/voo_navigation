import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_navigation/voo_navigation.dart';

import '../fixtures.dart';
import '../preview_chrome.dart';

@Preview(
  name: 'Drawer (1440×900)',
  size: Size(1440, 900),
  theme: previewTheme,
)
Widget desktopScaffoldDrawer() => VooDesktopScaffold(
      config: Fixtures.fullNavConfig(),
      body: const Center(child: Text('Desktop body')),
      backgroundColor: Colors.white,
      selectedId: 'dashboard',
      onNavigationItemSelected: (_) {},
      showAppBar: true,
      drawerEdgeDragWidth: 20,
      drawerEnableOpenDragGesture: true,
      endDrawerEnableOpenDragGesture: true,
      resizeToAvoidBottomInset: true,
      extendBody: false,
      extendBodyBehindAppBar: false,
      navigationType: VooNavigationType.navigationDrawer,
    );

@Preview(
  name: 'Extended rail (1280×900)',
  size: Size(1280, 900),
  theme: previewTheme,
)
Widget desktopScaffoldRail() => VooDesktopScaffold(
      config: Fixtures.fullNavConfig(),
      body: const Center(child: Text('Desktop body')),
      backgroundColor: Colors.white,
      selectedId: 'dashboard',
      onNavigationItemSelected: (_) {},
      showAppBar: true,
      drawerEdgeDragWidth: 20,
      drawerEnableOpenDragGesture: true,
      endDrawerEnableOpenDragGesture: true,
      resizeToAvoidBottomInset: true,
      extendBody: false,
      extendBodyBehindAppBar: false,
      navigationType: VooNavigationType.extendedNavigationRail,
    );

@Preview(
  name: 'Dark (1440×900)',
  size: Size(1440, 900),
  theme: previewTheme,
  brightness: Brightness.dark,
)
Widget desktopScaffoldDark() => VooDesktopScaffold(
      config: Fixtures.fullNavConfig(),
      body: const Center(child: Text('Desktop body')),
      backgroundColor: const Color(0xFF111418),
      selectedId: 'dashboard',
      onNavigationItemSelected: (_) {},
      showAppBar: true,
      drawerEdgeDragWidth: 20,
      drawerEnableOpenDragGesture: true,
      endDrawerEnableOpenDragGesture: true,
      resizeToAvoidBottomInset: true,
      extendBody: false,
      extendBodyBehindAppBar: false,
      navigationType: VooNavigationType.navigationDrawer,
    );
