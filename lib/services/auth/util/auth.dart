import 'package:flutter/material.dart';
import 'package:graduan_test/config.dart';
import 'package:graduan_test/services/auth/util/user_data_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<void> setAccessToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Config.accessToken, token);
  }

  static Future<String> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(Config.accessToken) ?? "";
  }

  // SSO
  static Future<void> setLogin() async {
    await UserDataStorage.saveUserData(true, await getAccessToken());
  }

  Future<void> setLogout() async {
    await UserDataStorage.saveUserData(false, '');
  }

  static Future<bool> getLogin(BuildContext context) async {
    Map<String, dynamic> userData = await UserDataStorage.getUserData();

    if (userData.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("is_login", userData['is_login']);
      await prefs.setString("access_token", userData['access_token']);

      return userData['is_login'];
    } else {
      return false;
    }
  }

  // Clear all shared preferences
  static Future<void> clearPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
