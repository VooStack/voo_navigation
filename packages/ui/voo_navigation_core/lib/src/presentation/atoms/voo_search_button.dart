import 'package:flutter/material.dart';

import 'package:voo_navigation_core/src/presentation/atoms/voo_search_field.dart';

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
