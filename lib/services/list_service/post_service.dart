import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:graduan_test/model/post_model.dart';
import 'package:graduan_test/services/api_service.dart';

import '../../config.dart';

class PostService {
  Future<List<PostModel>> getPostList(BuildContext context) async {
    //might need to change the future type
    try {
      List<dynamic> response = await fetchApiData(
        isDebug: false,
        context: context,
        method: 'get',
        path: Config.postList,
        params: {},
        isApplyFormData: false,
        isApplyBearerToken: true,
      );
      List<PostModel> postData =
          response.map((jsonItem) => PostModel.fromJson(jsonItem)).toList();
      return postData;
    } catch (e) {
      debugPrint('auth.post get error: $e');
      return [];
    }
  }

  Future<PostModel?> createPost(
      BuildContext context, Map<String, dynamic> params) async {
    try {
      final response = await fetchApiData(
        isDebug: false,
        context: context,
        method: 'post',
        path: Config.createPost,
        params: params,
        isApplyFormData: true,
        isApplyBearerToken: true,
      );
      return PostModel.fromJson(response);
    } catch (e) {
      debugPrint('auth.post create error: $e');
      return null;
    }
  }
}
