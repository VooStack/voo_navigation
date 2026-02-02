import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/app_bar_config.dart';

/// Configuration for page-level scaffold overrides.
///
/// Use this to customize scaffold elements on a per-page basis when
/// using [VooAdaptiveScaffold]. Wrap your page content with [VooPage]
/// and provide a [VooPageConfig] to override default scaffold behavior.
///
/// Example:
/// ```dart
/// VooPage(
///   config: VooPageConfig(
///     appBarConfig: VooAppBarConfig(
///       title: Text('My Page'),
///       centerTitle: true,
///       bottom: TabBar(tabs: [...]),
///     ),
///     floatingActionButton: FloatingActionButton(
///       onPressed: () {},
///       child: Icon(Icons.add),
///     ),
///   ),
///   child: MyPageContent(),
/// )
/// ```
class VooPageConfig {
  /// App bar configuration for this page.
  ///
  /// Use this to customize the app bar's title, actions, bottom widget,
  /// background color, and other properties.
  final VooAppBarConfig? appBarConfig;

  /// Custom floating action button for this page.
  ///
  /// When provided, replaces the FAB from [VooNavigationConfig].
  final Widget? floatingActionButton;

  /// Location of the floating action button.
  ///
  /// When provided, overrides the FAB location from config.
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Floating action button animator.
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  /// Whether to show the floating action button.
  ///
  /// When null, uses the scaffold's default setting.
  final bool? showFloatingActionButton;

  /// Custom bottom sheet for this page.
  final Widget? bottomSheet;

  /// Persistent footer buttons for this page.
  final List<Widget>? persistentFooterButtons;

  /// Background color override for this page's scaffold.
  final Color? backgroundColor;

  /// Whether to resize to avoid bottom inset for this page.
  final bool? resizeToAvoidBottomInset;

  /// Whether to extend body behind bottom navigation/app bar.
  final bool? extendBody;

  /// Whether to extend body behind app bar.
  final bool? extendBodyBehindAppBar;

  /// Custom end drawer for this page.
  final Widget? endDrawer;

  /// Whether to wrap the page content in a basic Scaffold.
  ///
  /// This provides a simpler alternative to [useCustomScaffold] + [scaffoldBuilder]
  /// when you just need a basic Scaffold wrapper without custom configuration.
  /// When true, the child is wrapped in `Scaffold(body: child)`.
  final bool wrapInScaffold;

  /// Whether this page uses a completely custom scaffold.
  ///
  /// When true, the [VooPage.child] is rendered directly without
  /// any scaffold wrapping. Use this for pages that need full
  /// control over their layout.
  final bool useCustomScaffold;

  /// Custom scaffold builder for complete control.
  ///
  /// When provided and [useCustomScaffold] is true, this builder
  /// is called to create the page scaffold.
  final Widget Function(BuildContext context, Widget child)? scaffoldBuilder;

  /// Padding to apply to the body content for this page.
  final EdgeInsetsGeometry? bodyPadding;

  /// Whether to wrap body in a card (desktop/tablet only).
  final bool? useBodyCard;

  /// Body card elevation.
  final double? bodyCardElevation;

  /// Body card border radius.
  final BorderRadius? bodyCardBorderRadius;

  /// Body card color.
  final Color? bodyCardColor;

  const VooPageConfig({
    this.appBarConfig,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.showFloatingActionButton,
    this.bottomSheet,
    this.persistentFooterButtons,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.extendBody,
    this.extendBodyBehindAppBar,
    this.endDrawer,
    this.wrapInScaffold = false,
    this.useCustomScaffold = false,
    this.scaffoldBuilder,
    this.bodyPadding,
    this.useBodyCard,
    this.bodyCardElevation,
    this.bodyCardBorderRadius,
    this.bodyCardColor,
  });

  /// Creates a config that hides all scaffold elements for a clean page.
  const VooPageConfig.clean()
    : appBarConfig = const VooAppBarConfig.hidden(),
      floatingActionButton = null,
      floatingActionButtonLocation = null,
      floatingActionButtonAnimator = null,
      showFloatingActionButton = false,
      bottomSheet = null,
      persistentFooterButtons = null,
      backgroundColor = null,
      resizeToAvoidBottomInset = null,
      extendBody = true,
      extendBodyBehindAppBar = true,
      endDrawer = null,
      wrapInScaffold = false,
      useCustomScaffold = false,
      scaffoldBuilder = null,
      bodyPadding = null,
      useBodyCard = false,
      bodyCardElevation = null,
      bodyCardBorderRadius = null,
      bodyCardColor = null;

  /// Creates a config for a full-screen page (no app bar, extended body).
  const VooPageConfig.fullscreen()
    : appBarConfig = const VooAppBarConfig.hidden(),
      floatingActionButton = null,
      floatingActionButtonLocation = null,
      floatingActionButtonAnimator = null,
      showFloatingActionButton = null,
      bottomSheet = null,
      persistentFooterButtons = null,
      backgroundColor = null,
      resizeToAvoidBottomInset = null,
      extendBody = true,
      extendBodyBehindAppBar = true,
      endDrawer = null,
      wrapInScaffold = false,
      useCustomScaffold = false,
      scaffoldBuilder = null,
      bodyPadding = null,
      useBodyCard = null,
      bodyCardElevation = null,
      bodyCardBorderRadius = null,
      bodyCardColor = null;

