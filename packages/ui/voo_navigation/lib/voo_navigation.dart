/// A comprehensive, adaptive navigation package for Flutter.
///
/// This package automatically adjusts navigation to different screen sizes
/// and platforms with Material 3 design. It combines:
/// - voo_navigation_core: Shared entities, atoms, molecules, and utilities
/// - voo_navigation_rail: Navigation rail components
/// - voo_navigation_drawer: Navigation drawer components
/// - voo_navigation_bar: Bottom navigation bar components
library voo_navigation;

// Re-export all sub-packages for convenience
export 'package:voo_navigation_core/voo_navigation_core.dart';
export 'package:voo_navigation_rail/voo_navigation_rail.dart'
    hide VooNavigationConfig, VooNavigationItem, VooNavigationType, VooNavigationBarType,
         VooNavigationTheme, VooBreakpoint, VooNavigationRoute, VooNavigationSection, VooPageConfig;
export 'package:voo_navigation_drawer/voo_navigation_drawer.dart'
    hide VooNavigationConfig, VooNavigationItem, VooNavigationType, VooNavigationBarType,
         VooNavigationTheme, VooBreakpoint, VooNavigationRoute, VooNavigationSection, VooPageConfig;
export 'package:voo_navigation_bar/voo_navigation_bar.dart'
    hide VooNavigationConfig, VooNavigationItem, VooNavigationType, VooNavigationBarType,
         VooNavigationTheme, VooBreakpoint, VooNavigationRoute, VooNavigationSection, VooPageConfig;

// Presentation - Organisms (Orchestration layer - stays in voo_navigation)
export 'src/presentation/organisms/voo_adaptive_app_bar.dart';
export 'src/presentation/organisms/voo_adaptive_scaffold.dart';
export 'src/presentation/organisms/voo_desktop_scaffold.dart';
export 'src/presentation/organisms/voo_mobile_scaffold.dart';
export 'src/presentation/organisms/voo_navigation_shell.dart';
export 'src/presentation/organisms/voo_page.dart';
export 'src/presentation/organisms/voo_router_shell.dart';
export 'src/presentation/organisms/voo_scaffold_builder.dart';
export 'src/presentation/organisms/voo_tablet_scaffold.dart';

// Presentation - Builders
export 'src/presentation/builders/voo_navigation_builder.dart';

// Presentation - Providers
export 'src/presentation/providers/voo_go_router.dart';

// Presentation - Utils (Page scope stays in voo_navigation)
export 'src/presentation/utils/voo_page_scope.dart';
