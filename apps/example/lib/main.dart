import 'package:flutter/material.dart';
import 'package:voo_navigation/voo_navigation.dart';

import '_previews/fixtures.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'voo_navigation demo',
      debugShowCheckedModeBanner: false,
      theme: VooMinimalTheme.lightThemeData(),
      darkTheme: VooMinimalTheme.darkThemeData(),
      home: const _DemoHome(),
    );
  }
}

class _DemoHome extends StatefulWidget {
  const _DemoHome();

  @override
  State<_DemoHome> createState() => _DemoHomeState();
}

class _DemoHomeState extends State<_DemoHome> {
  String _selectedId = 'dashboard';

  @override
  Widget build(BuildContext context) {
    return VooAdaptiveScaffold(
      config: Fixtures.fullNavConfig(
        selectedId: _selectedId,
        onSelected: (id) => setState(() => _selectedId = id),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.dashboard_rounded,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Selected: $_selectedId',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'This demo uses the same fixtures as the widget previews.\n'
                'Run "flutter widget-preview start" to browse them.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
