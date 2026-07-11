import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_endpoints.dart';
import 'app_exception.dart';

class ApiClient {
  ApiClient._internal();
  static final ApiClient instance = ApiClient._internal();

  final http.Client _client = http.Client();
  final Duration timeout = const Duration(seconds: 20);

  Uri _uri(String path) => Uri.parse('${ApiEndpoints.baseUrl}$path');

  Map<String, String> get _jsonHeaders => const {'Content-Type': 'application/json', 'Accept': 'application/json'};

  Future<Map<String, dynamic>> get(String path, {Map<String, String>? headers}) async {
    final response = await _run(() => _client.get(_uri(path), headers: {..._jsonHeaders, ...?headers}));
    return _decode(response);
  }

  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    final response = await _run(() => _client.post(
          _uri(path),
          headers: {..._jsonHeaders, ...?headers},
          body: body != null ? jsonEncode(body) : null,
        ));
    return _decode(response);
  }

  Future<Map<String, dynamic>> multipart(
    String path, {
    required Map<String, String> fields,
    Map<String, File> files = const {},
    String method = 'POST',
    Map<String, String>? headers,
  }) async {
    final request = http.MultipartRequest(method, _uri(path));
    request.headers.addAll({'Accept': 'application/json', ...?headers});
    request.fields.addAll(fields);
    for (final entry in files.entries) {
      request.files.add(await http.MultipartFile.fromPath(entry.key, entry.value.path));
    }
    final response = await _run(() async => http.Response.fromStream(await request.send()));
    return _decode(response);
  }

  Future<http.Response> _run(Future<http.Response> Function() request) async {
    try {
      return await request().timeout(timeout);
    } on TimeoutException catch (e, st) {
      developer.log('Request timed out after $timeout', error: e, stackTrace: st, name: 'ApiClient');
      throw AppException.timeout();
    } on SocketException catch (e, st) {
      developer.log('Socket error: could not reach ${ApiEndpoints.baseUrl}', error: e, stackTrace: st, name: 'ApiClient');
      throw AppException.network();
    } on HttpException catch (e, st) {
      developer.log('HTTP error', error: e, stackTrace: st, name: 'ApiClient');
      throw AppException.network();
    } catch (e, st) {
      if (e is AppException) rethrow;
      developer.log('Unexpected request error', error: e, stackTrace: st, name: 'ApiClient');
      throw AppException('Request failed: $e');
    }
  }

  Map<String, dynamic> _decode(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {};
      final decoded = jsonDecode(response.body);
      return decoded is Map<String, dynamic> ? decoded : {'data': decoded};
    }
    throw AppException.fromResponseBody(response.statusCode, response.body);
  }
}