  /// Creates a copy of this configuration with the given fields replaced.
  VooPageConfig copyWith({
    VooAppBarConfig? appBarConfig,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    FloatingActionButtonAnimator? floatingActionButtonAnimator,
    bool? showFloatingActionButton,
    Widget? bottomSheet,
    List<Widget>? persistentFooterButtons,
    Color? backgroundColor,
    bool? resizeToAvoidBottomInset,
    bool? extendBody,
    bool? extendBodyBehindAppBar,
    Widget? endDrawer,
    bool? wrapInScaffold,
    bool? useCustomScaffold,
    Widget Function(BuildContext context, Widget child)? scaffoldBuilder,
    EdgeInsetsGeometry? bodyPadding,
    bool? useBodyCard,
    double? bodyCardElevation,
    BorderRadius? bodyCardBorderRadius,
    Color? bodyCardColor,
  }) {
    return VooPageConfig(
      appBarConfig: appBarConfig ?? this.appBarConfig,
      floatingActionButton: floatingActionButton ?? this.floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation ?? this.floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator ?? this.floatingActionButtonAnimator,
      showFloatingActionButton: showFloatingActionButton ?? this.showFloatingActionButton,
      bottomSheet: bottomSheet ?? this.bottomSheet,
      persistentFooterButtons: persistentFooterButtons ?? this.persistentFooterButtons,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset ?? this.resizeToAvoidBottomInset,
      extendBody: extendBody ?? this.extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar ?? this.extendBodyBehindAppBar,
      endDrawer: endDrawer ?? this.endDrawer,
      wrapInScaffold: wrapInScaffold ?? this.wrapInScaffold,
      useCustomScaffold: useCustomScaffold ?? this.useCustomScaffold,
      scaffoldBuilder: scaffoldBuilder ?? this.scaffoldBuilder,
      bodyPadding: bodyPadding ?? this.bodyPadding,
      useBodyCard: useBodyCard ?? this.useBodyCard,
      bodyCardElevation: bodyCardElevation ?? this.bodyCardElevation,
      bodyCardBorderRadius: bodyCardBorderRadius ?? this.bodyCardBorderRadius,
      bodyCardColor: bodyCardColor ?? this.bodyCardColor,
    );
  }

  // ===== Convenience getters for app bar properties =====
  // These provide easy access to app bar config values

  /// Whether to show the app bar.
  bool? get showAppBar => appBarConfig?.show;

  /// Custom app bar widget.
  PreferredSizeWidget? get appBar => appBarConfig?.appBar;

  /// Custom title widget for the app bar.
  Widget? get appBarTitle => appBarConfig?.title;

  /// Custom leading widget for the app bar.
  Widget? get appBarLeading => appBarConfig?.leading;

  /// Additional actions to add to the app bar.
  List<Widget>? get additionalAppBarActions => appBarConfig?.additionalActions;

  /// Widget to display at the bottom of the app bar (e.g., TabBar).
  PreferredSizeWidget? get appBarBottom => appBarConfig?.bottom;

  /// Whether to show a divider/border at the bottom of the app bar.
  bool? get showAppBarBottomDivider => appBarConfig?.showBottomDivider;

  /// Whether to show the back button in the app bar.
  bool? get shouldShowBackButton => appBarConfig?.showBackButton;

  /// Background color for the app bar.
  Color? get appBarBackgroundColor => appBarConfig?.backgroundColor;

  /// Foreground color for the app bar.
  Color? get appBarForegroundColor => appBarConfig?.foregroundColor;

  /// Whether to center the app bar title.
  bool? get centerAppBarTitle => appBarConfig?.centerTitle;

  /// App bar elevation.
  double? get appBarElevation => appBarConfig?.elevation;

  /// App bar toolbar height.
  double? get appBarToolbarHeight => appBarConfig?.toolbarHeight;

  /// Returns true if any override is set.
  bool get hasOverrides =>
      (appBarConfig?.hasOverrides ?? false) ||
      floatingActionButton != null ||
      floatingActionButtonLocation != null ||
      floatingActionButtonAnimator != null ||
      showFloatingActionButton != null ||
      bottomSheet != null ||
      persistentFooterButtons != null ||
      backgroundColor != null ||
      resizeToAvoidBottomInset != null ||
      extendBody != null ||
      extendBodyBehindAppBar != null ||
      endDrawer != null ||
      wrapInScaffold ||
      useCustomScaffold ||
      scaffoldBuilder != null ||
      bodyPadding != null ||
      useBodyCard != null ||
      bodyCardElevation != null ||
      bodyCardBorderRadius != null ||
      bodyCardColor != null;
}
