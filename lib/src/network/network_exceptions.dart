/// Base exception for network errors
abstract class NetworkException implements Exception {
  final String message;
  final Uri? uri;
  
  NetworkException(this.message, {this.uri});
  
  @override
  String toString() => 'NetworkException: $message${uri != null ? ' at $uri' : ''}';
}

/// Thrown when request times out
class TimeoutException extends NetworkException {
  TimeoutException(Uri uri) : super('Request timed out', uri: uri);
}

/// Thrown when there's no internet connection
class NoInternetException extends NetworkException {
  NoInternetException() : super('No internet connection');
}

/// Thrown when server returns error status
class HttpException extends NetworkException {
  final int statusCode;
  final String? responseBody;
  
  HttpException(this.statusCode, this.responseBody, Uri uri) 
    : super('HTTP Error $statusCode', uri: uri);
}

/// Thrown when response is not valid JSON
class InvalidJsonException extends NetworkException {
  InvalidJsonException(Uri uri) : super('Invalid JSON response', uri: uri);
}

/// Thrown when request was cancelled
class RequestCancelledException extends NetworkException {
  RequestCancelledException() : super('Request was cancelled');
}

/// Thrown for unknown network errors
class UnknownNetworkException extends NetworkException {
  UnknownNetworkException(String message, {Uri? uri}) 
    : super(message, uri: uri);
}

/// Thrown when max retries exceeded
class MaxRetriesExceededException extends NetworkException {
  MaxRetriesExceededException(Uri uri) 
    : super('Max retries exceeded', uri: uri);
}