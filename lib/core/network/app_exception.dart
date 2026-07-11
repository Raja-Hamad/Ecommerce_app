import 'dart:convert';

class AppException implements Exception {
  AppException(this.message);

  final String message;

  factory AppException.fromResponseBody(int statusCode, String body) {
    try {
      if (body.isNotEmpty) {
        final decoded = jsonDecode(body);
        if (decoded is Map && decoded['message'] != null) {
          return AppException(decoded['message'].toString());
        }
      }
    } catch (_) {
      // response body wasn't valid JSON, fall through to generic message
    }
    if (statusCode >= 500) return AppException('Server error. Please try again later.');
    if (statusCode == 404) return AppException('Requested resource not found.');
    if (statusCode == 401 || statusCode == 403) return AppException('You are not authorized. Please login again.');
    return AppException('Something went wrong (code $statusCode).');
  }

  factory AppException.network() => AppException('No internet connection. Please check your network.');

  factory AppException.timeout() => AppException('Connection timed out. Please try again.');

  @override
  String toString() => message;
}
