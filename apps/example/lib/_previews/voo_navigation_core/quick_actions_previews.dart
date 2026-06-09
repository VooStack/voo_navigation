import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';

import '../fixtures.dart';
import '../preview_chrome.dart';

Widget _frame(Widget child) => Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Align(alignment: Alignment.topLeft, child: child),
      ),
    );

@BrightnessPreview(group: 'QuickActions')
Widget quickActionsList() => _frame(
      VooQuickActions(actions: Fixtures.quickActions()),
    );

@Preview(
  name: 'Grid layout',
  size: Size(480, 320),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget quickActionsGrid() => _frame(
      VooQuickActions(
        actions: Fixtures.quickActions(),
        useGridLayout: true,
        gridColumns: 2,
      ),
    );

@Preview(
  name: 'Compact trigger',
  size: Size(240, 200),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget quickActionsCompact() => _frame(
      VooQuickActions(
        actions: Fixtures.quickActions(),
        compact: true,
      ),
    );
