import 'package:flutter/material.dart';
import 'package:graduan_test/services/auth/service.dart';
import 'package:graduan_test/utils/widget/custom_input_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> _onLogin(BuildContext context) async {
    final param = {
      'email': emailController.text,
      'password': passwordController.text
    };
    final isLogin = await login(context, param);
    if(isLogin?['token'] != null || isLogin?['token'] != ''){
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Log In"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomInputField(
              controller: emailController,
              hintText: "Email",
              onSaved: (value) {
                emailController.text = value!;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            CustomInputField(
              controller: passwordController,
              hintText: "Password",
              onSaved: (value) {
                passwordController.text = value!;
              },
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              height: 55,
              width: 175,
              margin: const EdgeInsets.only(left: 15, right: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).primaryColorDark.withOpacity(0.75),
              ),
              child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 5, top: 5, left: 20, right: 20),
                  child: GestureDetector(
                    onTap: () {
                      _onLogin(context);
                    },
                    child: const Expanded(
                        child: Center(
                      child: Text('Log In'),
                    )),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
