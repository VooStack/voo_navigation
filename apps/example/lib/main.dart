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

  /// Whether the mobile app bar shows a hamburger button that opens a drawer
  /// listing every nav item. Only takes effect at mobile breakpoints — on
  /// tablet/desktop the rail or drawer already shows everything, so the
  /// hamburger is auto-suppressed by the adaptive scaffold.
  ///
  /// Opt-in API:
  /// ```dart
  /// VooNavigationConfig(
  ///   ...,
  ///   showHamburgerMenu: true,
  ///   // optional — customize the drawer body; defaults to VooMobileNavigationDrawer
  ///   mobileDrawerBuilder: (context) => MyCustomDrawer(...),
  /// )
  /// ```
  bool _showHamburgerMenu = false;

  @override
  Widget build(BuildContext context) {
    return VooAdaptiveScaffold(
      config: Fixtures.fullNavConfig(
        selectedId: _selectedId,
        onSelected: (id) => setState(() => _selectedId = id),
      ).copyWith(showHamburgerMenu: _showHamburgerMenu),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
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
                const SizedBox(height: 24),
                SwitchListTile(
                  title: const Text('Hamburger menu (mobile)'),
                  subtitle: const Text(
                    'Adds a hamburger button to the mobile app bar that '
                    'opens a drawer listing every nav item. Resize the '
                    'window narrow enough to trigger the mobile layout.',
                  ),
                  value: _showHamburgerMenu,
                  onChanged: (v) => setState(() => _showHamburgerMenu = v),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
