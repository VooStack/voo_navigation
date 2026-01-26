import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/multi_switcher_config.dart';
import 'package:voo_navigation_core/src/domain/entities/multi_switcher_style.dart';
import 'package:voo_navigation_core/src/domain/entities/organization.dart';
import 'package:voo_navigation_core/src/presentation/molecules/multi_switcher_sections.dart';

/// Modal component for the multi-switcher (open state).
///
/// This widget displays the expanded view with organization and user sections.
/// It slides up from the bottom with spring physics animation.
class VooMultiSwitcherModal extends StatefulWidget {
  /// Configuration for the multi-switcher
  final VooMultiSwitcherConfig config;

  /// Animation for the slide transition
  final Animation<double> animation;

  /// Callback when the modal should close
  final VoidCallback onClose;

  /// Callback when an organization is selected
  final ValueChanged<VooOrganization> onOrganizationSelected;

  /// Callback when a user is selected
  final ValueChanged<dynamic>? onUserSelected;

  const VooMultiSwitcherModal({
    super.key,
    required this.config,
    required this.animation,
    required this.onClose,
    required this.onOrganizationSelected,
    this.onUserSelected,
  });

  @override
  State<VooMultiSwitcherModal> createState() => _VooMultiSwitcherModalState();
}

class _VooMultiSwitcherModalState extends State<VooMultiSwitcherModal> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<VooOrganization> get _filteredOrganizations {
    if (_searchQuery.isEmpty) return widget.config.organizations;
    return widget.config.organizations.where((org) {
      return org.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (org.subtitle?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
              false);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = widget.config.style ?? const VooMultiSwitcherStyle();

    // Allow custom modal builder
    if (widget.config.modalBuilder != null) {
      return AnimatedBuilder(
        animation: widget.animation,
        builder: (context, child) {
          return Opacity(
            opacity: widget.animation.value.clamp(0.0, 1.0),
            child: widget.config.modalBuilder!(
              context,
              VooMultiSwitcherModalData(
                organizations: _filteredOrganizations,
                selectedOrganization: widget.config.selectedOrganization,
                users: widget.config.users,
                selectedUser: widget.config.selectedUser,
                userName: widget.config.userName,
                userEmail: widget.config.userEmail,
                avatarUrl: widget.config.avatarUrl,
                initials: widget.config.initials,
                status: widget.config.status,
                isLoading: widget.config.isLoading,
                onClose: widget.onClose,
                onOrganizationSelected: widget.onOrganizationSelected,
                onUserSelected: widget.config.onUserChanged,
                onSettingsTap: widget.config.onSettingsTap,
                onLogout: widget.config.onLogout,
                onCreateOrganization: widget.config.onCreateOrganization,
                onAddUser: widget.config.onAddUser,
                menuItems: widget.config.menuItems,
              ),
            ),
          );
        },
      );
    }

    // Animation handled by parent - just render the container
    return Container(
        constraints: BoxConstraints(
          maxHeight: style.modalMaxHeight ?? VooMultiSwitcherStyle.defaultModalMaxHeight,
        ),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: style.modalDecoration ??
            BoxDecoration(
              color: style.modalBackgroundColor ?? theme.colorScheme.surface,
              borderRadius: style.modalBorderRadius ?? BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.15),
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
                BoxShadow(
                  color: theme.shadowColor.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
        child: ClipRRect(
          borderRadius: style.modalBorderRadius ?? BorderRadius.circular(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Search (optional)
              if (widget.config.showSearch) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    decoration: InputDecoration(
                      hintText: widget.config.searchHint ?? 'Search...',
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        size: 20,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.close_rounded,
                                size: 18,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: theme.colorScheme.onSurface
                          .withValues(alpha: 0.04),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      isDense: true,
                    ),
                    style: theme.textTheme.bodyMedium,
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                  ),
                ),
              ],

              // Scrollable content
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Organization Section
                      if (widget.config.showOrganizationSection)
                        VooMultiSwitcherOrganizationSection(
                          config: widget.config,
                          organizations: _filteredOrganizations,
                          onSelect: (org) {
                            widget.onOrganizationSelected(org);
                            widget.onClose();
                          },
                        ),

                      // Divider between sections
                      if (widget.config.showOrganizationSection &&
                          widget.config.showUserSection)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Divider(
                            height: 1,
                            color: style.sectionDividerColor ??
                                theme.dividerColor.withValues(alpha: 0.1),
                          ),
                        ),

                      // User Section
                      if (widget.config.showUserSection)
                        VooMultiSwitcherUserSection(
                          config: widget.config,
                          onSelect: widget.onUserSelected,
                          onLogout: widget.config.onLogout != null
                              ? () {
                                  widget.config.onLogout?.call();
                                  widget.onClose();
                                }
                              : null,
                          onSettings: widget.config.onSettingsTap != null
                              ? () {
                                  widget.config.onSettingsTap?.call();
                                  widget.onClose();
                                }
                              : null,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
