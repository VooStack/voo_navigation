import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_navigation/voo_navigation.dart';

import '../fixtures.dart';
import '../preview_chrome.dart';

@Preview(
  name: 'Rail collapsed (834×1112)',
  size: Size(834, 1112),
  theme: previewTheme,
)
Widget tabletScaffoldCollapsed() => VooTabletScaffold(
      config: Fixtures.fullNavConfig(),
      body: const Center(child: Text('Tablet body')),
      backgroundColor: Colors.white,
      extended: false,
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
  name: 'Rail extended (834×1112)',
  size: Size(834, 1112),
  theme: previewTheme,
)
Widget tabletScaffoldExtended() => VooTabletScaffold(
      config: Fixtures.fullNavConfig(),
      body: const Center(child: Text('Tablet body')),
      backgroundColor: Colors.white,
      extended: true,
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
