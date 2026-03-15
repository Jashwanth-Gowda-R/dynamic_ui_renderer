import 'dart:convert';
import 'package:dynamic_ui_renderer/src/models/network_models.dart';
import 'package:dynamic_ui_renderer/src/network/network_exceptions.dart';
import 'package:http/http.dart' as http;

/// Handles actual HTTP communication
class HttpClient {
  final http.Client _client = http.Client();

  /// Execute a network request and return response
  Future<NetworkResponse> execute(NetworkRequest request) async {
    try {
      // Build the request
      final uri = request.uri;
      final headers = {'Content-Type': 'application/json', ...?request.headers};

      late http.Request httpRequest;

      // Create request based on method
      switch (request.method) {
        case HttpMethod.get:
          httpRequest = http.Request('GET', uri);
          break;
        case HttpMethod.post:
          httpRequest = http.Request('POST', uri);
          httpRequest.body = jsonEncode(request.body ?? {});
          break;
        case HttpMethod.put:
          httpRequest = http.Request('PUT', uri);
          httpRequest.body = jsonEncode(request.body ?? {});
          break;
        case HttpMethod.patch:
          httpRequest = http.Request('PATCH', uri);
          httpRequest.body = jsonEncode(request.body ?? {});
          break;
        case HttpMethod.delete:
          httpRequest = http.Request('DELETE', uri);
          break;
      }

      httpRequest.headers.addAll(headers);

      // Send with timeout
      final streamedResponse = await _client
          .send(httpRequest)
          .timeout(request.timeout ?? const Duration(seconds: 30));

      final response = await http.Response.fromStream(streamedResponse);

      // Parse response
      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          return NetworkResponse(
            data: data,
            statusCode: response.statusCode,
            headers: response.headers,
          );
        } catch (_) {
          throw InvalidJsonException(uri);
        }
      } else {
        throw HttpException(response.statusCode, response.body, uri);
      }
    } on HttpException {
      rethrow;
    } on InvalidJsonException {
      rethrow;
    } on NoInternetException {
      rethrow;
    } on TimeoutException {
      rethrow;
    } catch (e) {
      // For any other error, use a concrete exception
      if (e.toString().contains('timed out')) {
        throw TimeoutException(request.uri);
      }
      if (e.toString().contains('SocketException') ||
          e.toString().contains('Connection refused')) {
        throw NoInternetException();
      }
      // Use a generic NetworkException with a proper subclass
      throw UnknownNetworkException(e.toString(), uri: request.uri);
    }
  }

  /// Retry a request with exponential backoff
  Future<NetworkResponse> executeWithRetry(NetworkRequest request) async {
    int attempt = 0;
    while (attempt < request.maxRetries) {
      try {
        return await execute(request);
      } on HttpException catch (e) {
        // Don't retry client errors (4xx)
        if (e.statusCode >= 400 && e.statusCode < 500) {
          rethrow;
        }
        // Retry server errors (5xx)
        if (attempt == request.maxRetries - 1) rethrow;
      } on TimeoutException {
        if (attempt == request.maxRetries - 1) rethrow;
      } on NoInternetException {
        // Don't retry if no internet
        rethrow;
      } catch (_) {
        if (attempt == request.maxRetries - 1) rethrow;
      }

      attempt++;
      // Exponential backoff: 1s, 2s, 4s, etc.
      await Future.delayed(Duration(seconds: 1 << attempt));
    }

    throw MaxRetriesExceededException(request.uri);
  }

  void dispose() {
    _client.close();
  }
}