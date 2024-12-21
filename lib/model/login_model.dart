import 'package:graduan_test/model/user_model.dart';

class LoginModel {
  final bool? success;
  final String? message;
  final UserData? data;

  LoginModel({
    this.success,
    this.message,
    this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }
}
