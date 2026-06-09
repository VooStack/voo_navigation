import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';

import '../preview_chrome.dart';

Widget _gallery(List<Widget> items) => Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Wrap(
          spacing: 24,
          runSpacing: 24,
          alignment: WrapAlignment.start,
          children: items,
        ),
      ),
    );

@BrightnessPreview(group: 'Badge')
Widget badgeGallery() => _gallery(const [
      VooBadge(count: 1),
      VooBadge(count: 7),
      VooBadge(count: 99),
      VooBadge(count: 250),
      VooBadge(text: 'NEW'),
      VooBadge(text: 'BETA'),
      VooBadge(showDot: true, backgroundColor: Colors.red),
      VooBadge(showDot: true, backgroundColor: Colors.green, dotSize: 12),
    ]);

@Preview(
  name: 'Custom colors',
  size: Size(480, 160),
  theme: previewTheme,
  brightness: Brightness.light,
)
Widget badgeColors() => _gallery(const [
      VooBadge(count: 3, backgroundColor: Colors.indigo),
      VooBadge(count: 3, backgroundColor: Colors.amber, foregroundColor: Colors.black),
      VooBadge(count: 3, backgroundColor: Colors.teal),
      VooBadge(text: 'PRO', backgroundColor: Colors.purple),
    ]);
