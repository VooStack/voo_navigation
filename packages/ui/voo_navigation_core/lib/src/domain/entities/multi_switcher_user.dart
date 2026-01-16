import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/voo_user_status.dart';

/// Represents a user account for the multi-switcher component.
///
/// This entity follows the same pattern as [VooOrganization] and allows
/// switching between multiple user accounts within the multi-switcher modal.
class VooMultiSwitcherUser extends Equatable {
  /// Unique identifier for the user
  final String id;

  /// Display name of the user
  final String name;

  /// Email address of the user
  final String? email;

  /// URL for the user's avatar image
  final String? avatarUrl;

  /// Custom widget for the avatar (takes precedence over avatarUrl)
  final Widget? avatarWidget;

  /// Fallback color for initials when no avatar is provided
  final Color? avatarColor;

  /// Current online status of the user
  final VooUserStatus? status;

  /// Whether this user is currently selected/active
  final bool isSelected;

  /// Additional metadata for custom use
  final Map<String, dynamic>? metadata;

  const VooMultiSwitcherUser({
    required this.id,
    required this.name,
    this.email,
    this.avatarUrl,
    this.avatarWidget,
    this.avatarColor,
    this.status,
    this.isSelected = false,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        avatarUrl,
        avatarColor,
        status,
        isSelected,
      ];

  /// Creates a copy of this user with the given fields replaced
  VooMultiSwitcherUser copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    Widget? avatarWidget,
    Color? avatarColor,
    VooUserStatus? status,
    bool? isSelected,
    Map<String, dynamic>? metadata,
  }) =>
      VooMultiSwitcherUser(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        avatarWidget: avatarWidget ?? this.avatarWidget,
        avatarColor: avatarColor ?? this.avatarColor,
        status: status ?? this.status,
        isSelected: isSelected ?? this.isSelected,
        metadata: metadata ?? this.metadata,
      );

  /// Gets the initials from the user name
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
