import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

import '../core/config/app_config.dart';
import '../core/constants/app_strings.dart';
import 'storage_service.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient({StorageService? storage}) : _storage = storage ?? StorageService();

  final StorageService _storage;

  Future<Map<String, String>> _headers({bool auth = true, bool multipart = false}) async {
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    if (!multipart) {
      headers['Content-Type'] = 'application/json';
    }
    if (auth) {
      final token = await _storage.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  Future<void> _ensureOnline() async {
    try {
      final result = await Connectivity().checkConnectivity();
      final hasNetwork = result.any(
        (r) => r != ConnectivityResult.none && r != ConnectivityResult.bluetooth,
      );
      if (!hasNetwork && result.isNotEmpty) {
        throw const ApiException(AppStrings.noInternet);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      // If connectivity plugin fails, still try the API request.
    }
  }

  ApiException _connectionError() => ApiException(
        '${AppStrings.serverUnreachable}\n(${AppConfig.apiBaseUrl})',
      );

  Future<dynamic> get(String path, {bool auth = true}) async {
    await _ensureOnline();
    try {
      final response = await http
          .get(Uri.parse('${AppConfig.apiBaseUrl}$path'), headers: await _headers(auth: auth))
          .timeout(const Duration(seconds: 30));
      return _handleResponse(response);
    } on SocketException {
      throw _connectionError();
    } on TimeoutException {
      throw _connectionError();
    }
  }

  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) async {
    await _ensureOnline();
    try {
      final response = await http
          .post(
            Uri.parse('${AppConfig.apiBaseUrl}$path'),
            headers: await _headers(auth: auth),
            body: body == null ? null : jsonEncode(body),
          )
          .timeout(path == '/send-message' ? const Duration(seconds: 90) : const Duration(seconds: 30));
      return _handleResponse(response);
    } on SocketException {
      throw _connectionError();
    } on TimeoutException {
      throw _connectionError();
    }
  }

  Future<dynamic> delete(String path, {bool auth = true}) async {
    await _ensureOnline();
    try {
      final response = await http
          .delete(Uri.parse('${AppConfig.apiBaseUrl}$path'), headers: await _headers(auth: auth))
          .timeout(const Duration(seconds: 30));
      return _handleResponse(response);
    } on SocketException {
      throw _connectionError();
    } on TimeoutException {
      throw _connectionError();
    }
  }

  Future<dynamic> postMultipart(
    String path, {
    required Map<String, String> fields,
    File? file,
    String fileField = 'image',
  }) async {
    await _ensureOnline();
    try {
      final uri = Uri.parse('${AppConfig.apiBaseUrl}$path');
      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll(await _headers(auth: true, multipart: true));
      request.fields.addAll(fields);
      if (file != null) {
        request.files.add(await http.MultipartFile.fromPath(fileField, file.path));
      }
      final streamed = await request.send().timeout(const Duration(seconds: 90));
      final response = await http.Response.fromStream(streamed);
      return _handleResponse(response);
    } on SocketException {
      throw _connectionError();
    } on TimeoutException {
      throw _connectionError();
    }
  }

  dynamic _handleResponse(http.Response response) {
    Map<String, dynamic>? json;
    if (response.body.isNotEmpty) {
      try {
        json = jsonDecode(response.body) as Map<String, dynamic>?;
      } catch (_) {}
    }

    if (response.statusCode == 401) {
      throw ApiException(
        json?['message']?.toString() ?? 'Authentication failed.',
        statusCode: 401,
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json ?? <String, dynamic>{};
    }

    final message = json?['error']?.toString() ??
        json?['message']?.toString() ??
        AppStrings.somethingWrong;
    throw ApiException(message, statusCode: response.statusCode);
  }
}
