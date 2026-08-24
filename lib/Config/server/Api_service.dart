import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

enum HttpVerb { get, post, put, delete, patch }

class ApiResponse<T> {
  final T? data;
  final int statusCode;
  final String? error;

  ApiResponse({this.data, required this.statusCode, this.error});
  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}

class ApiService {

  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8000';
    if (Platform.isAndroid) return 'http://10.0.2.2:8000';
    return 'http://localhost:8000'; 
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  static Future<ApiResponse<T>> request<T>({
    required String endpoint,
    required HttpVerb verb,
    dynamic body,
    Map<String, String>? headers,
    required T Function(dynamic json) fromJson,
  }) async {
    final token = await getToken();
    final url = endpoint.startsWith('http') ? endpoint : '$baseUrl$endpoint';

    final defaultHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };

    try {
      final uri = Uri.parse(url);
      http.Response response;

      switch (verb) {
        case HttpVerb.get:
          response = await http.get(uri, headers: defaultHeaders);
          break;
        case HttpVerb.post:
          response = await http.post(
            uri,
            headers: defaultHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case HttpVerb.put:
          response = await http.put(
            uri,
            headers: defaultHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case HttpVerb.patch:
          response = await http.patch(
            uri,
            headers: defaultHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case HttpVerb.delete:
          response = await http.delete(
            uri,
            headers: defaultHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        final data = fromJson(decoded);
        return ApiResponse<T>(data: data, statusCode: response.statusCode);
      } else {
        return ApiResponse<T>(
          data: null,
          statusCode: response.statusCode,
          error: response.body,
        );
      }
    } catch (e) {
      debugPrint('Erro na requisição ($endpoint): $e');
      return ApiResponse<T>(data: null, statusCode: 500, error: e.toString());
    }
  }
}