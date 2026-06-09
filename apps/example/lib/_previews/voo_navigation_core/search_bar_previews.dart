import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';

import '../fixtures.dart';
import '../preview_chrome.dart';

Widget _frame(Widget child) => Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Align(alignment: Alignment.topCenter, child: child),
      ),
    );

@BrightnessPreview(group: 'SearchBar')
Widget searchBarDefault() => _frame(
      SizedBox(
        width: 400,
        child: VooSearchBar(
          hintText: 'Search...',
          enableKeyboardShortcut: true,
          keyboardShortcutHint: '⌘K',
          navigationItems: Fixtures.simpleItems,
        ),
      ),
    );

@Preview(
  name: 'Expanded',
  size: Size(720, 200),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget searchBarExpanded() => _frame(
      VooSearchBar(
        hintText: 'Search across the app...',
        expanded: true,
        enableKeyboardShortcut: true,
        keyboardShortcutHint: '⌘K',
        navigationItems: Fixtures.simpleItems,
      ),
    );

@Preview(
  name: 'No shortcut hint',
  size: Size(480, 200),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget searchBarNoShortcut() => _frame(
      const SizedBox(
        width: 400,
        child: VooSearchBar(hintText: 'Search...'),
      ),
    );
