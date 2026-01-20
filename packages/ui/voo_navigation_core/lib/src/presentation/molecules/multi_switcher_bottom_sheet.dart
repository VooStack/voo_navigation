import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/src/domain/entities/multi_switcher_config.dart';
import 'package:voo_navigation_core/src/domain/entities/multi_switcher_style.dart';
import 'package:voo_navigation_core/src/domain/entities/organization.dart';
import 'package:voo_navigation_core/src/presentation/molecules/multi_switcher_sections.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Shows the multi-switcher as a bottom sheet modal.
///
/// This is the mobile-friendly presentation of the multi-switcher,
/// providing a clean UI/UX for switching organizations and managing
/// account settings on mobile devices.
void showMultiSwitcherBottomSheet({
  required BuildContext context,
  required VooMultiSwitcherConfig config,
}) {
  HapticFeedback.lightImpact();

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => VooMultiSwitcherBottomSheet(config: config),
  );
}

/// Bottom sheet widget for the multi-switcher.
///
/// This widget displays organizations and user account options in a bottom
/// sheet format, optimized for mobile interaction. It combines both the
/// organization section and user section into a single scrollable view.
class VooMultiSwitcherBottomSheet extends StatefulWidget {
  /// Configuration for the multi-switcher
  final VooMultiSwitcherConfig config;

  const VooMultiSwitcherBottomSheet({
    super.key,
    required this.config,
  });

  @override
  State<VooMultiSwitcherBottomSheet> createState() =>
      _VooMultiSwitcherBottomSheetState();
}

class _VooMultiSwitcherBottomSheetState
    extends State<VooMultiSwitcherBottomSheet> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

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
    super.dispose();
  }

  void _handleOrganizationSelected(VooOrganization org) {
    widget.config.onOrganizationChanged?.call(org);
    Navigator.of(context).pop();
  }

  void _handleSettingsTap() {
    Navigator.of(context).pop();
    widget.config.onSettingsTap?.call();
  }

  void _handleLogout() {
    Navigator.of(context).pop();
    widget.config.onLogout?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = context.vooRadius;
    final style = widget.config.style ?? const VooMultiSwitcherStyle();
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      margin: const EdgeInsets.all(16),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(radius.lg),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Search (optional)
          if (widget.config.showSearch)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: widget.config.searchHint ?? 'Search organizations...',
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
                  fillColor: theme.colorScheme.onSurface.withValues(alpha: 0.04),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: theme.textTheme.bodyMedium,
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                },
              ),
            ),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Organization section
                  if (widget.config.showOrganizationSection &&
                      widget.config.organizations.isNotEmpty) ...[
                    VooMultiSwitcherOrganizationSection(
                      config: widget.config,
                      organizations: _filteredOrganizations,
                      onSelect: _handleOrganizationSelected,
                    ),

                    // Divider between sections
                    if (widget.config.showUserSection)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Divider(
                          height: 1,
                          color: style.sectionDividerColor ??
                              theme.dividerColor.withValues(alpha: 0.1),
                        ),
                      ),
                  ],

                  // User section
                  if (widget.config.showUserSection)
                    VooMultiSwitcherUserSection(
                      config: widget.config,
                      onSettings: widget.config.onSettingsTap != null
                          ? _handleSettingsTap
                          : null,
                      onLogout: widget.config.onLogout != null
                          ? _handleLogout
                          : null,
                    ),
                ],
              ),
            ),
          ),

          // Bottom safe area padding
          SizedBox(height: bottomPadding > 0 ? bottomPadding : 8),
        ],
      ),
    );
  }
}
