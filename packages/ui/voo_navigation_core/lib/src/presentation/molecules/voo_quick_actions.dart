import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/quick_action.dart';

/// A quick actions menu with customizable trigger
class VooQuickActions extends StatefulWidget {
  /// List of quick actions
  final List<VooQuickAction> actions;

  /// Icon for the trigger button
  final IconData? triggerIcon;

  /// Custom trigger widget
  final Widget? triggerWidget;

  /// Tooltip for the trigger
  final String? tooltip;

  /// Whether to show labels in grid layout
  final bool showLabelsInGrid;

  /// Style configuration
  final VooQuickActionsStyle? style;

  /// Whether to show in compact mode
  final bool compact;

  /// Custom action builder
  final Widget Function(VooQuickAction, VoidCallback onTap)? actionBuilder;

  /// Callback when an action is selected
  final ValueChanged<VooQuickAction>? onActionSelected;

  /// Whether to use grid layout
  final bool useGridLayout;

  /// Number of columns in grid layout
  final int gridColumns;

  const VooQuickActions({
    super.key,
    required this.actions,
    this.triggerIcon,
    this.triggerWidget,
    this.tooltip,
    this.showLabelsInGrid = true,
    this.style,
    this.compact = false,
    this.actionBuilder,
    this.onActionSelected,
    this.useGridLayout = false,
    this.gridColumns = 4,
  });

  @override
  State<VooQuickActions> createState() => _VooQuickActionsState();
}

class _VooQuickActionsState extends State<VooQuickActions>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 0.125).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _toggleMenu() {
    if (_isOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward();
    setState(() {
      _isOpen = true;
    });
  }

  void _removeOverlay() {
    _animationController.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
    setState(() {
      _isOpen = false;
    });
  }

  void _handleActionTap(VooQuickAction action) {
    _removeOverlay();
    widget.onActionSelected?.call(action);
    action.onTap?.call();
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final screenSize = MediaQuery.of(context).size;

    final style = widget.style ?? const VooQuickActionsStyle();
    final dropdownWidth = style.dropdownWidth ??
        (widget.useGridLayout ? widget.gridColumns * 80.0 + 32 : 220);

    // Calculate position
    double left = offset.dx + size.width / 2 - dropdownWidth / 2;
    if (left + dropdownWidth > screenSize.width - 16) {
      left = screenSize.width - dropdownWidth - 16;
    }
    if (left < 16) left = 16;

    // Position above if near bottom of screen
    final spaceBelow = screenSize.height - offset.dy - size.height;
    final showAbove = spaceBelow < 300;

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
          // Menu
          Positioned(
            left: left,
            top: showAbove ? null : offset.dy + size.height + 8,
            bottom: showAbove ? screenSize.height - offset.dy + 8 : null,
            child: ScaleTransition(
              scale: _scaleAnimation,
              alignment: showAbove ? Alignment.bottomCenter : Alignment.topCenter,
              child: _buildMenuContent(style, dropdownWidth),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuContent(VooQuickActionsStyle style, double width) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      elevation: 8,
      borderRadius: style.borderRadius ?? BorderRadius.circular(16),
      color: style.backgroundColor ?? colorScheme.surface,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: style.borderRadius ?? BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: widget.useGridLayout
            ? _buildGridLayout(style)
            : _buildListLayout(style),
      ),
    );
  }

  Widget _buildGridLayout(VooQuickActionsStyle style) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final visibleActions = widget.actions.where((a) => !a.isDivider).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: visibleActions.map((action) {
          return SizedBox(
            width: (style.dropdownWidth ?? (widget.gridColumns * 80.0)) /
                    widget.gridColumns -
                16,
            child: InkWell(
              onTap: action.isEnabled ? () => _handleActionTap(action) : null,
              borderRadius: BorderRadius.circular(12),
              child: Opacity(
                opacity: action.isEnabled ? 1.0 : 0.5,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: action.isDangerous
                              ? (style.dangerColor ?? colorScheme.error)
                                  .withValues(alpha: 0.1)
                              : colorScheme.surfaceContainerHighest,
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
                      if (widget.showLabelsInGrid) ...[
                        const SizedBox(height: 8),
                        Text(
                          action.label,
                          style: style.labelStyle ?? theme.textTheme.labelSmall?.copyWith(
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
        }).toList(),
      ),
    );
  }

  Widget _buildListLayout(VooQuickActionsStyle style) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: widget.actions.length,
      itemBuilder: (context, index) {
        final action = widget.actions[index];

        if (action.isDivider) {
          return const Divider(height: 8);
        }

        if (widget.actionBuilder != null) {
          return widget.actionBuilder!(
            action,
            () => _handleActionTap(action),
          );
        }

        return _ActionTile(
          action: action,
          style: style,
          onTap: () => _handleActionTap(action),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final style = widget.style ?? const VooQuickActionsStyle();

    if (widget.triggerWidget != null) {
      return Tooltip(
        message: widget.tooltip ?? 'Quick actions',
        child: InkWell(
          onTap: _toggleMenu,
          borderRadius: BorderRadius.circular(8),
          child: widget.triggerWidget,
        ),
      );
    }

    final triggerSize = style.triggerSize ?? (widget.compact ? 40.0 : 56.0);

    return Tooltip(
      message: widget.tooltip ?? 'Quick actions',
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimation.value * 3.14159 * 2,
            child: Material(
              elevation: _isOpen ? 8 : 4,
              borderRadius: BorderRadius.circular(triggerSize / 2),
              color: style.triggerBackgroundColor ?? colorScheme.primary,
              child: InkWell(
                onTap: _toggleMenu,
                borderRadius: BorderRadius.circular(triggerSize / 2),
                child: SizedBox(
                  width: triggerSize,
                  height: triggerSize,
                  child: Icon(
                    _isOpen ? Icons.close : (widget.triggerIcon ?? Icons.add),
                    size: widget.compact ? 20 : 28,
                    color: style.triggerColor ?? colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ActionTile extends StatefulWidget {
  final VooQuickAction action;
  final VooQuickActionsStyle style;
  final VoidCallback onTap;

  const _ActionTile({
    required this.action,
    required this.style,
    required this.onTap,
  });

  @override
  State<_ActionTile> createState() => _ActionTileState();
}

class _ActionTileState extends State<_ActionTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final action = widget.action;
    final style = widget.style;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Opacity(
        opacity: action.isEnabled ? 1.0 : 0.5,
        child: InkWell(
          onTap: action.isEnabled ? widget.onTap : null,
          child: Container(
            padding: style.itemPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: _isHovered
                ? (style.hoverColor ?? colorScheme.surfaceContainerHighest)
                : null,
            child: Row(
              children: [
                // Icon
                action.iconWidget ??
                    Icon(
                      action.icon ?? Icons.star,
                      size: style.iconSize ?? 20,
                      color: action.isDangerous
                          ? (style.dangerColor ?? colorScheme.error)
                          : (action.iconColor ?? colorScheme.onSurfaceVariant),
                    ),
                const SizedBox(width: 12),

                // Label and description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        action.label,
                        style: style.labelStyle ?? theme.textTheme.bodyMedium?.copyWith(
                          color: action.isDangerous
                              ? (style.dangerColor ?? colorScheme.error)
                              : colorScheme.onSurface,
                        ),
                      ),
                      if (action.description != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          action.description!,
                          style: style.descriptionStyle ??
                              theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Shortcut
                if (action.shortcut != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      action.shortcut!,
                      style: style.shortcutStyle ?? theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),

                // Arrow for nested menus
                if (action.hasChildren)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.chevron_right,
                      size: 16,
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
