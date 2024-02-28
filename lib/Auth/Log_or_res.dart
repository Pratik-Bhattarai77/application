import 'package:flutter/material.dart';
import 'package:application/pages/Register_page.dart';
import 'package:application/pages/login_page.dart';

class loginOrRegister extends StatefulWidget {
  const loginOrRegister({super.key});

  @override
  State<loginOrRegister> createState() => _loginOrRegisterState();
}

class _loginOrRegisterState extends State<loginOrRegister> {
  // intiial page
  bool showLoginpage = true;

  //toggel pages
  void togglepages() {
    setState(() {
      showLoginpage = !showLoginpage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginpage) {
      return LoginPage(onTap: togglepages);
    } else {
      return RegisterPage(onTap: togglepages);
    }
  }
}
