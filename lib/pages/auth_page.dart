import 'package:application/Auth/Log_or_res.dart';
import 'package:application/pages/Home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user login
          if (snapshot.hasData) {
            return HomePage();
          }
          //user not logedin
          else {
            return const loginOrRegister();
          }
        },
      ),
    );
  }
}
