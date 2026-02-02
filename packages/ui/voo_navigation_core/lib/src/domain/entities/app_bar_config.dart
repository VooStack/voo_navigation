import 'package:flutter/material.dart';

/// Configuration for app bar customization on a per-page basis.
///
/// Use this to customize app bar elements when using [VooPage] with
/// [VooAdaptiveScaffold]. This consolidates all app bar related settings
/// into a single configuration object.
///
/// Example:
/// ```dart
/// VooPage(
///   config: VooPageConfig(
///     appBarConfig: VooAppBarConfig(
///       title: Text('My Page'),
///       centerTitle: true,
///       backgroundColor: Colors.blue,
///       bottom: TabBar(tabs: [...]),
///     ),
///   ),
///   child: MyPageContent(),
/// )
/// ```
class VooAppBarConfig {
  /// Custom app bar widget to completely replace the default app bar.
  ///
  /// When provided, this replaces the entire app bar and all other
  /// properties in this config are ignored.
  final PreferredSizeWidget? appBar;

  /// Whether to show the app bar.
  ///
  /// When null, uses the scaffold's default setting.
  /// Set to false to hide the app bar for this page only.
  final bool? show;

  /// Custom title widget for the app bar.
  final Widget? title;

  /// Custom leading widget for the app bar.
  final Widget? leading;

  /// Additional actions to add to the app bar.
  ///
  /// These are appended to the default actions from [VooNavigationConfig].
  final List<Widget>? additionalActions;

  /// Widget to display at the bottom of the app bar (e.g., TabBar).
  final PreferredSizeWidget? bottom;

  /// Whether to show a divider/border at the bottom of the app bar.
  ///
  /// When null, defaults to true (show divider).
  final bool? showBottomDivider;

  /// Whether to show the back button in the app bar.
  ///
  /// When null (default), uses automatic behavior based on Navigator.canPop().
  /// When true, always shows the back button.
  /// When false, never shows the back button.
  final bool? showBackButton;

  /// Background color for the app bar.
  ///
  /// When null, uses the default theme color.
  final Color? backgroundColor;

  /// Foreground color for the app bar (text, icons).
  ///
  /// When null, uses the default theme color.
  final Color? foregroundColor;

  /// Whether to center the title.
  ///
  /// When null, uses the default from [VooNavigationConfig] or platform default.
  final bool? centerTitle;

  /// Custom elevation for the app bar.
  final double? elevation;

  /// Custom toolbar height.
  final double? toolbarHeight;

  const VooAppBarConfig({
    this.appBar,
    this.show,
    this.title,
    this.leading,
    this.additionalActions,
    this.bottom,
    this.showBottomDivider,
    this.showBackButton,
    this.backgroundColor,
    this.foregroundColor,
    this.centerTitle,
    this.elevation,
    this.toolbarHeight,
  });

  /// Creates a config that hides the app bar.
  const VooAppBarConfig.hidden()
      : appBar = null,
        show = false,
        title = null,
        leading = null,
        additionalActions = null,
        bottom = null,
        showBottomDivider = null,
        showBackButton = false,
        backgroundColor = null,
        foregroundColor = null,
        centerTitle = null,
        elevation = null,
        toolbarHeight = null;

  /// Creates a copy of this configuration with the given fields replaced.
  VooAppBarConfig copyWith({
    PreferredSizeWidget? appBar,
    bool? show,
    Widget? title,
    Widget? leading,
    List<Widget>? additionalActions,
    PreferredSizeWidget? bottom,
    bool? showBottomDivider,
    bool? showBackButton,
    Color? backgroundColor,
    Color? foregroundColor,
    bool? centerTitle,
    double? elevation,
    double? toolbarHeight,
  }) {
    return VooAppBarConfig(
      appBar: appBar ?? this.appBar,
      show: show ?? this.show,
      title: title ?? this.title,
      leading: leading ?? this.leading,
      additionalActions: additionalActions ?? this.additionalActions,
      bottom: bottom ?? this.bottom,
      showBottomDivider: showBottomDivider ?? this.showBottomDivider,
      showBackButton: showBackButton ?? this.showBackButton,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      centerTitle: centerTitle ?? this.centerTitle,
      elevation: elevation ?? this.elevation,
      toolbarHeight: toolbarHeight ?? this.toolbarHeight,
    );
  }

  /// Returns true if any override is set.
  bool get hasOverrides =>
      appBar != null ||
      show != null ||
      title != null ||
      leading != null ||
      additionalActions != null ||
      bottom != null ||
      showBottomDivider != null ||
      showBackButton != null ||
      backgroundColor != null ||
      foregroundColor != null ||
      centerTitle != null ||
      elevation != null ||
      toolbarHeight != null;
}
