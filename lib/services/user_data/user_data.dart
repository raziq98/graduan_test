import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:graduan_test/model/user_model.dart';
import 'package:graduan_test/services/api_service.dart';

import '../../config.dart';

class UserDataService {
  Future<UserData> getUserdata(BuildContext context) async {
    try {
      final response = await fetchApiData(
        isDebug: false,
        context: context,
        method: 'get',
        path: Config.userInfo,
        params: {},
        isApplyFormData: false,
        isApplyBearerToken: true,
      );
      return UserData.fromJson(response);
    } catch (e) {
      debugPrint('user_data.get error: $e');
      return UserData(id: 0,name: '',email:'', emailVerifiedAt: '', createdAt: '',updatedAt: '');
    }
  }

  Future<String> updateUserData(
      BuildContext context, Map<String, dynamic> params) async {
    try {
      final response = await fetchApiData(
        isDebug: false,
        context: context,
        method: 'put',
        path: Config.userInfo,
        params: params,
        isApplyFormData: true,
        isApplyBearerToken: true,
      );
      return response;
    } catch (e) {
      debugPrint('user_data.update error: $e');
      return 'false';
    }
  }
}
