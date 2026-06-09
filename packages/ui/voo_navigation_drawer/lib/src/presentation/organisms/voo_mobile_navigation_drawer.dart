import 'package:flutter/material.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';

/// Material [Drawer] that lists every navigation destination, intended for
/// mobile layouts where the floating bottom bar can't show all items.
///
/// Items are rendered in their declared order. Items with `children` render
/// as expandable sections (Teams, Employee, etc.) — the chevron rotates and
/// the children slide open. [VooNavigationDestination] divider items
/// (`isDivider == true`) become uppercase section headers labelled by their
/// `id` (stripped of any `divider_` prefix). Items that appear *before* any
/// divider are grouped under [firstSectionLabel] when it is non-null.
class VooMobileNavigationDrawer extends StatefulWidget {
  /// Navigation configuration sourcing the items list.
  final VooNavigationConfig config;

  /// Currently selected item id, used to highlight the matching row.
  final String selectedId;

  /// Called with the tapped item id after the drawer pops itself.
  final void Function(String itemId) onNavigationItemSelected;

  /// Title shown at the top of the drawer.
  final String title;

  /// Optional subtitle rendered under the title (e.g. user name, brand line).
  final String? subtitle;

  /// Section header shown above the first batch of items (the ones before any
  /// divider). When null, those items render without a section header.
  final String? firstSectionLabel;

  /// Optional widget rendered at the bottom of the drawer, below the items
  /// list (e.g. user profile chip, sign-out button).
  final Widget? footer;

  const VooMobileNavigationDrawer({
    super.key,
    required this.config,
    required this.selectedId,
    required this.onNavigationItemSelected,
    this.title = 'Navigation',
    this.subtitle,
    this.firstSectionLabel,
    this.footer,
  });

  /// Opens the navigation drawer of the nearest ancestor [Scaffold] that
  /// actually has a drawer attached.
  ///
  /// [Scaffold.maybeOf] returns the closest Scaffold, which inside nested
  /// scaffolds (a page scaffold inside a navigation scaffold) is usually the
  /// inner one. This walks past inner scaffolds that have no drawer until it
  /// finds the navigation scaffold installed by the voo system. Returns true
  /// if a drawer was opened.
  static bool open(BuildContext context) {
    ScaffoldState? target;
    context.visitAncestorElements((element) {
      if (element is StatefulElement && element.state is ScaffoldState) {
        final state = element.state as ScaffoldState;
        if (state.hasDrawer) {
          target = state;
          return false;
        }
      }
      return true;
    });
    if (target == null) return false;
    target!.openDrawer();
    return true;
  }

  @override
  State<VooMobileNavigationDrawer> createState() =>
      _VooMobileNavigationDrawerState();
}

class _VooMobileNavigationDrawerState extends State<VooMobileNavigationDrawer> {
  // Persists across rebuilds of the same drawer instance so children stay
  // open if the user picks an item and the drawer is re-opened later in
  // the same session.
  final Set<String> _expandedSectionIds = {};

  @override
  void initState() {
    super.initState();
    // Seed expansion from the config so authors can mark `isExpanded: true`
    // on the section in their VooNavigationDestination tree.
    for (final item in widget.config.items) {
      if (item.hasChildren && item.isExpanded) {
        _expandedSectionIds.add(item.id);
      }
    }
  }

  bool _isSelectedSomewhere(VooNavigationDestination section) {
    if (section.id == widget.selectedId) return true;
    if (section.children == null) return false;
    for (final child in section.children!) {
      if (child.id == widget.selectedId) return true;
    }
    return false;
  }

  void _toggleSection(String id) {
    setState(() {
      if (_expandedSectionIds.contains(id)) {
        _expandedSectionIds.remove(id);
      } else {
        _expandedSectionIds.add(id);
      }
    });
  }

  void _handleItemTap(String id) {
    Navigator.of(context).pop();
    widget.onNavigationItemSelected(id);
  }

  @override
  Widget build(BuildContext context) {
    final m = context.vooMinimal;
    final width = MediaQuery.of(context).size.width.clamp(300.0, 340.0);

    final rows = <Widget>[];
    String? pendingLabel = widget.firstSectionLabel;
    var emittedFirstSection = false;

    for (final item in widget.config.items) {
      if (!item.isVisible) continue;
      if (item.isDivider) {
        pendingLabel = _sectionLabelFromDividerId(item.id);
        continue;
      }
      if (pendingLabel != null) {
        rows.add(_DrawerSectionHeader(
          label: pendingLabel,
          topPadding: emittedFirstSection ? 16 : 8,
        ));
        pendingLabel = null;
        emittedFirstSection = true;
      }

      if (item.hasChildren) {
        // Auto-expand if a child is currently selected so the user can see
        // their position in the tree on every drawer open.
        final hasSelectedChild = _isSelectedSomewhere(item);
        final isExpanded = _expandedSectionIds.contains(item.id) || hasSelectedChild;
        rows.add(_DrawerExpandableSection(
          item: item,
          isExpanded: isExpanded,
          selectedId: widget.selectedId,
          onToggle: () => _toggleSection(item.id),
          onChildTap: _handleItemTap,
        ));
      } else {
        rows.add(_DrawerNavRow(
          item: item,
          isSelected: item.id == widget.selectedId,
          onTap: () => _handleItemTap(item.id),
        ));
      }
    }

    return Drawer(
      backgroundColor: m.background,
      width: width,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(12)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DrawerHeader(title: widget.title, subtitle: widget.subtitle),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                children: rows,
              ),
            ),
            if (widget.footer != null) ...[
              Container(height: 1, color: m.border),
              Padding(padding: const EdgeInsets.all(16), child: widget.footer!),
            ],
          ],
        ),
      ),
    );
  }

  static String _sectionLabelFromDividerId(String id) {
    var label = id;
    if (label.startsWith('divider_')) {
      label = label.substring('divider_'.length);
    }
    return label.replaceAll('_', ' ').toUpperCase();
  }
}

