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

// Network (NEW)
export 'src/network/network_loader.dart';
export 'src/models/network_models.dart';
export 'src/network/network_exceptions.dart';
export 'src/widgets/default_loading.dart';
export 'src/widgets/default_error.dart';

import 'dart:convert';
import 'package:dynamic_ui_renderer/src/models/network_models.dart';
import 'package:flutter/material.dart';
import 'src/models/ui_component.dart';
import 'src/core/widget_factory.dart';
import 'src/network/network_loader.dart';

typedef FormSubmitCallback =
    void Function(String formId, Map<String, dynamic> formData);

/// The main entry point for the dynamic_ui_renderer package
///
/// This class provides simple methods to convert JSON into Flutter widgets
class DynamicUIRenderer {
  /// ==================== EXISTING METHODS ====================

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

  /// ==================== NEW NETWORK METHODS ====================

  /// Load UI from a network URL (Simple version)
  ///
  /// Example:
  /// ```dart
  /// // Simple GET request
  /// DynamicUIRenderer.fromNetwork(
  ///   'https://api.example.com/ui/login',
  ///   context,
  /// );
  ///
  /// // POST request with body
  /// DynamicUIRenderer.fromNetwork(
  ///   'https://api.example.com/ui/generate',
  ///   context,
  ///   method: HttpMethod.post,
  ///   body: {'userId': '123', 'theme': 'dark'},
  ///   headers: {'Authorization': 'Bearer token'},
  ///   loadingWidget: MyCustomLoader(),
  ///   errorWidget: (error) => MyErrorScreen(error),
  /// );
  /// ```
  static Widget fromNetwork(
    String url,
    BuildContext context, {
    HttpMethod method = HttpMethod.get,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
    Duration? timeout,
    int maxRetries = 3,
    Widget? loadingWidget,
    Widget Function(String error)? errorWidget,
  }) {
    final request = NetworkRequest(
      url: url,
      method: method,
      headers: headers,
      body: body,
      queryParams: queryParams,
      timeout: timeout,
      maxRetries: maxRetries,
    );

    return fromNetworkWithRequest(
      request,
      context,
      loadingWidget: loadingWidget,
      errorWidget: errorWidget,
    );
  }

  /// Load UI from a network URL with full request configuration
  ///
  /// Example:
  /// ```dart
  /// final request = NetworkRequest(
  ///   url: 'https://api.example.com/ui/dashboard',
  ///   method: HttpMethod.get,
  ///   headers: {'Authorization': 'Bearer token'},
  ///   timeout: Duration(seconds: 15),
  ///   maxRetries: 5,
  /// );
  ///
  /// DynamicUIRenderer.fromNetworkWithRequest(
  ///   request,
  ///   context,
  ///   loadingWidget: CircularProgressIndicator(),
  /// );
  /// ```
  static Widget fromNetworkWithRequest(
    NetworkRequest request,
    BuildContext context, {
    Widget? loadingWidget,
    Widget Function(String error)? errorWidget,
  }) {
    return NetworkLoader(
      request: request,
      loadingWidget: loadingWidget,
      errorWidget: errorWidget,
    );
  }

  /// Load UI from a network URL with automatic retry and caching (Coming soon)
  ///
  /// This is a placeholder for future caching functionality
  static Widget fromNetworkWithCache(
    String url,
    BuildContext context, {
    Duration cacheDuration = const Duration(hours: 1),
    HttpMethod method = HttpMethod.get,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
    Widget? loadingWidget,
    Widget Function(String error)? errorWidget,
  }) {
    // TODO: Implement caching in v0.4.0
    return fromNetwork(
      url,
      context,
      method: method,
      headers: headers,
      body: body,
      queryParams: queryParams,
      loadingWidget: loadingWidget,
      errorWidget: errorWidget,
    );
  }

  /// ==================== HELPER METHODS ====================

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

  /// ==================== FORM CALLBACK METHODS ====================

  static final Map<String, FormSubmitCallback> _formCallbacks = {};

  /// Register a callback for a specific form ID
  ///
  /// Example:
  /// ```dart
  /// DynamicUIRenderer.registerFormCallback('login_form', (formId, formData) {
  ///   print('Login form submitted: $formData');
  ///   // Send to your backend
  /// });
  /// ```
  static void registerFormCallback(String formId, FormSubmitCallback callback) {
    _formCallbacks[formId] = callback;
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
