import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';

import '../fixtures.dart';
import '../preview_chrome.dart';

Widget _topBar(Widget child) => Scaffold(
      appBar: AppBar(
        title: const Text('Demo app bar'),
        actions: [
          Padding(padding: const EdgeInsets.only(right: 8), child: child),
        ],
      ),
      body: const SizedBox.shrink(),
    );

@BrightnessPreview(group: 'NotificationsBell')
Widget notificationsBellPopulated() => _topBar(
      VooNotificationsBell(notifications: Fixtures.notifications3()),
    );

@Preview(
  name: 'Empty',
  size: Size(480, 240),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget notificationsBellEmpty() => _topBar(
      const VooNotificationsBell(notifications: []),
    );

@Preview(
  name: 'Large unread count',
  size: Size(480, 240),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget notificationsBellLargeCount() => _topBar(
      VooNotificationsBell(
        notifications: Fixtures.notifications3(),
        unreadCount: 142,
      ),
    );

@Preview(
  name: 'Compact',
  size: Size(480, 240),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget notificationsBellCompact() => _topBar(
      VooNotificationsBell(
        notifications: Fixtures.notifications3(),
        compact: true,
      ),
    );
