import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/src/domain/entities/organization.dart';
import 'package:voo_navigation_core/src/presentation/atoms/voo_avatar.dart';
import 'package:voo_navigation_core/src/presentation/atoms/voo_search_field.dart';
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
              child: _buildDropdownContent(style, maxHeight),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownContent(VooOrganizationSwitcherStyle style, double maxHeight) {
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
            if (_shouldShowSearch)
              Padding(
                padding: const EdgeInsets.all(12),
                child: VooSearchField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  hintText: widget.searchHint ?? 'Search organizations...',
                  showKeyboardHint: false,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                      _selectedIndex = -1;
                    });
                    widget.onSearch?.call(value);
                    _overlayEntry?.markNeedsBuild();
                  },
                ),
              ),

            // Organization list
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(
                  top: _shouldShowSearch ? 0 : 8,
                  bottom: 8,
                ),
                itemCount: _filteredOrganizations.length,
                itemBuilder: (context, index) {
                  final org = _filteredOrganizations[index];
                  final isSelected = org.id == widget.selectedOrganization?.id;
                  final isHighlighted = index == _selectedIndex;

                  if (widget.organizationTileBuilder != null) {
                    return InkWell(
                      onTap: () => _selectOrganization(org),
                      child: widget.organizationTileBuilder!(org, isSelected),
                    );
                  }

                  return _OrganizationTile(
                    organization: org,
                    isSelected: isSelected,
                    isHighlighted: isHighlighted,
                    style: style,
                    onTap: () => _selectOrganization(org),
                  );
                },
              ),
            ),

            // Create button
            if (widget.showCreateButton && widget.onCreateOrganization != null) ...[
              const Divider(height: 1),
              InkWell(
                onTap: () {
                  _removeOverlay();
                  widget.onCreateOrganization?.call();
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
                        widget.createButtonLabel ?? 'Create Organization',
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
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
      // Default trigger
      trigger = InkWell(
        onTap: _toggleDropdown,
        borderRadius: style.borderRadius ?? BorderRadius.circular(8),
        child: Container(
          padding: style.triggerPadding ??
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: style.triggerDecoration ??
              BoxDecoration(
                color: _isOpen
                    ? colorScheme.surfaceContainerHighest
                    : colorScheme.surfaceContainerHigh,
                borderRadius: style.borderRadius ?? BorderRadius.circular(8),
                border: Border.all(
                  color: _isOpen
                      ? colorScheme.primary.withValues(alpha: 0.5)
                      : colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              VooAvatar(
                imageUrl: selected?.avatarUrl,
                name: selected?.name,
                backgroundColor: selected?.avatarColor,
                size: style.avatarSize,
                placeholderIcon: Icons.business,
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      selected?.name ?? 'Select Organization',
                      style: style.titleStyle ?? theme.textTheme.titleSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (selected?.subtitle != null)
                      Text(
                        selected!.subtitle!,
                        style: style.subtitleStyle ??
                            theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              AnimatedRotation(
                turns: _isOpen ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return CompositedTransformTarget(
      link: _layerLink,
      child: trigger,
    );
  }
}

class _OrganizationTile extends StatefulWidget {
  final VooOrganization organization;
  final bool isSelected;
  final bool isHighlighted;
  final VooOrganizationSwitcherStyle style;
  final VoidCallback onTap;

  const _OrganizationTile({
    required this.organization,
    required this.isSelected,
    required this.isHighlighted,
    required this.style,
    required this.onTap,
  });

  @override
  State<_OrganizationTile> createState() => _OrganizationTileState();
}

class _OrganizationTileState extends State<_OrganizationTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final org = widget.organization;
    final style = widget.style;

    final backgroundColor = widget.isSelected
        ? (style.selectedColor ?? colorScheme.primaryContainer)
        : widget.isHighlighted || _isHovered
            ? (style.hoverColor ?? colorScheme.surfaceContainerHighest)
            : Colors.transparent;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          padding: style.itemPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: backgroundColor,
          child: Row(
            children: [
              VooAvatar(
                imageUrl: org.avatarUrl,
                child: org.avatarWidget,
                name: org.name,
                backgroundColor: org.avatarColor,
                size: style.avatarSize * 0.9,
                placeholderIcon: Icons.business,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      org.name,
                      style: style.titleStyle ?? theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (org.subtitle != null)
                      Text(
                        org.subtitle!,
                        style: style.subtitleStyle ?? theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              if (widget.isSelected)
                Icon(
                  Icons.check,
                  size: 20,
                  color: colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
