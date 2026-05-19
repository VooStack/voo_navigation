import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_destination.dart';

/// Material [Drawer] that lists every navigation destination, intended for
/// mobile layouts where the floating bottom bar can't show all items.
///
/// Items are rendered in their declared order. [VooNavigationDestination]
/// divider items (`isDivider == true`) become uppercase section headers
/// labelled by their `id` (stripped of any `divider_` prefix).
///
/// Items that appear *before* any divider are grouped under
/// [firstSectionLabel] when it is non-null.
class VooMobileNavigationDrawer extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width.clamp(300.0, 340.0);

    final rows = <Widget>[];
    String? pendingLabel = firstSectionLabel;
    var emittedFirstSection = false;

    for (final item in config.items) {
      if (!item.isVisible) continue;
      if (item.isDivider) {
        pendingLabel = _sectionLabelFromDividerId(item.id);
        continue;
      }
      if (pendingLabel != null) {
        rows.add(_DrawerSectionHeader(label: pendingLabel, topPadding: emittedFirstSection ? 16 : 8));
        pendingLabel = null;
        emittedFirstSection = true;
      }
      rows.add(
        _DrawerNavRow(
          item: item,
          isSelected: item.id == selectedId,
          onTap: () {
            Navigator.of(context).pop();
            onNavigationItemSelected(item.id);
          },
        ),
      );
    }

    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      width: width,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DrawerHeader(title: title, subtitle: subtitle),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                children: rows,
              ),
            ),
            if (footer != null) ...[
              Divider(height: 1, color: theme.dividerColor.withValues(alpha: 0.4)),
              Padding(padding: const EdgeInsets.all(12), child: footer!),
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
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 8, 12),
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
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.2),
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 22),
            tooltip: 'Close',
            visualDensity: VisualDensity.compact,
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
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(20, topPadding, 20, 6),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary,
          letterSpacing: 1.4,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _DrawerNavRow extends StatelessWidget {
  final VooNavigationDestination item;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerNavRow({required this.item, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface;
    final background = isSelected ? theme.colorScheme.primaryContainer.withValues(alpha: 0.55) : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Center(
                    child: IconTheme.merge(
                      data: IconThemeData(size: 18, color: color),
                      child: isSelected ? item.effectiveSelectedIcon : item.icon,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    item.label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: color,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(color: theme.colorScheme.primary, shape: BoxShape.circle),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
