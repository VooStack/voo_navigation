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

@BrightnessPreview(group: 'MultiSwitcher')
Widget multiSwitcherDefault() => _frame(
      VooMultiSwitcher(config: Fixtures.multiSwitcher()),
    );

@Preview(
  name: 'Single org',
  size: Size(320, 220),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget multiSwitcherSingleOrg() => _frame(
      VooMultiSwitcher(
        config: Fixtures.multiSwitcher(
          organizations: Fixtures.oneOrganization,
        ),
      ),
    );

@Preview(
  name: 'Compact (collapsed rail)',
  size: Size(120, 220),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget multiSwitcherCompact() => Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: VooMultiSwitcher(
            config: Fixtures.multiSwitcher(),
            compact: true,
          ),
        ),
      ),
    );

@Preview(
  name: 'Status: away',
  size: Size(320, 220),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget multiSwitcherAway() => _frame(
      VooMultiSwitcher(
        config: Fixtures.multiSwitcher(status: VooUserStatus.away),
      ),
    );

@Preview(
  name: 'Loading',
  size: Size(320, 220),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget multiSwitcherLoading() => _frame(
      VooMultiSwitcher(
        config: Fixtures.multiSwitcher().copyWith(isLoading: true),
      ),
    );
