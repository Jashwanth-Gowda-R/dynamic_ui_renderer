import 'package:flutter/material.dart';

/// Represents a UI component parsed from JSON
/// This is the core data structure that represents any UI element
class UIComponent {
  final String type; // e.g., 'text', 'button', 'container'
  final Map<String, dynamic> properties; // Styling, text, etc.
  final List<UIComponent> children; // Nested components
  final Map<String, dynamic> actions; // What happens on interaction

  // Add this for context storage
  static BuildContext? _globalContext;

  UIComponent({
    required this.type,
    this.properties = const {},
    this.children = const [],
    this.actions = const {},
  });

  /// Creates a UIComponent from JSON
  /// This is where JSON becomes a Dart object
  factory UIComponent.fromJson(Map<String, dynamic> json) {
    return UIComponent(
      type: json['type'] as String,
      properties: json['properties'] as Map<String, dynamic>? ?? {},
      children:
          (json['children'] as List?)
              ?.map((c) => UIComponent.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [],
      actions: json['actions'] as Map<String, dynamic>? ?? {},
    );
  }

  /// Sets the build context for this component tree
  void setContext(BuildContext context) {
    _globalContext = context;
    for (var child in children) {
      child.setContext(context);
    }
  }

  /// Gets the build context
  BuildContext? get buildContext => _globalContext;

  /// Converts component back to JSON (useful for debugging)
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'properties': properties,
      'children': children.map((c) => c.toJson()).toList(),
      'actions': actions,
    };
  }
}
