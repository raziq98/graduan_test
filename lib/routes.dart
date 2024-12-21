// ignore_for_file: prefer_const_constructors


import 'package:flutter/widgets.dart';
import 'package:graduan_test/main.dart';
import 'package:graduan_test/utils/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => const MyHomePage(title: '',),
};

// Function to build protected routes
Widget _buildProtectedRoute(BuildContext context, Widget widget) {
  return FutureBuilder(
    future: SharedPreferences.getInstance(),
    builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: LoadingAnimation());
      } else if (snapshot.hasError) {
        return Center(child: Text("Error: ${snapshot.error}"));
      } else {
        SharedPreferences prefs = snapshot.data!;
        bool isLoggedIn = prefs.getBool("isLogin") ?? false;
        if (isLoggedIn) {
          return widget;
        } else {
          Future.delayed(Duration.zero, () {
            Navigator.pushReplacementNamed(context, '/login');
          });
          return const SizedBox.shrink();
        }
      }
    },
  );
}
