import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_endpoints.dart';
import 'app_exception.dart';
import 'token_storage.dart';

class ApiClient {
  ApiClient._internal();
  static final ApiClient instance = ApiClient._internal();

  final http.Client _client = http.Client();
  final Duration timeout = const Duration(seconds: 20);

  Uri _uri(String path) => Uri.parse('${ApiEndpoints.baseUrl}$path');

  Future<Map<String, String>> _authHeaders() async {
    final token = await TokenStorage.instance.readToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> get(String path, {Map<String, String>? headers}) async {
    final baseHeaders = await _authHeaders();
    final response = await _run(() => _client.get(_uri(path), headers: {...baseHeaders, ...?headers}));
    return _decode(response);
  }

  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    final baseHeaders = await _authHeaders();
    final response = await _run(() => _client.post(
          _uri(path),
          headers: {...baseHeaders, ...?headers},
          body: body != null ? jsonEncode(body) : null,
        ));
    return _decode(response);
  }

  Future<Map<String, dynamic>> put(String path, {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    final baseHeaders = await _authHeaders();
    final response = await _run(() => _client.put(
          _uri(path),
          headers: {...baseHeaders, ...?headers},
          body: body != null ? jsonEncode(body) : null,
        ));
    return _decode(response);
  }

  Future<Map<String, dynamic>> delete(String path, {Map<String, String>? headers}) async {
    final baseHeaders = await _authHeaders();
    final response = await _run(() => _client.delete(_uri(path), headers: {...baseHeaders, ...?headers}));
    return _decode(response);
  }

  Future<Map<String, dynamic>> multipart(
    String path, {
    required Map<String, String> fields,
    Map<String, File> files = const {},
    String method = 'POST',
    Map<String, String>? headers,
  }) async {
    final token = await TokenStorage.instance.readToken();
    final request = http.MultipartRequest(method, _uri(path));
    request.headers.addAll({
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    });
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
