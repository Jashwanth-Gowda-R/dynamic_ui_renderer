/// HTTP methods supported for network requests
enum HttpMethod {
  get,      // Fetch data
  post,     // Send data to create something
  put,      // Send data to update something
  patch,    // Send partial data to update
  delete,   // Remove something
}

/// Configuration for a network request
class NetworkRequest {
  final String url;
  final HttpMethod method;
  final Map<String, String>? headers;
  final Map<String, dynamic>? body;
  final Map<String, dynamic>? queryParams;
  final Duration? timeout;
  final int maxRetries;

  const NetworkRequest({
    required this.url,
    this.method = HttpMethod.get,
    this.headers,
    this.body,
    this.queryParams,
    this.timeout,
    this.maxRetries = 3,
  });

  /// Convert to actual URI with query parameters
  Uri get uri {
    final uri = Uri.parse(url);
    if (queryParams == null) return uri;
    
    return uri.replace(
      queryParameters: {
        ...uri.queryParameters,
        ...queryParams!.map((key, value) => MapEntry(key, value.toString())),
      },
    );
  }

  /// Create a copy with modified values
  NetworkRequest copyWith({
    String? url,
    HttpMethod? method,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
    Duration? timeout,
    int? maxRetries,
  }) {
    return NetworkRequest(
      url: url ?? this.url,
      method: method ?? this.method,
      headers: headers ?? this.headers,
      body: body ?? this.body,
      queryParams: queryParams ?? this.queryParams,
      timeout: timeout ?? this.timeout,
      maxRetries: maxRetries ?? this.maxRetries,
    );
  }
}

/// Response from a network request
class NetworkResponse {
  final Map<String, dynamic>? data;
  final int? statusCode;
  final Map<String, String>? headers;
  final String? error;

  const NetworkResponse({
    this.data,
    this.statusCode,
    this.headers,
    this.error,
  });

  bool get isSuccess => statusCode != null && statusCode! >= 200 && statusCode! < 300;
  bool get hasData => data != null;
}