import 'dart:convert';
import 'package:http/http.dart' as http;

/// Centralized HTTP client that handles JWT auth, tenant headers, and error parsing.
class ApiClient {
  static const String devBaseUrl = 'http://localhost:3000/api';
  static const String prodBaseUrl = 'https://api.sims.example.com/api';

  final String baseUrl;
  String? _token;
  String? _tenantId;

  ApiClient({String? baseUrl}) : baseUrl = baseUrl ?? devBaseUrl;

  void setAuth(String? token, String? tenantId) {
    _token = token;
    _tenantId = tenantId;
  }

  String? get token => _token;
  String? get tenantId => _tenantId;

  Map<String, String> get _headers {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (_token != null) headers['Authorization'] = 'Bearer $_token';
    if (_tenantId != null) headers['X-Tenant-Id'] = _tenantId!;
    return headers;
  }

  Future<Map<String, dynamic>> get(String path) async {
    final response = await http.get(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  Future<void> delete(String path) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
    );
    if (response.statusCode != 204 && response.statusCode < 200 ||
        response.statusCode >= 300) {
      _throwError(response);
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.statusCode == 204 || response.body.isEmpty) {
        return {};
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    _throwError(response);
  }

  Never _throwError(http.Response response) {
    String message;
    try {
      final error = jsonDecode(response.body) as Map<String, dynamic>;
      message = error['message'] as String? ?? 'API error: ${response.statusCode}';
    } catch (_) {
      message = 'API error: ${response.statusCode}';
    }
    throw ApiException(message, response.statusCode);
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => message;
}

/// Singleton API client instance.
final apiClient = ApiClient();
