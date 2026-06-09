import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';

import '../preview_chrome.dart';

Widget _row(List<Widget> avatars) => Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Wrap(
          spacing: 24,
          runSpacing: 24,
          children: avatars,
        ),
      ),
    );

@BrightnessPreview(group: 'Avatar')
Widget avatarGallery() => _row(const [
      VooAvatar(name: 'John Doe', size: 32),
      VooAvatar(name: 'Sarah Connor', size: 40),
      VooAvatar(name: 'Acme Bot', size: 56),
      VooAvatar(initials: 'JD', size: 40, backgroundColor: Colors.indigo),
      VooAvatar(placeholderIcon: Icons.person, size: 40),
      VooAvatar(
        name: 'Border',
        size: 40,
        border: Border.fromBorderSide(BorderSide(color: Colors.amber, width: 2)),
      ),
    ]);

@Preview(
  name: 'Sizes',
  size: Size(480, 160),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget avatarSizes() => Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            VooAvatar(name: 'A', size: 24),
            VooAvatar(name: 'B', size: 32),
            VooAvatar(name: 'C', size: 40),
            VooAvatar(name: 'D', size: 56),
            VooAvatar(name: 'E', size: 72),
          ],
        ),
      ),
    );
