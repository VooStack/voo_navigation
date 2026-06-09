import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/src/design/voo_minimal.dart';
import 'package:voo_navigation_core/src/design/voo_minimal_theme.dart';

/// A styled search input field with keyboard shortcut support
class VooSearchField extends StatefulWidget {
  /// Controller for the text field
  final TextEditingController? controller;

  /// Focus node for the text field
  final FocusNode? focusNode;

  /// Hint text to display when empty
  final String? hintText;

  /// Callback when text changes
  final ValueChanged<String>? onChanged;

  /// Callback when search is submitted (enter pressed)
  final ValueChanged<String>? onSubmitted;

  /// Callback when the field is cleared
  final VoidCallback? onClear;

  /// Callback when the field gains focus
  final VoidCallback? onFocused;

  /// Whether the search field is expanded (full width)
  final bool expanded;

  /// Width of the search field (ignored if expanded)
  final double? width;

  /// Height of the search field
  final double? height;

  /// Whether to show the keyboard shortcut hint
  final bool showKeyboardHint;

  /// Keyboard shortcut hint text (e.g., "⌘K")
  final String? keyboardHintText;

  /// Whether to enable keyboard shortcut to focus
  final bool enableKeyboardShortcut;

  /// Whether to show the clear button
  final bool showClearButton;

  /// Whether to show the search icon
  final bool showSearchIcon;

  /// Custom prefix widget (replaces search icon)
  final Widget? prefixWidget;

  /// Custom suffix widget (replaces clear button)
  final Widget? suffixWidget;

  /// Background color
  final Color? backgroundColor;

  /// Background color when focused
  final Color? focusedBackgroundColor;

  /// Border color
  final Color? borderColor;

  /// Border color when focused
  final Color? focusedBorderColor;

  /// Border radius
  final BorderRadius? borderRadius;

  /// Text style
  final TextStyle? textStyle;

  /// Hint text style
  final TextStyle? hintStyle;

  /// Padding inside the field
  final EdgeInsets? contentPadding;

  /// Whether the field is read-only
  final bool readOnly;

  /// Whether the field is enabled
  final bool enabled;

  /// Whether to autofocus
  final bool autofocus;

  const VooSearchField({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.onFocused,
    this.expanded = false,
    this.width,
    this.height,
    this.showKeyboardHint = true,
    this.keyboardHintText,
    this.enableKeyboardShortcut = true,
    this.showClearButton = true,
    this.showSearchIcon = true,
    this.prefixWidget,
    this.suffixWidget,
    this.backgroundColor,
    this.focusedBackgroundColor,
    this.borderColor,
    this.focusedBorderColor,
    this.borderRadius,
    this.textStyle,
    this.hintStyle,
    this.contentPadding,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
  });

  @override
  State<VooSearchField> createState() => _VooSearchFieldState();
}

class _VooSearchFieldState extends State<VooSearchField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _hasFocus = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _hasText = _controller.text.isNotEmpty;

    _focusNode.addListener(_onFocusChange);
    _controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _focusNode.removeListener(_onFocusChange);
    _controller.removeListener(_onTextChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
    if (_focusNode.hasFocus) {
      widget.onFocused?.call();
    }
  }

  void _onTextChange() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  void _handleClear() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
    _focusNode.requestFocus();
  }

  String get _keyboardHint {
    if (widget.keyboardHintText != null) return widget.keyboardHintText!;
    // Platform-specific hint
    final isMac = Theme.of(context).platform == TargetPlatform.macOS;
    return isMac ? '⌘K' : 'Ctrl+K';
  }

  @override
  Widget build(BuildContext context) {
    final m = context.vooMinimal;

    final effectiveBgColor = _hasFocus
        ? (widget.focusedBackgroundColor ?? widget.backgroundColor ?? m.surfaceElevated)
        : (widget.backgroundColor ?? m.surface);

    final effectiveBorderColor = _hasFocus
        ? (widget.focusedBorderColor ?? widget.borderColor ?? m.accent)
        : (widget.borderColor ?? m.border);

    final effectiveBorderRadius = widget.borderRadius ?? VooMinimal.brSm;
    final effectiveHeight = widget.height ?? VooMinimal.controlHeight;

    Widget searchField = AnimatedContainer(
      duration: VooMinimal.motionFast,
      curve: VooMinimal.motionCurve,
      width: widget.expanded ? double.infinity : widget.width,
      height: effectiveHeight,
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: effectiveBorderRadius,
        border: Border.all(
          color: effectiveBorderColor,
          width: _hasFocus ? 1.5 : VooMinimal.strokeWidth,
        ),
      ),
      child: Row(
        children: [
          // Prefix / Search icon
          if (widget.prefixWidget != null)
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: widget.prefixWidget,
            )
          else if (widget.showSearchIcon)
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(
                Icons.search,
                size: VooMinimal.iconSize,
                color: _hasFocus ? m.textPrimary : m.textTertiary,
              ),
            ),

          // Text field
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              readOnly: widget.readOnly,
              enabled: widget.enabled,
              autofocus: widget.autofocus,
              cursorWidth: 1.0,
              cursorColor: m.textPrimary,
              style: widget.textStyle ??
                  TextStyle(fontSize: VooMinimal.fontSizeMd, color: m.textPrimary),
              decoration: InputDecoration(
                hintText: widget.hintText ?? 'Search...',
                hintStyle: widget.hintStyle ??
                    TextStyle(fontSize: VooMinimal.fontSizeMd, color: m.textTertiary),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: widget.contentPadding ??
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                isDense: true,
              ),
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              textInputAction: TextInputAction.search,
            ),
          ),

          // Keyboard hint — small monospace kbd-like chip
          if (widget.showKeyboardHint && !_hasFocus && !_hasText)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: m.surfaceMuted,
                  borderRadius: VooMinimal.brXs,
                  border: Border.all(color: m.border),
                ),
                child: Text(
                  _keyboardHint,
                  style: TextStyle(
                    color: m.textTertiary,
                    fontWeight: FontWeight.w500,
                    fontSize: VooMinimal.fontSizeXs,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ),

          // Clear button / Suffix
          if (widget.suffixWidget != null)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: widget.suffixWidget,
            )
          else if (widget.showClearButton && _hasText)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  size: VooMinimal.iconSize,
                  color: m.textSecondary,
                ),
                onPressed: _handleClear,
                splashRadius: 14,
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                ),
                tooltip: 'Clear',
              ),
            ),
        ],
      ),
    );


    // Wrap with keyboard shortcut handler
    if (widget.enableKeyboardShortcut) {
      searchField = Shortcuts(
        shortcuts: {
          LogicalKeySet(
            LogicalKeyboardKey.meta,
            LogicalKeyboardKey.keyK,
          ): const _FocusSearchIntent(),
          LogicalKeySet(
            LogicalKeyboardKey.control,
            LogicalKeyboardKey.keyK,
          ): const _FocusSearchIntent(),
        },
        child: Actions(
          actions: {
            _FocusSearchIntent: CallbackAction<_FocusSearchIntent>(
              onInvoke: (_) {
                _focusNode.requestFocus();
                return null;
              },
            ),
          },
          child: searchField,
        ),
      );
    }

    return searchField;
  }
}

class _FocusSearchIntent extends Intent {
  const _FocusSearchIntent();
}
