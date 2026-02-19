import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/src/domain/entities/quick_action.dart';

/// A widget that renders a section of quick actions with a label header
/// and optional horizontal scrolling.
class VooQuickActionsSectionLayout extends StatelessWidget {
  /// The section to render
  final VooQuickActionSection section;

  /// Style configuration
  final VooQuickActionsStyle style;

  /// Global setting for showing labels
  final bool showLabelsInGrid;

  /// Callback when an action is tapped
  final void Function(VooQuickAction) onActionTap;

  const VooQuickActionsSectionLayout({
    super.key,
    required this.section,
    required this.style,
    required this.showLabelsInGrid,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectivePadding = section.padding ?? const EdgeInsets.symmetric(horizontal: 16);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Section header
        Padding(
          padding: effectivePadding,
          child: Text(
            section.label,
            style: section.labelStyle ??
                theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        const SizedBox(height: 8),
        // Actions
        if (section.horizontalScroll)
          SizedBox(
            height: section.itemHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: effectivePadding,
              itemCount: section.actions.length,
              separatorBuilder: (_, __) => SizedBox(width: section.itemSpacing),
              itemBuilder: (context, index) {
                final action = section.actions[index];
                return SizedBox(
                  width: section.itemWidth,
                  height: section.itemHeight,
                  child: _buildActionItem(
                    action: action,
                    theme: theme,
                    colorScheme: colorScheme,
                  ),
                );
              },
            ),
          )
        else
          Padding(
            padding: effectivePadding,
            child: Wrap(
              spacing: section.itemSpacing,
              runSpacing: section.itemSpacing,
              children: section.actions.map((action) {
                return SizedBox(
                  width: section.itemWidth,
                  height: section.itemHeight,
                  child: _buildActionItem(
                    action: action,
                    theme: theme,
                    colorScheme: colorScheme,
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildActionItem({
    required VooQuickAction action,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    // Determine icon background color
    final iconBgColor = action.gridIconBackgroundColor ??
        (action.isDangerous
            ? (style.dangerColor ?? colorScheme.error).withValues(alpha: 0.1)
            : colorScheme.surfaceContainerHighest);

    // Determine item background color
    final itemBgColor = action.gridBackgroundColor ?? colorScheme.surfaceContainerLow;

    // Per-action showLabel overrides section setting, which overrides global
    final shouldShowLabel = action.showLabel ?? section.showLabels ?? showLabelsInGrid;

    return Material(
      color: itemBgColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: action.isEnabled
            ? () {
                HapticFeedback.lightImpact();
                action.onTap?.call();
                onActionTap(action);
              }
            : null,
        borderRadius: BorderRadius.circular(12),
        child: Opacity(
          opacity: action.isEnabled ? 1.0 : 0.5,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: action.iconWidget ??
                      Icon(
                        action.icon ?? Icons.star,
                        size: style.iconSize ?? 24,
                        color: action.isDangerous
                            ? (style.dangerColor ?? colorScheme.error)
                            : (action.iconColor ?? colorScheme.onSurfaceVariant),
                      ),
                ),
                if (shouldShowLabel) ...[
                  const SizedBox(height: 8),
                  Text(
                    action.label,
                    style: action.labelStyle ??
                        style.labelStyle ??
                        theme.textTheme.labelSmall?.copyWith(
                          color: action.isDangerous
                              ? (style.dangerColor ?? colorScheme.error)
                              : colorScheme.onSurface,
                        ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A widget that renders multiple sections of quick actions
class VooQuickActionsSectionsLayout extends StatelessWidget {
  /// List of sections to render
  final List<VooQuickActionSection> sections;

  /// Style configuration
  final VooQuickActionsStyle style;

  /// Global setting for showing labels
  final bool showLabelsInGrid;

  /// Callback when an action is tapped
  final void Function(VooQuickAction) onActionTap;

  /// Spacing between sections. Defaults to 16.
  final double sectionSpacing;

  /// Padding around the entire layout
  final EdgeInsets? padding;

  const VooQuickActionsSectionsLayout({
    super.key,
    required this.sections,
    required this.style,
    required this.showLabelsInGrid,
    required this.onActionTap,
    this.sectionSpacing = 16,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < sections.length; i++) ...[
            VooQuickActionsSectionLayout(
              section: sections[i],
              style: style,
              showLabelsInGrid: showLabelsInGrid,
              onActionTap: onActionTap,
            ),
            if (i < sections.length - 1) SizedBox(height: sectionSpacing),
          ],
        ],
      ),
    );
  }
}
