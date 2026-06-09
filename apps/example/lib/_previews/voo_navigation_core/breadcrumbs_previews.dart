import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';

import '../fixtures.dart';
import '../preview_chrome.dart';

@BrightnessPreview(group: 'Breadcrumbs')
Widget breadcrumbsDefault() => Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Align(
          alignment: Alignment.topLeft,
          child: VooBreadcrumbs(items: Fixtures.breadcrumbs()),
        ),
      ),
    );

@Preview(
  name: 'Collapsed (long path)',
  size: Size(900, 120),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget breadcrumbsCollapsed() => Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Align(
          alignment: Alignment.topLeft,
          child: VooBreadcrumbs(
            items: Fixtures.breadcrumbsLong(),
            maxVisibleItems: 4,
          ),
        ),
      ),
    );

@Preview(
  name: 'Custom separator',
  size: Size(720, 120),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget breadcrumbsCustomSeparator() => Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Align(
          alignment: Alignment.topLeft,
          child: VooBreadcrumbs(
            items: Fixtures.breadcrumbs(),
            separator: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Icon(Icons.arrow_forward_ios, size: 12),
            ),
          ),
        ),
      ),
    );
