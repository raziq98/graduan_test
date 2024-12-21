import 'dart:convert';

import 'package:flutter/widgets.dart';

import '../../config.dart';
import 'package:http/http.dart' as http;

class PostService {
  Future<bool> getPostList(BuildContext context, String phone) async {
    final String apiUrl = Config.urls(Config.postList);
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "jsonrpc": "2.0",
          "params": {"phone": phone}
        }),
      );

      if (response.statusCode == 200) {
        final parsedResponse = jsonDecode(response.body);

        if (parsedResponse.containsKey('result') &&
            parsedResponse['result']['success'] == true) {
          print('OTP sent');
          return true;
        } else if (parsedResponse.containsKey('result') &&
            parsedResponse['result']['success'] == false) {
          return false;
        } else {
          // Unexpected response format
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to create user');
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }
  }