import 'package:dynamic_ui_renderer/src/actions/action_models.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Handles all button actions
class ActionHandler {
  static void handleAction(
    BuildContext context,
    Map<String, dynamic> actionData,
  ) {
    if (actionData.isEmpty) {
      debugPrint('No action data provided');
      return;
    }

    try {
      final action = ButtonAction.fromJson(actionData);

      switch (action.type) {
        case ActionType.navigate:
          _handleNavigate(context, action.parameters);
          break;

        case ActionType.showDialog:
          _handleShowDialog(context, action.parameters);
          break;

        case ActionType.showBottomSheet:
          _handleShowBottomSheet(context, action.parameters);
          break;

        case ActionType.showSnackbar:
          _handleShowSnackbar(context, action.parameters);
          break;

        case ActionType.launchUrl:
          _handleLaunchUrl(context, action.parameters);
          break;

        case ActionType.print:
          _handlePrint(action.parameters);
          break;

        case ActionType.custom:
          _handleCustom(action.parameters);
          break;
      }
    } catch (e) {
      debugPrint('Error handling action: $e');

      // Show error in debug mode
      if (actionData['showError'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Action error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  static void _handleNavigate(
    BuildContext context,
    Map<String, dynamic> params,
  ) {
    final route = params['route'] as String?;
    final type = params['type'] as String? ?? 'push';
    final arguments = params['arguments'];

    if (route == null) {
      debugPrint('Navigation failed: No route provided');
      return;
    }

    switch (type) {
      case 'push':
        Navigator.of(context).pushNamed(route, arguments: arguments);
        break;

      case 'pushReplacement':
        Navigator.of(context).pushReplacementNamed(route, arguments: arguments);
        break;

      case 'pushAndRemoveUntil':
        Navigator.of(context).pushNamedAndRemoveUntil(
          route,
          (route) => false,
          arguments: arguments,
        );
        break;

      case 'pop':
        Navigator.of(context).pop(arguments);
        break;

      default:
        Navigator.of(context).pushNamed(route, arguments: arguments);
    }

    debugPrint('Navigated to: $route');
  }

  static void _handleShowDialog(
    BuildContext context,
    Map<String, dynamic> params,
  ) {
    // Check if form data is included
    if (params.containsKey('formData')) {
      debugPrint('Form Data Received:');
      final formData = params['formData'] as Map<String, dynamic>;
      formData.forEach((key, value) {
        debugPrint('   • $key: $value');
      });
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(params['title'] ?? 'Message'),
        content: Text(params['message'] ?? ''),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(params['buttonText'] ?? 'OK'),
          ),
        ],
      ),
    );
  }

  static void _handleShowBottomSheet(
    BuildContext context,
    Map<String, dynamic> params,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              params['title'] ?? '',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(params['message'] ?? ''),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(params['buttonText'] ?? 'Close'),
            ),
          ],
        ),
      ),
    );
  }

  static void _handleShowSnackbar(
    BuildContext context,
    Map<String, dynamic> params,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(params['message'] ?? ''),
        duration: Duration(seconds: params['duration'] ?? 2),
        action: params['actionLabel'] != null
            ? SnackBarAction(
                label: params['actionLabel']!,
                onPressed: () {
                  // Handle snackbar action
                  if (params['actionData'] != null) {
                    handleAction(
                      context,
                      params['actionData'] as Map<String, dynamic>,
                    );
                  }
                },
              )
            : null,
      ),
    );
  }

  static Future<void> _handleLaunchUrl(
    BuildContext context,
    Map<String, dynamic> params,
  ) async {
    final url = params['url'] as String?;
    final mode = params['mode'] as String? ?? 'inApp';

    if (url == null) {
      debugPrint('URL launch failed: No URL provided');
      return;
    }

    try {
      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        if (mode == 'external') {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          await launchUrl(uri);
        }
        debugPrint('Launched URL: $url');
      } else {
        _showUrlLaunchError(context, url);
      }
    } catch (e) {
      debugPrint('Failed to launch URL: $e');
      _showUrlLaunchError(context, url);
    }
  }

  static void _showUrlLaunchError(BuildContext context, String url) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Could not launch URL: $url'),
        backgroundColor: Colors.red,
      ),
    );
  }

  static void _handlePrint(Map<String, dynamic> params) {
    final message = params['message'] ?? 'Button pressed';
    final level = params['level'] ?? 'info';

    // If form data is included, print it nicely
    if (params.containsKey('formData')) {
      // debugPrint('\n📋 ===== FORM SUBMISSION =====');
      // final formData = params['formData'] as Map<String, dynamic>;
      // formData.forEach((key, value) {
      //   debugPrint('   • $key: $value');
      // });
      // debugPrint('📋 ===========================\n');
    } else {
      switch (level) {
        case 'info':
          debugPrint('ℹ️ $message');
          break;
        case 'warning':
          debugPrint('⚠️ $message');
          break;
        case 'error':
          debugPrint('❌ $message');
          break;
        default:
          debugPrint('📢 $message');
      }
    }
  }

  static void _handleCustom(Map<String, dynamic> params) {
    // debugPrint('🔧 Custom action: $params');
  }
}
