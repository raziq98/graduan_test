// ignore_for_file: prefer_const_constructors


import 'package:flutter/widgets.dart';
import 'package:graduan_test/screen/home_page.dart';
import 'package:graduan_test/screen/login_page.dart';
import 'package:graduan_test/screen/user_page.dart';
import 'package:graduan_test/utils/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, WidgetBuilder> routes = {
  '/home': (context) => const MyHomePage(),
  '/login': (context) => const LoginPage(),
  '/profile': (context) => const Profile(),
  '/': (context) => const LoginPage(),
};
