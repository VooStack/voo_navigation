import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/src/domain/entities/organization.dart';
import 'package:voo_navigation_core/src/presentation/atoms/voo_avatar.dart';
import 'package:voo_navigation_core/src/presentation/molecules/organization_dropdown_content.dart';
import 'package:voo_navigation_core/src/presentation/utils/voo_collapse_state.dart';

/// A dropdown switcher for selecting between organizations
class VooOrganizationSwitcher extends StatefulWidget {
  /// List of available organizations
  final List<VooOrganization> organizations;

  /// Currently selected organization
  final VooOrganization? selectedOrganization;

  /// Callback when an organization is selected
  final ValueChanged<VooOrganization>? onOrganizationChanged;

  /// Callback when create organization is tapped
  final VoidCallback? onCreateOrganization;

  /// Callback when search text changes
  final ValueChanged<String>? onSearch;

  /// Whether to show search (auto-enabled when >5 orgs)
  final bool? showSearch;

  /// Whether to show the create organization button
  final bool showCreateButton;

  /// Label for the create button
  final String? createButtonLabel;

  /// Hint text for search
  final String? searchHint;

  /// Style configuration
  final VooOrganizationSwitcherStyle? style;

  /// Whether to show in compact mode (avatar only)
  ///
  /// When null, auto-detects from [VooCollapseState] in widget tree.
  /// Set explicitly to override auto-detection.
  final bool? compact;

  /// Custom builder for organization tiles in dropdown
  final Widget Function(VooOrganization, bool isSelected)? organizationTileBuilder;

  /// Custom builder for the selected organization display
  final Widget Function(VooOrganization)? selectedOrganizationBuilder;

  /// Tooltip text
  final String? tooltip;

  const VooOrganizationSwitcher({
    super.key,
    required this.organizations,
    this.selectedOrganization,
    this.onOrganizationChanged,
    this.onCreateOrganization,
    this.onSearch,
    this.showSearch,
    this.showCreateButton = true,
    this.createButtonLabel,
    this.searchHint,
    this.style,
    this.compact,
    this.organizationTileBuilder,
    this.selectedOrganizationBuilder,
    this.tooltip,
  });

  @override
  State<VooOrganizationSwitcher> createState() => _VooOrganizationSwitcherState();
}

