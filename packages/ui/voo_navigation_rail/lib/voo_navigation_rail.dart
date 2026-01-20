/// Navigation rail components for Flutter.
///
/// This package provides navigation rail widgets that can be used standalone
/// or as part of the voo_navigation adaptive navigation system.
library voo_navigation_rail;

// Re-export core for convenience
export 'package:voo_navigation_core/voo_navigation_core.dart';

// Atoms
export 'src/presentation/atoms/voo_rail_modern_badge.dart';

// Molecules
export 'src/presentation/molecules/rail_context_switcher.dart';
export 'src/presentation/molecules/rail_multi_switcher.dart';
export 'src/presentation/molecules/voo_rail_default_header.dart';
export 'src/presentation/molecules/voo_rail_navigation_item.dart';
export 'src/presentation/molecules/voo_rail_section_header.dart';

// Organisms
export 'src/presentation/organisms/voo_adaptive_navigation_rail.dart';
export 'src/presentation/organisms/voo_rail_navigation_items.dart';
