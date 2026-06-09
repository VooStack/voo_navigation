import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';

import '../fixtures.dart';
import '../preview_chrome.dart';

Widget _frame(Widget child) => Scaffold(
      body: Center(child: Padding(padding: const EdgeInsets.all(48), child: child)),
    );

VooNavigationConfig _config() => Fixtures.simpleNavConfig();

@BrightnessPreview(group: 'NavigationBadge')
Widget navigationBadgeCount() => _frame(
      VooNavigationBadge(
        item: const VooNavigationDestination(
          id: 'i',
          label: 'Inbox',
          icon: Icon(Icons.inbox),
          badgeCount: 7,
        ),
        config: _config(),
      ),
    );

@Preview(
  name: '99+',
  size: Size(120, 120),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget navigationBadgeLarge() => _frame(
      VooNavigationBadge(
        item: const VooNavigationDestination(
          id: 'i',
          label: 'Inbox',
          icon: Icon(Icons.inbox),
          badgeCount: 250,
        ),
        config: _config(),
      ),
    );

@Preview(
  name: 'Dot indicator',
  size: Size(120, 120),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget navigationBadgeDot() => _frame(
      VooNavigationBadge(
        item: const VooNavigationDestination(
          id: 'i',
          label: 'Inbox',
          icon: Icon(Icons.inbox),
          showDot: true,
        ),
        config: _config(),
      ),
    );

@Preview(
  name: 'Custom text',
  size: Size(120, 120),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget navigationBadgeText() => _frame(
      VooNavigationBadge(
        item: const VooNavigationDestination(
          id: 'i',
          label: 'Inbox',
          icon: Icon(Icons.inbox),
          badgeText: 'NEW',
        ),
        config: _config(),
      ),
    );
