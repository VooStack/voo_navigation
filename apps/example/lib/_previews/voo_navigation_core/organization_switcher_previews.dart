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

@BrightnessPreview(group: 'OrgSwitcher')
Widget orgSwitcherDefault() => _frame(
      VooOrganizationSwitcher(
        organizations: Fixtures.manyOrganizations,
        selectedOrganization: Fixtures.acme,
      ),
    );

@Preview(
  name: 'Single org',
  size: Size(320, 200),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget orgSwitcherSingle() => _frame(
      const VooOrganizationSwitcher(
        organizations: Fixtures.oneOrganization,
        selectedOrganization: Fixtures.acme,
      ),
    );

@Preview(
  name: 'Compact',
  size: Size(120, 200),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget orgSwitcherCompact() => Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: VooOrganizationSwitcher(
            organizations: Fixtures.manyOrganizations,
            selectedOrganization: Fixtures.acme,
            compact: true,
          ),
        ),
      ),
    );
