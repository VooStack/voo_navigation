import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';

import '../fixtures.dart';
import '../preview_chrome.dart';

Widget _frame(Widget child) => Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(width: 280, child: child),
        ),
      ),
    );

@BrightnessPreview(group: 'ContextSwitcher')
Widget contextSwitcherDefault() => _frame(
      VooContextSwitcher(config: Fixtures.contextSwitcher()),
    );

@Preview(
  name: 'Compact',
  size: Size(120, 200),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget contextSwitcherCompact() => Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: VooContextSwitcher(
            config: Fixtures.contextSwitcher(),
            compact: true,
          ),
        ),
      ),
    );

@Preview(
  name: 'No selection (placeholder)',
  size: Size(320, 200),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget contextSwitcherPlaceholder() => _frame(
      VooContextSwitcher(
        config: VooContextSwitcherConfig(
          items: const [Fixtures.project1, Fixtures.project2, Fixtures.project3],
          sectionTitle: 'Projects',
          placeholder: 'Select a project',
        ),
      ),
    );
