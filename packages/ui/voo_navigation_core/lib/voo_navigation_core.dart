/// Core foundation package for voo_navigation.
///
/// This package provides shared entities, atoms, molecules, and utilities
/// that are used by voo_navigation_rail, voo_navigation_drawer, and voo_navigation_bar.
library voo_navigation_core;

// Domain - Tokens
export 'src/domain/tokens/voo_navigation_tokens.dart';

// Domain Entities
export 'src/domain/entities/app_bar_config.dart';
export 'src/domain/entities/action_navigation_item.dart';
export 'src/domain/entities/breadcrumb_item.dart';
export 'src/domain/entities/breakpoint.dart';
export 'src/domain/entities/context_switcher_config.dart';
export 'src/domain/entities/context_switcher_item.dart';
export 'src/domain/entities/context_switcher_style.dart';
export 'src/domain/entities/multi_switcher_config.dart';
export 'src/domain/entities/multi_switcher_style.dart';
export 'src/domain/entities/multi_switcher_user.dart';
export 'src/domain/entities/navigation_config.dart';
export 'src/domain/entities/navigation_destination.dart';
export 'src/domain/entities/navigation_section.dart';
export 'src/domain/entities/navigation_theme.dart';
export 'src/domain/entities/navigation_type.dart';
export 'src/domain/entities/notification_item.dart';
export 'src/domain/entities/organization.dart';
export 'src/domain/entities/page_config.dart';
export 'src/domain/entities/quick_action.dart';
export 'src/domain/entities/search_action.dart';
export 'src/domain/entities/user_profile_config.dart';
export 'src/domain/entities/voo_profile_menu_item.dart';
export 'src/domain/entities/voo_user_status.dart';

// Presentation - Atoms
export 'src/presentation/atoms/voo_avatar.dart';
export 'src/presentation/atoms/voo_background_indicator.dart';
export 'src/presentation/atoms/voo_badge.dart';
export 'src/presentation/atoms/voo_collapse_toggle.dart';
export 'src/presentation/atoms/voo_scale_indicator.dart';
export 'src/presentation/atoms/voo_dot_badge.dart';
export 'src/presentation/atoms/voo_edge_indicator.dart';
export 'src/presentation/atoms/voo_line_indicator.dart';
export 'src/presentation/atoms/voo_modern_badge.dart';
export 'src/presentation/atoms/voo_modern_icon.dart';
export 'src/presentation/atoms/voo_navigation_icon.dart';
export 'src/presentation/atoms/voo_pill_indicator.dart';
export 'src/presentation/atoms/voo_search_field.dart';
export 'src/presentation/atoms/voo_text_badge.dart';

// Presentation - Molecules
export 'src/presentation/molecules/context_switcher_bottom_sheet.dart';
export 'src/presentation/molecules/context_switcher_card.dart';
export 'src/presentation/molecules/context_switcher_modal.dart';
export 'src/presentation/molecules/context_switcher_nav_item.dart';
export 'src/presentation/molecules/multi_switcher_bottom_sheet.dart';
export 'src/presentation/molecules/multi_switcher_card.dart';
export 'src/presentation/molecules/multi_switcher_modal.dart';
export 'src/presentation/molecules/multi_switcher_nav_item.dart';
export 'src/presentation/molecules/multi_switcher_sections.dart';
export 'src/presentation/molecules/multi_switcher_tiles.dart';
export 'src/presentation/molecules/voo_app_bar_leading.dart';
export 'src/presentation/molecules/voo_app_bar_title.dart';
export 'src/presentation/molecules/voo_breadcrumbs.dart';
export 'src/presentation/molecules/voo_dropdown_child_item.dart';
export 'src/presentation/molecules/voo_dropdown_children.dart';
export 'src/presentation/molecules/voo_dropdown_header.dart';
export 'src/presentation/molecules/voo_mobile_app_bar.dart';
export 'src/presentation/molecules/voo_context_switcher.dart';
export 'src/presentation/molecules/voo_multi_switcher.dart';
export 'src/presentation/molecules/voo_navigation_badge.dart';
export 'src/presentation/molecules/voo_notifications_bell.dart';
export 'src/presentation/molecules/voo_organization_switcher.dart';
export 'src/presentation/molecules/voo_quick_actions.dart';
export 'src/presentation/molecules/quick_actions_menu_content.dart';
export 'src/presentation/molecules/quick_actions_section_layout.dart';
export 'src/presentation/molecules/voo_search_bar.dart';
export 'src/presentation/molecules/voo_themed_nav_container.dart';
export 'src/presentation/molecules/voo_user_profile_footer.dart';

// Presentation - Utils
export 'src/presentation/utils/voo_collapse_state.dart';
export 'src/presentation/utils/voo_navigation_animations.dart';
export 'src/presentation/utils/voo_navigation_helper.dart';
export 'src/presentation/utils/voo_navigation_inherited.dart';
