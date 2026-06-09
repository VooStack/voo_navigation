import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';

import '../fixtures.dart';
import '../preview_chrome.dart';

Widget _frame(Widget child) => Scaffold(
      body: Center(child: child),
    );

@BrightnessPreview(group: 'StackedAvatars')
Widget stackedAvatarsDefault() => _frame(
      VooStackedAvatars(
        organization: Fixtures.acme,
        userName: 'John Doe',
        status: VooUserStatus.online,
      ),
    );

@Preview(
  name: 'Large (org=64, user=48)',
  size: Size(180, 180),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget stackedAvatarsLarge() => _frame(
      VooStackedAvatars(
        organization: Fixtures.acme,
        userName: 'John Doe',
        status: VooUserStatus.online,
        orgAvatarSize: 64,
        userAvatarSize: 48,
      ),
    );

@Preview(
  name: 'Status: busy',
  size: Size(120, 120),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget stackedAvatarsBusy() => _frame(
      VooStackedAvatars(
        organization: Fixtures.startup,
        userName: 'Jane Smith',
        status: VooUserStatus.busy,
      ),
    );

@Preview(
  name: 'No status indicator',
  size: Size(120, 120),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget stackedAvatarsNoStatus() => _frame(
      VooStackedAvatars(
        organization: Fixtures.enterprise,
        userName: 'Acme Bot',
        showStatus: false,
      ),
    );
