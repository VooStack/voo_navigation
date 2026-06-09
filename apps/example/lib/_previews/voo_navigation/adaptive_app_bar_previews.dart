import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_navigation/voo_navigation.dart';

import '../fixtures.dart';
import '../preview_chrome.dart';

@BrightnessPreview()
Widget adaptiveAppBar() {
  final config = Fixtures.fullNavConfig();
  return Scaffold(
    appBar: VooAdaptiveAppBar(
      config: config,
      selectedId: 'dashboard',
      title: const Text('Dashboard'),
    ),
    body: const Center(child: Text('Body')),
  );
}

@Preview(
  name: 'With breadcrumbs',
  size: Size(1280, 400),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget adaptiveAppBarWithBreadcrumbs() {
  final config = Fixtures.fullNavConfig().copyWith(
    breadcrumbs: VooBreadcrumbsConfig(items: Fixtures.breadcrumbs()),
    showBreadcrumbsInAppBar: true,
  );
  return Scaffold(
    appBar: VooAdaptiveAppBar(
      config: config,
      selectedId: 'dashboard',
      title: const Text('Q3 Roadmap'),
    ),
    body: const SizedBox.shrink(),
  );
}
