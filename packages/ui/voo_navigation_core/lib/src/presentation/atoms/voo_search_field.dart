import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveBgColor = _hasFocus
        ? (widget.focusedBackgroundColor ?? widget.backgroundColor ?? colorScheme.surfaceContainerHighest)
        : (widget.backgroundColor ?? colorScheme.surfaceContainerHigh);

    final effectiveBorderColor = _hasFocus
        ? (widget.focusedBorderColor ?? widget.borderColor ?? colorScheme.primary)
        : (widget.borderColor ?? colorScheme.outline.withValues(alpha: 0.3));

    final effectiveBorderRadius = widget.borderRadius ?? BorderRadius.circular(12);
    final effectiveHeight = widget.height ?? 44;

    Widget searchField = Container(
      width: widget.expanded ? double.infinity : widget.width,
      height: effectiveHeight,
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: effectiveBorderRadius,
        border: Border.all(
          color: effectiveBorderColor,
          width: _hasFocus ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Prefix / Search icon
          if (widget.prefixWidget != null)
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: widget.prefixWidget,
            )
          else if (widget.showSearchIcon)
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Icon(
                Icons.search,
                size: 20,
                color: _hasFocus
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
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
              style: widget.textStyle ?? theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: widget.hintText ?? 'Search...',
                hintStyle: widget.hintStyle ?? theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
                border: InputBorder.none,
                contentPadding: widget.contentPadding ??
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                isDense: true,
              ),
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              textInputAction: TextInputAction.search,
            ),
          ),

          // Keyboard hint
          if (widget.showKeyboardHint && !_hasFocus && !_hasText)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  _keyboardHint,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

          // Clear button / Suffix
          if (widget.suffixWidget != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: widget.suffixWidget,
            )
          else if (widget.showClearButton && _hasText)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
                onPressed: _handleClear,
                splashRadius: 16,
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

/// A compact search button that expands into a search field
class VooSearchButton extends StatefulWidget {
  /// Callback when text changes
  final ValueChanged<String>? onChanged;

  /// Callback when search is submitted
  final ValueChanged<String>? onSubmitted;

  /// Hint text
  final String? hintText;

  /// Icon for the button
  final IconData? icon;

  /// Tooltip for the button
  final String? tooltip;

  /// Width when expanded
  final double expandedWidth;

  /// Animation duration
  final Duration animationDuration;

  const VooSearchButton({
    super.key,
    this.onChanged,
    this.onSubmitted,
    this.hintText,
    this.icon,
    this.tooltip,
    this.expandedWidth = 300,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  State<VooSearchButton> createState() => _VooSearchButtonState();
}

class _VooSearchButtonState extends State<VooSearchButton> {
  bool _isExpanded = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && _controller.text.isEmpty) {
      setState(() {
        _isExpanded = false;
      });
    }
  }

  void _expand() {
    setState(() {
      _isExpanded = true;
    });
    Future.delayed(widget.animationDuration, () {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: widget.animationDuration,
      curve: Curves.easeOutCubic,
      width: _isExpanded ? widget.expandedWidth : 44,
      height: 44,
      child: _isExpanded
          ? VooSearchField(
              controller: _controller,
              focusNode: _focusNode,
              hintText: widget.hintText,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              showKeyboardHint: false,
            )
          : IconButton(
              icon: Icon(widget.icon ?? Icons.search),
              onPressed: _expand,
              tooltip: widget.tooltip ?? 'Search',
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.surfaceContainerHigh,
              ),
            ),
    );
  }
}
