import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';

import '../preview_chrome.dart';

Widget _frame(Widget child, {double width = 280}) => Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(width: width, child: child),
          ),
        ),
      ),
    );

@BrightnessPreview(group: 'UserProfileFooter')
Widget userProfileFooter() => _frame(
      const VooUserProfileFooter(
        userName: 'John Doe',
        userEmail: 'john@example.com',
        initials: 'JD',
        status: VooUserStatus.online,
      ),
    );

@Preview(
  name: 'Status: away',
  size: Size(320, 200),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget userProfileFooterAway() => _frame(
      const VooUserProfileFooter(
        userName: 'John Doe',
        userEmail: 'john@example.com',
        initials: 'JD',
        status: VooUserStatus.away,
      ),
    );

@Preview(
  name: 'Status: offline',
  size: Size(320, 200),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget userProfileFooterOffline() => _frame(
      const VooUserProfileFooter(
        userName: 'John Doe',
        userEmail: 'john@example.com',
        initials: 'JD',
        status: VooUserStatus.offline,
      ),
    );

@Preview(
  name: 'Compact (collapsed)',
  size: Size(120, 200),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget userProfileFooterCompact() => _frame(
      const VooUserProfileFooter(
        userName: 'John Doe',
        initials: 'JD',
        status: VooUserStatus.online,
        compact: true,
      ),
      width: 80,
    );
