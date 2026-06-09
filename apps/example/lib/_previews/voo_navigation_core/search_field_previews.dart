import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';

import '../preview_chrome.dart';

Widget _frame(Widget child) => Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Align(alignment: Alignment.topCenter, child: SizedBox(width: 400, child: child)),
      ),
    );

@BrightnessPreview(group: 'SearchField')
Widget searchFieldDefault() => _frame(
      const VooSearchField(hintText: 'Search...'),
    );

@Preview(
  name: 'With shortcut hint',
  size: Size(480, 200),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget searchFieldShortcut() => _frame(
      const VooSearchField(
        hintText: 'Search...',
        showKeyboardHint: true,
        keyboardHintText: '⌘K',
      ),
    );

@Preview(
  name: 'Expanded',
  size: Size(720, 200),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget searchFieldExpanded() => _frame(
      const VooSearchField(hintText: 'Search across the app...', expanded: true),
    );

@Preview(
  name: 'Disabled',
  size: Size(480, 200),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget searchFieldDisabled() => _frame(
      const VooSearchField(hintText: 'Disabled', enabled: false),
    );
