import 'package:flutter/material.dart';

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
///     appBar: MyCustomAppBar(),
///     floatingActionButton: FloatingActionButton(
///       onPressed: () {},
///       child: Icon(Icons.add),
///     ),
///     floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
///   ),
///   child: MyPageContent(),
/// )
/// ```
class VooPageConfig {
  /// Custom app bar to override the scaffold's app bar.
  ///
  /// When provided, this replaces the app bar from [VooNavigationConfig].
  final PreferredSizeWidget? appBar;

  /// Whether to show the app bar.
  ///
  /// When null, uses the scaffold's default setting.
  /// Set to false to hide the app bar for this page only.
  final bool? showAppBar;

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

  /// Background color override for this page.
  final Color? backgroundColor;

  /// Whether to resize to avoid bottom inset for this page.
  final bool? resizeToAvoidBottomInset;

  /// Whether to extend body behind bottom navigation/app bar.
  final bool? extendBody;

  /// Whether to extend body behind app bar.
  final bool? extendBodyBehindAppBar;

  /// Custom end drawer for this page.
  final Widget? endDrawer;

  /// Additional actions to add to the app bar for this page.
  ///
  /// These are appended to the actions from [VooNavigationConfig].
  final List<Widget>? additionalAppBarActions;

  /// Custom leading widget for the app bar.
  final Widget? appBarLeading;

  /// Custom title widget for the app bar.
  final Widget? appBarTitle;

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
    this.appBar,
    this.showAppBar,
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
    this.additionalAppBarActions,
    this.appBarLeading,
    this.appBarTitle,
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
      : appBar = null,
        showAppBar = false,
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
        additionalAppBarActions = null,
        appBarLeading = null,
        appBarTitle = null,
        useCustomScaffold = false,
        scaffoldBuilder = null,
        bodyPadding = null,
        useBodyCard = false,
        bodyCardElevation = null,
        bodyCardBorderRadius = null,
        bodyCardColor = null;

  /// Creates a config for a full-screen page (no app bar, extended body).
  const VooPageConfig.fullscreen()
      : appBar = null,
        showAppBar = false,
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
        additionalAppBarActions = null,
        appBarLeading = null,
        appBarTitle = null,
        useCustomScaffold = false,
        scaffoldBuilder = null,
        bodyPadding = null,
        useBodyCard = null,
        bodyCardElevation = null,
        bodyCardBorderRadius = null,
        bodyCardColor = null;

  /// Creates a copy of this configuration with the given fields replaced.
  VooPageConfig copyWith({
    PreferredSizeWidget? appBar,
    bool? showAppBar,
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
    List<Widget>? additionalAppBarActions,
    Widget? appBarLeading,
    Widget? appBarTitle,
    bool? useCustomScaffold,
    Widget Function(BuildContext context, Widget child)? scaffoldBuilder,
    EdgeInsetsGeometry? bodyPadding,
    bool? useBodyCard,
    double? bodyCardElevation,
    BorderRadius? bodyCardBorderRadius,
    Color? bodyCardColor,
  }) {
    return VooPageConfig(
      appBar: appBar ?? this.appBar,
      showAppBar: showAppBar ?? this.showAppBar,
      floatingActionButton: floatingActionButton ?? this.floatingActionButton,
      floatingActionButtonLocation:
          floatingActionButtonLocation ?? this.floatingActionButtonLocation,
      floatingActionButtonAnimator:
          floatingActionButtonAnimator ?? this.floatingActionButtonAnimator,
      showFloatingActionButton:
          showFloatingActionButton ?? this.showFloatingActionButton,
      bottomSheet: bottomSheet ?? this.bottomSheet,
      persistentFooterButtons:
          persistentFooterButtons ?? this.persistentFooterButtons,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      resizeToAvoidBottomInset:
          resizeToAvoidBottomInset ?? this.resizeToAvoidBottomInset,
      extendBody: extendBody ?? this.extendBody,
      extendBodyBehindAppBar:
          extendBodyBehindAppBar ?? this.extendBodyBehindAppBar,
      endDrawer: endDrawer ?? this.endDrawer,
      additionalAppBarActions:
          additionalAppBarActions ?? this.additionalAppBarActions,
      appBarLeading: appBarLeading ?? this.appBarLeading,
      appBarTitle: appBarTitle ?? this.appBarTitle,
      useCustomScaffold: useCustomScaffold ?? this.useCustomScaffold,
      scaffoldBuilder: scaffoldBuilder ?? this.scaffoldBuilder,
      bodyPadding: bodyPadding ?? this.bodyPadding,
      useBodyCard: useBodyCard ?? this.useBodyCard,
      bodyCardElevation: bodyCardElevation ?? this.bodyCardElevation,
      bodyCardBorderRadius: bodyCardBorderRadius ?? this.bodyCardBorderRadius,
      bodyCardColor: bodyCardColor ?? this.bodyCardColor,
    );
  }

  /// Returns true if any override is set.
  bool get hasOverrides =>
      appBar != null ||
      showAppBar != null ||
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
      additionalAppBarActions != null ||
      appBarLeading != null ||
      appBarTitle != null ||
      useCustomScaffold ||
      scaffoldBuilder != null ||
      bodyPadding != null ||
      useBodyCard != null ||
      bodyCardElevation != null ||
      bodyCardBorderRadius != null ||
      bodyCardColor != null;
}
