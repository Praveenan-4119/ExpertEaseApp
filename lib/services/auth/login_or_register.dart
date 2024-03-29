import 'package:expert_ease/Pages/login_page.dart';
import 'package:expert_ease/Pages/register_page.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // initially show the login screen
  bool showLoginPage = true;

  // toggle between login and register page
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  

 
  }

 @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onTap: () {
          togglePages();
          // If you need to perform additional actions when tapping "Register now"
          // you can add them here.
        },
      );
    } else {
      return RegisterPage(
        onTap: () {
          togglePages();
          // If you need to perform additional actions when tapping "Login now"
          // you can add them here.
        },
      );
    }
  }
}
