import 'package:dynamic_ui_renderer/dynamic_ui_renderer.dart';
import 'package:dynamic_ui_renderer/src/models/network_models.dart';
import 'package:dynamic_ui_renderer/src/network/http_client.dart';
import 'package:dynamic_ui_renderer/src/network/network_exceptions.dart';
import 'package:dynamic_ui_renderer/src/widgets/default_error.dart';
import 'package:dynamic_ui_renderer/src/widgets/default_loading.dart';
import 'package:flutter/material.dart';

/// Widget that loads UI from a network URL
class NetworkLoader extends StatefulWidget {
  final NetworkRequest request;
  final Widget? loadingWidget;
  final Widget Function(String error)? errorWidget;
  final Duration? timeout;

  const NetworkLoader({
    super.key,
    required this.request,
    this.loadingWidget,
    this.errorWidget,
    this.timeout,
  });

  @override
  State<NetworkLoader> createState() => _NetworkLoaderState();
}

class _NetworkLoaderState extends State<NetworkLoader> {
  final HttpClient _client = HttpClient();
  late Future<NetworkResponse> _future;

  @override
  void initState() {
    super.initState();

    // Apply timeout if provided
    final request = widget.timeout != null
        ? widget.request.copyWith(timeout: widget.timeout)
        : widget.request;

    _future = _client.executeWithRetry(request);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NetworkResponse>(
      future: _future,
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return widget.loadingWidget ?? const DefaultLoadingWidget();
        }

        // Error state
        if (snapshot.hasError) {
          final error = _getErrorMessage(snapshot.error);

          // Use custom error widget if provided
          if (widget.errorWidget != null) {
            return widget.errorWidget!(error);
          }

          return DefaultErrorWidget(error: error, onRetry: _retry);
        }

        // Success state with data
        if (snapshot.hasData && snapshot.data!.hasData) {
          try {
            return DynamicUIRenderer.fromJsonMap(
              snapshot.data!.data!,
              context,
              formId: widget
                  .request
                  .url, // Use URL as form ID for network-loaded forms
            );
          } catch (e) {
            return DefaultErrorWidget(
              error: 'Error rendering UI: $e',
              onRetry: _retry,
            );
          }
        }

        // Fallback error
        return DefaultErrorWidget(error: 'No data received', onRetry: _retry);
      },
    );
  }

  String _getErrorMessage(dynamic error) {
    if (error is NetworkException) {
      return error.message;
    }
    return error.toString();
  }

  void _retry() {
    setState(() {
      _future = _client.executeWithRetry(widget.request);
    });
  }

  @override
  void dispose() {
    _client.dispose();
    super.dispose();
  }
}