class _VooOrganizationSwitcherState extends State<VooOrganizationSwitcher> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  int _selectedIndex = -1;

  bool get _shouldShowSearch =>
      widget.showSearch ?? widget.organizations.length > 5;

  List<VooOrganization> get _filteredOrganizations {
    if (_searchQuery.isEmpty) return widget.organizations;
    final query = _searchQuery.toLowerCase();
    return widget.organizations.where((org) {
      return org.name.toLowerCase().contains(query) ||
          (org.subtitle?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  @override
  void dispose() {
    _removeOverlay();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
      _searchQuery = '';
      _searchController.clear();
      _selectedIndex = -1;
    });
    if (_shouldShowSearch) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _searchFocusNode.requestFocus();
      });
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isOpen = false;
    });
  }

  void _selectOrganization(VooOrganization org) {
    widget.onOrganizationChanged?.call(org);
    _removeOverlay();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    final orgs = _filteredOrganizations;
    if (orgs.isEmpty) return;

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      setState(() {
        _selectedIndex = (_selectedIndex + 1) % orgs.length;
      });
      _overlayEntry?.markNeedsBuild();
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      setState(() {
        _selectedIndex = _selectedIndex <= 0 ? orgs.length - 1 : _selectedIndex - 1;
      });
      _overlayEntry?.markNeedsBuild();
    } else if (event.logicalKey == LogicalKeyboardKey.enter) {
      if (_selectedIndex >= 0 && _selectedIndex < orgs.length) {
        _selectOrganization(orgs[_selectedIndex]);
      }
    } else if (event.logicalKey == LogicalKeyboardKey.escape) {
      _removeOverlay();
    }
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final screenSize = MediaQuery.of(context).size;

    final style = widget.style ?? const VooOrganizationSwitcherStyle();
    final dropdownWidth = style.dropdownWidth ?? 280;
    final maxHeight = style.maxDropdownHeight ?? 400;

    // Calculate position - prefer below, but flip if not enough space
    final spaceBelow = screenSize.height - offset.dy - size.height;
    final showAbove = spaceBelow < maxHeight && offset.dy > maxHeight;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Backdrop
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              behavior: HitTestBehavior.opaque,
              child: Container(color: Colors.transparent),
            ),
          ),
          // Dropdown
          Positioned(
            left: offset.dx,
            top: showAbove ? null : offset.dy + size.height + 4,
            bottom: showAbove ? screenSize.height - offset.dy + 4 : null,
            width: dropdownWidth,
            child: KeyboardListener(
              focusNode: FocusNode(),
              onKeyEvent: _handleKeyEvent,
              child: VooOrganizationDropdownContent(
                style: style,
                maxHeight: maxHeight,
                shouldShowSearch: _shouldShowSearch,
                searchController: _searchController,
                searchFocusNode: _searchFocusNode,
                searchHint: widget.searchHint,
                onSearchChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                    _selectedIndex = -1;
                  });
                  widget.onSearch?.call(value);
                  _overlayEntry?.markNeedsBuild();
                },
                filteredOrganizations: _filteredOrganizations,
                selectedOrganization: widget.selectedOrganization,
                selectedIndex: _selectedIndex,
                organizationTileBuilder: widget.organizationTileBuilder,
                onSelectOrganization: _selectOrganization,
                showCreateButton: widget.showCreateButton,
                onCreateOrganization: widget.onCreateOrganization,
                createButtonLabel: widget.createButtonLabel,
                onRemoveOverlay: _removeOverlay,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? const VooOrganizationSwitcherStyle();
    final selected = widget.selectedOrganization;

    // Auto-detect compact mode from VooCollapseState if not explicitly set
    final effectiveCompact = widget.compact ?? VooCollapseState.isCollapsedOf(context);

    Widget trigger;

    if (effectiveCompact) {
      // Compact mode - just avatar
      trigger = Tooltip(
        message: selected?.name ?? widget.tooltip ?? 'Select organization',
        child: VooAvatar(
          imageUrl: selected?.avatarUrl,
          name: selected?.name,
          backgroundColor: selected?.avatarColor,
          size: style.compactAvatarSize,
          onTap: _toggleDropdown,
        ),
      );
    } else if (widget.selectedOrganizationBuilder != null && selected != null) {
      // Custom builder
      trigger = InkWell(
        onTap: _toggleDropdown,
        borderRadius: style.borderRadius ?? BorderRadius.circular(8),
        child: widget.selectedOrganizationBuilder!(selected),
      );
    } else {
      // Default trigger - clean design matching profile card style
      trigger = _DefaultOrgSwitcherTrigger(
        selected: selected,
        isOpen: _isOpen,
        onTap: _toggleDropdown,
        style: style,
      );
    }

    return CompositedTransformTarget(
      link: _layerLink,
      child: trigger,
    );
  }
}

/// Clean default trigger matching profile card style
class _DefaultOrgSwitcherTrigger extends StatefulWidget {
  final VooOrganization? selected;
  final bool isOpen;
  final VoidCallback onTap;
  final VooOrganizationSwitcherStyle style;

  const _DefaultOrgSwitcherTrigger({
    required this.selected,
    required this.isOpen,
    required this.onTap,
    required this.style,
  });

  @override
  State<_DefaultOrgSwitcherTrigger> createState() => _DefaultOrgSwitcherTriggerState();
}

class _DefaultOrgSwitcherTriggerState extends State<_DefaultOrgSwitcherTrigger> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final selected = widget.selected;
    final style = widget.style;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: style.borderRadius ?? BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: style.triggerPadding ??
                const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: style.triggerDecoration ??
                BoxDecoration(
                  color: _isHovered || widget.isOpen
                      ? colorScheme.onSurface.withValues(alpha: 0.05)
                      : Colors.transparent,
                  borderRadius: style.borderRadius ?? BorderRadius.circular(8),
                  border: _isHovered || widget.isOpen
                      ? Border.all(
                          color: colorScheme.outline.withValues(alpha: 0.1),
                          width: 1,
                        )
                      : null,
                ),
            child: Row(
              children: [
                VooAvatar(
                  imageUrl: selected?.avatarUrl,
                  name: selected?.name,
                  backgroundColor: selected?.avatarColor,
                  size: 32,
                  placeholderIcon: Icons.business,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selected?.name ?? 'Select Organization',
                        style: style.titleStyle ??
                            theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      if (selected?.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          selected!.subtitle!,
                          style: style.subtitleStyle ??
                              theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: _isHovered ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
