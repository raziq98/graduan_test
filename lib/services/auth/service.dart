
import 'package:flutter/material.dart';
import 'package:graduan_test/config.dart';
import 'package:graduan_test/services/api_service.dart';
import 'package:graduan_test/services/auth/util/auth.dart';

Future<Map<String, dynamic>?> login(
    BuildContext context, Map<String, dynamic> params) async {
  try {
    final response = await fetchApiData(
      isDebug: true,
      context: context,
      method: 'post',
      path: Config.login,
      params: params,
      isApplyFormData: true,
      isApplyBearerToken: false
    );
    if(response!= null){
      AuthService.setAccessToken(response['token']);
    }
    return response;
  } catch (e) {
    debugPrint(
        'auth.login error: $e');
    return null;
  }
}

Future<Map<String, dynamic>?> logout(
    BuildContext context) async {
  try {
    final response = await fetchApiData(
      isDebug: false,
      context: context,
      method: 'post',
      path: Config.logOut,
      params: {},
    );
    return response;
  } catch (e) {
    debugPrint(
        'auth.logout error: $e');
    return null;
  }
}