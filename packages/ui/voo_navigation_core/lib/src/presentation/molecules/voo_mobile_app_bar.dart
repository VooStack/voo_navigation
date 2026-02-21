import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_tokens/voo_tokens.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_destination.dart';
import 'package:voo_navigation_core/src/presentation/molecules/voo_app_bar_leading.dart';
import 'package:voo_navigation_core/src/presentation/molecules/voo_app_bar_title.dart';

/// Mobile app bar molecule - a simpler app bar specifically for mobile layouts
class VooMobileAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Navigation configuration
  final VooNavigationConfig? config;

  /// Currently selected navigation item
  final VooNavigationDestination? selectedItem;

  /// Currently selected navigation item ID
  final String? selectedId;

  /// Custom title widget
  final Widget? title;

  /// Custom leading widget
  final Widget? leading;

  /// Custom actions (replaces default actions when provided)
  final List<Widget>? actions;

  /// Additional actions to append to the default or custom actions
  final List<Widget>? additionalActions;

  /// Whether to center the title
  final bool? centerTitle;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom foreground color
  final Color? foregroundColor;

  /// Whether to show menu button (for drawer)
  final bool showMenuButton;

  /// Custom toolbar height
  final double? toolbarHeight;

  /// Custom bottom widget (e.g., TabBar)
  final PreferredSizeWidget? bottom;

  /// Whether to show the bottom divider
  final bool? showBottomDivider;

  const VooMobileAppBar({
    super.key,
    this.config,
    this.selectedItem,
    this.selectedId,
    this.title,
    this.leading,
    this.actions,
    this.additionalActions,
    this.centerTitle,
    this.backgroundColor,
    this.foregroundColor,
    this.showMenuButton = false,
    this.toolbarHeight,
    this.bottom,
    this.showBottomDivider,
  });

  @override
  Size get preferredSize {
    double height = (toolbarHeight ?? kToolbarHeight) + 8 + 1;
    if (bottom != null) {
      height += bottom!.preferredSize.height;
    }
    return Size.fromHeight(height);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveTitle =
        title ??
        (selectedItem != null
            ? VooAppBarTitle(item: selectedItem!, config: config)
            : const Text(''));

    // Check if the leading widget would actually show content
    final wouldShowLeading = leading != null ||
        VooAppBarLeading.wouldShowContent(
          context: context,
          showMenuButton: showMenuButton,
          config: config,
        );

    final Widget? effectiveLeading = wouldShowLeading
        ? (leading ??
            VooAppBarLeading(
              showMenuButton: showMenuButton,
              config: config,
            ))
        : null;

    final effectiveCenterTitle = centerTitle ?? false;

    var effectiveActions = actions;

    // Append additional actions if provided
    if (additionalActions != null && additionalActions!.isNotEmpty) {
      effectiveActions = [...?effectiveActions, ...additionalActions!];
    }

    // Use theme surface color for proper theming
    final effectiveBackgroundColor =
        backgroundColor ??
        config?.navigationBackgroundColor ??
        colorScheme.surface;

    final effectiveForegroundColor = foregroundColor ?? colorScheme.onSurface;

    return Container(
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(context.vooRadius.lg),
          topRight: Radius.circular(context.vooRadius.lg),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(context.vooRadius.lg),
          topRight: Radius.circular(context.vooRadius.lg),
        ),
        child: AppBar(
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.vooSpacing.xs),
            child: effectiveTitle,
          ),
          leading: effectiveLeading,
          leadingWidth: wouldShowLeading ? null : 0,
          automaticallyImplyLeading: false,
          actions: effectiveActions?.isNotEmpty == true
              ? [...effectiveActions!, SizedBox(width: context.vooSpacing.md)]
              : null,
          centerTitle: effectiveCenterTitle,
          backgroundColor: Colors.transparent,
          foregroundColor: effectiveForegroundColor,
          elevation: 0,
          toolbarHeight:
              (toolbarHeight ?? kToolbarHeight) + context.vooSpacing.sm,
          titleSpacing: context.vooSpacing.md,
          titleTextStyle: theme.textTheme.titleLarge?.copyWith(
            color: effectiveForegroundColor,
            fontWeight: FontWeight.w600,
          ),
          bottom: _buildBottom(context, theme),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: theme.brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light,
            statusBarBrightness: theme.brightness,
          ),
        ),
      ),
    );
  }

  /// Builds the bottom widget for the app bar.
  /// If a custom bottom widget is provided, uses that.
  /// Otherwise, shows a divider based on showBottomDivider (defaults to true).
  PreferredSizeWidget? _buildBottom(BuildContext context, ThemeData theme) {
    // If custom bottom widget provided, wrap with divider if needed
    if (bottom != null) {
      final effectiveShowDivider = showBottomDivider ?? true;
      if (effectiveShowDivider) {
        return PreferredSize(
          preferredSize: Size.fromHeight(bottom!.preferredSize.height + 1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              bottom!,
              Container(
                height: context.vooSize.borderThin,
                color: theme.dividerColor.withValues(alpha: 0.08),
              ),
            ],
          ),
        );
      }
      return bottom;
    }

    // Default: show divider based on showBottomDivider (defaults to true)
    final effectiveShowDivider = showBottomDivider ?? true;
    if (!effectiveShowDivider) {
      return null;
    }

    return PreferredSize(
      preferredSize: const Size.fromHeight(1),
      child: Container(
        height: context.vooSize.borderThin,
        color: theme.dividerColor.withValues(alpha: 0.08),
      ),
    );
  }
}
