import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_navigation/voo_navigation.dart';

import '../fixtures.dart';
import '../preview_chrome.dart';

@Preview(
  name: 'Default (360×800)',
  size: Size(360, 800),
  theme: previewTheme,
)
Widget mobileScaffoldDefault() => VooMobileScaffold(
      config: Fixtures.simpleNavConfig(),
      body: const Center(child: Text('Mobile body')),
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
    );

@Preview(
  name: 'Dark (360×800)',
  size: Size(360, 800),
  theme: previewTheme,
  brightness: Brightness.dark,
)
Widget mobileScaffoldDark() => VooMobileScaffold(
      config: Fixtures.simpleNavConfig(),
      body: const Center(child: Text('Mobile body')),
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
    );