class _DrawerHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _DrawerHeader({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final m = context.vooMinimal;
    return Padding(
      // More vertical breathing room than the desktop drawer header —
      // mobile drawers typically feel right at ~64-72dp tall.
      padding: const EdgeInsets.fromLTRB(20, 20, 8, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: m.textPrimary,
                    fontSize: VooMinimal.fontSizeXl, // 20 (was 16)
                    fontWeight: FontWeight.w600,
                    letterSpacing: VooMinimal.letterSpacingTight,
                    height: 1.1,
                  ),
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: m.textTertiary,
                      fontSize: VooMinimal.fontSizeMd, // 14 (was 12)
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Larger 44dp tap target for the close button.
          IconButton(
            icon: Icon(Icons.close_rounded, size: 22, color: m.textSecondary),
            tooltip: 'Close',
            iconSize: 22,
            padding: const EdgeInsets.all(10),
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class _DrawerSectionHeader extends StatelessWidget {
  final String label;
  final double topPadding;

  const _DrawerSectionHeader({required this.label, this.topPadding = 12});

  @override
  Widget build(BuildContext context) {
    final m = context.vooMinimal;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, topPadding + 4, 20, 6),
      child: Text(
        label,
        style: TextStyle(
          color: m.textTertiary,
          letterSpacing: 1.0,
          fontWeight: FontWeight.w600,
          fontSize: VooMinimal.fontSizeSm, // 12 (was 11)
        ),
      ),
    );
  }
}

/// Single-line nav row — used for items with no children and for the
/// section *header* row inside `_DrawerExpandableSection`.
class _DrawerNavRow extends StatelessWidget {
  final VooNavigationDestination item;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget? trailing;

  const _DrawerNavRow({
    required this.item,
    required this.isSelected,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final m = context.vooMinimal;
    final iconColor = isSelected
        ? (item.selectedIconColor ?? m.accent)
        : (item.iconColor ?? m.textTertiary);
    final textColor = isSelected ? m.textPrimary : m.textSecondary;
    final background = isSelected ? m.selectedOverlay : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: background,
        borderRadius: VooMinimal.brMd,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          // Min 48dp tap target — Material Touch Target Sizes guideline.
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: Center(
                      child: IconTheme.merge(
                        data: IconThemeData(size: 20, color: iconColor),
                        child: isSelected ? item.effectiveSelectedIcon : item.icon,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      item.label ?? '',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        letterSpacing: -0.1,
                        height: 1.2,
                      ),
                    ),
                  ),
                  ?trailing,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Section row with a chevron + animated child list. Mirrors the desktop
/// `VooDrawerExpandableSection` look and feel but with mobile-appropriate
/// padding.
class _DrawerExpandableSection extends StatelessWidget {
  final VooNavigationDestination item;
  final bool isExpanded;
  final String selectedId;
  final VoidCallback onToggle;
  final void Function(String id) onChildTap;

  const _DrawerExpandableSection({
    required this.item,
    required this.isExpanded,
    required this.selectedId,
    required this.onToggle,
    required this.onChildTap,
  });

  @override
  Widget build(BuildContext context) {
    final m = context.vooMinimal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Section header — reuse the nav-row look but trailing chevron
        // instead of nothing, and never "selected" (the children are).
        _DrawerNavRow(
          item: item,
          isSelected: false,
          onTap: onToggle,
          trailing: AnimatedRotation(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            turns: isExpanded ? 0.5 : 0,
            child: Icon(
              Icons.keyboard_arrow_down,
              color: m.textTertiary,
              size: 20,
            ),
          ),
        ),
        // Animated children — guide line on the left so the nested rows
        // visually attach to the parent section (Linear/Notion-style).
        // Indent so the line sits under the parent's icon center.
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 180),
          sizeCurve: Curves.easeOutCubic,
          firstChild: const SizedBox(width: double.infinity, height: 0),
          secondChild: Padding(
            // 14px container padding (matches row horizontal padding) + 11px
            // to land the line center on the parent icon center (icon is at
            // 14 + 11 = 25px from the row's left edge).
            padding: const EdgeInsets.only(left: 14),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 2,
                    margin: const EdgeInsets.only(left: 10, right: 14),
                    decoration: BoxDecoration(
                      color: m.borderStrong,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final child in item.children ?? const [])
                          if (child.isVisible)
                            _DrawerChildRow(
                              item: child,
                              isSelected: child.id == selectedId,
                              onTap: () => onChildTap(child.id),
                            ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          crossFadeState: isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
        ),
      ],
    );
  }
}

/// Child row — narrower padding, no icon, matches the desktop child item.
class _DrawerChildRow extends StatelessWidget {
  final VooNavigationDestination item;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerChildRow({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final m = context.vooMinimal;
    final textColor = isSelected ? m.textPrimary : m.textTertiary;
    final background = isSelected ? m.selectedOverlay : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: background,
        borderRadius: VooMinimal.brMd,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 40),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  item.label ?? '',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    letterSpacing: -0.1,
                    height: 1.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
