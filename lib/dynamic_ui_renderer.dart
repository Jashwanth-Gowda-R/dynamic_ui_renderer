// library dynamic_ui_renderer;

// Export key classes for users who need direct access
export 'src/actions/action_handler.dart';
export 'src/actions/action_models.dart';
export 'src/models/ui_component.dart';

// Core
export 'src/models/form_models.dart';
export 'src/core/utils.dart';
export 'src/core/form_controller.dart';

// Widgets
export 'src/widgets/dynamic_form.dart';
export 'src/widgets/form_fields/text_field.dart';
export 'src/widgets/form_fields/email_field.dart';
export 'src/widgets/form_fields/password_field.dart';
export 'src/widgets/form_fields/number_field.dart';
export 'src/widgets/form_fields/dropdown_field.dart';
export 'src/widgets/form_fields/checkbox_field.dart';
export 'src/widgets/form_fields/date_field.dart';
export 'src/widgets/form_fields/phone_field.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'src/models/ui_component.dart';
import 'src/core/widget_factory.dart';

typedef FormSubmitCallback =
    void Function(String formId, Map<String, dynamic> formData);

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
  static Widget fromJsonString(
    String jsonString,
    BuildContext context, {
    String? formId,
  }) {
    try {
      final Map<String, dynamic> json = Map<String, dynamic>.from(
        jsonDecode(jsonString) as Map,
      );

      // Add formId to properties if provided
      if (formId != null) {
        if (!json.containsKey('properties')) {
          json['properties'] = {};
        }
        (json['properties'] as Map)['formId'] = formId;
      }

      final component = UIComponent.fromJson(json);

      // Store context for actions that need navigation
      component.setContext(context);

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
  static Widget fromJsonMap(
    Map<String, dynamic> json,
    BuildContext context, {
    String? formId,
  }) {
    // Add formId to properties if provided
    if (formId != null) {
      if (!json.containsKey('properties')) {
        json['properties'] = {};
      }
      (json['properties'] as Map)['formId'] = formId;
    }
    try {
      final component = UIComponent.fromJson(json);

      // Store context for actions that need navigation
      component.setContext(context);

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

  static final Map<String, FormSubmitCallback> _formCallbacks = {};
  static String? _defaultFormId;

  /// Register a callback for a specific form ID
  static void registerFormCallback(String formId, FormSubmitCallback callback) {
    _formCallbacks[formId] = callback;
  }

  /// Set default form ID for forms without explicit ID
  static void setDefaultFormId(String formId) {
    _defaultFormId = formId;
  }

  /// Get callback for a form ID
  static FormSubmitCallback? getFormCallback(String? formId) {
    if (formId == null) return null;
    return _formCallbacks[formId];
  }

  /// Clear all registered callbacks
  static void clearCallbacks() {
    _formCallbacks.clear();
  }
}
