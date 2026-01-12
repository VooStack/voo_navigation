import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/organization.dart';
import 'package:voo_navigation_core/src/presentation/atoms/voo_search_field.dart';
import 'package:voo_navigation_core/src/presentation/molecules/organization_tile.dart';

/// Dropdown content for organization switcher
class VooOrganizationDropdownContent extends StatelessWidget {
  /// Style configuration
  final VooOrganizationSwitcherStyle style;

  /// Maximum height of the dropdown
  final double maxHeight;

  /// Whether to show search field
  final bool shouldShowSearch;

  /// Controller for search field
  final TextEditingController searchController;

  /// Focus node for search field
  final FocusNode searchFocusNode;

  /// Hint text for search field
  final String? searchHint;

  /// Callback when search text changes
  final ValueChanged<String> onSearchChanged;

  /// Filtered list of organizations
  final List<VooOrganization> filteredOrganizations;

  /// Currently selected organization
  final VooOrganization? selectedOrganization;

  /// Currently selected index in list
  final int selectedIndex;

  /// Custom organization tile builder
  final Widget Function(VooOrganization, bool isSelected)? organizationTileBuilder;

  /// Callback when organization is selected
  final ValueChanged<VooOrganization> onSelectOrganization;

  /// Whether to show create button
  final bool showCreateButton;

  /// Callback when create organization is tapped
  final VoidCallback? onCreateOrganization;

  /// Label for create button
  final String? createButtonLabel;

  /// Callback to remove overlay
  final VoidCallback onRemoveOverlay;

  const VooOrganizationDropdownContent({
    super.key,
    required this.style,
    required this.maxHeight,
    required this.shouldShowSearch,
    required this.searchController,
    required this.searchFocusNode,
    this.searchHint,
    required this.onSearchChanged,
    required this.filteredOrganizations,
    this.selectedOrganization,
    required this.selectedIndex,
    this.organizationTileBuilder,
    required this.onSelectOrganization,
    required this.showCreateButton,
    this.onCreateOrganization,
    this.createButtonLabel,
    required this.onRemoveOverlay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      elevation: 8,
      borderRadius: style.borderRadius ?? BorderRadius.circular(12),
      color: style.backgroundColor ?? colorScheme.surface,
      child: Container(
        constraints: BoxConstraints(maxHeight: maxHeight),
        decoration: style.dropdownDecoration ??
            BoxDecoration(
              borderRadius: style.borderRadius ?? BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search
            if (shouldShowSearch)
              Padding(
                padding: const EdgeInsets.all(12),
                child: VooSearchField(
                  controller: searchController,
                  focusNode: searchFocusNode,
                  hintText: searchHint ?? 'Search organizations...',
                  showKeyboardHint: false,
                  onChanged: onSearchChanged,
                ),
              ),

            // Organization list
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(
                  top: shouldShowSearch ? 0 : 8,
                  bottom: 8,
                ),
                itemCount: filteredOrganizations.length,
                itemBuilder: (context, index) {
                  final org = filteredOrganizations[index];
                  final isSelected = org.id == selectedOrganization?.id;
                  final isHighlighted = index == selectedIndex;

                  if (organizationTileBuilder != null) {
                    return InkWell(
                      onTap: () => onSelectOrganization(org),
                      child: organizationTileBuilder!(org, isSelected),
                    );
                  }

                  return VooOrganizationTile(
                    organization: org,
                    isSelected: isSelected,
                    isHighlighted: isHighlighted,
                    style: style,
                    onTap: () => onSelectOrganization(org),
                  );
                },
              ),
            ),

            // Create button
            if (showCreateButton && onCreateOrganization != null) ...[
              const Divider(height: 1),
              InkWell(
                onTap: () {
                  onRemoveOverlay();
                  onCreateOrganization?.call();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        createButtonLabel ?? 'Create Organization',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
