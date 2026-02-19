// library dynamic_ui_renderer;

// Export key classes for users who need direct access
export 'src/models/ui_component.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'src/models/ui_component.dart';
import 'src/core/widget_factory.dart';

/// The main entry point for the dynamic_ui_renderer package
///
/// This class provides simple methods to convert JSON into Flutter widgets
class DynamicUIRenderer {
  /// Renders a widget tree from a JSON string
  ///
  /// Example:
  /// ```dart
  /// Widget myWidget = DynamicUIRenderer.fromJsonString('''
  ///   {
  ///     "type": "text",
  ///     "properties": {"text": "Hello World"}
  ///   }
  /// ''');
  /// ```
  static Widget fromJsonString(String jsonString) {
    try {
      final Map<String, dynamic> json = Map<String, dynamic>.from(
        jsonDecode(jsonString) as Map,
      );
      final component = UIComponent.fromJson(json);
      return WidgetFactory.build(component);
    } catch (e) {
      return _buildErrorWidget('Error parsing JSON: $e');
    }
  }

  /// Renders a widget tree from a JSON map
  ///
  /// Example:
  /// ```dart
  /// Widget myWidget = DynamicUIRenderer.fromJsonMap({
  ///   "type": "text",
  ///   "properties": {"text": "Hello World"}
  /// });
  /// ```
  static Widget fromJsonMap(Map<String, dynamic> json) {
    try {
      final component = UIComponent.fromJson(json);
      return WidgetFactory.build(component);
    } catch (e) {
      return _buildErrorWidget('Error building UI: $e');
    }
  }

  /// Creates a simple error widget for display
  static Widget _buildErrorWidget(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.red.shade50,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 48),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
