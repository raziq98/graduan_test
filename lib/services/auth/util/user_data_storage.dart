import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataStorage {
  // TO SAVE THE USER LOGIN DATA
  static Future<void> saveUserData(bool isLogin, String accessToken) async {
    Map<String, dynamic> userData = {
      'is_login': isLogin,
      'access_token': accessToken,
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("is_login", userData['is_login']);

    Directory directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/user_data.json');
    await file.writeAsString(jsonEncode(userData));
  }

  // TO GET THE USER LOGIN DATA
  static Future<Map<String, dynamic>> getUserData() async {
    Directory directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/user_data.json');

    if (await file.exists()) {
      String fileContents = await file.readAsString();
      return jsonDecode(fileContents);
    } else {
      return {};
    }
  }

  // TO DELETE THE USER LOGIN DATA
  static Future<void> deleteUserData() async {
    Directory directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/user_data.json');

    if (await file.exists()) {
      await file.delete();
    }
  }
}
