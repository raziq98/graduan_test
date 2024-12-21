// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graduan_test/config.dart';
import 'package:graduan_test/services/auth/util/auth.dart';
import 'package:http/http.dart' as http;

class ApiService {
  late final BuildContext _context;

  ApiService(BuildContext context) : _context = context;

  Future<http.Response?> get({required String path}) async {
    return _makeRequest(method: 'GET', path: path);
  }

  Future<http.Response?> delete({required String path}) async {
    return _makeRequest(method: 'DELETE', path: path);
  }

  Future<http.Response?> post({required String path, dynamic params, bool isApplyFormData = true}) async {
    return isApplyFormData ? _sendFormDataRequest(method: 'POST', path: path, body: params) : _sendUrlEncodedRequest(method: 'POST', path: path, body: params);
  }

  Future<http.Response?> put({required String path, dynamic params}) async {
    return _sendFormDataRequest(method: 'PUT', path: path, body: params);
  }

  Future<http.Response?> _sendFormDataRequest(
      {required String method,
      required String path,
      required dynamic body}) async {
    try {
      final uri = Uri.parse(Config.urls(path));
      var request = http.MultipartRequest(method, uri);

      if (body != null) {
        body.forEach((key, value) {
          if (value is String ||
              value is int ||
              value is double ||
              value is bool) {
            request.fields[key] = value.toString();
          } else if (value is List<int>) {
            request.files.add(http.MultipartFile.fromBytes(
              key,
              value,
              filename: key,
            ));
          }
        });
      }

      final response = await request.send();

      return await http.Response.fromStream(response);
    } catch (e) {
      debugPrint('Error sending FormData request: $e');
      return null;
    }
  }

  Future<http.Response?> _makeRequest({
    required String method,
    required String path,
    dynamic body,
  }) async {
    String token = await AuthService.getAccessToken();
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    };

    if (token.isNotEmpty) {
      try {
        http.Response res;
        Uri url = Uri.parse(Config.urls(path));

        switch (method) {
          case 'GET':
            res = await http
                .get(url, headers: headers)
                .timeout(const Duration(minutes: 1));
            break;
          case 'POST':
            res = await http
                .post(url, body: body, headers: headers)
                .timeout(const Duration(minutes: 1));
            break;
          case 'PUT':
            res = await http
                .put(url, body: body, headers: headers)
                .timeout(const Duration(minutes: 1));
            break;
          case 'DELETE':
            res = await http
                .delete(url, headers: headers)
                .timeout(const Duration(minutes: 1));
            break;
          default:
            throw Exception('Unsupported HTTP method: $method');
        }

        if (res.statusCode == 401) {
          bool isSuccess = (await AuthService.getAccessToken() != '');
          if (isSuccess) {
            return await _makeRequest(method: method, path: path, body: body);
          } else {
            return _tokenExpiredHandling(_context);
          }
        }

        return _httpResHandling(res);
      } catch (e) {
        debugPrint("Error: ${e.toString()}");
        return _httpResHandling(
            http.Response('{"message": "Error occurred."}', 500));
      }
    } else {
      return _tokenExpiredHandling(_context);
    }
  }

  Future<http.Response?> _sendUrlEncodedRequest({
    required String method,
    required String path,
    required Map<String, dynamic> body,
  }) async {
    try {
      final uri = Uri.parse(Config.urls(path));
      final headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      // Encode the parameters into x-www-form-urlencoded format
      final encodedBody = _encodeBody(body);
      
      if (method.toUpperCase() == 'PUT') {
        // For PUT, you might want to use http.put instead
        return await http.put(
          uri,
          headers: headers,
          body: encodedBody,
        );
      }
      
      final response = await http.post(
        uri,
        headers: headers,
        body: encodedBody,
      );

      return response;
    } catch (e) {
      debugPrint('Error sending URL-encoded request: $e');
      return null;
    }
  }

// Helper method to encode body as x-www-form-urlencoded
  String _encodeBody(Map<String, dynamic> body) {
    final encoded = body.entries.map((entry) {
      // Encode each key and value
      return '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value.toString())}';
    }).join('&');

    return encoded;
  }

  http.Response _tokenExpiredHandling(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: SelectableText(
          'Your access has expired, please re-login to your account again.',
        ),
      ),
    );
    AuthService.clearPrefs();
    Navigator.pushNamed(context, '/login/splash');
    return _httpResHandling(
        http.Response('{"message": "Error occurred."}', 500));
  }

  http.Response _httpResHandling(http.Response res) {
    if (res.statusCode == 200) {
      return res;
    } else {
      return res;
    }
  }
}

// Fetch API data function
Future<T?> fetchApiData<T>(
    {required BuildContext context,
    required String path,
    required String method,
    Map<String, dynamic>? params,
    T Function(Map<String, dynamic>)? fromJson,
    required bool isDebug}) async {
  try {
    // Initialize ApiService with optional custom URL provider
    final apiService = ApiService(context);

    http.Response? response;

    switch (method.toUpperCase()) {
      case 'GET':
        response = await apiService.get(path: path);
        break;
      case 'POST':
        response = await apiService.post(path: path, params: params);
        break;
      case 'PUT':
        response = await apiService.put(path: path, params: params);
        break;
      case 'DELETE':
        response = await apiService.delete(path: path);
        break;
      default:
        throw Exception('Unsupported HTTP method: $method');
    }

    if (response != null && response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (isDebug) {
        String prettyJson = const JsonEncoder.withIndent('  ').convert(data);
        debugPrint('Response (${response.statusCode}):\n $prettyJson');
      }

      if (fromJson != null) {
        return fromJson(data);
      } else {
        return data as T;
      }
    } else {
      debugPrint('Error $path: ${response?.statusCode ?? 'Unknown error'}');
    }
  } catch (e) {
    debugPrint('Exception occurred: $e');
  }
  return null;
}
