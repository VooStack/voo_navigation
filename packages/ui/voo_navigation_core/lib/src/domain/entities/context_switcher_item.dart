import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Represents a context item for the context switcher component.
///
/// A context can represent a project, workspace, environment, team, or any
/// other scoped entity that changes the navigation items below it.
///
/// Example usage:
/// ```dart
/// VooContextItem(
///   id: 'proj-1',
///   name: 'Marketing Website',
///   icon: Icons.web,
///   color: Colors.blue,
///   subtitle: '12 tasks',
/// )
/// ```
class VooContextItem extends Equatable {
  /// Unique identifier for the context
  final String id;

  /// Display name of the context
  final String name;

  /// Icon to display for this context
  final IconData? icon;

  /// Color associated with this context (used for avatar background)
  final Color? color;

  /// Optional subtitle (e.g., "12 tasks", "Production", "Team Alpha")
  final String? subtitle;

  /// URL for the context's avatar/logo image
  final String? avatarUrl;

  /// Custom widget for the avatar (takes precedence over avatarUrl and icon)
  final Widget? avatarWidget;

  /// Whether this context is currently selected
  final bool isSelected;

  /// Additional metadata for custom use
  final Map<String, dynamic>? metadata;

  const VooContextItem({
    required this.id,
    required this.name,
    this.icon,
    this.color,
    this.subtitle,
    this.avatarUrl,
    this.avatarWidget,
    this.isSelected = false,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        icon,
        color,
        subtitle,
        avatarUrl,
        isSelected,
      ];

  /// Creates a copy of this context with the given fields replaced
  VooContextItem copyWith({
    String? id,
    String? name,
    IconData? icon,
    Color? color,
    String? subtitle,
    String? avatarUrl,
    Widget? avatarWidget,
    bool? isSelected,
    Map<String, dynamic>? metadata,
  }) =>
      VooContextItem(
        id: id ?? this.id,
        name: name ?? this.name,
        icon: icon ?? this.icon,
        color: color ?? this.color,
        subtitle: subtitle ?? this.subtitle,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        avatarWidget: avatarWidget ?? this.avatarWidget,
        isSelected: isSelected ?? this.isSelected,
        metadata: metadata ?? this.metadata,
      );

  /// Gets the initials from the context name (for avatar fallback)
  String get initials {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '';
    if (words.length == 1) {
      return words.first
          .substring(0, words.first.length.clamp(0, 2))
          .toUpperCase();
    }
    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }
}
